

extends Control
class_name policyPanel
@export var index=0
@onready var button = $PanelContainer/orderPanel/VBoxContainer/HBoxContainer/Button
@onready var tab_bar = $TabBar
@onready var point_label = $lawPanel/PointLabel
@onready var law_label = $lawPanel/DetailPanel/Label2
@onready var exp_len = $PanelContainer/orderPanel2/VBoxContainer/expLen
@onready var tourPoint: Node2D = $Node2D


func showTourPoint():
	tourPoint.show()
	$"Node2D/5Yellow/AnimationPlayer".play("YELLOWGUILD")

var costhp=35
#@onready var button = $PanelContainer/orderPanel/VBoxContainer/HBoxContainer/Button
@onready var detail_panel = $lawPanel/DetailPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.changeLanguage.connect(changeLanguage)
	if GameManager.sav.hp<costhp:
	
		button.disabled=true
		
		pass
		
	pass
	#initControls()
	changeLanguage()
	 # Replace with function body.


func initControls():

	var group=GameManager.getPolicyGroup()
		#GameManager.currenceScene.selectPolicy(self["control_"+index].data)
		#DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"xxx")
		#判断自己的逻辑
	#应该是第二天
	if group==-1 and GameManager.sav.policyExcute==false and GameManager.sav.day>=5:
		if GameManager.sav.randomIndex<=1:
			group=4
	if group==-1:
		currence_no_policy.show()
		$PanelContainer/orderPanel/VBoxContainer.hide()
	else:
		$PanelContainer/orderPanel/VBoxContainer.show()
		currence_no_policy.hide()
		GameManager.currenceScene._initGroup(group)
		control_1.initDataByGroup(1,group)
		control_2.initDataByGroup(2,group)
		control_3.initDataByGroup(3,group)
var expLenWidth=1240		

@onready var ConfireButton = $lawPanel/DetailPanel/Button

func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	
	if currencelanguage=="ru":
		expLenWidth=1325
		tourPoint.position.x=-130
		currence_no_policy.add_theme_font_size_override("font_size",45)
		ConfireButton.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		tab_bar.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		#label.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		law_label.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))	
		#currence_no_policy.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))	
	else:
		if currencelanguage=="en":
			tourPoint.position.x=-405
		elif currencelanguage=="ja":
			tourPoint.position.x=-250
		else:
			tourPoint.position.x=-344
		currence_no_policy.add_theme_font_size_override("font_size",66)
		expLenWidth=1240
		ConfireButton.remove_theme_font_override("font")
		tab_bar.remove_theme_font_override("font")
		#label.remove_theme_font_override("font")
		law_label.remove_theme_font_override("font")
		#currence_no_policy.remove_theme_font_override("font")
	point_label.text=tr("点数:%s")%GameManager.sav.Merit_points
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _initData():
	#_on_control_1_gui_input()
	if GameManager.sav.have_event["firstLawExecute"]==false and GameManager.sav.day<5:
		$TextureButton.hide()
	else:
		$TextureButton.show()
	if GameManager.sav.curLawName.length()>0:
		law_label.text=tr("当前【%s】法案已被立项，请先在议事厅通过该法案，才能立项其他法律。")%tr(GameManager.sav.curLawName)
		
		changeexp_len()
		#var label_height = 81
		#var label_line_count = law_label.get_line_count()  # 获取行数（可选）
		#var padding = 20  # 可根据需要调整
		#var new_size = Vector2(detail_panel.custom_minimum_size.x, label_height +label_line_count* padding)
		#exp_len.custom_minimum_size=Vector2(expLenWidth,new_size.y-81)

		#detail_panel.custom_minimum_size = new_size
	
	refreshLawPoint()

func changeexp_len():

	var label_height = 81
	var label_line_count = law_label.get_line_count()  # 获取行数（可选）
	var padding = 20  # 可根据需要调整
	var new_size = Vector2(1295+expLenWidth-1240, label_height +label_line_count* padding)
	exp_len.custom_minimum_size=Vector2(expLenWidth,new_size.y-81)
		# 应用到 Panel
	detail_panel.custom_minimum_size = new_size
func refreshLawPoint():
	get_tree().call_group("lawpoints","_initData")
	if GameManager.sav.curLawName.length()>0 or GameManager.sav.curLawNum1!=-1 or GameManager.sav.curLawNum2!=-1:
		$lawPanel/DetailPanel/Button.disabled=true
	else:
		$lawPanel/DetailPanel/Button.disabled=false
	point_label.text=tr("点数:%s")%GameManager.sav.Merit_points

@onready var LawPanelBoard = $PanelContainer/orderPanel2


func _on_tab_bar_tab_changed(tab):
	tourPoint.hide()
	if tab==0:
		$lawPanel.hide()
		LawPanelBoard.hide()
		$PanelContainer/orderPanel.show()
	else:
		$lawPanel.show()
		LawPanelBoard.show()
		changeexp_len()
		$PanelContainer/orderPanel.hide()
		if GameManager.sav.have_event["firstTabLaw"]==false:
			GameManager.sav.have_event["firstTabLaw"]=true
			DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"第一次指定法律")
		#判断剧情是否触发，如果没触发触发剧情
	#pass # Replace with function body.
	_initData()

@onready var control_1 = $PanelContainer/orderPanel/VBoxContainer/orderVbox/Control_1
@onready var control_2 = $PanelContainer/orderPanel/VBoxContainer/orderVbox/Control_2
@onready var control_3 = $PanelContainer/orderPanel/VBoxContainer/orderVbox/Control_3

@onready var label = $PanelContainer/orderPanel/VBoxContainer/Label

func _on_control_1_gui_input(event):
	

	if control_1.canclick==false:
		return
	if(event is InputEventMouseButton and event.button_index==1):
		index=1
		
		button.disabled=false
		SoundManager.play_sound(sounds.CLICKHERO)
		control_1.check_box.button_pressed=true
		control_2.check_box.button_pressed=false
		control_3.check_box.button_pressed=false
		label.text=tr(control_1.context)+":"+tr(control_1.detail)
		canHideBlockShow()

func _on_control_2_gui_input(event):
	

	if control_2.canclick==false:
		return
	if(event is InputEventMouseButton and event.button_index==1):	
		index=2		
		button.disabled=false
		SoundManager.play_sound(sounds.CLICKHERO)
		control_1.check_box.button_pressed=false
		control_2.check_box.button_pressed=true
		control_3.check_box.button_pressed=false
		label.text=tr(control_2.context)+":"+tr(control_2.detail)	
		canHideBlockShow()
@onready var can_hide_block = $PanelContainer/orderPanel/VBoxContainer/canHideBlock


func _on_control_3_gui_input(event):
	

	if control_3.canclick==false:
		return
	if(event is InputEventMouseButton and event.button_index==1):
		SoundManager.play_sound(sounds.CLICKHERO)
		index=3
		button.disabled=false
		control_1.check_box.button_pressed=false
		control_2.check_box.button_pressed=false
		control_3.check_box.button_pressed=true
		label.text=tr(control_3.context)+":"+tr(control_3.detail)	
		canHideBlockShow()
		
func canHideBlockShow():		
	var lines = label.get_line_count()
	if lines >= 5:
		can_hide_block.hide()
	else:
		can_hide_block.show()	
func bancontrol(_index,status):
	#get("ban%d"%index)=boolvalue
	#set("ban%d"%index,boolvalue)
	#var value=get("ban%d"%index)
	var item= get("control_%d"%_index) as policyItem
	item.setStatus(status)


func _disableAll():
	control_1.canclick=false
	control_2.canclick=false
	control_3.canclick=false

func _on_button_button_down():

	if await GameManager.isTried(costhp) or index==0:
		return
	GameManager.sav.hp=GameManager.sav.hp-costhp
	SoundManager.play_sound(sounds.SFX_FAST_UI_CLICK_MECHANICAL_03_WAV)
	#var context="story"+index
	#根据选项判断影响，并同时让施政选项不再显示
	#get_tree().get_root().get_node("")
	
	GameManager.currenceScene.selectPolicy(self["control_"+var_to_str(index)].data)
	#每个上中下上册都有一个结构体，这边事后根据结构体对应id判断不同id点击施政的确切影响
	pass # Replace with function body.

var selectLawPoint:lawpoint
func preLaw(value:lawpoint):
	if await GameManager.isTried(costhp):
		return
	lawbutton.show()
	selectLawPoint=value
	law_label.text=value.detail
	
	changeexp_len()
	#var label_height = 81
	#var label_line_count = law_label.get_line_count()  # 获取行数（可选）
	#var padding = 20  # 可根据需要调整
	#var new_size = Vector2(detail_panel.custom_minimum_size.x, label_height +label_line_count* padding)
	
	# 应用到 Panel
	#detail_panel.custom_minimum_size = new_size
	
	#exp_len.custom_minimum_size=Vector2(expLenWidth,new_size.y-81)
	#detail_panel.size=new_size
	pass
@onready var lawbutton = $lawPanel/DetailPanel/Button

func excuteLaw(value:lawpoint):

	if value==null:
		return
	#GameManager.hp=GameManager.hp-costhp
	if(GameManager.sav.Merit_points<value.costPoint):
		DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"你的政策点不够")	
		return
	if await GameManager.isTried(costhp):
		return	

	if selectLawPoint!=null:
		DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"确认法律")
	else:
		DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"当前没有法律可执行")

func agreelaw():
	if await GameManager.isTried(costhp):
		return
	GameManager.sav.RewardLaw=tr(selectLawPoint.IncomeTxt)

	GameManager.sav.curLawName=selectLawPoint.context
	GameManager.sav.curLawNum1=selectLawPoint.num1
	GameManager.sav.curLawNum2=selectLawPoint.num2
	SignalManager.changeSupport.emit()
	#num1\num2
	# int index	
	#当前【民田开垦】法案已被立项，请先在议会厅通过该法案，才能立项其他法律。	
	GameManager.sav.hp=GameManager.sav.hp-costhp
	GameManager.sav.Merit_points=GameManager.sav.Merit_points-selectLawPoint.costPoint
	selectLawPoint.isUnlock=true
	selectLawPoint._initData()

	GameManager.refreshPaixis()
	GameManager.sav.laws[selectLawPoint.num1].append(selectLawPoint.num2)
	
	#判断法律是否为即将达成的，如果是，则让其完成，获得好感度和目标
	
	#GameManager.haveLaw=true
	SoundManager.play_sound(sounds.confiresound)
	if GameManager.sav.have_event["firstLawExecute"]==false:
		GameManager.sav.have_event["firstLawExecute"]=true
		
		DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"第一次指定法律完成")
	#第一次执行完 执行额外操作
	#后续法律生效写在这里
	#if selectLawPoint.context=="":
	#	pass
	#elif selectLawPoint.context=="":
	#	pass
	_initData()
enum itemStatus{ban,select,normal}

func arrangeDone():
	_on_exit_button_button_down()
	#$"../.."._initData()
	
func _on_law_confire_button_down():
	excuteLaw(selectLawPoint)
	pass # Replace with function body.

@onready var law_panel = $lawPanel

func getPolicyName(lawIndex,policyIndex)->String:
	
	
	
	var lawPoint:lawpoint=law_panel.get_node("Control"+var_to_str(lawIndex+1)+"-"+var_to_str(policyIndex))
	return tr(lawPoint.context)

@onready var currence_no_policy = $PanelContainer/orderPanel/currenceNoPolicy

func _on_exit_button_button_down():
	SoundManager.play_sound(sounds.declinesound)
	self.hide()
	
	pass # Replace with function body.
