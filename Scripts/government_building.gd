extends baseComponent

@onready var control = $Control

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

#dontwork
func implementpolicy():
	pass
	


# Called when the node enters the scene tree for the first time.
func _ready():
	#DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
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
	control._processList(initData)

	control.buttonClick.connect(_buttonListClick)
	initData()
		
	pass # Replace with function body.

func initData():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
	GameManager.currenceScene=self



func _buttonListClick(item):
	if item.context == "执行政策":
		policy_panel.show()
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"enterpolicy")
	elif item.context == "召见手下":
		#显示接下来要点击啥
		pass
	elif item.context == "离开":
		const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
		#FancyFade.new().custom_fade(STREET.instantiate(), 2, DISSOLVE_IMAGE)
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
	


#@onready var button = $PanelContainer/orderPanel/VBoxContainer/HBoxContainer/Button

func hidePolicy():
	policy_panel.button.disabled=true
	policy_panel._disableAll()
	policy_panel.bancontrol(policy_panel.index,policy_panel.itemStatus.select)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
