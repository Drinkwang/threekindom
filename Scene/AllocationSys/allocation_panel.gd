extends Control
@export var arrs:Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.playDemand.connect(initData)

@onready var label_2: Label = $Label2


func initData():
	var contextstr=""
	if GameManager.sav.allocationDay==1:
		contextstr=tr("俸给筹备期")
		#弹出不同的教程
	elif GameManager.sav.allocationDay==2:
		contextstr=tr("月例派发期")
	elif GameManager.sav.allocationDay==3:
		contextstr=tr("延发清缴日")
		
	#休整闲暇期

	label_2.text=tr("月例配给管理面板")+"【"+ contextstr+"】"
	for i in range(0,4):
		if i !=1:
			arrs[i].show()
			arrs[i].initData()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_button_down() -> void:
	self.hide()
