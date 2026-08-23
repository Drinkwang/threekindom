#@tool
class_name  swordMan
extends Node
@onready var sprite_2d = $Sprite2D
const SPARK_2D = preload("res://Scene/prefab/spark2d.tscn")



@onready var primary_sword: Sprite2D = $Sword9
@onready var double_sword: Sprite2D = $doublesword
var _double_sword_equipped := false
var _weapon_enabled := true

var sword: Sprite2D:
	get:
		return get_active_sword()

var timer: Timer:
	get:
		return get_active_sword_timer()

var collision_shape_2d: CollisionShape2D:
	get:
		return get_active_sword_collision()
enum type_name { LiuBei, CaoCao }
@export var _name:type_name
signal hit_body(who: swordMan)
@export var hparr:Array[ColorRect]
@export var color:Color:
	get:
		return color
	set(value):
		if sprite_2d!=null:
			sprite_2d.set_modulate(value)
		color=value
		pass
@export var hp:int:
	get:
		return hp
	set(value):
		hp=value
		if hparr!=null and hparr.size()>=3:
			for i in range(0,3):
				if i<hp:
					hparr[i].show()
				else:
					hparr[i].hide()
const SWORDMANMAT = preload("res://swordmanmat.tres")
@export var _shader : Shader
# Called when the node enters the scene tree for the first time.

func changeWaitTime(waitT):
	timer.wait_time=waitT

func _ready():
	 # 创建 ShaderMaterial 实例
	#var material_instance = ShaderMaterial.new()
	#material_instance.shader = _shader  # 将 Shader 赋值给材质实例

	# 设置材质参数（如果有的话）
	#material_instance.set_shader_param("my_param", 1.0)  # 示例参数

	# 将材质应用到节点的材质属性
	#$Sprite2D.material = material_instance  # 应用到当前节点
	 #var material_instance = SWORDMANMAT.new()
	#material_instance.shader = shader  # 将 Shader 赋值给材质实例
	#$Sprite2D.material=SWORDMANMAT.new()
	# 创建 ShaderMaterial 实例
	get_active_sword_timer().start()
	_refresh_weapon_state()
	if sprite_2d!=null:
		sprite_2d.set_modulate(color)
	#tween.tween_property(sword, "rotation_degrees", 360 * ROTATION_DURATION+stop_angle, 2)


func get_active_sword() -> Sprite2D:
	return double_sword if _double_sword_equipped else primary_sword


func get_active_sword_area() -> Area2D:
	return get_active_sword().get_node("sword") as Area2D


func get_active_sword_collision() -> CollisionShape2D:
	return get_active_sword_area().get_node("CollisionShape2D") as CollisionShape2D


func get_active_sword_timer() -> Timer:
	return get_active_sword().get_node("Timer") as Timer


func set_double_sword_equipped(equipped: bool) -> void:
	if _double_sword_equipped == equipped:
		_refresh_weapon_state()
		return
	var previous_timer := get_active_sword_timer()
	var previous_wait_time := previous_timer.wait_time
	var was_running := not previous_timer.is_stopped()
	previous_timer.stop()
	_double_sword_equipped = equipped
	var active_timer := get_active_sword_timer()
	active_timer.wait_time = previous_wait_time
	if was_running:
		active_timer.start()
	_refresh_weapon_state()


func set_weapon_enabled(enabled: bool) -> void:
	_weapon_enabled = enabled
	_refresh_weapon_state()


func _refresh_weapon_state() -> void:
	var primary_enabled := _weapon_enabled and not _double_sword_equipped
	var double_enabled := _weapon_enabled and _double_sword_equipped
	primary_sword.visible = primary_enabled
	primary_sword.get_node("sword/CollisionShape2D").disabled = not primary_enabled
	double_sword.visible = double_enabled
	double_sword.get_node("sword/CollisionShape2D").disabled = not double_enabled

func changeWeapon(txt):
	sword.set_modulate(Color.WHITE)
	sword.texture=txt

func changeColor(color):
	color=color
	sprite_2d.set_modulate(color)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#将其旋转
	pass

var degree=0
var m_Radius=40
var direction=1
func _on_timer_timeout():
	if isdead==true:
		return
	degree=degree+1*direction
	
	if degree>=360:
		degree=0
	##sword.rotation=degree
	#var hudu=PI *degree/ 180
	#var x = m_Radius * cos(hudu);
	#var z = m_Radius * sin(hudu);
	#print(degree)
	#sword.position=Vector2(x,z)
	self.rotation_degrees=degree
@onready var animation_player = $Sprite2D/AnimationPlayer

@onready var areabody = $body
var areasword: Area2D:
	get:
		return get_active_sword_area()
@export var _spark:PackedScene
var isdead:bool=false
var controlled_velocity := Vector2.ZERO
func _on_GetHit_area_entered(area):

	if area!=areabody and area!=areasword and isdead==false:
		var current_node=area
		if(current_node==null or current_node.get_parent() == null):
			return	
		# 循环查找最顶层父节点
		while not current_node is swordMan:
			current_node = current_node.get_parent()
		if current_node == self:
			return
		if current_node.isdead==true:
			return		
		if area.name=="sword":
			#print("aaaa")
			animation_player.active=true
			animation_player.play("die")
			animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))
			isdead=true

func _on_animation_finished(anim_name):
	if anim_name == "die":
		# 发出 hit_body 信号，传递当前节点（self）作为 body
		emit_signal("hit_body", self)
		print("动画 'die' 完成，发出 hit_body 信号，时间：", Time.get_datetime_string_from_system())


const SWORD_PANG = preload("res://Asset/sound/swordPang.wav")
func _on_Hit_area_entered(area):
	if area!=areabody and area!=areasword and isdead==false:
		if area.name=="sword":
			var current_node=area
			if(current_node==null or current_node.get_parent() == null):
				return	
			# 循环查找最顶层父节点
			while !(current_node is swordMan):
				if(current_node.get_parent() != null):
					current_node = current_node.get_parent()
				else:
					return
			if current_node == self:
				return
			if current_node.isdead==true:
				return		
			var _s=_spark.instantiate()
			_s.emitting=true
			direction=-direction
			var _sNode: Node = _s
			_s.position=collision_shape_2d.global_position
			get_tree().current_scene.add_child(_s)
			SoundManager.play_sound(SWORD_PANG)
