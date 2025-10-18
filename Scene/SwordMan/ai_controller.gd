class_name AIController
extends Node

@export var ai_swordman: swordMan
@export var player_swordman: swordMan
@export var move_speed: float = 200.0
@export var safe_distance: float = 300.0 # 与玩家的安全距离
@export var attack_distance: float = 160 # 攻击距离
@export var ai_id: int = 0 # AI类型ID: 0=基础AI, 1=高难度AI, 2=镜像AI

enum AIState { IDLE, CHASE, ATTACK, RETREAT }
enum AIType { BASIC, ADVANCED, MIRROR }
var current_state: AIState = AIState.IDLE
var ai_type: AIType

# 镜像AI相关变量
var player_position_history: Array[Vector2] = []
var history_timestamps: Array[float] = []
var mirror_delay: float = 2.0 # 2秒延迟

# 高难度AI相关变量
var prediction_factor: float = 0.8 # 预测系数，提高预测准确性
var last_player_position: Vector2
var player_velocity: Vector2
var dodge_timer: float = 0.0
var dodge_direction: Vector2
var attack_pattern_timer: float = 0.0 # 攻击模式计时器
var current_attack_pattern: int = 0 # 当前攻击模式
var circle_angle: float = 0.0 # 环绕角度
var adaptive_distance: float = 160.0 # 自适应攻击距离
var player_behavior_analysis: Dictionary = {} # 玩家行为分析

# 碰撞体检测相关变量
var sword_danger_distance: float = 80.0 # 剑的危险距离
var body_attack_distance: float = 60.0 # 攻击玩家身体的距离
var is_dodging: bool = false # 是否正在躲避
var dodge_cooldown: float = 0.0 # 躲避冷却时间

var mirrorWaitTime=2.0
func _ready():
	# 根据AI ID设置AI类型
	match ai_id:
		0:
			ai_type = AIType.BASIC
		1:
			ai_type = AIType.ADVANCED
		2:
			ai_type = AIType.MIRROR
		_:
			ai_type = AIType.BASIC
			
	if ai_swordman and player_swordman:
		# 连接玩家被击中信号
		player_swordman.hit_body.connect(_on_player_hit)
		last_player_position = player_swordman.global_position
		
func _physics_process(delta):
	if not ai_swordman or not player_swordman or ai_swordman.isdead or player_swordman.isdead or GameManager.swordManGameState==GameManager.gameState.pause:
		return
	
	# 根据AI类型执行不同的行为
	match ai_type:
		AIType.BASIC:
			_basic_ai_behavior(delta)
		AIType.ADVANCED:
			_advanced_ai_behavior(delta)
		AIType.MIRROR:
			_mirror_ai_behavior(delta)

# 基础AI行为（原有逻辑）
func _basic_ai_behavior(delta):
	var direction = (player_swordman.global_position - ai_swordman.global_position).normalized()
	var distance = ai_swordman.global_position.distance_to(player_swordman.global_position)
	
	# 添加简单的移动平滑，避免抽搐
	var target_position = ai_swordman.global_position
	
	match current_state:
		AIState.IDLE:
			if distance < safe_distance * 1.5:
				current_state = AIState.CHASE
				
		AIState.CHASE:
			if distance < attack_distance:
				current_state = AIState.ATTACK
			elif distance > safe_distance * 2:
				current_state = AIState.IDLE
			target_position += direction * move_speed * delta
			
		AIState.ATTACK:
			if distance > attack_distance * 1.2:
				current_state = AIState.CHASE
			# 尝试保持在攻击距离内
			var ideal_pos = player_swordman.global_position - direction * attack_distance
			target_position = ai_swordman.global_position.move_toward(ideal_pos, move_speed * delta)
			
		AIState.RETREAT:
			if distance > safe_distance:
				current_state = AIState.CHASE
			target_position -= direction * move_speed * 1.5 * delta
	
	# 平滑移动，避免抽搐
	ai_swordman.global_position = ai_swordman.global_position.move_toward(target_position, move_speed * 2.0 * delta)

# 高难度AI行为
func _advanced_ai_behavior(delta):
	var current_player_pos = player_swordman.global_position
	
	# 计算玩家速度和加速度
	var new_velocity = (current_player_pos - last_player_position) / delta
	var acceleration = (new_velocity - player_velocity) / delta
	player_velocity = new_velocity
	last_player_position = current_player_pos
	
	# 分析玩家行为模式
	_analyze_player_behavior(current_player_pos, player_velocity)
	
	# 更新计时器
	if dodge_timer > 0:
		dodge_timer -= delta
	if dodge_cooldown > 0:
		dodge_cooldown -= delta
	attack_pattern_timer += delta
	
	# 获取关键碰撞体位置
	var player_sword_pos = player_swordman.sword.global_position
	var player_body_pos = player_swordman.areabody.global_position
	var ai_body_pos = ai_swordman.areabody.global_position
	var ai_sword_pos = ai_swordman.sword.global_position
	
	# 检测剑的威胁并躲避
	var sword_distance = ai_body_pos.distance_to(player_sword_pos)
	var should_dodge = _should_dodge_sword(sword_distance, player_sword_pos, ai_body_pos)
	
	# 检测是否可以攻击玩家身体
	var body_distance = ai_sword_pos.distance_to(player_body_pos)
	var can_attack_body = body_distance <= body_attack_distance
	
	# 优先级：躲避 > 攻击身体 > 正常AI行为
	if should_dodge and dodge_cooldown <= 0:
		_execute_dodge(delta, player_sword_pos, ai_body_pos)
		is_dodging = true
		dodge_cooldown = 1.0 # 1秒冷却
	elif can_attack_body:
		_attack_player_body(delta, player_body_pos, ai_sword_pos)
		is_dodging = false
	else:
		_execute_normal_advanced_behavior(delta, current_player_pos)
		is_dodging = false

# 判断是否应该躲避剑
func _should_dodge_sword(distance: float, sword_pos: Vector2, body_pos: Vector2) -> bool:
	if distance > sword_danger_distance:
		return false
	
	# 检查剑是否在朝AI移动
	var sword_to_body = (body_pos - sword_pos).normalized()
	var player_sword_velocity = Vector2.ZERO
	
	# 简单预测剑的移动方向（基于玩家移动）
	if player_velocity.length() > 10:
		player_sword_velocity = player_velocity.normalized()
		var dot_product = sword_to_body.dot(player_sword_velocity)
		return dot_product > 0.3 # 如果剑朝AI方向移动
	
	return distance <= sword_danger_distance * 0.7 # 非常接近时必须躲避

# 执行躲避动作
func _execute_dodge(delta: float, sword_pos: Vector2, body_pos: Vector2):
	var danger_vector = body_pos - sword_pos
	var dodge_direction = Vector2(-danger_vector.y, danger_vector.x).normalized() # 垂直于威胁方向
	
	# 随机选择左右躲避
	if randf() < 0.5:
		dodge_direction = -dodge_direction
	
	# 快速躲避移动
	var dodge_speed = move_speed * 2.5
	ai_swordman.global_position += dodge_direction * dodge_speed * delta
	
	print("AI正在躲避玩家的剑！")

# 攻击玩家身体
func _attack_player_body(delta: float, player_body_pos: Vector2, ai_sword_pos: Vector2):
	var attack_direction = (player_body_pos - ai_sword_pos).normalized()
	
	# 快速接近玩家身体
	var attack_speed = move_speed * 1.8
	ai_swordman.global_position += attack_direction * attack_speed * delta
	
	print("AI正在攻击玩家身体！")

# 执行正常的高级AI行为
func _execute_normal_advanced_behavior(delta: float, current_player_pos: Vector2):
	# 高级预测：考虑加速度的预测
	var prediction_time = prediction_factor + (player_velocity.length() / 200.0)
	var acceleration = Vector2.ZERO # 简化处理
	var predicted_player_pos = current_player_pos + player_velocity * prediction_time
	
	var direction = (predicted_player_pos - ai_swordman.global_position).normalized()
	var distance = ai_swordman.global_position.distance_to(current_player_pos)
	
	# 自适应攻击距离
	if player_velocity.length() > 100:
		adaptive_distance = attack_distance * 1.3
	else:
		adaptive_distance = attack_distance * 0.8
	
	match current_state:
		AIState.IDLE:
			if distance < safe_distance * 2.0:
				current_state = AIState.CHASE
				
		AIState.CHASE:
			if distance < adaptive_distance:
				current_state = AIState.ATTACK
				attack_pattern_timer = 0.0
				current_attack_pattern = randi() % 3
			elif distance > safe_distance * 3.0:
				current_state = AIState.IDLE
			
			# 智能追击
			var move_direction = direction
			if player_velocity.length() > 80:
				var intercept_point = _calculate_advanced_intercept_point(current_player_pos, player_velocity, acceleration)
				move_direction = (intercept_point - ai_swordman.global_position).normalized()
			elif player_velocity.length() > 20:
				var escape_prediction = _predict_escape_route(current_player_pos, player_velocity)
				move_direction = (escape_prediction - ai_swordman.global_position).normalized()
			
			ai_swordman.global_position += move_direction * move_speed * 1.4 * delta
			
		AIState.ATTACK:
			if distance > adaptive_distance * 2.0:
				current_state = AIState.CHASE
			
			# 多种攻击模式
			match current_attack_pattern:
				0:
					_circle_attack_pattern(delta, predicted_player_pos)
				1:
					_pressure_attack_pattern(delta, predicted_player_pos, direction)
				2:
					_dodge_attack_pattern(delta, predicted_player_pos, direction)
			
			# 切换攻击模式
			if attack_pattern_timer > 2.0:
				current_attack_pattern = (current_attack_pattern + 1) % 3
				attack_pattern_timer = 0.0
			
		AIState.RETREAT:
			if distance > safe_distance * 1.5:
				current_state = AIState.CHASE
			var retreat_direction = _calculate_smart_retreat(current_player_pos, player_velocity)
			ai_swordman.global_position += retreat_direction * move_speed * 2.0 * delta

# 环绕攻击模式
func _circle_attack_pattern(delta: float, target_pos: Vector2):
	circle_angle += delta * 3.0 # 环绕速度
	var radius = adaptive_distance * 0.9
	var circle_offset = Vector2(cos(circle_angle), sin(circle_angle)) * radius
	var ideal_pos = target_pos + circle_offset
	ai_swordman.global_position = ai_swordman.global_position.move_toward(ideal_pos, move_speed * 1.5 * delta)

# 压制攻击模式
func _pressure_attack_pattern(delta: float, target_pos: Vector2, direction: Vector2):
	var optimal_distance = adaptive_distance * 0.7
	var ideal_pos = target_pos - direction * optimal_distance
	
	# 添加侧向压力
	var side_direction = Vector2(-direction.y, direction.x)
	if randf() < 0.5:
		side_direction = -side_direction
	ideal_pos += side_direction * 30
	
	ai_swordman.global_position = ai_swordman.global_position.move_toward(ideal_pos, move_speed * 1.6 * delta)

# 闪避攻击模式
func _dodge_attack_pattern(delta: float, target_pos: Vector2, direction: Vector2):
	var optimal_distance = adaptive_distance * 0.8
	var ideal_pos = target_pos - direction * optimal_distance
	
	# 高频闪避
	if dodge_timer <= 0 and randf() < 0.6:
		dodge_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		dodge_timer = 0.3
	
	if dodge_timer > 0:
		ideal_pos += dodge_direction * 80
	
	ai_swordman.global_position = ai_swordman.global_position.move_toward(ideal_pos, move_speed * 1.7 * delta)

# 分析玩家行为模式
func _analyze_player_behavior(pos: Vector2, velocity: Vector2):
	var speed_category = "slow"
	if velocity.length() > 150:
		speed_category = "fast"
	elif velocity.length() > 75:
		speed_category = "medium"
	
	if not player_behavior_analysis.has(speed_category):
		player_behavior_analysis[speed_category] = 0
	player_behavior_analysis[speed_category] += 1

# 高级拦截点计算
func _calculate_advanced_intercept_point(player_pos: Vector2, player_vel: Vector2, player_acc: Vector2) -> Vector2:
	var time_to_intercept = 1.2
	# 考虑加速度的预测
	return player_pos + player_vel * time_to_intercept + player_acc * time_to_intercept * time_to_intercept * 0.5

# 预测逃跑路线
func _predict_escape_route(player_pos: Vector2, player_vel: Vector2) -> Vector2:
	var screen_center = get_viewport().get_visible_rect().size / 2
	var to_center = (screen_center - player_pos).normalized()
	var escape_direction = player_vel.normalized()
	
	# 如果玩家向边缘移动，预测其会转向中心
	if player_pos.distance_to(screen_center) > 200:
		escape_direction = to_center
	
	return player_pos + escape_direction * 150

# 智能撤退计算
func _calculate_smart_retreat(player_pos: Vector2, player_vel: Vector2) -> Vector2:
	var retreat_direction = (ai_swordman.global_position - player_pos).normalized()
	
	# 如果玩家高速追击，向侧面撤退
	if player_vel.length() > 100:
		var side_direction = Vector2(-player_vel.y, player_vel.x).normalized()
		retreat_direction = (retreat_direction + side_direction).normalized()
	
	return retreat_direction

# 计算拦截点
func _calculate_intercept_point(player_pos: Vector2, player_vel: Vector2) -> Vector2:
	var time_to_intercept = 1.0 # 预测1秒后的位置
	return player_pos + player_vel * time_to_intercept

# 镜像AI行为（重复2秒前玩家的反向操作）
func _mirror_ai_behavior(delta):
	var current_time = Time.get_time_dict_from_system()
	var timestamp = current_time.hour * 3600 + current_time.minute * 60 + current_time.second + current_time.get("millisecond", 0) / 1000.0
	
	# 记录玩家当前位置
	player_position_history.append(player_swordman.global_position)
	history_timestamps.append(timestamp)
	
	# 清理超过延迟时间的历史记录
	while history_timestamps.size() > 0 and (timestamp - history_timestamps[0]) > mirror_delay:
		player_position_history.pop_front()
		history_timestamps.pop_front()
	
	# 如果有足够的历史数据，执行镜像行为
	if player_position_history.size() >= mirrorWaitTime:
		var target_index = -1
		
		# 找到2秒前的位置索引
		for i in range(history_timestamps.size()):
			if (timestamp - history_timestamps[i]) >= mirror_delay:
				target_index = i
			else:
				break
		
		if target_index >= 0 and target_index < player_position_history.size() - 1:
			# 计算2秒前玩家的移动方向
			var old_pos = player_position_history[target_index]
			var next_old_pos = player_position_history[target_index + 1]
			var old_movement = next_old_pos - old_pos
			
			# 反向移动（镜像操作）
			var mirror_movement = -old_movement
			var new_position = ai_swordman.global_position + mirror_movement
			
			# 限制AI移动范围，避免移出屏幕
			var screen_size = get_viewport().get_visible_rect().size
			new_position.x = clamp(new_position.x, 50, screen_size.x - 50)
			new_position.y = clamp(new_position.y, 50, screen_size.y - 50)
			
			ai_swordman.global_position = new_position
		else:
			# 如果没有足够的历史数据，使用基础AI行为
			_advanced_ai_behavior(delta)
	else:
		# 历史数据不足时，使用基础AI行为
		_advanced_ai_behavior(delta)

func _on_player_hit(_who: swordMan):
	# 玩家被击中时，AI进入撤退状态
	current_state = AIState.RETREAT
