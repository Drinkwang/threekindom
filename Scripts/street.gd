extends baseComponent
@onready var control = $Control
const GOVERNMENT_BUILDING = preload("res://Scene/government_building.tscn")

@onready var chenqun = $"陈群"

# Called when the node enters the scene tree for the first time.
func _ready():



	Transitions.post_transition.connect(post_transition)
	control.buttonClick.connect(_buttonListClick)
	if GameManager.story_point==0 :
		GameManager.story_point=GameManager.story_point+1
		control.hide()
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
	
	pass # Replace with function body.


func post_transition():
	print("fadedone")
	_initData()

	pass

func _initData():
	var initData=[
	{	
		"id":"1",
		"context":"府邸", #前往小道通向议事厅 
		"visible":"true"
	},
	{
		"id":"2",
		"context":"自宅", #前往花园并通向小道
		"visible":"true"
	},
	{
		"id":"3",
		"context":"议事厅",#前往大街
		"visible":"true"
	},
	{
		"id":"4",
		"context":"商店",#打开人物面板
		"visible":"true"
	},
	{
		"id":"5",
		"context":"军事商店",#打开属性ui
		"visible":"true"
	},
	{
		"id":"6",
		"context":"城门-军事驻地", #天数加1 进入过度
		"visible":"true"
	}]
	control._processList(initData)
	


func _buttonListClick(item):
	if GameManager.story_point<1:
		#if item.context == "府邸":
			#const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
			#FancyFade.new().custom_fade(GOVERNMENT_BUILDING.instantiate(), 7, DISSOLVE_IMAGE)
		#else:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"tip")
			return
	
	if item.context == "府邸":
		const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
		FancyFade.new().custom_fade(GOVERNMENT_BUILDING.instantiate(), 2, DISSOLVE_IMAGE)
	elif item.context == "自宅":
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"tip")
	elif item.context == "议事厅":
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"tip")
	elif item.context == "商店":
		print(item)
	elif item.context == "军事商店":
		pass
	
	pass
	 # Replace with function body.


func showFirstGuild():
	control.show()
	control._show_button_5_yellow(0)
	#$"陈群".hide()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
