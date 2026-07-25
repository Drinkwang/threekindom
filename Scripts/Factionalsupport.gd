class_name factionalsupport
extends PanelContainer
const russian_font = preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")
const LABEL_PREFERRED_SIZE := 30
const LABEL_MIN_SIZE := 18
const LABEL_MAX_WIDTH := 410.0
@onready var label = $MarginContainer/Label


@onready var texture_rect_2 = $MarginContainer/Label/TextureRect2

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.changeLanguage.connect(changeLanguage)			
	changeLanguage()
	pass # Replace with function body.
	
	
func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="ru":
		label.add_theme_font_override("font",russian_font)
	else:
		label.remove_theme_font_override("font")
	refreshData()
var _data:cldata
func init(data:cldata):
	_data=data
	refreshData()
	#self._set_size(Vector2(panel_container.size.x+texture_rect_2.size.x,texture_rect_2.size.y+20))
func refreshData():
	if _data==null:
		return
	if _data.index!=3:
		label.text=tr(_data._name)+":%d"%_data._num_all+"(%d:%d:%d)"%[_data._num_sp,_data._num_op,_data._num_rt]
	else:
		label.text=tr(_data._name)+":%d"%_data._num_all+"(-:-:-)"
	_fit_label()
	TooltipManager.register_tooltip(self,_data.detail)


func _fit_label():
	label.add_theme_font_size_override("font_size",LABEL_PREFERRED_SIZE)
	var font=label.get_theme_font("font")
	var fitted_size=LABEL_PREFERRED_SIZE
	var text_width=font.get_string_size(label.text,HORIZONTAL_ALIGNMENT_LEFT,-1,fitted_size).x
	while fitted_size>LABEL_MIN_SIZE and text_width>LABEL_MAX_WIDTH:
		fitted_size-=1
		text_width=font.get_string_size(label.text,HORIZONTAL_ALIGNMENT_LEFT,-1,fitted_size).x
	label.add_theme_font_size_override("font_size",fitted_size)
	label.custom_minimum_size.x=min(ceil(text_width),LABEL_MAX_WIDTH)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
