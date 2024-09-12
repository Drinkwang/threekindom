extends Control
class_name energe
@onready var progress_bar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager._engerge=self
	changerate(GameManager.hp)
	pass # Replace with function body.


func changerate(rate):
	progress_bar.value=rate






func _on_item_button_button_down():
	pass # Replace with function body.


func _on_save_button_button_down():
	PanelManager.show_Save_panel()
	pass # Replace with function body.
