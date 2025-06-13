extends Node2D

@onready var liubei:CharacterBody2D  = $liubei
@onready var caocao:CharacterBody2D = $caocao
const dialogue_resource = preload("res://dialogues/青梅煮酒.dialogue")
var caocaoPos:Vector2
var liubeiPos:Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	caocaoPos=caocao.position
	liubeiPos=liubei.position
	
	caocao.hit_body.connect(_on_player_hit)
	liubei.hit_body.connect(_on_player_hit)
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"最终章节")
	
func dialogEnd():
	caocao.isdead=false
	liubei.isdead=false
	GameManager.swordManGameState=GameManager.gameState.start
	
	
func _on_player_hit(_who: swordMan):
	await 0.5
	GameManager.swordManGameState=GameManager.gameState.pause
	# 玩家被击中时，AI进入撤退状态
	_who.hp-=1
	if _who._name==_who.type_name.CaoCao:
		if _who.hp==1:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"击中曹操")
		elif _who.hp==0:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"赢曹操")
	elif  _who._name==_who.type_name.LiuBei:
		if _who.hp==1:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"被曹操击中")
		elif _who.hp==0:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"输曹操")
	enterNewTurn()
	_who.animation_player.play("RESET")
	_who.animation_player.seek(0, true)
	#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"SaveFile")
func _input(event):
	if GameManager.swordManGameState==GameManager.gameState.pause:
		return 
	if event is InputEventMouseMotion:
		liubei.position=event.global_position
	#print(event)
		pass



func enterNewTurn():
	var target_position = Vector2(100, 100)  # 移动到 (100, 100) 像素
	Input.warp_mouse(liubeiPos)
	caocao.position=caocaoPos
	liubei.position=liubeiPos
	print("鼠标已移动到：", target_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
