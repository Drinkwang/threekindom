extends baseComponent

@onready var faction = $CanvasBook/faction

@onready var control = $Control
const FancyFade = preload("res://addons/transitions/FancyFade.gd")


	#var initData=[
	#{	
	#	"name":"xxx",
	#	"context":"执行政策", #前往小道通向议事厅 
	#	"img":"true"
	#},


#将这个页面的操作面板显示并存档
#dontwork
func implementpolicy():
	GameManager.have_event["firstPolicyOpShow"]=true
	_initData()
	pass
	
#将施政面板显示并存档
func showTab():
	GameManager.have_event["firstTabLaw"]=true
	_initData()
	

func post_transition():
	print("fadedone")
	_initData()


# Called when the node enters the scene tree for the first time.
func _ready():
	#DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)

	Transitions.post_transition.connect(post_transition)
	control.buttonClick.connect(_buttonListClick)
	super._ready()
	#initData()
		
	pass # Replace with function body.

func _initFaction():
	pass

func _initData():
	#if	GameManager.have_event["firstgovernment"]==false:
		#DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
		#GameManager.have_event["firstgovernment"]=true
	GameManager.currenceScene=self
	var initData=[
	{	
		"id":"1",
		"context":"开始议事", #前往小道通向议事厅 
		"visible":"true"
	},
	{
		"id":"2",
		"context":"议事说明", #前往花园并通向小道
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
		


func _buttonListClick(item):
	if item.context == "执行政策":
		if(GameManager.have_event["firstgovermentTip"]==false):
			GameManager.have_event["firstgovermentTip"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"enterpolicy")
	elif item.context == "召见手下":
		#显示接下来要点击啥
		pass
	elif item.context == "离开":
		if(GameManager.have_event["firstLawExecute"]==true):
			const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
			FancyFade.new().custom_fade(SceneManager.STREET.instantiate(), 2, DISSOLVE_IMAGE)
		else:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"不能离开")
		#显示金钱 民心 xx 武将面板
	print(item)
	pass




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
