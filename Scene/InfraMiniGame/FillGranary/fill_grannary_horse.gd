class_name fill_granary_hourse 
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	orighinpos=self.position # Replace with function body.

@onready var texture_rect_4: TextureRect = $TextureRect4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#

const FLASH_COLOR := Color(1.8, 1.8, 1.8)  # 高亮颜色，可调
const FLASH_DURATION := 3   # 一次完整明暗循环时间



#var targetGranner
@onready var tween: Tween = null
@onready var MoveTween: Tween = null
func start_flash():
	if tween and tween.is_valid():
		tween.kill()
	
	tween = create_tween()
	tween.set_loops()  # 无限循环
	tween.tween_property(texture_rect_4, "modulate", FLASH_COLOR, FLASH_DURATION / 2)
	tween.tween_property(texture_rect_4, "modulate", Color.WHITE, FLASH_DURATION / 2)
@onready var label: Label = $Label
var orighinpos
func crateHorse(value):
	holdValue=value
	updateDetail()
	self.show()
	self.position=orighinpos

func updateDetail():
	if targetValue!=-1:
		label.text="目标{num}号".format({"num":targetValue})+"\n"+var_to_str(holdValue)
	else:
		label.text=var_to_str(holdValue)

func stop_flash():
	if tween and tween.is_valid():
		tween.kill()
	 #恢复正常颜色（可以改成你原来的颜色）
	tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.15)
@onready var animation_player: AnimationPlayer = $TextureRect4/AnimationPlayer

var holdValue=-1
var targetValue=-1
func selectGrannary(grannary:granary_house):
	if MoveTween and MoveTween.is_valid():
		MoveTween.kill()

	MoveTween = create_tween()
	targetValue=grannary._index
	MoveTween.tween_property(self, "global_position", grannary.global_position, 2.5)
	stop_flash()
	animation_player.play("carriage")
	animation_player.speed_scale = 2
	var finishFunc=func(grannary):
		if MoveTween and MoveTween.is_valid():
			MoveTween.kill()	
		animation_player.stop()	
		grannary.addValue(holdValue)
		self.hide()
		$"../..".refreshHorse()
	MoveTween.finished.connect(finishFunc.bind(grannary))
	updateDetail()
@onready var area_2d: Area2D = $Area2D
