extends Control


@export var datas:Array[cldata]



@onready var _label = $PanelContainer/VBoxContainer/Label
@onready var _label_2 = $PanelContainer/VBoxContainer/Label2
@onready var _panel: PanelContainer = $PanelContainer
var _panel_base_offset_top:float
var _panel_base_offset_bottom:float
var _layout_refresh_queued:=false

#var _name:String
#var _num_all:int
#var _num_rt:int
# Called when the node enters the scene tree for the first time.
func _ready():
	_panel_base_offset_top=_panel.offset_top
	_panel_base_offset_bottom=_panel.offset_bottom

	datas.clear()
	datas.append(GameManager.sav.BENTUPAI)


	datas.append(GameManager.sav.HAOZUPAI)
	datas.append(GameManager.sav.WAIDIPAI)
	datas.append(GameManager.sav.LVBU)
	var d:cldata=cldata.new()
	#d.
	_processList()
	SignalManager.changeLanguage.connect(changeLanguage)
	changeLanguage()
	SignalManager.changeSupport.connect(_processList)
	SignalManager.changeFraction.connect(refreshData)

func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	#if currencelanguage=="ja":
		#pass
	if currencelanguage=="ru":
		#var newfont=preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")
		if _label!=null:
		#	_label.add_theme_font_override("font",newfont)
			_label.add_theme_constant_override("line_spacing",-2)
		if _label_2!=null:
		#	_label_2.add_theme_font_override("font",newfont)
			_label_2.add_theme_constant_override("line_spacing",-2)
		if currence_laws!=null:
			pass
		#	currence_laws.add_theme_font_override("font",newfont)
	else:
		if _label!=null:
			#_label.remove_theme_font_override("font")
			_label.add_theme_constant_override("line_spacing",0)
		if _label_2!=null:
			#_label_2.remove_theme_font_override("font")
			_label_2.add_theme_constant_override("line_spacing",0)
		if currence_laws!=null:
			pass
			#currence_laws.remove_theme_font_override("font")
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


	showCurrenceLaw()
	_queue_layout_refresh()

@onready var currence_laws = $PanelContainer/VBoxContainer/currenceLaws

func refreshData():
	var items=v_box_container.get_children()
	for item in items:
		if item is factionalsupport:
			item.refreshData()
	showCurrenceLaw()
	_queue_layout_refresh()

func showCurrenceLaw():
	if  GameManager.sav.curLawName!=null and  GameManager.sav.curLawName.length()>0:
		if currence_laws!=null:
			currence_laws.show()
			currence_laws.text=tr("_current_bill")%tr(GameManager.sav.curLawName)
			print(tr("_current_bill"))
	else:
		if currence_laws!=null:
			currence_laws.hide()

func _queue_layout_refresh():
	if _layout_refresh_queued:
		return
	_layout_refresh_queued=true
	await get_tree().process_frame
	_layout_refresh_queued=false
	refreshLayout()

func refreshLayout():
	var currencelanguage=TranslationServer.get_locale()
	var panel_y_offset=-14.0 if currencelanguage=="ja" or currencelanguage=="lzh" else 0.0
	if  GameManager.sav.curLawName!=null and  GameManager.sav.curLawName.length()>0:
		panel_y_offset+=30
	_panel.offset_top=_panel_base_offset_top+panel_y_offset
	_panel.offset_bottom=_panel_base_offset_bottom+panel_y_offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
