extends Node2D

@onready var liubei:CharacterBody2D  = $liubei
@onready var caocao:CharacterBody2D = $caocao
const dialogue_resource = preload("res://dialogues/青梅煮酒.dialogue")
var caocaoPos:Vector2
var liubeiPos:Vector2

# 鼠标移动限制相关变量
var mouse_speed_limit: float = 0.0 # 0表示无限制
var last_mouse_position: Vector2
var is_mouse_limited: bool = false
var original_mouse_mode: bool = false

@onready var ai_controller: AIController = $AIController

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
	initBattleRect()
	Transitions.post_transition.connect(startGame)
	set_mouse_speed_limit(5)
	# 初始化鼠标位置
	#last_mouse_position = get_global_mouse_position()
func post_transition():
	initBattleRect()
	
func initBattleRect():

	if GameManager.trainGeneral=="张飞":
		changeColor(Color.DARK_RED,tr(GameManager.trainGeneral))
		caocao.changeWaitTime(0.0065)
	elif GameManager.trainGeneral=="关羽":
		changeColor(Color.GREEN,tr(GameManager.trainGeneral))
		caocao.changeWaitTime(0.0060)
	elif GameManager.trainGeneral=="赵云":
		changeColor(Color.WHITE,tr(GameManager.trainGeneral))
		caocao.changeWaitTime(0.0055)
	else:
		#更改ai类型以及ai的时长
		caocao.changeWaitTime(0.01)
	var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.雌雄双股剑)	
	#判断有无武器
	if num>=1:
		liubei.hp=3
	else:
		liubei.hp=2
	if GameManager.trainLevel==3:
		caocao.hp=3
	elif GameManager.trainLevel==2:
		caocao.hp=3
	elif GameManager.trainLevel==1:
		caocao.hp=2



func startGame():
	if GameManager.sav.have_event["比武训练教程"]==false:
		GameManager.sav.have_event["比武训练教程"]=true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"是否第一次")
	else:
		dialogEnd()		
const zhangba = preload("res://addons/inventory_example/textures/weapons/丈八.png")

const yinyueqiang = preload("res://addons/inventory_example/textures/weapons/银月.png")

const qinglong = preload("res://addons/inventory_example/textures/weapons/青龙.png")

func changeColor(color,label):
	var hps=h_box_container_hp.get_children()
	for hp:ColorRect in hps:
		hp.color=color
	if GameManager.trainLevel==3:
		ai_controller.ai_id=2
		ai_controller.ai_type=ai_controller.AIType.MIRROR
		
		if GameManager.trainGeneral=="赵云":
			caocao.changeWeapon(yinyueqiang)
			ai_controller.mirrorWaitTime=1.2
		elif GameManager.trainGeneral=="关羽":
			caocao.changeWeapon(qinglong)
			ai_controller.mirrorWaitTime=0.6
		elif GameManager.trainGeneral=="张飞":
			caocao.changeWeapon(zhangba)
			ai_controller.mirrorWaitTime=1.8
		else:
			ai_controller.mirrorWaitTime=2
	caocao.changeColor(color)
	enemy_label.add_theme_color_override("font_color",color)
	enemy_label.text=label
func dialogEnd():
	caocao.isdead=false
	liubei.isdead=false
	
	caocao.sword.show()
	liubei.sword.show()
	GameManager.swordManGameState=GameManager.gameState.start
	
	# 将鼠标位置设置为刘备当前位置
	Input.warp_mouse(liubeiPos)
	last_mouse_position = liubeiPos
	print("鼠标位置已设置为刘备位置: ", liubei.global_position)
	
	
func _on_player_hit(_who: swordMan):

	await 0.5
	GameManager.swordManGameState=GameManager.gameState.pause
	# 玩家被击中时，AI进入撤退状态
	_who.hp-=1
	if _who._name==_who.type_name.CaoCao:
		SoundManager.play_sound(sounds.HUI_1)
		if _who.hp==2:
			
			if GameManager.trainGeneral.length()==0:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"击中曹操2")
			else:
				dialogEnd()			
		elif _who.hp==1:
			if GameManager.trainGeneral.length()==0:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"击中曹操")
			else:
				dialogEnd()

		elif _who.hp==0:
			if GameManager.trainGeneral.length()==0:
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
		SoundManager.play_sound(sounds.HUI_2)
		if _who.hp==2:
			if GameManager.trainGeneral.length()==0:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"被曹操击中2")
			else:
				dialogEnd()	
		if _who.hp==1:
			if GameManager.trainGeneral.length()==0:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"被曹操击中")
			else:
				dialogEnd()
		elif _who.hp==0:
			if GameManager.trainGeneral.length()==0:
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
		if is_mouse_limited and mouse_speed_limit > 0:
			# 限制鼠标移动速度
			var current_mouse_pos = event.global_position
			var mouse_movement = current_mouse_pos - last_mouse_position
			var movement_distance = mouse_movement.length()
			
			# 如果移动距离超过限制，则限制移动
			if movement_distance > mouse_speed_limit:
				var limited_movement = mouse_movement.normalized() * mouse_speed_limit
				var limited_position = last_mouse_position + limited_movement
				liubei.position = limited_position
				last_mouse_position = limited_position
				# 将鼠标位置强制设置到限制位置
				Input.warp_mouse(limited_position)
			else:
				liubei.position = current_mouse_pos
				last_mouse_position = current_mouse_pos
		else:
			# 无限制模式
			liubei.position = event.global_position
			last_mouse_position = event.global_position


func winGame():
	restore_mouse_movement() # 恢复鼠标移动
	GameManager.trainResult=SceneManager.trainResult.win
	SceneManager.changeScene(SceneManager.roomNode.DRILL_GROUND,2)
func loseGame():
	restore_mouse_movement() # 恢复鼠标移动
	GameManager.trainResult=SceneManager.trainResult.fail
	SceneManager.changeScene(SceneManager.roomNode.DRILL_GROUND,2)
	
	
func retryGame():
	lose_rect.hide()
	initBattleRect()
	set_mouse_speed_limit(5)
	dialogEnd()
func enterNewTurn():
	var target_position = Vector2(100, 100)  # 移动到 (100, 100) 像素
	Input.warp_mouse(liubeiPos)
	caocao.position=caocaoPos
	liubei.position=liubeiPos
	print("鼠标已移动到：", target_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# 设置鼠标移动速度限制
func set_mouse_speed_limit(limit: float):
	mouse_speed_limit = limit
	is_mouse_limited = limit > 0
	print("鼠标移动速度限制设置为: ", limit)

# 移除鼠标移动速度限制
func remove_mouse_speed_limit():
	mouse_speed_limit = 0.0
	is_mouse_limited = false
	print("鼠标移动速度限制已移除")

# 游戏结束时恢复鼠标移动
func restore_mouse_movement():
	remove_mouse_speed_limit()
	print("游戏结束，鼠标移动已恢复正常")
@onready var bit_player: VideoStreamPlayer = $bitPlayer
const c_1 = preload("res://Asset/vedio/小球教程1.ogv")
const c_2 = preload("res://Asset/vedio/小球教程2.ogv")
func bitPlayerCourse(index):
	
	bit_player.show()
	bit_player.stop()
	if index==0:
		bit_player.stream=c_1
	else:
		bit_player.stream=c_2
	#if index==1:
	#	bit_player.finished.connect(_on_video_player_finished)
	bit_player.play()

#func _on_video_player_finished():
#	bit_player.hide()
	#hp_panel.show()
	#res_panel.show()
	#support_panel.show()
	
	#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"克苏鲁梦境结束")
