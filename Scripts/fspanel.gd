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
	SignalManager.changeSupport.connect(refreshData)
	showCurrenceLaw()
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
	#v_box_container.remove_child()
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
