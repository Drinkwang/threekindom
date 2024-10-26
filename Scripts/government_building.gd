extends baseComponent


@onready var control = $Control
const FancyFade = preload("res://addons/transitions/FancyFade.gd")
@onready var policyBook = $"政府文书"
@onready var policy_panel = $CanvasLayer/policyPanel
@onready var rule_book = $CanvasLayer/ruleBook

	#var initData=[
	#{	
	#	"name":"xxx",
	#	"context":"执行政策", #前往小道通向议事厅 
	#	"img":"true"
	#},

func showwrit():
	policyBook.show()
	control._show_button_5_yellow(-1)
	#pass
const fanyuesound = preload("res://Asset/sound/翻阅.mp3")
func lookDown():
	SoundManager.play_sound(fanyuesound)
	policyBook.hide()
	pass

#将这个页面的操作面板显示并存档
#dontwork
func implementpolicy():
	GameManager.sav.have_event["firstPolicyOpShow"]=true
	#
	_initData()
	control._show_button_5_yellow(0)
	pass
	
#将施政面板显示并存档
func showTab():
	GameManager.sav.have_event["firstTabLaw"]=true
	control._show_button_5_yellow(-1)
	_initData()
const 府邸 = preload("res://Asset/bgm/办公.wav")	
#const 府邸 = preload("res://Asset/bgm/府邸.mp3")
func post_transition():
	SoundManager.play_music(府邸)
	policy_panel.initControls()
	print("fadedone")
	_initData()




func _initGroup(group):
	if group==2:
		pass
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	#DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)

	Transitions.post_transition.connect(post_transition)
	control.buttonClick.connect(_buttonListClick)
	super._ready()
	#initData()
		
	pass # Replace with function body.

func _initData():
	if GameManager.sav.day==1:
		if	GameManager.sav.have_event["firstgovernment"]==false:
			#control._show_button_5_yellow(1)
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
			GameManager.sav.have_event["firstgovernment"]=true
	#elif GameManager.day==2:
	
	GameManager.currenceScene=self
	var initData=[
	{	
		"id":"1",
		"context":"执行政策", #前往小道通向议事厅 
		"visible":"true"
	},
	{
		"id":"2",
		"context":"召见手下", #前往花园并通向小道
		"visible":"false"
	},
	{
		"id":"3",
		"context":"离开",#前往大街
		"visible":"true"
	},

	]

	if(GameManager.sav.day>=2):
		initData[1].visible="true"
	
	if GameManager.sav.have_event["firstPolicyOpShow"]==true||GameManager.sav.day>1:
		control._processList(initData)
		
	if GameManager.sav.have_event["firstTabLaw"]==true:
		policy_panel.tab_bar.show()
	else:
		policy_panel.tab_bar.hide()
	policy_panel._initData()

	if GameManager.sav.day==2:
		control._show_button_5_yellow(1)
#
var costHp_SummonOne=50
var costHp_policy=35
func _buttonListClick(item):
	#35点
	if item.context == "执行政策":
		#if await GameManager.isTried(costHp_policy):
		#	return 
		#GameManager.hp=GameManager.hp-costHp_policy
		if(GameManager.sav.day==1):
			policy_panel.show()
			if(GameManager.sav.have_event["firstgovermentTip"]==false):
				GameManager.sav.have_event["firstgovermentTip"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"enterpolicy")
		elif(GameManager.sav.day==2):
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第二天的提示")
		else:
			policy_panel.show()
			#后续逻辑，但
			pass			
	#50点	
	elif item.context == "召见手下":
		if await GameManager.isTried(costHp_SummonOne):
			return
		#GameManager.hp=GameManager.hp-costHp_SummonOne
		if GameManager.sav.isMeet==false:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"召见手下1")
		#显示接下来要点击啥
		else:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"已经召见手下")
		pass
	elif item.context == "离开":
		if(GameManager.sav.have_event["firstLawExecute"]==true||GameManager.sav.have_event["firstMeetingEnd"]==true):
			const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
			FancyFade.new().custom_fade(SceneManager.STREET.instantiate(), 2, DISSOLVE_IMAGE)
		else:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"不能离开")
		#显示金钱 民心 xx 武将面板
	print(item)
	pass

func selectPolicy(data):
	var id=data.id
	if id==1:
		#额外buff填写
		selectCorrect()
	elif id==2:	
		#额外buff填写
		selectCorrect()
	elif id==3:
		policy_panel.bancontrol(3,policy_panel.itemStatus.ban)
		
		#执行初始错误决策，体力回复
		GameManager.hp=GameManager.hp+35
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"错误决策0")
		#pass
	elif id==policymanager.policyID.P_COMMERCIAL_INPLACE_AID:
		GameManager.sav.targetValue=500
		GameManager.sav.targetResType=GameManager.ResType.coin
		GameManager.sav.targetTxt="当前凑集资金：{currence}/{target}"
		pass
	elif id== policymanager.policyID.P_SUPPLIES_SELF_SUFFIENCY:
		GameManager.sav.targetResType=GameManager.ResType.coin
		GameManager.sav.targetValue=400
		GameManager.sav.targetTxt="当前凑集资金：{currence}/{target}"
	elif id== policymanager.policyID.P_RAISE_TAX:
		GameManager.sav.targetResType=GameManager.ResType.coin
		GameManager.sav.targetValue=550
		GameManager.sav.targetTxt="当前凑集资金：{currence}/{target}"
		#GameManager._engerge.ref
func selectCorrect():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"正确决策0")
	hidePolicy()

func selectCorrectBefore():
	if GameManager.sav.have_event["firstPolicyCorrect"]==false:
		GameManager.sav.have_event["firstPolicyCorrect"]=true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"正确决策0之后引导")
	pass

func agreelaw():
	policy_panel.agreelaw()
#@onready var button = $PanelContainer/orderPanel/VBoxContainer/HBoxContainer/Button

#做出可以做的决策后，对面板进行隐藏
func hidePolicy():
	policy_panel.button.disabled=true
	#policy_panel.button.
	policy_panel._disableAll()
	policy_panel.bancontrol(policy_panel.index,policy_panel.itemStatus.select)

func arrangeDone():
	control._show_button_5_yellow(1)
	#无操作
	pass
const EAT_2 = preload("res://Asset/sound/eat2.mp3")
func meeting():
	SoundManager.play_sound(EAT_2)
	rule_book.visible=true
	if GameManager.sav.have_event["firstMeetingEnd"]==false:
		GameManager.sav.have_event["firstMeetingEnd"]=true
		rule_book.clickEvent="宴会结束"	
	else:
		rule_book.clickEvent=""
	

func meetingEnd():
	GameManager.sav.destination="议事厅"
	GameManager.hp=GameManager.hp-costHp_SummonOne
	GameManager.sav.isMeet=true
	control._show_button_5_yellow(-1)	
@onready var mizhu = $"糜竺"
@onready var chenden = $"陈登"

func _firstPhaseBegin():
	mizhu.show()
	chenden.show()
	mizhu

func cancel():
	pass	

func mizhuHide():
	mizhu.hide()

func chendenHide():
	chenden.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



