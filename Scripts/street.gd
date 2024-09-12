extends baseComponent
@onready var control = $Control
const FancyFade = preload("res://addons/transitions/FancyFade.gd")
#var destination:String #放在gameins里面
@onready var scholar = $CanvasLayer/scholar

# Called when the node enters the scene tree for the first time.
func _ready():

	#方便测试
	GameManager.sav.have_event["firstmeetchenqun"]=true


	super._ready()
	Transitions.post_transition.connect(post_transition)
	control.buttonClick.connect(_buttonListClick)


	
	pass # Replace with function body.

func streetTwo():
	control.show()
	control._show_button_5_yellow(5)	
	pass

func streetThree():
	pass
#const 街道 = preload("res://Asset/bgm/街道.mp3")	
func post_transition():
	
	#print("fadedone")
	_initData()
	if GameManager.sav.day==1:
		if(GameManager.sav.have_event["firststreet"]==true):
			if(GameManager.sav.have_event["secondStreet"]==false):
				GameManager.sav.destination="城门-军事驻地"
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第二次街道")
				GameManager.sav.have_event["secondStreet"]=true
			
	
		if(GameManager.sav.have_event["firststreet"]==false):
			GameManager.sav.destination="府邸"
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
			GameManager.sav.have_event["firststreet"]=true
		if GameManager.sav.have_event["firstTrain"]==true:
			if GameManager.sav.have_event["threeStree"]==false:
				GameManager.sav.destination="自宅"#只要把这段逻辑打开，就能那啥
				GameManager.sav.have_event["threeStree"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"ImustGoHome")
	
	if GameManager.sav.day==2 and GameManager.sav.have_event["firstMeetingEnd"]==false:
		control._show_button_5_yellow(0)
	if GameManager.sav.have_event["firstMeetingEnd"]==true:
		if GameManager.sav.have_event["streetBeginBouleuterion"]==false:
			GameManager.sav.have_event["streetBeginBouleuterion"]=true
			control._show_button_5_yellow(2)
			GameManager.sav.destination="议事厅"
	if GameManager.sav.day==3:
		if GameManager.sav.have_event["firstBattle"]==false:
			GameManager.sav.have_event["firstBattle"]=true
			control._show_button_5_yellow(5)
	if GameManager.sav.day==4:
		GameManager.sav.destination="城门-军事驻地"
		control._show_button_5_yellow(5)
		#拜访大儒
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
	if(GameManager.sav.destination.length()>0):
		if(GameManager.sav.destination!=item.context):
			if(GameManager.sav.destination=="府邸"):
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"tip")
			#return 
			elif(GameManager.sav.destination=="自宅"):
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"ImustGoHome")
			elif GameManager.sav.destination=="城门-军事驻地":
				if GameManager.sav.day!=4:
					DialogueManager.show_example_dialogue_balloon(dialogue_resource,"校场")	
				else:
					DialogueManager.show_example_dialogue_balloon(dialogue_resource,"tip_scholar")	
			elif GameManager.sav.destination=="议事厅":
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"tip_bouleuterion")
			return
		else:
			GameManager.sav.destination=""	#如果去的是目的地，则将目的地滞空	
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
	elif item.context=="城门-军事驻地":
		if(GameManager.sav.day>=4):
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"selectOutSide")
			pass #给选项，可跳可不跳
		else:
			visitDrill()
		pass
	#FancyFade.new().custom_fade(scene, 2, DISSOLVE_IMAGE)
	pass
	 # Replace with function body.


func showFirstGuild():
	control.show()
	control._show_button_5_yellow(0)
	
	#$"陈群".hide()
	pass




func visitDrill():
	if GameManager.sav.day==4:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"tip_scholar")
	else:
		SceneManager.changeScene(SceneManager.roomNode.DRILL_GROUND,2)
	

func visitScholar():
	#PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeInAndOut)
	PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeIn)
	
	await 0.5
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"大儒辩经的剧情")
	#SceneManager.changeScene(SceneManager.roomNode.DRILL_GROUND,2)
	
	
func showbianji():
	PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeOut)
	scholar.visible=true
	
func bianjiEnd():
	control._show_button_5_yellow(1)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


