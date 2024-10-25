@tool
class_name  swordMan
extends Node
@onready var sprite_2d = $Sprite2D

@onready var sword = $Sword9
@export var color:Color:
	get:
		return color
	set(value):
		if sprite_2d!=null:
			sprite_2d.set_modulate(value)
		color=value
		pass
@onready var timer = $Sword9/Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	if sprite_2d!=null:
		sprite_2d.set_modulate(color)
	timer.start()
	#tween.tween_property(sword, "rotation_degrees", 360 * ROTATION_DURATION+stop_angle, 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#将其旋转
	pass

var degree=0
var m_Radius=40
func _on_timer_timeout():
	degree=degree+1
	
	if degree>=360:
		degree=0
	##sword.rotation=degree
	#var hudu=PI *degree/ 180
	#var x = m_Radius * cos(hudu);
	#var z = m_Radius * sin(hudu);
	#print(degree)
	#sword.position=Vector2(x,z)
	self.rotation_degrees=degree

@onready var areabody = $body
@onready var areasword = $Sword9/sword

func _on_GetHit_area_entered(area):
	if area!=areabody and area!=areasword:
		if area.name=="sword":
			print("aaaa")


func _on_Hit_area_entered(area):
	pass
