extends CanvasLayer

# Tooltip 相关节点
@onready var tooltip_popup =$PanelContainer
@onready var tooltip_label =$PanelContainer/MarginContainer/Label
@onready var panel_container = $PanelContainer

# 计时器相关
var hover_timer = 0.0
var click_timer = 0.0
const HOVER_DELAY = 1.0  # 悬停延迟（秒）
const CLICK_HOLD_DELAY = 0.5  # 点击保持延迟（秒）
var is_hovered = false
var is_click_held = false
var mouse_pos = Vector2.ZERO

func _ready():
	# 确保 tooltip 初始化时隐藏
	#tooltip_popup.hide()
	# 设置 tooltip 内容
	#tooltip_label.text = "[center]This is a custom tooltip![/center]"
	# 连接鼠标进入和离开信号
	panel_container.mouse_entered.connect(_on_mouse_entered)
	panel_container.mouse_exited.connect(_on_mouse_exited)

func _input(event):
	# 检测鼠标点击和释放
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_click_held = true
			click_timer = 0.0
			mouse_pos = get_viewport().get_mouse_position()
		else:
			is_click_held = false
			tooltip_popup.hide()

var context
func showText(_v):
	context=_v
	if tooltip_label!=null:
		tooltip_label.text=context

func _process(delta):
	showText(context)
	# 处理悬停计时
	if is_hovered and not is_click_held:
		hover_timer += delta
		if hover_timer >= HOVER_DELAY:
			show_tooltip()

	# 处理点击保持计时
	if is_click_held:
		# 检查鼠标是否移动（避免移动时显示 tooltip）
		var current_mouse_pos = get_viewport().get_mouse_position()
		if current_mouse_pos.distance_to(mouse_pos) < 5.0:  # 允许小范围移动
			click_timer += delta
			if click_timer >= CLICK_HOLD_DELAY:
				show_tooltip()
		else:
			is_click_held = false
			
	#tooltip_popup.hide()
	adjust_tooltip_position()
func _on_mouse_entered():
	is_hovered = true
	hover_timer = 0.0

func _on_mouse_exited():
	is_hovered = false
	hover_timer = 0.0
	tooltip_popup.hide()


func adjust_tooltip_position():
	var screen_size = get_viewport().get_visible_rect().size
	var tooltip_size = tooltip_popup.size
	var pos = tooltip_popup.position
	pos.x = min(pos.x, screen_size.x - tooltip_size.x)
	pos.y = min(pos.y, screen_size.y - tooltip_size.y)
	pos.x = max(pos.x, 0)
	pos.y = max(pos.y, 0)
	tooltip_popup.position = pos

func show_tooltip():
	# 显示 tooltip 并跟随鼠标位置
	tooltip_popup.show()
	var mouse_pos = get_viewport().get_mouse_position()
	tooltip_popup.position = mouse_pos + Vector2(10, 10)  # 偏移以避免遮挡鼠标
	showText(context)
