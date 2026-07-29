extends Control
class_name supportPanel
@onready var v_box_container = $PanelContainer/VBoxContainer

@export var datas:Array[cldata] 
# Called when the node enters the scene tree for the first time.
func _ready():
	
	var d:cldata=cldata.new()
	datas.clear()
	datas.append(GameManager.sav.BENTUPAI)
	datas.append(GameManager.sav.HAOZUPAI)
	datas.append(GameManager.sav.WAIDIPAI)
	datas.append(GameManager.sav.LVBU)
	var index=0
	if  GameManager.sav.curLawName!=null and  GameManager.sav.curLawName.length()>0:
		self.position.y=27
	else:
		self.position.y=0
	#d.
	_processList()
	SignalManager.changeFraction.connect(refreshData)
	SignalManager.changeSupport.connect(_processList)
	SignalManager.changeLanguage.connect(refreshData)

func _processList():
	GameManager.maxResPanelX=0
	GameManager.clear_children(v_box_container)
	for item:cldata in datas:
		if item.isshow==false:
			continue
		
		var fs=load("res://Scene/prefab/FactionalNum.tscn").instantiate() as factionalname


		v_box_container.add_child(fs)		
		fs.init(item)
		
	
	for c:factionalname in v_box_container.get_children():

	
		c.refreshSameX()

func refreshData():
	GameManager.maxResPanelX=0
	var items=v_box_container.get_children()
	for item:factionalname in items:
		item.refreshData()
	for item:factionalname in items:
		item.refreshSameX()
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
