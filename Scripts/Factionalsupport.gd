class_name factionalsupport
extends PanelContainer
@onready var label = $MarginContainer/Label


@onready var texture_rect_2 = $MarginContainer/Label/TextureRect2

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.changeLanguage.connect(changeLanguage)			
	changeLanguage()
	pass # Replace with function body.
	
	
func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="ja":
		pass
	elif currencelanguage=="ru":

		label.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
			
	else:
		pass	
var _data
func init(data:cldata):
	_data=data
	refreshData()
	#self._set_size(Vector2(panel_container.size.x+texture_rect_2.size.x,texture_rect_2.size.y+20))
func refreshData():
	label.text=tr(_data._name)+":%d"%_data._num_all+"(%d:%d:%d)"%[_data._num_sp,_data._num_op,_data._num_rt]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
