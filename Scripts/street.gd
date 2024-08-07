extends baseComponent
@onready var control = $Control
const FancyFade = preload("res://addons/transitions/FancyFade.gd")
#var destination:String #放在gameins里面

# Called when the node enters the scene tree for the first time.
func _ready():


	super._ready()
	Transitions.post_transition.connect(post_transition)
	control.buttonClick.connect(_buttonListClick)


	
	pass # Replace with function body.

func streetTwo():
	pass


func post_transition():
	#print("fadedone")
	_initData()
	if(GameManager.have_event["firststreet"]==true):
		if(GameManager.have_event["secondStreet"]==false):
			GameManager.destination="自宅"
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第二次街道")
			GameManager.have_event["secondStreet"]=true
			
	
	if(GameManager.have_event["firststreet"]==false):
		GameManager.destination="府邸"
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
		GameManager.have_event["firststreet"]=true
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
	
#const HOUSE = preload("res://Scene/house.tscn")
#const BOULEUTERION = preload("res://Scene/Bouleuterion.tscn")
func _buttonListClick(item):
	#if GameManager.story_point<1:
		#if item.context == "府邸":
			#const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
			#FancyFade.new().custom_fade(GOVERNMENT_BUILDING.instantiate(), 7, DISSOLVE_IMAGE)
		#else:
	#		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"tip")
	#		return
	if(GameManager.destination.length()>0):
		if(GameManager.destination!=item.context):
			if(GameManager.destination=="府邸"):
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"tip")
			return 
			if(GameManager.destination=="自宅"):
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"ImustGoHome")
	const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')

	if item.context == "府邸":
		SceneManager.changeScene(SceneManager.roomNode.GOVERNMENT_BUILDING,2)
	elif item.context == "自宅":
		SceneManager.changeScene(SceneManager.roomNode.HOUSE,2)
		#scene=HOUSE
	elif item.context == "议事厅":
		SceneManager.changeScene(SceneManager.roomNode.BOULEUTERION,2)
		pass
		#scene=BOULEUTERION
	elif item.context == "商店":
	
		pass
		#打开商店ui
		#scene=GOVERNMENT_BUILDING
	elif item.context == "军事商店":
		pass
		##打开商店ui换皮或者换页
	#FancyFade.new().custom_fade(scene, 2, DISSOLVE_IMAGE)
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
