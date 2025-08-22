@tool
class_name boardCard
extends Control
var originScale
@export var _value:int:
	get: return _value
	set(value): 
		_value=value
		var kvalue=_value
		var reside:int=floori((kvalue)%13)
		var devisor:int=floori((kvalue)/13)
		setimg(reside,devisor)
@onready var point_value: Label = $NinePatchRect/pointValue
@onready var flowercolor: Label = $NinePatchRect/flowercolor
@onready var img: TextureRect = $NinePatchRect/img
@export var holdType:board_game.cardHoldType
const binli = preload("res://Asset/ui/兵力.png")
const renxin = preload("res://Asset/ui/人心.png")
const coin = preload("res://Asset/ui/钱财.png")
const zhanli = preload("res://Asset/ui/战力.png")		


@onready var animation_player: AnimationPlayer = $AnimationPlayer


@onready var nine_patch_rect: NinePatchRect = $NinePatchRect


@onready var score_ball: ColorRect = $scoreBall
@onready var _color_rect: ColorRect = $ColorRect

	
func setimg(reside,devisor):
	var kvalue=reside+1
	if point_value==null:
		return
	if kvalue==1:
		point_value.text="A"
	else:
		point_value.text=var_to_str(kvalue)
	if devisor==0:#红桃-民心
		point_value.add_theme_color_override("font_color",Color.RED)
		flowercolor.add_theme_color_override("font_color",Color.RED)
		flowercolor.text="♥"
		img.texture=renxin
	elif devisor==1:#黑桃 -声望 帅旗
		point_value.add_theme_color_override("font_color",Color.BLACK)
		flowercolor.add_theme_color_override("font_color",Color.BLACK)
		flowercolor.text="♠"
		img.texture=zhanli
	elif devisor==2:#梅花 -钱
		point_value.add_theme_color_override("font_color",Color.BLACK)
		flowercolor.add_theme_color_override("font_color",Color.BLACK)
		flowercolor.text="♣"
		img.texture=coin
	elif devisor==3:#方片 兵力
		point_value.add_theme_color_override("font_color",Color.RED)
		flowercolor.add_theme_color_override("font_color",Color.RED)
		flowercolor.text="♦"
		img.texture=binli				
# Called when the node enters the scene tree for the first time.



func _ready() -> void:
	originScale=self.scale
	

	nine_patch_rect.material=nine_patch_rect.material.duplicate()

	img.material=img.material.duplicate()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !(event is InputEventMouseButton):
		return
		
	var gouppunishType
	if 	GameManager.currenceScene.groupPunishTyp2!=board_game.groupType.none:
		gouppunishType=GameManager.currenceScene.groupPunishTyp2
	else:
		gouppunishType=GameManager.currenceScene.groupPunishTyp
	GameManager.currenceScene.groupPunishTyp2=board_game.groupType.none
	if gouppunishType!=board_game.groupType.none and holdType==board_game.cardHoldType.player:
		
		var reside:int=floori((_value)%13)
		var devisor:int=floori((_value)/13)
		if devisor==0 and gouppunishType==board_game.groupType.min and GameManager.currenceScene.punishStage==true:#红桃-民心
			queue_free()
			GameManager.currenceScene.SettlePunish()
		elif devisor==1  and gouppunishType==board_game.groupType.shi and GameManager.currenceScene.punishStage==true:#黑桃 -声望 帅旗
			queue_free()			
			GameManager.currenceScene.SettlePunish()
		elif devisor==2 and gouppunishType==board_game.groupType.shang and GameManager.currenceScene.punishStage==true:#梅花 -钱
			queue_free()			
			GameManager.currenceScene.SettlePunish()
		elif devisor==3 and gouppunishType==board_game.groupType.bin and GameManager.currenceScene.punishStage==true:#方片 兵力
			queue_free()			
			GameManager.currenceScene.SettlePunish()
		
		pass#选中卡牌如果满足条件，则销毁 同时完成对应销毁，
	elif(event is InputEventMouseButton and event.button_index==1 and holdType==board_game.cardHoldType.player and GameManager.currenceScene.playerStage>0):
		SoundManager.play_sound(sounds.SFX_FAST_UI_CLICK)
		var moupos=get_viewport().get_mouse_position()
		GameManager.currenceScene.selectCard=self
		GameManager.currenceScene.clickPoint(moupos)
		#创建ui跟手
		#创建红线
		#这些东西可以在scene里写 也可以定义成专门的物体
		#右键或者空左键时 需要点击
		
		
#播这个的同时，1秒移动到deck区
@onready var animation_player_reward: AnimationPlayer = $AnimationPlayer_reward


func _on_area_2d_mouse_entered() -> void:
	if holdType==board_game.cardHoldType.enemy or GameManager.currenceScene._phaseName!=board_game.phaseName.useCard:
		return
		
	self.scale=Vector2(originScale.x*1.2,originScale.y*1.2)
	self.z_index=10


func _on_area_2d_mouse_exited() -> void:
	if holdType==board_game.cardHoldType.enemy or GameManager.currenceScene._phaseName!=board_game.phaseName.useCard:
		return	
	self.scale=Vector2(originScale.x*1,originScale.y*1)
	self.z_index=0
