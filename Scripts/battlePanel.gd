
extends Control
class_name battlePanel
@onready var battle_circle:DiskInBattle = $battleCircle

#condition 类 
@onready var soild_num = $sliderlabel1/soildNum
@onready var coin_num = $sliderlabel2/coinNum

@onready var coin_slider = $coinSlider
@onready var soild_slider = $soildSlider
@onready var control_3 = $Control_3
@onready var control_2 = $Control_2
@onready var control_1 = $Control_1

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameManager.labor_force<0:
		soild_slider.editable=false
	if GameManager.coin<0:
		coin_slider.editable=false
	
	initTask()
	pass # Replace with function body.


func initTask():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _changeProgress():
	battle_circle._processSuccussCircle()
	pass

var costcoin:int
var costsoild:int

func _soilderNum_changed(value):
	costcoin=(GameManager.labor_force/100*value)
	
	soild_num.text=costsoild
	



func _on_coin_slider_value_changed(value):
	costcoin=(GameManager.coin/100*value)
	coin_num.text=costcoin


#{"name": "关羽", "level": 1, "max_level": 10, "randominit": -1}
func _on_control_1_gui_input(event):
	control_1.check_box.button_pressed=true
	control_2.check_box.button_pressed=false
	control_3.check_box.button_pressed=false
	battle_circle.selectgeneral= GameManager.generals[control_1.repImg]
	battle_circle.refresh()
	
	#取消其它的选中状态
	#给当前标记为选中
	#将选中将领具体信息发送给disk	
	pass # Replace with function body.


func _on_control_2_gui_input(event):
	control_1.check_box.button_pressed=false
	control_2.check_box.button_pressed=true
	control_3.check_box.button_pressed=false
	battle_circle.selectgeneral= GameManager.generals[control_2.repImg]
	battle_circle.refresh() 

func _on_control_3_gui_input(event):
	control_1.check_box.button_pressed=false
	control_2.check_box.button_pressed=false
	control_3.check_box.button_pressed=true
	battle_circle.selectgeneral= GameManager.generals[control_3.repImg]
	battle_circle.refresh()	 
