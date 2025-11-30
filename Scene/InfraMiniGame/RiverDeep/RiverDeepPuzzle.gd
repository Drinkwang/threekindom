extends Control

@onready var board: Node2D = $Board
@onready var farmland_panel: Control = $FarmlandPanel
@onready var victory_label: Label = $PanelContainer/Label2


func _ready() -> void:
	victory_label.visible = false
	board.connect("water_depth_changed", Callable(self, "_on_water_depth_changed"))
	for child in farmland_panel.get_children():
		if child is Control and child.has_method("update_irrigation"):
			child.set("cell_size", board.get("cell_size"))
			child.set("max_depth", board.get("grid_height") - 1)
			var req := int(child.get("required_depth"))
			child.position.y = float(req) * float(board.get("cell_size"))

func _on_water_depth_changed(depth: int) -> void:
	var all_done := true
	for child in farmland_panel.get_children():
		if child is Control and child.has_method("update_irrigation"):
			child.update_irrigation(depth)
			if not child.irrigated and child.visible==true:
				all_done = false
	if all_done:
		_show_victory()

func _show_victory() -> void:
	victory_label.visible = true
