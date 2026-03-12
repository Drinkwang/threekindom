class_name credit
extends Node2D

const __CREDIT__ = preload("res://Asset/other/常规credit曲子.MP3")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.currenceScene=self
	initData()
	SoundManager.play_music(__CREDIT__)
	credit_animation.play("credit")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



@onready var animation_player: AnimationPlayer = $"ColorRect/中文logo/AnimationPlayer"

@onready var back_animation_player: AnimationPlayer = $"ColorRect/AnimationPlayer"

#开端可以了。剩下就是播bgm
#开始credit
func initData():
	await get_tree().create_timer(1.5).timeout
	var _endfunc=func(name):
		await get_tree().create_timer(3).timeout
		back_animation_player.play("colorRect")
		#back_animation_player.play("new_animation", -1) 

	animation_player.animation_finished.connect(_endfunc)	
		
	animation_player.play("new_animation")
@onready var bgfade: AnimationPlayer = $"内饰/bgfade"

@onready var credit_animation: AnimationPlayer = $creditAnimation

@onready var caocao: Node2D = $"曹操老"
@onready var guojia: Node2D = $"郭嘉"


func fade():
	bgfade.play("fadein")
	await get_tree().create_timer(1).timeout
	bgfade.play("fadeout")

const final = preload("res://Asset/bgm/会议室.wav")
func eggFunc():
	PanelManager.Fade_Blank(Color.BLACK,1,PanelManager.fadeType.fadeOut)
	SoundManager.play_ambient_sound(final)
	DialogueManager.show_example_dialogue_balloon(GameManager.sys,"彩蛋剧情")


@onready var finalBG: ColorRect = $CanvasLayer/final

	
func settleGame():
	finalBG.show()
	#修改finalBG

#ESC按钮，待开发
func _on_button_button_down() -> void:
	SoundManager.stop_all_ambient_sounds()
	GameManager.ReturnMenu()

var paused_animation_time 
#= animation_player.current_animation_position

@onready var control_sub: Control = $CanvasLayer/Control

func pauseCredit():
	SoundManager.pause_music()
	credit_animation.pause()
	control_sub.pause_subtitle()
	paused_animation_time = credit_animation.current_animation_position
func continusCredit():
	SoundManager.resume_music()
	
	control_sub.resume_subtitle()
	credit_animation.play("credit", paused_animation_time)
	
