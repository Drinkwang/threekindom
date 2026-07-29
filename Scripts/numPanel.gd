extends Control
class_name supportPanel
@onready var v_box_container = $PanelContainer/VBoxContainer

@export var datas:Array[cldata] 
@export var law_y_offset:float=27.0

var _shift_controls:Array[Control]=[]
var _base_vertical_offsets:Array[Vector2]=[]
var _language_refresh_queued:=false

# Called when the node enters the scene tree for the first time.
func _ready():
	_cache_base_offsets()
	_refresh_law_position()

	var d:cldata=cldata.new()
	datas.clear()
	datas.append(GameManager.sav.BENTUPAI)
	datas.append(GameManager.sav.HAOZUPAI)
	datas.append(GameManager.sav.WAIDIPAI)
	datas.append(GameManager.sav.LVBU)
	var index=0
	#d.
	_processList()
	SignalManager.changeFraction.connect(refreshData)
	SignalManager.changeSupport.connect(_on_support_changed)
	SignalManager.changeLanguage.connect(_on_language_changed)

func _cache_base_offsets():
	for child in get_children():
		if child is Control:
			var control:=child as Control
			_shift_controls.append(control)
			_base_vertical_offsets.append(Vector2(control.offset_top,control.offset_bottom))

func _refresh_law_position():
	var has_law:=GameManager.sav.curLawName!=null and GameManager.sav.curLawName.length()>0
	var y_offset:=law_y_offset if has_law else 0.0
	for index in _shift_controls.size():
		var control:=_shift_controls[index]
		var base_offsets:=_base_vertical_offsets[index]
		control.offset_top=base_offsets.x+y_offset
		control.offset_bottom=base_offsets.y+y_offset

func _on_support_changed():
	_refresh_law_position()
	_processList()

func _on_language_changed():
	if _language_refresh_queued:
		return
	_language_refresh_queued=true
	call_deferred("_refresh_after_language_change")

func _refresh_after_language_change():
	_language_refresh_queued=false
	refreshData()

func _processList():
	GameManager.clear_children(v_box_container)
	for item:cldata in datas:
		if item.isshow==false:
			continue
		
		var fs=load("res://Scene/prefab/FactionalNum.tscn").instantiate() as factionalname


		v_box_container.add_child(fs)		
		fs.init(item)
		
	
	_refresh_label_widths()

func refreshData():
	var items=v_box_container.get_children()
	for item:factionalname in items:
		item.refreshData()
	_refresh_label_widths()

func _refresh_label_widths():
	var widest_label:=0.0
	var items=v_box_container.get_children()
	for item:factionalname in items:
		widest_label=maxf(widest_label,item.get_label_width())
	for item:factionalname in items:
		item.refreshSameX(widest_label)
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
