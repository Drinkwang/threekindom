@tool
extends baseComponent
@onready var img = $img
@export var showName:String="":
	set(value):
		showName=value
		if $Panel!=null and value.length()>0:
			$Panel.show()
			$Panel/Label.text=value;
		else: 
			if $Panel!=null and value.length()==0:
				$Panel.hide()
			
	get:
		return showName
@export var dialogue_doubleclick:String
@export var showborder:bool=true:
	set(isshow):
		showborder=isshow
		if _8!=null and _9!=null and isshow==false:
			_8.hide()
			_9.hide()
		else: 
			if isshow==true:
				if boardType==0:
					if _8!=null:
						_9.hide()
						_8.show()
				elif boardType==1:
					if _9!=null:
						_8.hide()
						_9.show()
			
	get:
		return showborder
		

@onready var ex_point = $exPoint
@onready var _8: Sprite2D = $"8"


@export var showEX:bool=false:
	set(value):
		showEX=value
	
		if ex_point==null:
			return
		if showEX==true:
			ex_point.show()
		else:
			ex_point.hide()

	get:
		return showEX

@export var txt2d:Texture2D:
	#if Engine.editor_hint:
	set(txt):
		txt2d=txt
		print(txt)
		if img!=null:
			img.texture=txt

	get:
		return txt2d
@onready var _9: Sprite2D = $"9"
		
@export var boardType=0
# Called when the node enters the scene tree for the first time.
func _ready():
	img.texture=txt2d
	
	if showborder==false:
		_8.hide()
		_9.hide()
	else: 
		if boardType==0:
			_9.hide()
			_8.show()
		elif boardType==1:
			_8.hide()
			_9.show()
	if $Panel!=null and showName.length()>0:
		$Panel.show()
		$Panel/Label.text=showName;
	else:
		$Panel.hide()
	if SignalManager and SignalManager.has_signal("changeLanguage"):
		SignalManager.changeLanguage.connect(_changeLanguage)			
	_changeLanguage()	
	
	
	if showEX==true:
		ex_point.show()
	else:
		ex_point.hide()

@onready var label = $Panel/Label
const NOT_JAM_UI_CONDENSED_16 = preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")
func _changeLanguage():
	var currencelanguage=TranslationServer.get_locale()

	#if currencelanguage=="ru":
	#	label.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
	#else:
	#	label.remove_theme_font_override("font")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@onready var area_2d: Area2D = $Area2D



func get_global_rect() -> Rect2:
	# 查找 CollisionShape2D 子节点
	var collision_shape = $Area2D/CollisionShape2D
	if not collision_shape or not collision_shape.shape:
		push_error("No CollisionShape2D found or shape is not set!")
		return Rect2()
	
	# 获取形状
	var shape = collision_shape.shape
	
	# 处理矩形形状（假设使用 RectangleShape2D）
	if shape is RectangleShape2D:
		var size = shape.extents * 2  # extents 是矩形的一半大小
		var local_rect = Rect2(-shape.extents, size)  # 以形状中心为原点的矩形
		var global_transform = collision_shape.global_transform
		return global_transform * local_rect  # 转换为全局坐标
	
	# 如果是其他形状（例如 CircleShape2D 或多边形），需要额外处理
	push_warning("Unsupported shape type, returning empty Rect2")
	return Rect2()

@export var isHide=true

func _on_area_2d_input_event(viewport, event, shape_idx):
	
	if !(event is InputEventMouseButton) or DialogueManager.dialogBegin==true or GameManager.rewardPanel==true:
		return
	#大概率是后面二项导致的	
	print("dialogBegin "+var_to_str(DialogueManager.dialogBegin))
	print("rewardPanel "+var_to_str(GameManager.rewardPanel))
	if(event is InputEventMouseButton and event.button_index==1 and dialogue_start.length()>0):
		SoundManager.play_sound(sounds.SFX_FAST_UI_CLICK)
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
		if isHide==true:
			self.hide()
	#等待2秒，如果2秒还为单击，则为单击
	if(event is InputEventMouseButton and event.double_click==true and dialogue_doubleclick.length()>0):
		SoundManager.play_sound(sounds.SFX_FAST_UI_CLICK)
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_doubleclick)
		if isHide==true:
			self.hide()
	pass
@onready var heart = $Heart

@onready var Heartlabel = $Heart/Label
@onready var heart_ani = $heartAni

func showHeart(num):
	heart.show()
	Heartlabel.text=tr("好感度:{s}").format({"s":num})
	heart_ani.play("heart")

func changeAllClick(_value):
	dialogue_start=_value
	dialogue_doubleclick=_value

func _on_timer_timeout():

	pass # Replace with function body.


func _on_area_2d_mouse_entered_board() -> void:
	if GameManager.currenceScene!=null and GameManager.currenceScene is board_game:
		if GameManager.currenceScene.mouseline.visible==true:
			showEX=true
		else:
			showEX=false

func _on_area_2d_mouse_exited_board() -> void:
	if GameManager.currenceScene!=null and GameManager.currenceScene is board_game:
		if GameManager.currenceScene:
			showEX=false
