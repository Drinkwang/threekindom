@tool
extends Control
@onready var reallabel = $"TextureRect/realBox/正常文本"

@onready var label = $TextureRect/Label

@export_multiline var context:String:  #get set
	get:
		return context
	set(value): 
		context=value
		if(label!=null):
			label.text=value
@export var lookdoneDialog:String
@export var pageDownDialog:String

@export var dialogue_resource:DialogueResource
@export var hasPage:bool 
# Called when the node enters the scene tree for the first time.
func _ready():
	label.text=context;
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="en":
		label.add_theme_font_size_override("font_size", 34)
		reallabel.add_theme_font_size_override("font_size", 38)
	elif currencelanguage=="zh":
		label.add_theme_font_size_override("font_size", 40)
		reallabel.add_theme_font_size_override("font_size", 40)
		#label.font_size=36
	elif currencelanguage=="ru":
		label.add_theme_font_size_override("font_size", 34)
		reallabel.add_theme_font_size_override("font_size", 38)
		label.add_theme_constant_override("line_spacing", -3)
		reallabel.add_theme_constant_override("line_spacing", -5)
		label.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		reallabel.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))

	print(TranslationServer.get_locale()) 
	# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _changeText(value):
	label.text=value

func _showNextPage():
	$"TextureRect/读完了按钮".hide()
	$"TextureRect/翻页按钮".show()
	
func _showreadDown():
	$"TextureRect/读完了按钮".show()
	$"TextureRect/翻页按钮".hide()

func _changeBtnState(state:buttonState):
	if state==buttonState.page:
		_showNextPage()
	elif  state==buttonState.readdone:
		_showreadDown()
	elif  state==buttonState.none:
		_hideAll()

func _hideAll():
	$"TextureRect/读完了按钮".hide()
	$"TextureRect/翻页按钮".hide()


enum buttonState{
	none,
	page,
	readdone
	
}


func _on_texture_rect_gui_input(event):

	if(event is InputEventMouseButton and event.button_index==1):
		#$"TextureRect/翻页按钮".show()
		$TextureRect/realBox.show()
		$"TextureRect/读完了按钮".show()
		print("done")
		#DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
	pass # Replace with function body.


func _on_读完了按钮_button_down():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,lookdoneDialog)
	pass

const _翻阅 = preload("res://Asset/sound/翻阅.mp3")
func _on_翻页按钮_button_down():
	SoundManager.play_sound(_翻阅)
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,pageDownDialog)
	$"TextureRect/realBox/正常文本".text=context
	$TextureRect/realBox.hide()
	pass # Replace with function body.
