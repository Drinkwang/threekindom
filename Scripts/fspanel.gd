extends Control


@export var datas:Array[cldata] 



@onready var _label = $PanelContainer/VBoxContainer/Label
@onready var _label_2 = $PanelContainer/VBoxContainer/Label2

#var _name:String
#var _num_all:int
#var _num_rt:int 
# Called when the node enters the scene tree for the first time.
func _ready():

	datas.clear()
	datas.append(GameManager.sav.WAIDIPAI)
	datas.append(GameManager.sav.BENTUPAI)
	datas.append(GameManager.sav.HAOZUPAI)
	
	var d:cldata=cldata.new()
	#d.
	_processList()
	SignalManager.changeLanguage.connect(changeLanguage)
	changeLanguage()
	SignalManager.changeSupport.connect(_processList)
	showCurrenceLaw()
func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	#if currencelanguage=="ja":
		#pass
	if currencelanguage=="ru":
		var newfont=preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")
		_label.add_theme_font_override("font",newfont)
		_label_2	.add_theme_font_override("font",newfont)
		_label.add_theme_constant_override("line_spacing",-2)
		_label_2.add_theme_constant_override("line_spacing",-2)
		currence_laws.add_theme_font_override("font",newfont)
	else:
		_label.remove_theme_font_override("font")
		_label_2.remove_theme_font_override("font")
		_label.remove_theme_constant_override("line_spacing")
		_label_2.remove_theme_constant_override("line_spacing")
		currence_laws.remove_theme_font_override("font")
	refreshData()
@onready var v_box_container = $PanelContainer/VBoxContainer

func _processList():
	GameManager.clear_children(v_box_container)#.remove_child()
	for item:cldata in datas:
		if item.isshow==false:
			continue

		var fs=load("res://Scene/prefab/Factionalsupport.tscn").instantiate()


		
		v_box_container.add_child(fs)		
		fs.init(item)
		
	
	pass
	
@onready var currence_laws = $PanelContainer/VBoxContainer/currenceLaws

func refreshData():
	var items=v_box_container.get_children()		
	for item in items:
		if item is factionalsupport:
			item.refreshData()		
	showCurrenceLaw()

func showCurrenceLaw():
	if  GameManager.sav.curLawName!=null and  GameManager.sav.curLawName.length()>0:

		currence_laws.show()
		currence_laws.text=tr("_current_bill")%tr(GameManager.sav.curLawName)
		print(tr("_current_bill"))
	else:
		currence_laws.hide()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
