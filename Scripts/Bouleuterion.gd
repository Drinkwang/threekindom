extends baseComponent

@onready var faction = $CanvasBook/faction
@onready var control =$CanvasBook/Control
@onready var yishimianban = $CanvasBook/yishimianban

const FancyFade = preload("res://addons/transitions/FancyFade.gd")
@onready var mizhu = $"糜竺"
@onready var chendeng = $"陈登"

#议事详细
@onready var parliamentary_detail = $CanvasBook/parliamentaryDetail

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
	#if GameManager.have_event["firstBoleuterion"]==true:
	control._processList(initData)
	if GameManager.day==4:
		if GameManager.have_event["firstNewEnd"]==true:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"新手教程结束_阴谋论")
			return
	elif GameManager.day==2:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
	
var costhp=50

func _buttonListClick(item):
	if item.context == "开始议事":
		if(GameManager.have_event["firstgovermentTip"]==false):
			GameManager.have_event["firstgovermentTip"]=true
			if(await GameManager.isTried(costhp)):
				return
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"开始议事")
	elif item.context == "议事说明":
		yishimianban.show()
		#显示接下来要点击啥
		pass
	elif item.context == "离开":
		if(GameManager.have_event["firstParliamentary"]==true):
			const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
			FancyFade.new().custom_fade(SceneManager.STREET.instantiate(), 2, DISSOLVE_IMAGE)
		else:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"不能离开")
		#显示金钱 民心 xx 武将面板
	print(item)
	pass



func showGuild():
	$CanvasBook/Node2D.show()
	$"CanvasBook/Node2D/5Yellow/AnimationPlayer".play("YELLOWGUILD")
	
func meetingEnd():
	control._show_button_5_yellow(2)

func hideGuild():
	$CanvasBook/Node2D.hide()


func showResult():
	if await GameManager.isTried(costhp):
		return 
	GameManager.hp=GameManager.hp-costhp
	parliamentary_detail.show()
	parliamentary_detail.enter()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func ymlShow():
	mizhu.show()
	chendeng.show()
	pass
	
	
func ymlShowEnd():
	GameManager.restLabel="没过多久，刘备也收到了来自徐州的密信"
	GameManager._rest()
	pass
