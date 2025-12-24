extends Node

var tooltip_scene = preload("res://Scene/commonPanel/Tooltip.tscn")
var current_tooltip: CanvasLayer = null
var hold_timer: Timer = null
var hold_duration: float = 0.5 # 点击保持时间（秒）
var is_holding: bool = false
var current_target: Node = null

func _ready():
	# 初始化计时器
	hold_timer = Timer.new()
	hold_timer.one_shot = true
	hold_timer.wait_time = hold_duration
	hold_timer.timeout.connect(_on_hold_timeout)
	add_child(hold_timer)
	
	# 自动为分组中的节点连接信号
	# 假设所有需要 Tooltip 的节点都加入 "Tooltipable" 分组
	get_tree().connect("node_added", _on_node_added)

func register_tooltip(node: Node, tooltip_text: String):
	# 为节点设置 Tooltip 元数据
	node.set_meta("tooltip_text", tooltip_text)
	unregister_tooltip(node)
	# 自动加入分组（可选）
	node.add_to_group("Tooltipable")
	
	# 如果是 Control 节点，自动连接鼠标信号
	if node is Control:
		if not node.is_connected("mouse_entered", _on_mouse_entered.bind(node)):
			node.mouse_entered.connect(_on_mouse_entered.bind(node))
		if not node.is_connected("mouse_exited", _on_mouse_exited.bind(node)):
			node.mouse_exited.connect(_on_mouse_exited.bind(node))
		# 确保接收鼠标输入
		node.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# 如果是 2D 节点，检查是否有 Area2D
	elif node is Node2D and node.has_node("Area2D"):
		var area:Area2D = node.get_node("Area2D")
		if not area.is_connected("mouse_entered", _on_mouse_entered.bind(node)):
			area.mouse_entered.connect(_on_mouse_entered.bind(node))
		if not area.is_connected("mouse_exited", _on_mouse_exited.bind(node)):
			area.mouse_exited.connect(_on_mouse_exited.bind(node))
			#area.click

func unregister_tooltip(node: Node):
	# 从 Tooltipable 分组移除
	if node.is_in_group("Tooltipable"):
		node.remove_from_group("Tooltipable")
	
	# 断开信号
	if node is Control:
		if node.is_connected("mouse_entered", _on_mouse_entered.bind(node)):
			node.mouse_entered.disconnect(_on_mouse_entered.bind(node))
		if node.is_connected("mouse_exited", _on_mouse_exited.bind(node)):
			node.mouse_exited.disconnect(_on_mouse_exited.bind(node))
	elif node is Node2D and node.has_node("Area2D"):
		var area = node.get_node("Area2D")
		if area.is_connected("mouse_entered", _on_mouse_entered.bind(node)):
			area.mouse_entered.disconnect(_on_mouse_entered.bind(node))
		if area.is_connected("mouse_exited", _on_mouse_exited.bind(node)):
			area.mouse_exited.disconnect(_on_mouse_exited.bind(node))
	
	# 移除 tooltip_text 元数据（可选）
	if node.has_meta("tooltip_text"):
		node.remove_meta("tooltip_text")
	
	# 如果是当前目标节点，隐藏 Tooltip
	if current_target == node:
		hide_tooltip()

func _on_node_added(node: Node):
	# 自动为加入 "Tooltipable" 分组的节点连接信号
	if node.is_in_group("Tooltipable") and node.has_meta("tooltip_text"):
		if node is Control:
			if not node.is_connected("mouse_entered", _on_mouse_entered.bind(node)):
				node.mouse_entered.connect(_on_mouse_entered.bind(node))
			if not node.is_connected("mouse_exited", _on_mouse_exited.bind(node)):
				node.mouse_exited.connect(_on_mouse_exited.bind(node))
			node.mouse_filter = Control.MOUSE_FILTER_STOP
		elif node is Node2D and node.has_node("Area2D"):
			var area = node.get_node("Area2D")
			if not area.is_connected("mouse_entered", _on_mouse_entered.bind(node)):
				area.mouse_entered.connect(_on_mouse_entered.bind(node))
			if not area.is_connected("mouse_exited", _on_mouse_exited.bind(node)):
				area.mouse_exited.connect(_on_mouse_exited.bind(node))

func show_tooltip(target: Node, text: String, position: Vector2):
	#hide_tooltip()

	if(current_tooltip==null):
		current_tooltip = tooltip_scene.instantiate()
		#current_tooltip.area2d=target
		current_tooltip.showText(text)
		get_tree().root.add_child(current_tooltip)
	current_tooltip.panel_container.global_position = position + Vector2(10, 10)
	#current_tooltip.area2d=target
	# 防止溢出屏幕
	var screen_size = get_viewport().get_visible_rect().size
	var tooltip_size = current_tooltip.panel_container.size
	if current_tooltip.panel_container.global_position.x + tooltip_size.x > screen_size.x:
		current_tooltip.panel_container.global_position.x = screen_size.x - tooltip_size.x - 10
	if current_tooltip.panel_container.global_position.y + tooltip_size.y > screen_size.y:
		current_tooltip.panel_container.global_position.y = screen_size.y - tooltip_size.y - 10
	current_tooltip.show_tooltip()
	current_target = target

func hide_tooltip():
	if current_tooltip:
		current_tooltip.queue_free()
		current_tooltip = null
	current_target = null
	is_holding = false
	hold_timer.stop()

func _on_mouse_entered(target: Node):
	if target.has_meta("tooltip_text"):
	
		var text = target.get_meta("tooltip_text")
		var mouse_pos = get_viewport().get_mouse_position()
		print("showtip")
		show_tooltip(target, text, mouse_pos)
	else:
		print("dontshowtip")
		hide_tooltip()

func _on_mouse_exited(target: Node):
	pass
	hide_tooltip()

func _input(event):
	# 处理点击保持
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_holding = true
			hold_timer.start()
		else:
			is_holding = false
			hold_timer.stop()
			#hide_tooltip()

func _on_hold_timeout():
	if is_holding and current_target and current_target.has_meta("tooltip_text"):
		var text = current_target.get_meta("tooltip_text")
		var mouse_pos = get_viewport().get_mouse_position()
		#show_tooltip(current_target, text, mouse_pos)
		#暂时注销，如果是手机用户，这里不需要执行
