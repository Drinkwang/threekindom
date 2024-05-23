@tool
extends Control
@export var detail:String
@export var context:String:
	get:
		return context
	set(value):
		context=value
		if $PanelContainer/MarginContainer/Label!=null:
			$PanelContainer/MarginContainer/Label.text=value
		

# Called when the node enters the scene tree for the first time.
func _ready():
	$PanelContainer/MarginContainer/Label.text=context
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gui_input(event):
	pass # Replace with function body.
