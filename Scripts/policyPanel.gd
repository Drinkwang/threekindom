

extends Control
class_name policyPanel
@export var index=0
@onready var button = $PanelContainer/orderPanel/VBoxContainer/HBoxContainer/Button
@onready var tab_bar = $TabBar
@onready var point_label = $lawPanel/PointLabel


# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _initData():
	index=0
	if GameManager.have_event["firstLawExecute"]==false:
		$TextureButton.hide()
	else:
		$TextureButton.show()
	pass
	point_label.text="点数:%s"%GameManager.Merit_points
	refreshLawPoint()

func refreshLawPoint():
	get_tree().call_group("lawpoints","_initData")
	

func _on_tab_bar_tab_changed(tab):
	if tab==0:
		$lawPanel.hide()
		$PanelContainer/orderPanel.show()
	else:
		$lawPanel.show()
		$PanelContainer/orderPanel.hide()
		if GameManager.have_event["firstTabLaw"]==false:
			GameManager.have_event["firstTabLaw"]=true
			DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"第一次指定法律")
		#判断剧情是否触发，如果没触发触发剧情
	#pass # Replace with function body.


@onready var control_1 = $PanelContainer/orderPanel/VBoxContainer/orderVbox/Control_1
@onready var control_2 = $PanelContainer/orderPanel/VBoxContainer/orderVbox/Control_2
@onready var control_3 = $PanelContainer/orderPanel/VBoxContainer/orderVbox/Control_3

@onready var label = $PanelContainer/orderPanel/VBoxContainer/Label

func _on_control_1_gui_input(event):
	if control_1.canclick==false:
		return
	if(event is InputEventMouseButton and event.button_index==1):
		index=1
		control_1.check_box.button_pressed=true
		control_2.check_box.button_pressed=false
		control_3.check_box.button_pressed=false
		label.text=control_1.context+":"+control_1.detail


func _on_control_2_gui_input(event):
	if control_2.canclick==false:
		return
	if(event is InputEventMouseButton and event.button_index==1):	
		index=2		
		control_1.check_box.button_pressed=false
		control_2.check_box.button_pressed=true
		control_3.check_box.button_pressed=false
		label.text=control_2.context+":"+control_2.detail	


func _on_control_3_gui_input(event):
	if control_3.canclick==false:
		return
	if(event is InputEventMouseButton and event.button_index==1):
		index=3
		control_1.check_box.button_pressed=false
		control_2.check_box.button_pressed=false
		control_3.check_box.button_pressed=true
		label.text=control_3.context+":"+control_3.detail	

func bancontrol(index,status):
	#get("ban%d"%index)=boolvalue
	#set("ban%d"%index,boolvalue)
	#var value=get("ban%d"%index)
	var item= get("control_%d"%index) as policyItem
	item.setStatus(status)


func _disableAll():
	control_1.canclick=false
	control_2.canclick=false
	control_3.canclick=false

func _on_button_button_down():
	#var context="story"+index
	#根据选项判断影响，并同时让施政选项不再显示
	#get_tree().get_root().get_node("")
	GameManager.currenceScene.selectPolicy(index)
	#每个上中下上册都有一个结构体，这边事后根据结构体对应id判断不同id点击施政的确切影响
	pass # Replace with function body.

var selectLawPoint:lawpoint
func preLaw(value:lawpoint):
	selectLawPoint=value
	$lawPanel/DetailPanel/Label2.text=value.detail
	pass
	
func excuteLaw(value:lawpoint):
	if(GameManager.Merit_points<value.costPoint):
		DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"你的政策点不够")	
		return
		
	if selectLawPoint!=null:
		DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"确认法律")
	else:
		DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"当前没有法律可执行")

func agreelaw():
	GameManager.Merit_points=GameManager.Merit_points-selectLawPoint.costPoint
	selectLawPoint.isUnlock=true
	selectLawPoint._initData()
	
	if GameManager.have_event["firstLawExecute"]==false:
		GameManager.have_event["firstLawExecute"]=true
		_initData()
		DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"第一次指定法律完成")
	#第一次执行完 执行额外操作
	#后续法律生效写在这里
	if selectLawPoint.context=="":
		pass
	elif selectLawPoint.context=="":
		pass

enum itemStatus{ban,select,normal}

func arrangeDone():
	_on_exit_button_button_down()
	
func _on_law_confire_button_down():
	excuteLaw(selectLawPoint)
	pass # Replace with function body.


func _on_exit_button_button_down():
	self.hide()
	pass # Replace with function body.
