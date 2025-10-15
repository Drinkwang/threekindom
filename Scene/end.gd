extends Node2D

@onready var liubei:CharacterBody2D  = $liubei
@onready var caocao:CharacterBody2D = $caocao
const dialogue_resource = preload("res://dialogues/青梅煮酒.dialogue")
var caocaoPos:Vector2
var liubeiPos:Vector2


@onready var enemy_label: Label = $CanvasInventory/CAOCAOBox/Label

@onready var win_rect: ColorRect = $CanvasInventory/winRect
@onready var blink_rect: TextureRect = $CanvasInventory/blinkRect
@onready var blink_animation_player: AnimationPlayer = $CanvasInventory/blinkRect/AnimationPlayer

@onready var lose_rect: ColorRect = $CanvasInventory/LoseRect

@onready var h_box_container_hp: HBoxContainer = $CanvasInventory/CAOCAOBox/HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	caocaoPos=caocao.position
	liubeiPos=liubei.position
	caocao.sword.hide()
	liubei.sword.hide()
	caocao.hit_body.connect(_on_player_hit)
	liubei.hit_body.connect(_on_player_hit)
	#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"最终章节")


func initBattleRect():

	if GameManager.trainGeneral=="张飞":
		changeColor(Color.RED,tr(GameManager.trainGeneral))
	elif GameManager.trainGeneral=="关羽":
		changeColor(Color.GREEN,tr(GameManager.trainGeneral))
	elif GameManager.trainGeneral=="赵云":
		changeColor(Color.WHITE,tr(GameManager.trainGeneral))
	else:
		pass
		
		
	if GameManager.trainLevel==2:
		caocao.hp=3
	elif GameManager.trainLevel==1:
		caocao.hp=2
	elif GameManager.trainLevel==0:
		caocao.hp=1
func changeColor(color,label):
	var hps=h_box_container_hp.get_children()
	for hp:ColorRect in hps:
		hp.color=color
	enemy_label.add_theme_color_override("font_color",color)
	enemy_label.text=label
func dialogEnd():
	caocao.isdead=false
	liubei.isdead=false
	
	caocao.sword.show()
	liubei.sword.show()
	GameManager.swordManGameState=GameManager.gameState.start
	
	
func _on_player_hit(_who: swordMan):
	await 0.5
	GameManager.swordManGameState=GameManager.gameState.pause
	# 玩家被击中时，AI进入撤退状态
	_who.hp-=1
	if _who._name==_who.type_name.CaoCao:
		if _who.hp==1:
			if GameManager.trainGeneral.length()!=0:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"击中曹操")
		elif _who.hp==0:
			if GameManager.trainGeneral.length()!=0:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"赢曹操")
			else:
				blink_rect.show()
				blink_animation_player.play("win")
				win_rect.show()
				var finishfunc=func(aniname):
					blink_rect.hide()
				blink_animation_player.animation_finished.connect(finishfunc)				
				SoundManager.stop_music()
				SoundManager.play_sound(sounds.GOOD_THING)
	elif  _who._name==_who.type_name.LiuBei:
		if _who.hp==1:
			if GameManager.trainGeneral.length()!=0:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"被曹操击中")
		elif _who.hp==0:
			if GameManager.trainGeneral.length()!=0:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"输曹操")
			else:
				SoundManager.stop_music()	
				lose_rect.show()
				SoundManager.play_sound(sounds.BAD_BATTLE)
				#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"游戏失败")
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


func winGame():
	GameManager.trainResult=SceneManager.trainResult.win
	SceneManager.changeScene(SceneManager.roomNode.DRILL_GROUND,2)
func loseGame():
	GameManager.trainResult=SceneManager.trainResult.fail
	SceneManager.changeScene(SceneManager.roomNode.DRILL_GROUND,2)
func enterNewTurn():
	var target_position = Vector2(100, 100)  # 移动到 (100, 100) 像素
	Input.warp_mouse(liubeiPos)
	caocao.position=caocaoPos
	liubei.position=liubeiPos
	print("鼠标已移动到：", target_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
