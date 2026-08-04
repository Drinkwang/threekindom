@tool
extends Control

const LETTER_TEXT_MAX_HEIGHT := 768.0
const LETTER_TEXT_MIN_FONT_SIZE := 1

#@onready var reallabel = $"TextureRect/realBox/正常文本"

@onready var label: Label = $TextureRect/Label

var _label_base_font_size := 34
var _is_fitting_letter_label := false

@export_multiline var context:String:  #get set
	get:
		return context
	set(value): 
		context=value
		if(label!=null):
			label.text=value
			_fit_letter_label_font()
			#reallabel=context
@export var lookdoneDialog:String
@export var pageDownDialog:String

@export var dialogue_resource:DialogueResource
@export var hasPage:bool 
# Called when the node enters the scene tree for the first time.
func _ready():
	label.text=context;

	SignalManager.changeLanguage.connect(changeLanguage)
	if not label.resized.is_connected(_fit_letter_label_font):
		label.resized.connect(_fit_letter_label_font)
	changeLanguage()

	# Replace with function body.

func changeLanguage():
	_fit_letter_label_font()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _changeText(value):
	label.text=value
	_fit_letter_label_font()

func _fit_letter_label_font() -> void:
	if label == null or _is_fitting_letter_label:
		return

	var available_height: float = LETTER_TEXT_MAX_HEIGHT
	if label.size.x <= 0.0:
		return

	_is_fitting_letter_label = true
	label.size = Vector2(label.size.x, available_height)
	var font: Font = label.get_theme_font("font")
	if font == null:
		_is_fitting_letter_label = false
		return

	var display_text: String = tr(label.text)
	var line_spacing: int = label.get_theme_constant("line_spacing")
	var font_size: int = _label_base_font_size
	while font_size > LETTER_TEXT_MIN_FONT_SIZE:
		var text_height: float = font.get_multiline_string_size(
			display_text,
			label.horizontal_alignment,
			label.size.x,
			font_size,
			-1,
			TextServer.BREAK_MANDATORY | TextServer.BREAK_WORD_BOUND | TextServer.BREAK_ADAPTIVE
		).y
		var line_height: float = font.get_height(font_size)
		var line_count: int = maxi(1, ceili(text_height / line_height))
		var required_height: float = text_height + max(0, line_count - 1) * line_spacing
		if required_height <= available_height:
			break
		font_size -= 1

	label.add_theme_font_size_override("font_size", font_size)
	label.size = Vector2(label.size.x, available_height)
	_is_fitting_letter_label = false

#func _notification(what: int) -> void:
	#if what == NOTIFICATION_TRANSLATION_CHANGED and is_node_ready():
		#call_deferred("_fit_letter_label_font")

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

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#$"TextureRect/翻页按钮".show()
		#$TextureRect/realBox.show()
		#$"TextureRect/读完了按钮".show()
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
	#$"TextureRect/realBox/正常文本".text=context
	#$TextureRect/realBox.hide()
	pass # Replace with function body.
