extends Control


@export var datas:Array[cldata] 


@onready var label = $PanelContainer/VBoxContainer/Label
@onready var label_2 = $PanelContainer/VBoxContainer/Label2

#var _name:String
#var _num_all:int
#var _num_rt:int 
# Called when the node enters the scene tree for the first time.
func _ready():
	var d:cldata=cldata.new()
	#d.
	_processList()
	changeLanguage()
	
func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="ja":
		pass
	elif currencelanguage=="ru":
		var newfont=preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")
		label.add_theme_font_override("font",newfont)
		label_2	.add_theme_font_override("font",newfont)
		label.add_theme_constant_override("line_spacing",-2)
		label_2.add_theme_constant_override("line_spacing",-2)		
	else:
		pass

@onready var v_box_container = $PanelContainer/VBoxContainer

func _processList():

	for item:cldata in datas:
		if item.isshow==false:
			continue
		


		#richTxt.add_theme_font_override("")
		#richTxt.horizontal_alignment = CENTER
		#richTxt.outline_color=Color.BLACK
		var fs=load("res://Scene/prefab/Factionalsupport.tscn").instantiate()

		#buttton.add_child(richTxt)
		#buttton.texture_normal=normalbtn
		#buttton.texture_pressed=pressbtn
		#buttton.texture_hover=hoverbtn
		#buttton.texture_focused=focusbtn
		#buttton.pressed.connect(_button_ation.bind(item,index))
		#buttton.name="button"+var_to_str(index)
		#index=index+1
		v_box_container.add_child(fs)		
		fs.init(item)
		
	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
