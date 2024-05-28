extends baseComponent

@onready var control = $Control
const FancyFade = preload("res://addons/transitions/FancyFade.gd")
@onready var policyBook = $"政府文书"
@onready var policy_panel = $CanvasLayer/policyPanel

	#var initData=[
	#{	
	#	"name":"xxx",
	#	"context":"执行政策", #前往小道通向议事厅 
	#	"img":"true"
	#},

func showwrit():
	policyBook.show()
	pass

func lookDown():
	policyBook.hide()
	pass

#将这个页面的操作面板显示并存档
#dontwork
func implementpolicy():
	GameManager.have_event["firstPolicyOpShow"]=true
	initData()
	pass
	
#将施政面板显示并存档
func showTab():
	GameManager.have_event["firstTabLaw"]=true
	initData()
	


# Called when the node enters the scene tree for the first time.
func _ready():
	#DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)


	control.buttonClick.connect(_buttonListClick)
	initData()
		
	pass # Replace with function body.

func initData():
	if	GameManager.have_event["firstgovernment"]==false:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
		GameManager.have_event["firstgovernment"]=true
	GameManager.currenceScene=self
	var initData=[
	{	
		"id":"1",
		"context":"执行政策", #前往小道通向议事厅 
		"visible":"true"
	},
	{
		"id":"2",
		"context":"召见手下", #前往花园并通向小道
		"visible":"true"
	},
	{
		"id":"3",
		"context":"离开",#前往大街
		"visible":"true"
	},

	]
	if GameManager.have_event["firstPolicyOpShow"]==true:
		control._processList(initData)
		
	if GameManager.have_event["firstTabLaw"]==true:
		policy_panel.tab_bar.show()
	else:
		policy_panel.tab_bar.hide()
	policy_panel._initData()
#

const STREET = preload("res://Scene/street.tscn")
func _buttonListClick(item):
	if item.context == "执行政策":
		policy_panel.show()
		if(GameManager.have_event["firstgovermentTip"]==false):
			GameManager.have_event["firstgovermentTip"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"enterpolicy")
	elif item.context == "召见手下":
		#显示接下来要点击啥
		pass
	elif item.context == "离开":
		if(GameManager.have_event["firstLawExecute"]==true):
			const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
			FancyFade.new().custom_fade(STREET.instantiate(), 2, DISSOLVE_IMAGE)
		else:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"不能离开")
		#显示金钱 民心 xx 武将面板
	print(item)
	pass

func selectPolicy(id):
	if id==1:
		#额外buff填写
		selectCorrect()
	elif id==2:	
		#额外buff填写
		selectCorrect()
	elif id==3:
		policy_panel.bancontrol(3,policy_panel.itemStatus.ban)
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"错误决策0")
		#pass
	
func selectCorrect():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"正确决策0")
	hidePolicy()

func selectCorrectBefore():
	if GameManager.have_event["firstPolicyCorrect"]==false:
		GameManager.have_event["firstPolicyCorrect"]=true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"正确决策0之后引导")
	pass

func agreelaw():
	policy_panel.agreelaw()
#@onready var button = $PanelContainer/orderPanel/VBoxContainer/HBoxContainer/Button

#做出可以做的决策后，对面板进行隐藏
func hidePolicy():
	policy_panel.button.disabled=true
	policy_panel._disableAll()
	policy_panel.bancontrol(policy_panel.index,policy_panel.itemStatus.select)

func arrangeDone():
	#无操作
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
