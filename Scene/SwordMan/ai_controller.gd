class_name AIController
extends Node

@export var ai_swordman: swordMan
@export var player_swordman: swordMan
@export var move_speed: float = 100.0
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
var prediction_factor: float = 0.5 # 预测系数
var last_player_position: Vector2
var player_velocity: Vector2
var dodge_timer: float = 0.0
var dodge_direction: Vector2


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
	
	match current_state:
		AIState.IDLE:
			if distance < safe_distance * 1.5:
				current_state = AIState.CHASE
				
		AIState.CHASE:
			if distance < attack_distance:
				current_state = AIState.ATTACK
			elif distance > safe_distance * 2:
				current_state = AIState.IDLE
			ai_swordman.global_position += direction * move_speed * delta
			
		AIState.ATTACK:
			if distance > attack_distance * 1.2:
				current_state = AIState.CHASE
			# 尝试保持在攻击距离内
			var ideal_pos = player_swordman.global_position - direction * attack_distance
			ai_swordman.global_position = ai_swordman.global_position.move_toward(ideal_pos, move_speed * delta)
			
		AIState.RETREAT:
			if distance > safe_distance:
				current_state = AIState.CHASE
			ai_swordman.global_position -= direction * move_speed * 1.5 * delta

# 高难度AI行为
func _advanced_ai_behavior(delta):
	var current_player_pos = player_swordman.global_position
	
	# 计算玩家速度
	player_velocity = (current_player_pos - last_player_position) / delta
	last_player_position = current_player_pos
	
	# 预测玩家位置
	var predicted_player_pos = current_player_pos + player_velocity * prediction_factor
	
	var direction = (predicted_player_pos - ai_swordman.global_position).normalized()
	var distance = ai_swordman.global_position.distance_to(current_player_pos)
	
	# 更新闪避计时器
	if dodge_timer > 0:
		dodge_timer -= delta
	
	match current_state:
		AIState.IDLE:
			if distance < safe_distance * 1.8:
				current_state = AIState.CHASE
				
		AIState.CHASE:
			if distance < attack_distance * 0.8:
				current_state = AIState.ATTACK
			elif distance > safe_distance * 2.5:
				current_state = AIState.IDLE
			
			# 智能移动：如果玩家移动速度很快，尝试拦截
			var move_direction = direction
			if player_velocity.length() > 50:
				var intercept_point = _calculate_intercept_point(current_player_pos, player_velocity)
				move_direction = (intercept_point - ai_swordman.global_position).normalized()
			
			ai_swordman.global_position += move_direction * move_speed * 1.2 * delta
			
		AIState.ATTACK:
			if distance > attack_distance * 1.5:
				current_state = AIState.CHASE
			
			# 高级攻击策略：保持最佳攻击距离并进行微调
			var optimal_distance = attack_distance * 0.9
			var ideal_pos = predicted_player_pos - direction * optimal_distance
			
			# 添加随机闪避动作
			if dodge_timer <= 0 and randf() < 0.3:
				dodge_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
				dodge_timer = 0.5
			
			if dodge_timer > 0:
				ideal_pos += dodge_direction * 50
			
			ai_swordman.global_position = ai_swordman.global_position.move_toward(ideal_pos, move_speed * 1.3 * delta)
			
		AIState.RETREAT:
			if distance > safe_distance * 1.2:
				current_state = AIState.CHASE
			# 智能撤退：向玩家移动方向的反方向撤退
			var retreat_direction = -direction
			if player_velocity.length() > 20:
				retreat_direction = -player_velocity.normalized()
			ai_swordman.global_position += retreat_direction * move_speed * 1.8 * delta

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
	if player_position_history.size() >= 2:
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
			_basic_ai_behavior(delta)
	else:
		# 历史数据不足时，使用基础AI行为
		_basic_ai_behavior(delta)

func _on_player_hit(_who: swordMan):
	# 玩家被击中时，AI进入撤退状态
	current_state = AIState.RETREAT
