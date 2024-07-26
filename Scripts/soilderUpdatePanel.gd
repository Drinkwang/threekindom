extends Control

@onready var control_1 = $PanelContainer/orderPanel/VBoxContainer/orderVbox/Control_1
@onready var control_2 = $PanelContainer/orderPanel/VBoxContainer/orderVbox/Control_2
@onready var control_3 = $PanelContainer/orderPanel/VBoxContainer/orderVbox/Control_3






var selected_general_index = 0
var gold = 100 #待屏蔽
var upgrade_cost = 5


# 在场景中准备好时运行
func _ready():
	#general1_button.connect("pressed", self, "_on_general1_button_pressed")
	#general2_button.connect("pressed", self, "_on_general2_button_pressed")
	#general3_button.connect("pressed", self, "_on_general3_button_pressed")
	#upgrade_button.connect("pressed", self, "_on_upgrade_button_pressed")
	update_ui()

# 更新界面

#var generals = [
	#{"name": "关羽", "level": 1, "max_level": 10},
	#{"name": "张飞", "level": 1, "max_level": 10},
	#{"name": "赵云", "level": 1, "max_level": 10}
#]

func update_ui():
	var selected_general = GameManager.generals.values()[selected_general_index]
	control_1.updateContext(0)
	control_2.updateContext(1)	
	control_3.updateContext(2)	
	#level_label.text = "当前等级: " + str(selected_general["level"])
	#gold_label.text = "当前金币: " + str(gold)
	#upgrade_button.disabled = selected_general["level"] >= selected_general["max_level"] or gold < upgrade_cost



# 升级按钮被按下时运行
func _on_upgrade_button_pressed():
	var selected_general = GameManager.generals.values()[selected_general_index]
	if gold >= upgrade_cost and selected_general["level"] < selected_general["max_level"]:
		gold -= upgrade_cost
		selected_general["level"] += 1
		update_ui()
		print("升级成功！", selected_general["name"], "当前等级: ", selected_general["level"])
	else:
		print("升级失败，金币不足或已达到最大等级。")

# 添加金币获取功能（可选）
func add_gold(amount):
	gold += amount
	update_ui()


func _on_control_1_gui_input(event):
	if(event is InputEventMouseButton and event.button_index==1):	
		selected_general_index=0		
		control_1.check_box.button_pressed=true
		control_2.check_box.button_pressed=false
		control_3.check_box.button_pressed=false
		#label.text=control_2.context+":"+control_2.detail	
		update_ui()


func _on_control_2_gui_input(event):
	if(event is InputEventMouseButton and event.button_index==1):	
		selected_general_index=1		
		control_1.check_box.button_pressed=false
		control_2.check_box.button_pressed=true
		control_3.check_box.button_pressed=false
		#label.text=control_2.context+":"+control_2.detail	
		update_ui()


func _on_control_3_gui_input(event):
	if(event is InputEventMouseButton and event.button_index==1):	
		selected_general_index=2		
		control_1.check_box.button_pressed=false
		control_2.check_box.button_pressed=false
		control_3.check_box.button_pressed=true
		#label.text=control_2.context+":"+control_2.detail	
		update_ui()
