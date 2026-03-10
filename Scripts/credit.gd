extends Node2D

const __CREDIT__ = preload("res://Asset/other/常规credit曲子.MP3")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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

func fade():
	bgfade.play("fadein")
	await get_tree().create_timer(1).timeout
	bgfade.play("fadeout")


func fadeIN():
	pass
func fadeOUT():
	pass
	
