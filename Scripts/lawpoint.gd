@tool
class_name lawpoint
extends Control
var isUnlock:bool=false

@onready var control = $"../.."
const _0_RED = preload("res://Scene/0_red.png")
const _1_BLUE = preload("res://Scene/1_blue.png")
const _2_GREEN = preload("res://Scene/2_green.png")
@export var costPoint:int=3
@export var _color:lawcolor
@export var lawpoins:Array[lawpoint]
@export var detail:String
@export var context:String:
	get:
		return context
	set(value):
		context=value
		if $PanelContainer/MarginContainer/Label!=null:
			$PanelContainer/MarginContainer/Label.text=value
		

var context_tr:String:
	get:
		return tr(context)

# Called when the node enters the scene tree for the first time.
func _ready():
	$PanelContainer/MarginContainer/Label.text=context
	_initData()
	changeLanguage()
	pass # Replace with function body.


func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="ja":
		pass
	elif currencelanguage=="ru":

		$PanelContainer/MarginContainer/Label.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
			
	else:
		pass

@onready var texture_rect = $TextureRect2/TextureRect
@onready var animation_player = $AnimationPlayer

func _initData():
	if isUnlock==true:
		texture_rect.show()
		animation_player.stop()
		if _color==lawcolor.red:
			$TextureRect2/TextureRect.texture=_0_RED
		elif _color==lawcolor.blue:
			$TextureRect2/TextureRect.texture=_1_BLUE
		elif _color==lawcolor.green:
			$TextureRect2/TextureRect.texture=_2_GREEN
		#已解锁
	if lawpoins.size()>0:
		if lawpoins.any(func(value):return value.isUnlock==true)==true:
			texture_rect.show()
			animation_player.play("blink")
			#待解锁
		else:
			pass
			texture_rect.hide()
			#未解锁
	else:
		texture_rect.show()
		animation_player.play("blink")
		#待解锁
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

const _001_HOVER_01 = preload("res://Asset/sound/ui/001_Hover_01.wav")
const _013_CONFIRM_03 = preload("res://Asset/sound/ui/013_Confirm_03.wav")
func _on_gui_input(event):
	
	if isUnlock==true:
		return
	if lawpoins.size()>0:
		if lawpoins.any(func(value):return value.isUnlock==true)==false:
			return
	if event is InputEventMouseButton and event.button_index==1:
		control.preLaw(self)
		#SoundManager.play_sound(_001_HOVER_01)
	elif(event is InputEventMouseButton and event.double_click==true):
		control.excuteLaw(self)
		SoundManager.play_sound(_013_CONFIRM_03)
	pass # Replace with function body.

enum lawcolor{
	red,blue,green
}


func _on_mouse_entered():
	pass
	#SoundManager.play_sound(_001_HOVER_01)
