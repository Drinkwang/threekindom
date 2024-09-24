extends baseComponent


@onready var control =$CanvasBook/Control
@onready var yishimianban = $CanvasBook/yishimianban

const FancyFade = preload("res://addons/transitions/FancyFade.gd")

@onready var mizhu = $"CanvasBook/糜竺"
@onready var chendeng = $"CanvasBook/陈登"
#@onready var context = $PanelContainer/MarginContainer/VBoxContainer/context

#议事详细
@onready var parliamentary_detail = $CanvasBook/parliamentaryDetail

	#var initData=[
	#{	
	#	"name":"xxx",
	#	"context":"执行政策", #前往小道通向议事厅 
	#	"img":"true"
	#},

@onready var faction = $CanvasBook/faction

#将这个页面的操作面板显示并存档
#dontwork
func implementpolicy():
	GameManager.sav.have_event["firstPolicyOpShow"]=true
	_initData()
	pass
	
#将施政面板显示并存档
func showTab():
	GameManager.sav.have_event["firstTabLaw"]=true
	_initData()
const bgmmeet = preload("res://Asset/bgm/会议室.wav")	
#const 议会2 = preload("res://Asset/bgm/议会2.mp3")
func post_transition():
	SoundManager.play_music(bgmmeet)
	print("fadedone")
	_initData()


# Called when the node enters the scene tree for the first time.
func _ready():

	Transitions.post_transition.connect(post_transition)
	control.buttonClick.connect(_buttonListClick)
	
	if GameManager.sav.day==4:
		ymlShow()
	super._ready()
	changeLanguage()
	#initData()
		
		
		
		
	pass # Replace with function body.
func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()	
	if currencelanguage=="en":
		pass
	elif currencelanguage=="zh":
		pass
	elif currencelanguage=="ru":
		faction.position=Vector2(5,728.545)
		pass

#@onready var faction = $CanvasBook/faction

func _initFaction():
	pass

func _initData():
	#if	GameManager.sav.have_event["firstgovernment"]==false:
		#DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
		#GameManager.sav.have_event["firstgovernment"]=true
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
	#if GameManager.sav.have_event["firstBoleuterion"]==true:
	
	if GameManager.sav.day==4:
		if GameManager.sav.have_event["firstNewEnd"]==true:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"新手教程结束_阴谋论")
			return
	elif GameManager.sav.day==2:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
	control._processList(initData)
var costhp=50

func _buttonListClick(item):
	if item.context == "开始议事":
		if(await GameManager.isTried(costhp)):
			return
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"开始议事")
	elif item.context == "议事说明":
		yishimianban.show()
		#显示接下来要点击啥
		pass
	elif item.context == "离开":
		if(GameManager.sav.have_event["firstParliamentary"]==true):
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
	GameManager.sav.destination="自宅"

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
	
	
const _chendenhecha = preload("res://Asset/人物/陈登睁眼.png")
const _chendenhechaOpen = preload("res://Asset/人物/陈登睁眼喝茶.png")
const _chendenOpen = preload("res://Asset/人物/陈登闭喝茶.png")

func chendenhecha():
	chendeng.img=_chendenhecha


func chendenhechaOpen():
	chendeng.img=_chendenhechaOpen


func chendenOpen():
	chendeng.img=_chendenOpen


const _mizhuCLOSE = preload("res://Asset/人物/糜竺眨眼.png")
const _mizhuOpen = preload("res://Asset/人物/糜竺睁眼.png")
const _mizhuxiao = preload("res://Asset/人物/糜竺笑.png")
func mizhuClose():
	mizhu.img=_mizhuCLOSE

func mizhuOpen():
	mizhu.img=_mizhuOpen
	

func mizhuxiao():
	mizhu.img=_mizhuxiao

func ymlShow():
	mizhu.show()
	chendeng.show()
	pass
	
	
func ymlShowEnd():
	GameManager.restLabel=tr("没过多久，刘备也收到了来自徐州的密信")
	GameManager.restFadeScene=null
	GameManager._rest()
	pass


