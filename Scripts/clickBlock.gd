@tool
class_name clickBlock
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
func changeName(_name):
	showName=_name		
		
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

	
	
	if showEX==true:
		ex_point.show()
	else:
		ex_point.hide()
	if GameManager==null or GameManager.sav==null:
		return		
		
	SignalManager.changeLanguage.connect(_changeLanguage)			
	_changeLanguage()	
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

func _is_mouse_blocked(_event_position: Vector2) -> bool:
	var tree = get_tree()
	if not tree:
		return false
	var viewport_pos = get_viewport().get_mouse_position()
	var viewport_size = get_viewport().get_visible_rect().size
	# 只判断覆盖 >60% 视口的大尺寸 Control，避免 HUD 小控件误伤
	var min_size = viewport_size * 0.6

	var canvas_layers: Array = []
	_collect_canvas_layers(tree.root, canvas_layers)
	for cl in canvas_layers:
		if not cl.visible:
			continue
		for child in cl.get_children():
			# PASS/STOP overlays may block lower clickBlocks, but visible descendants stay clickable.
			if child is Control and child.visible and child.mouse_filter != Control.MOUSE_FILTER_IGNORE:
				if not _is_blocker_above_self(child):
					continue
				var rect = child.get_global_rect()
				if rect.size.x < min_size.x or rect.size.y < min_size.y:
					continue
				if rect.has_point(viewport_pos):
					return true
	return false

func _is_blocker_above_self(blocker: Control) -> bool:
	if blocker.is_ancestor_of(self):
		return false

	var blocker_layer = _get_canvas_layer_for_node(blocker)
	var self_layer = _get_canvas_layer_for_node(self)
	if blocker_layer != self_layer:
		if blocker_layer == null:
			return false
		if self_layer == null:
			return true
		if blocker_layer.layer != self_layer.layer:
			return blocker_layer.layer > self_layer.layer
		return blocker_layer.get_index() > self_layer.get_index()

	var compare_parent: Node = blocker_layer
	if compare_parent == null:
		compare_parent = blocker.get_parent()
	var blocker_branch = _get_direct_child_under(compare_parent, blocker)
	var self_branch = _get_direct_child_under(compare_parent, self)
	if blocker_branch == null or self_branch == null or blocker_branch == self_branch:
		return false

	if blocker_branch is CanvasItem and self_branch is CanvasItem:
		var blocker_canvas_item := blocker_branch as CanvasItem
		var self_canvas_item := self_branch as CanvasItem
		var blocker_z = blocker_canvas_item.z_index
		var self_z = self_canvas_item.z_index
		if blocker_z != self_z:
			return blocker_z > self_z
	return blocker_branch.get_index() > self_branch.get_index()

func _get_canvas_layer_for_node(node: Node) -> CanvasLayer:
	var current = node
	while current != null:
		if current is CanvasLayer:
			return current
		current = current.get_parent()
	return null

func _get_direct_child_under(parent_node: Node, node: Node) -> Node:
	if parent_node == null:
		return null
	var current = node
	while current != null and current.get_parent() != parent_node:
		current = current.get_parent()
	if current != null and current.get_parent() == parent_node:
		return current
	return null

func _collect_canvas_layers(node: Node, result: Array) -> void:
	if node is CanvasLayer:
		result.append(node)
	for child in node.get_children():
		_collect_canvas_layers(child, result)

func _on_area_2d_input_event(viewport, event, shape_idx):
	#or GameManager.rewardPanel==true

	if !(event is InputEventMouseButton):
		return
		
	if (DialogueManager.haveDialoge()==true and DialogueManager.get_dialogue_balloon() != null) or GameManager.isLoadingSave==true or PanelManager.isOpenSetting==true and (PanelManager.rewardNode!=null and PanelManager.rewardNode.visible):
		return
	if not event.pressed:
		return
	if _is_mouse_blocked(event.position):
		return
	#大概率是后面二项导致的	


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
	heart.hide()

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
