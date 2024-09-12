extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	_on_v_slider_value_changed(100)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



@onready var v_box_container = $Control/VBoxContainer

func _on_v_slider_value_changed(value):
	print(value)
	var new_height = 27 * (100-value)
	v_box_container.position= Vector2(40, 20-new_height)


func _on_button_startGame():
	SceneManager.changeScene(SceneManager.roomNode.PRE_SCENE,2)
	
	#pass # Replace with function body.


func _on_texture_button_button_down():
	self.hide()
	pass # Replace with function body.
