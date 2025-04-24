extends Control

@onready var control_1 = $PanelContainer/orderPanel/VBoxContainer/orderVbox/Control_1
@onready var control_2 = $PanelContainer/orderPanel/VBoxContainer/orderVbox/Control_2
@onready var control_3 = $PanelContainer/orderPanel/VBoxContainer/orderVbox/Control_3


var costhp=10



var selected_general_index = 0

var upgrade_cost = 5


# 在场景中准备好时运行
func _ready():
	#general1_button.connect("pressed", self, "_on_general1_button_pressed")
	#general2_button.connect("pressed", self, "_on_general2_button_pressed")
	#general3_button.connect("pressed", self, "_on_general3_button_pressed")
	#upgrade_button.connect("pressed", self, "_on_upgrade_button_pressed")
	update_ui()
	changeLanguage()
# 更新界面

func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="ja":
		pass
	elif currencelanguage=="ru":
		pass

	else:
		pass
#var generals = [
	#{"name": "关羽", "level": 1, "max_level": 10},
	#{"name": "张飞", "level": 1, "max_level": 10},
	#{"name": "赵云", "level": 1, "max_level": 10}
#]
@onready var label = $PanelContainer/orderPanel/VBoxContainer/Label

func update_ui():
	var selected_general = GameManager.sav.generals.values()[selected_general_index]
	label.text=tr("选择{name}进行练兵升级，这大概需要花费{num}金，升级成功率100%").format({"name":tr(selected_general.name),"num":selected_general.level*50})
	control_1.updateContext(0)
	control_2.updateContext(1)	
	control_3.updateContext(2)	
	
	if(GameManager.sav.isLevelUp==false):
		control_1.canSelect=true
		control_2.canSelect=true
		control_3.canSelect=true
	else:
		control_1.canSelect=false
		control_2.canSelect=false
		control_3.canSelect=false		
	#level_label.text = "当前等级: " + str(selected_general["level"])
	#gold_label.text = "当前金币: " + str(gold)
	#upgrade_button.disabled = selected_general["level"] >= selected_general["max_level"] or gold < upgrade_cost


@onready var lvbutton = $PanelContainer/orderPanel/VBoxContainer/HBoxContainer/Button

# 升级按钮被按下时运行
func _on_upgrade_button_pressed():
	if GameManager.sav.isLevelUp==true:
		return
	
	if(await GameManager.isTried(costhp)):
		return 
	
	var selected_general = GameManager.sav.generals.values()[selected_general_index]
	if GameManager.sav.coin >= upgrade_cost and selected_general["level"] < selected_general["max_level"]:
		GameManager.sav.coin -= upgrade_cost
		selected_general["level"] += 1
		lvbutton.disabled=true
		GameManager.sav.isLevelUp=true
		update_ui()
		SoundManager.play_sound(sounds.buysellsound)
		GameManager.sav.hp=GameManager.sav.hp-costhp
		print("升级成功！", selected_general["name"], "当前等级: ", selected_general["level"])
	elif GameManager.sav.coin<upgrade_cost:
		label.text="你的金币不够"
	else:
		label.text="你已达到最大等级。"

# 添加金币获取功能（可选）
func add_gold(amount):
	GameManager.sav.coin += amount
	update_ui()
@export var dialogue_resource:DialogueResource


func _on_control_1_gui_input(event):
	if(event is InputEventMouseButton and event.button_index==1):	
		SoundManager.play_sound(sounds.SELECT_HERO)
		selected_general_index=0		
		control_1.check_box.button_pressed=true
		control_2.check_box.button_pressed=false
		control_3.check_box.button_pressed=false
		#label.text=control_2.context+":"+control_2.detail	
		update_ui()


func _on_control_2_gui_input(event):
	if(event is InputEventMouseButton and event.button_index==1):	
		selected_general_index=1
		SoundManager.play_sound(sounds.SELECT_HERO)		
		control_1.check_box.button_pressed=false
		control_2.check_box.button_pressed=true
		control_3.check_box.button_pressed=false
		#label.text=control_2.context+":"+control_2.detail	
		update_ui()


func _on_control_3_gui_input(event):
	if(event is InputEventMouseButton and event.button_index==1):	
		selected_general_index=2
				
		SoundManager.play_sound(sounds.SELECT_HERO)		
		control_1.check_box.button_pressed=false
		control_2.check_box.button_pressed=false
		control_3.check_box.button_pressed=true
		#label.text=control_2.context+":"+control_2.detail	
		update_ui()


func _on_exit_button_button_down():
	self.hide()
	if GameManager.sav.isLevelUp==true:
		if GameManager.sav.have_event["firstTrain"]==false:
			SoundManager.play_sound(sounds.declinesound)
			GameManager.sav.have_event["firstTrain"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"初次练兵")
		#当升级成果时，触发这里的脚本
	pass # Replace with function body.
