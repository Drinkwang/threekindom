extends baseComponent

@onready var control= $Control2
@onready var oldsoildereat = $CanvasInventory/oldsoildereat
@onready var train_panel = $CanvasInventory/trainPanel
@onready var battle_pane:battlePanel = $CanvasInventory/battlePane

# Called when the node enters the scene tree for the first time.
func _ready():
	Transitions.post_transition.connect(post_transition)
	control.buttonClick.connect(_buttonListClick)
	super._ready()

func post_transition():
	print("fadedone")
	_initData()


func enterOldSoilderEat():
	oldsoildereat.show()
	
	pass
	
	
	
var battleNum=0

func _initData():
	GameManager.currenceScene=self
	if(GameManager.sav.day==1):
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
	elif GameManager.sav.day==3:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"初次派遣")

	var initData=[
	{	
		"id":"1",
		"context":"离开此地", #前往小道通向议事厅 
		"visible":"true"
	},
	{
		"id":"2",
		"context":"操练士兵", #前往花园并通向小道
		"visible":"true"
	},
	{
		"id":"3",
		"context":"军事行动",#前往大街
		"visible":"false"
	},

	]
	
	if(GameManager.sav.day>=3):
		initData[2].visible="true"
	control._processList(initData)



func _buttonListClick(item):
	if item.context=="离开此地":
		if(GameManager.sav.day==1):
			if GameManager.sav.isLevelUp==false:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"训练还没有结束")
				return
		if(GameManager.sav.day==3):
			if GameManager.hp>10:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"三场战斗还没有结束")
				return 
		SceneManager.changeScene(SceneManager.roomNode.STREET,2)#判断条件
		#pass
	elif item.context=="操练士兵":
		train_panel.show()
		pass
	elif item.context=="军事行动":
		#第一次军事行动应该告诉你教程
		if GameManager.sav.day==3:
			if GameManager.sav.have_event["firstBattleTutorial"]==false:
				GameManager.sav.have_event["firstBattleTutorial"]=true
				DialogueManager.show_dialogue_balloon(dialogue_resource,"第一次军事行动教程")
		battle_pane.show()
		#暂时不能发动军事行动


	pass

#练兵结束调用这个 初次练兵

func trainBegin():
	control._show_button_5_yellow(1)	
	pass
	
func endtrain():
	control._show_button_5_yellow(0)
	pass	

@onready var point = $CanvasInventory/point

func showtutorial(num):

	if(num<8):
		battle_pane["guild_"+str(num)].show()
	if(num>=2 and num<=8):
		battle_pane["guild_"+str(num-1)].hide()
		#battle_pane["guild_"+str(num)].Get# AnimationPlayer".play("YELLOWGUILD")

	if num==8:
		point.show()
	elif num==9:
		point.hide()
		battle_pane.point_group.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
