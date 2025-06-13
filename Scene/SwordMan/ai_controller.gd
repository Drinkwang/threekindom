class_name AIController
extends Node

@export var ai_swordman: swordMan
@export var player_swordman: swordMan
@export var move_speed: float = 100.0
@export var safe_distance: float = 300.0 # 与玩家的安全距离
@export var attack_distance: float = 160 # 攻击距离

enum AIState { IDLE, CHASE, ATTACK, RETREAT }
var current_state: AIState = AIState.IDLE


func _ready():
	if ai_swordman and player_swordman:
		# 连接玩家被击中信号
		player_swordman.hit_body.connect(_on_player_hit)
		
func _physics_process(delta):
	if not ai_swordman or not player_swordman or ai_swordman.isdead or player_swordman.isdead or GameManager.swordManGameState==GameManager.gameState.pause:
		return
		
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

func _on_player_hit(_who: swordMan):
	# 玩家被击中时，AI进入撤退状态
	current_state = AIState.RETREAT
