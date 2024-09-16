extends Control

func _initData():
	_on_v_slider_value_changed(100)
# Called when the node enters the scene tree for the first time.
func _ready():
	_initData()

	pass # Replace with function body.

@onready var v_slider = $Control/VSlider

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _input(event):

	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_WHEEL_UP:
			v_slider.value=v_slider.value+1
		elif event.button_index==MOUSE_BUTTON_WHEEL_DOWN:
			v_slider.value=v_slider.value-1
			pass


@onready var v_box_container = $Control/VBoxContainer

func _on_v_slider_value_changed(value):
	#print(value)
	var baseValue
	var lan= TranslationServer.get_locale()
	if lan=="zh":
		baseValue=27
	elif lan=="en":
		baseValue=40
	elif lan=="ru":
		pass
	elif lan=="lzh":
		baseValue=27
	elif lan=="ja":
		baseValue=27
	var new_height = baseValue * (100-value)
	v_box_container.position= Vector2(40, 20-new_height)


func _on_button_startGame():
	SoundManager.play_sound(sounds.COLLECT_SMALL_JEWEL_1)
	SceneManager.changeScene(SceneManager.roomNode.PRE_SCENE,2)
	
	#pass # Replace with function body.


func _on_texture_button_button_down():
	self.hide()
	pass # Replace with function body.
