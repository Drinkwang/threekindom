extends baseComponent

@onready var control = $Control
const STREET = preload("res://Scene/street.tscn")
const FancyFade = preload("res://addons/transitions/FancyFade.gd")
# Called when the node enters the scene tree for the first time.
func _ready():
	

	Transitions.post_transition.connect(post_transition)
	control.buttonClick.connect(_buttonListClick)
	_initData()
		
	pass # Replace with function body.

func _initData():
	var initData=[
	{	
		"id":"1",
		"context":"(议事厅)", #前往小道通向议事厅 
		"visible":"false"
	},
	{
		"id":"2",
		"context":"(府邸)", #前往花园并通向小道
		"visible":"false"
	},
	{
		"id":"3",
		"context":"外出",#前往大街
		"visible":"true"
	},
	{
		"id":"4",
		"context":"今日政务",#打开人物面板
		"visible":"true"
	},
	{
		"id":"5",
		"context":"属性面板",#打开属性ui
		"visible":"true"
	},
	{
		"id":"6",
		"context":"休息", #天数加1 进入过度
		"visible":"false"
	}
	]
	control._processList(initData)
	GameManager.currenceScene=self
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
	pass

func post_transition():
	print("fadedone")
	_initData()

	pass

func _buttonListClick(item):
	if GameManager.story_point<1:
		#if item.context == "府邸":
			#const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
			#FancyFade.new().custom_fade(GOVERNMENT_BUILDING.instantiate(), 7, DISSOLVE_IMAGE)
		#else:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"tip")
			return
	
	if item.context == "外出":
		const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
		FancyFade.new().custom_fade(STREET.instantiate(), 2, DISSOLVE_IMAGE)
		pass
	elif item.context == "今日政务":
		#显示接下来要点击啥
		pass
	elif item.context == "属性面板":
		#显示金钱 民心 xx 武将面板
		pass
	print(item)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func showFirstGuild():
	control.show()
	control._show_button_5_yellow(0)
	$"陈群".hide()

	pass
	
func showchenqun():
	$"陈群".show()
	pass
