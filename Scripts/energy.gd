extends Control
class_name energe
@onready var progress_bar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager._engerge=self
	pass # Replace with function body.


func changerate(rate):
	progress_bar.value=rate

