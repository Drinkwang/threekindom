extends baseComponent

@onready var control= $Control2
@onready var oldsoildereat = $CanvasInventory/oldsoildereat
@onready var train_panel = $CanvasInventory/trainPanel
@onready var battle_pane:battlePanel = $CanvasInventory/battlePane

# Called when the node enters the scene tree for the first time.
func _ready():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)

	Transitions.post_transition.connect(post_transition)
	control.buttonClick.connect(_buttonListClick)
	super._ready()

func post_transition():
	print("fadedone")
	_initData()

func enterOldSoilderEat():
	oldsoildereat.show()
	pass
	
func _initData():
	GameManager.currenceScene=self

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
		"visible":"true"
	},

	]
	control._processList(initData)



func _buttonListClick(item):
	if item.context=="离开此地":
		#判断条件
		pass
	elif item.context=="操练士兵":
		train_panel.show()
		pass
	elif item.context=="军事行动":
		battle_pane.show()
		#暂时不能发动军事行动
		pass

	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
