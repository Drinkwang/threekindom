extends Control

@export var index=0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _initData():
	index=0
	pass


func _on_tab_bar_tab_changed(tab):
	if tab==0:
		$lawPanel.hide()
		$PanelContainer/orderPanel.show()
	else:
		$lawPanel.show()
		$PanelContainer/orderPanel.hide()
	#pass # Replace with function body.


@onready var control_1 = $PanelContainer/orderPanel/VBoxContainer/orderVbox/Control_1
@onready var control_2 = $PanelContainer/orderPanel/VBoxContainer/orderVbox/Control_2
@onready var control_3 = $PanelContainer/orderPanel/VBoxContainer/orderVbox/Control_3

@onready var label = $PanelContainer/orderPanel/VBoxContainer/Label

func _on_control_1_gui_input(event):
	if(event is InputEventMouseButton and event.button_index==1):
		index=1
		control_1.check_box.button_pressed=true
		control_2.check_box.button_pressed=false
		control_3.check_box.button_pressed=false
		label.text=control_1.context+":"+control_1.detail


func _on_control_2_gui_input(event):
	if(event is InputEventMouseButton and event.button_index==1):	
		index=2		
		control_1.check_box.button_pressed=false
		control_2.check_box.button_pressed=true
		control_3.check_box.button_pressed=false
		label.text=control_2.context+":"+control_2.detail	


func _on_control_3_gui_input(event):
	if(event is InputEventMouseButton and event.button_index==1):
		index=3
		control_1.check_box.button_pressed=false
		control_2.check_box.button_pressed=false
		control_3.check_box.button_pressed=true
		label.text=control_3.context+":"+control_3.detail	


func _on_button_button_down():
	var context="story"+index
	
	#pass # Replace with function body.
