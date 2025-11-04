extends Control

@onready var context: Label = $context


@onready var lock_animated_sprite_2d: AnimatedSprite2D = $ColorRect2/AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
@onready var succuss: TextureRect = $TextureRect/succuss
@onready var reward: TextureRect = $TextureRect/reward
@onready var discard: TextureRect = $TextureRect/discard

@export var lstate:lockState
@onready var lock: ColorRect = $lock
@onready var link: Sprite2D = $lock/Link
@onready var link_2: Sprite2D = $lock/Link2



# 锁定，解锁，关闭，领取奖励，领取过
func changeState(state):
	lstate=state
	if lstate==lockState.lock:
		lock.show()
		
		
		succuss.hide()
		reward.hide()
		discard.hide()		
		
	elif lstate==lockState.unlock:
		lock_animated_sprite_2d.play("new_animation")
		var _func=func(stringname):
			var tween=create_tween()
			tween.tween_property(link, "self_modulate:a",0,1)	
			tween.tween_property(link_2, "self_modulate:a",0,1)
			var _func2=func(stringname):
				changeState(lockState.close)
				#link.hide()
				#link_2
			tween.tween_callback(_func2)

		lock_animated_sprite_2d.animation_finished.connect(_func)
		#播放音效
		#播完执行tween 动画，播放锁链拉升声音，tween 动画完切状态

		
	elif lstate==lockState.close:
		lock.hide()
		succuss.hide()
		reward.hide()
		discard.show()
	elif lstate==lockState.canReward:
		lock.hide()
		succuss.hide()
		reward.show()
		discard.hide()
	elif lstate==lockState.after:
		lock.hide()
		succuss.show()
		reward.hide()
		discard.hide()
	
	
enum lockState{
	lock,
	unlock,
	close,
	canReward,
	after,
	
}
