extends Control
@onready var v_box_container = $PanelContainer/VBoxContainer

@export var datas:Array[cldata] 
# Called when the node enters the scene tree for the first time.
func _ready():
	var d:cldata=cldata.new()
	#d.
	_processList()
	SignalManager.changeFraction.connect(refreshData)


func _processList():

	for item:cldata in datas:
		if item.isshow==false:
			continue
		
		var fs=load("res://Scene/prefab/FactionalNum.tscn").instantiate() as factionalname


		v_box_container.add_child(fs)		
		fs.init(item)
		
	
	pass

func refreshData():
	var items=v_box_container.get_children()		
	for item in items:
		item.refreshData()
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
