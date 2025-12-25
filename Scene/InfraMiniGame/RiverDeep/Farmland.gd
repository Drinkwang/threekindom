extends ColorRect

@export var required_depth: int = 3
@export var cell_size: int = 64
@export var max_depth: int = 7
var irrigated: bool = false
var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_update_visual()
	_apply_position_from_depth()

func update_irrigation(current_depth: int) -> void:
	if irrigated:
		return
	if current_depth >= required_depth:
		irrigated = true
		_update_visual()
	else:
		irrigated = false
		_update_visual()
func _apply_position_from_depth() -> void:
	position.y = float(required_depth) * float(cell_size)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = event.position
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		var motion := event as InputEventMouseMotion
		var new_y: float = position.y + motion.relative.y
		new_y = clamp(new_y, 0.0, float(max_depth) * float(cell_size))
		position.y = new_y
		required_depth = int(round(new_y / float(cell_size)))
		if irrigated:
			_update_visual()
const nongtian = preload("res://Asset/RiverDeep/农田.png")
const handi = preload("res://Asset/RiverDeep/旱地.png")
@onready var texture_rect: TextureRect = $TextureRect

func _update_visual() -> void:
	if irrigated:
		texture_rect.texture=nongtian
	else:
		#color = Color(0.8, 0.7, 0.4, 1.0)
		texture_rect.texture=handi
