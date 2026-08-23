extends Node2D

@onready var liubei:CharacterBody2D  = $liubei
@onready var caocao:CharacterBody2D = $caocao
const dialogue_resource = preload("res://dialogues/青梅煮酒.dialogue")
const PlayerInputNormalizer = preload("res://Scene/SwordMan/player_input_normalizer.gd")
const PlayerMovementLimiter = preload("res://Scene/SwordMan/player_movement_limiter.gd")
var caocaoPos:Vector2
var liubeiPos:Vector2
var _battle_has_started := false

const PLAYER_DEFAULT_SPEED := 300.0
const PLAYER_DUAL_SWORD_SPEED := 350.0
const PLAYER_ARENA_MARGIN := 55.0
const REFERENCE_INPUT_INTERVAL_SECONDS := 1.0 / 60.0
const MIN_INPUT_INTERVAL_SECONDS := 1.0 / 1000.0
const INPUT_VELOCITY_HOLD_USEC := 50000
const WARP_EVENT_TOLERANCE := 1.0
var player_input_velocity := Vector2.ZERO
var last_mouse_sample_position := Vector2.ZERO
var last_mouse_sample_usec := 0
var input_velocity_expires_usec := 0
var ignore_warp_motion := false
var last_warp_screen_position := Vector2.ZERO
var player_reference_speed := PLAYER_DEFAULT_SPEED
var player_has_double_sword := false

@onready var ai_controller: AIController = $AIController

@onready var enemy_label: Label = $CanvasInventory/CAOCAOBox/Label

@onready var win_rect: ColorRect = $CanvasInventory/winRect
@onready var blink_rect: TextureRect = $CanvasInventory/blinkRect
@onready var blink_animation_player: AnimationPlayer = $CanvasInventory/blinkRect/AnimationPlayer

@onready var lose_rect: ColorRect = $CanvasInventory/LoseRect

@onready var h_box_container_hp: HBoxContainer = $CanvasInventory/CAOCAOBox/HBoxContainer
const finalmusic = preload("res://Asset/music/曹刘针锋相对.mp3")
# Debug knob for the final Cao Cao encounter. Keep this at 3 for the shipped default.
@export_range(1, 3, 1) var final_caocao_ai_difficulty: int = 3


@onready var cao_label: Label = $CanvasInventory/CAOCAOBox/Control/Label
@onready var liu_label: Label = $CanvasInventory/CAOCAOBox/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.swordManGameState = GameManager.gameState.pause
	caocao.isdead = true
	liubei.isdead = true
	caocaoPos=caocao.position
	liubeiPos=liubei.position
	caocao.set_weapon_enabled(false)
	liubei.set_weapon_enabled(false)
	caocao.hit_body.connect(_on_player_hit)
	liubei.hit_body.connect(_on_player_hit)
	initBattleRect()
	Transitions.post_transition.connect(startGame)
	
	SignalManager.changeLanguage.connect(changeLanguage)
	changeLanguage()
const _1_SIM = preload("res://Asset/Font/1_sim.ttf")	
func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="ru":
		cao_label.add_theme_font_override("font",_1_SIM)
		liu_label.add_theme_font_override("font",_1_SIM)
	else:
		liu_label.remove_theme_font_override("font")
	
func post_transition():
	initBattleRect()
	
func initBattleRect():

	SoundManager.stop_music()
	SoundManager.play_music(finalmusic)
	if GameManager.trainGeneral=="张飞":
		changeColor(Color.DARK_RED,tr(GameManager.trainGeneral))
		caocao.changeWaitTime(0.0065)
	elif GameManager.trainGeneral=="关羽":
		changeColor(Color.GREEN,tr(GameManager.trainGeneral))
		caocao.changeWaitTime(0.0060)
	elif GameManager.trainGeneral=="无名":
		changeColor(Color.WHITE,tr(GameManager.trainGeneral))
		caocao.changeWaitTime(0.0055)
	else:
		_configure_final_caocao_ai()
		#SoundManager.stop_music()
		#SoundManager.play_music(finalmusic)
		# Final Cao Cao uses the fastest sword rotation allowed by the scene.
		caocao.changeWaitTime(0.0001)
	var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.雌雄双股剑)	
	player_has_double_sword = num >= 1
	liubei.set_double_sword_equipped(player_has_double_sword)
	#判断有无武器
	if player_has_double_sword:
		liubei.hp=3
		player_reference_speed=PLAYER_DUAL_SWORD_SPEED
	else:
		liubei.hp=2
		player_reference_speed=PLAYER_DEFAULT_SPEED
	if GameManager.trainLevel==3:
		caocao.hp=3
	elif GameManager.trainLevel==2:
		caocao.hp=3
	elif GameManager.trainLevel==1:
		caocao.hp=2

func _configure_final_caocao_ai() -> void:
	ai_controller.ai_id = 3
	ai_controller.ai_type = ai_controller.AIType.MASTER
	ai_controller.configure_master(final_caocao_ai_difficulty)



func startGame():
	if GameManager.sav.have_event["比武训练教程"]==false:
		_show_mouse_after_battle()
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
		
		if GameManager.trainGeneral=="无名":
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
	if GameManager.trainGeneral.length() > 0 and not _battle_has_started:
		_request_training_skip_or_start()
		return
	begin_training_battle()


func _request_training_skip_or_start() -> void:
	var has_item := GameManager.has_minigame_skip_item(InventoryManagerItem.淆武幽帖)
	var skip_cost := GameManager.get_training_skip_cost()
	if GameManager.sav.training_skip_enabled and has_item and GameManager.sav.coin >= skip_cost:
		_show_mouse_after_battle()
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, "使用淆武幽帖")
	else:
		begin_training_battle()


func begin_training_battle() -> void:
	_battle_has_started = true
	caocao.isdead=false
	liubei.isdead=false
	
	caocao.set_weapon_enabled(true)
	liubei.set_weapon_enabled(true)
	GameManager.swordManGameState=GameManager.gameState.start
	_hide_mouse_for_battle()
	_reset_player_control()
	print("鼠标位置已设置为刘备位置: ", liubei.global_position)

func confirm_training_skip() -> void:
	if not GameManager.sav.training_skip_enabled or not GameManager.has_minigame_skip_item(InventoryManagerItem.淆武幽帖):
		begin_training_battle()
		return
	if not GameManager.try_spend_minigame_skip_cost(GameManager.get_training_skip_cost()):
		GameManager.show_minigame_skip_money_insufficient()
		begin_training_battle()
		return
	_battle_has_started = true
	GameManager.swordManGameState = GameManager.gameState.pause
	_show_mouse_after_battle()
	blink_rect.show()
	blink_animation_player.play("win")
	win_rect.show()
	var finishfunc=func(_aniname):
		blink_rect.hide()
	blink_animation_player.animation_finished.connect(finishfunc, CONNECT_ONE_SHOT)
	SoundManager.stop_music()
	SoundManager.play_sound(sounds.GOOD_THING)
	
	
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
				_show_mouse_after_battle()
				AchievementManager.set_achievement("NEW_ACHIEVEMENT_2_1")
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"赢曹操")
			else:
				_show_mouse_after_battle()
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
				_show_mouse_after_battle()
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"输曹操")
			else:
				_show_mouse_after_battle()
				SoundManager.stop_music()	
				lose_rect.show()
				SoundManager.play_sound(sounds.BAD_BATTLE)
				#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"游戏失败")
	enterNewTurn()
	_who.animation_player.play("RESET")
	_who.animation_player.seek(0, true)
	#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"SaveFile")
func _input(event):
	if GameManager.swordManGameState == GameManager.gameState.pause:
		return
	if event is InputEventMouseButton and event.pressed:
		if Input.mouse_mode != Input.MOUSE_MODE_CONFINED_HIDDEN:
			_hide_mouse_for_battle()
			_reset_mouse_sampling()
		return
	if event is InputEventMouseMotion:
		_update_mouse_velocity(event)


func _update_mouse_velocity(event: InputEventMouseMotion) -> void:
	var now_usec := Time.get_ticks_usec()
	if ignore_warp_motion and event.position.distance_to(last_warp_screen_position) <= WARP_EVENT_TOLERANCE:
		ignore_warp_motion = false
		return
	ignore_warp_motion = false

	var sample_position := _screen_to_world(event.position)
	var sample_interval := REFERENCE_INPUT_INTERVAL_SECONDS
	if last_mouse_sample_usec > 0:
		var elapsed_seconds := float(now_usec - last_mouse_sample_usec) / 1000000.0
		sample_interval = maxf(elapsed_seconds, MIN_INPUT_INTERVAL_SECONDS)
	player_input_velocity = PlayerInputNormalizer.calculate_velocity(
		sample_position - last_mouse_sample_position,
		sample_interval,
		player_reference_speed
	)
	last_mouse_sample_usec = now_usec
	input_velocity_expires_usec = now_usec + INPUT_VELOCITY_HOLD_USEC
	_warp_mouse_to_player()


func _physics_process(delta: float) -> void:
	if GameManager.swordManGameState != GameManager.gameState.start or liubei.isdead:
		liubei.controlled_velocity = Vector2.ZERO
		return
	var now_usec := Time.get_ticks_usec()
	if now_usec > input_velocity_expires_usec:
		player_input_velocity = Vector2.ZERO
	var old_position := liubei.global_position
	liubei.global_position = PlayerMovementLimiter.calculate_delta_position(
		old_position,
		player_input_velocity * delta,
		player_reference_speed,
		delta,
		get_viewport().get_visible_rect(),
		PLAYER_ARENA_MARGIN
	)
	liubei.controlled_velocity = (
		(liubei.global_position - old_position) / maxf(delta, 0.001)
	)


func _screen_to_world(screen_position: Vector2) -> Vector2:
	return get_canvas_transform().affine_inverse() * screen_position

func finalEndReturn():
	GameManager.sav.have_event["最终比武结束"]=true
	_show_mouse_after_battle()
	SceneManager.changeScene(SceneManager.roomNode.HOUSE,2)

func winGame():
	_show_mouse_after_battle()
	GameManager.trainResult=SceneManager.trainResult.win
	SceneManager.changeScene(SceneManager.roomNode.DRILL_GROUND,2)
func loseGame():
	_show_mouse_after_battle()
	GameManager.trainResult=SceneManager.trainResult.fail
	SceneManager.changeScene(SceneManager.roomNode.DRILL_GROUND,2)
	
	
func retryGame():
	lose_rect.hide()
	initBattleRect()
	dialogEnd()
func enterNewTurn():
	caocao.position=caocaoPos
	_reset_player_control()


func _reset_player_control() -> void:
	liubei.position = liubeiPos
	liubei.controlled_velocity = Vector2.ZERO
	player_input_velocity = Vector2.ZERO
	input_velocity_expires_usec = 0
	ai_controller.reset_player_tracking()
	_reset_mouse_sampling()


func _reset_mouse_sampling() -> void:
	last_mouse_sample_usec = 0
	_warp_mouse_to_player()


func _warp_mouse_to_player() -> void:
	last_mouse_sample_position = liubei.global_position
	last_warp_screen_position = get_canvas_transform() * liubei.global_position
	ignore_warp_motion = true
	get_viewport().warp_mouse(last_warp_screen_position)

func _hide_mouse_for_battle():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

func _show_mouse_after_battle():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _exit_tree():
	_show_mouse_after_battle()
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
