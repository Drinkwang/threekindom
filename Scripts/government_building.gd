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

	print("fadedone")
	_initData()




func _initGroup(group):
	if group==2:
		pass
	pass
@onready var bg = $"内屋2"
const newBuild = preload("res://Asset/城镇建筑/宅邸亮.png")
const xiaopeiBuild = preload("res://Asset/城镇建筑/小沛亮.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	if GameManager.sav.day>=5 or GameManager.sav.have_event["initXuzhou"]==true:
		bg.texture=newBuild
	else:
		bg.texture=xiaopeiBuild
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
	elif GameManager.sav.day==5:
		if	GameManager.sav.have_event["initXuzhou"]==false:
			GameManager.sav.have_event["initXuzhou"]==true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"府邸第一天")
			#mizhu.show()
	elif GameManager.sav.day>5:
		if GameManager.sav.have_event["chaosEnd"]==true:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"告知曹操信件") #征讨袁术开始*/	
	GameManager.currenceScene=self
	policy_panel.initControls()
#	if GameManager.sav.day>=1:
	
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
		
	_JudgeTask()
	#elif GameManager.sav.day==4:
	#	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"府邸第一天")
#
var costHp_SummonOne=50
var costHp_policy=35
func _buttonListClick(item):
	#35点
	if item.context == "执行政策":
		policy_panel.initControls()
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
		elif GameManager.sav.day==5:
			if(GameManager.sav.have_event["initTask1"]==false):
				#pass 跳转到下一个政策
				policy_panel.show()
				
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"主线第一次指定政策")
		else:
			policy_panel.show()
			#执行到第二个决策点
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
		if GameManager.sav.day<4:
			if(GameManager.sav.have_event["firstLawExecute"]==true||GameManager.sav.have_event["firstMeetingEnd"]==true):
				exit()
			else:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"不能离开")
		else:
			if(GameManager.sav.have_event["initTask1"]==false):
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"未完成前离开")
			else:
				if(GameManager.sav.have_event["initTaskPolicy"]==false):
					GameManager.sav.have_event["initTaskPolicy"]=true
					DialogueManager.show_example_dialogue_balloon(dialogue_resource,"完成第一次政务离开")
				else:
				
				#先提示对话 然后
					exit()	
				pass
		#我必须接受陈登和糜竺的建议 在施政面板做出决策前不能离开这里
		#显示金钱 民心 xx 武将面板
	print(item)
	pass

func showFirstMission():
	GameManager.sav.targetValue=200
	GameManager.sav.targetResType=GameManager.ResType.coin
	GameManager.sav.targetTxt="当前凑集资金：{currence}/{target}"
	GameManager.sav.TargetDestination="府邸"
func exit():
	const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
	FancyFade.new().custom_fade(SceneManager.STREET.instantiate(), 2, DISSOLVE_IMAGE)

const BENTUPAI = preload("res://Asset/tres/bentupai.tres")
const HAOZUPAI = preload("res://Asset/tres/haozupai.tres")
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
		policy_panel.bancontrol(1,policy_panel.itemStatus.ban)
		
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"xxx")
		HAOZUPAI.ChangeSupport(10)
		BENTUPAI.ChangeSupport(-10)
		GameManager.changePeopleSupport(-10)
		GameManager.sav.coin=GameManager.sav.coin+50
		GameManager.sav.have_event["initTask1"]=true
		#商业促进
	elif id== policymanager.policyID.P_SUPPLIES_SELF_SUFFIENCY:
		policy_panel.bancontrol(2,policy_panel.itemStatus.ban)
		#GameManager.sav.targetResType=GameManager.ResType.coin
		#GameManager.sav.targetValue=100
		GameManager.sav.have_event["initTask1"]=true
		HAOZUPAI.ChangeSupport(-5)
		GameManager.changePeopleSupport(5)
		#@export var  coin=100 #金钱 数值
		#@export var coin_DayGet=20
		#labor_DayGet
		# people_surrport-10
		#GameManager.sav.targetTxt="当前凑集资金：{currence}/{target}"
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"xxx")
		#军粮自给，维持现状
	elif id== policymanager.policyID.P_RAISE_TAX:
		policy_panel.bancontrol(3,policy_panel.itemStatus.ban)
		#GameManager.sav.targetResType=GameManager.ResType.coin
		#GameManager.sav.targetValue=200
		#GameManager.sav.targetTxt="当前凑集资金：{currence}/{target}"
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"xxx")
		HAOZUPAI.ChangeSupport(10)
		BENTUPAI.ChangeSupport(-20)
		GameManager.changePeopleSupport(-20)
		GameManager.sav.coin_DayGet=GameManager.sav.coin_DayGet+10
		GameManager.sav.have_event["initTask1"]=true
		#提升关税
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
	

func cancel():
	pass	

func mizhuHide():
	mizhu.hide()

func chendenHide():
	chenden.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _JudgeTask():
	var value=0
	if GameManager.sav.targetResType==GameManager.ResType.coin:
		value=GameManager.sav.coin
	elif GameManager.sav.targetResType==GameManager.ResType.people:
		pass
		#value	
	
	if value>=GameManager.sav.targetValue:
		if(GameManager.sav.have_event["completeTask1"]==false):
			GameManager.sav.have_event["completeTask1"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"收集资金任务完成")#显示对话
			#任务完成
		elif(true):
			pass
		if(GameManager.sav.have_event["completeTask2"]==true):
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"打跑黄巾军")#显示对话
func collectMoneyComplete():
	mizhu.show()
	chenden.show()
	mizhu.dialogue_start="与糜竺对话2"
	chenden.dialogue_start="与陈登对话2"

func chaosBegin():
	GameManager.sav.have_event["chaosBegin"]=true
	mizhu.show()
	chenden.show()
	mizhu.dialogue_start="混乱与糜竺对话"
	chenden.dialogue_start="混乱与陈登对话"
	pass
	
func chaosMizhuEnd():
	#糜竺会显示曹操的信
	GameManager.sav.have_event["chaoMizhuEnd"]=true
	mizhu.hide()
	if GameManager.sav.have_event["chaoChendengEnd"]==true:
		chaosDialogEnd()
	
func chaosChendengEnd():
	GameManager.sav.have_event["chaoChendengEnd"]=true
	chenden.hide()	
	if GameManager.sav.have_event["chaoMizhuEnd"]==true:
		chaosDialogEnd()
func chaosDialogEnd():
	#
	#可以离开，但是会有提示如何做
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"混乱对话结束")#显示对话
	GameManager.sav.have_event["chaoDialogEnd"]=true
func chaosTaskBegin():
	#显示任务，并显示任务 需要几天可以完成
	GameManager.sav.targetValue=10
	GameManager.sav.currenceValue=0
	GameManager.sav.targetResType=GameManager.ResType.rest
	GameManager.sav.targetTxt="当前过去的天数：{currence}/{target}"
	GameManager.sav.TargetDestination="rest"
@onready var disater_panel = $CanvasLayer/disaterPanel

func confireAllocation():
	disater_panel.confireAllocation()


func cancelAllocation():
	disater_panel.cancelAllocation()

func afterAllocation():
	disater_panel.afterAllocation()
#const BENTUPAI = preload("res://Asset/tres/bentupai.tres")
#const HAOZUPAI = preload("res://Asset/tres/haozupai.tres")
const WAIDIPAI = preload("res://Asset/tres/waidipai.tres")
func FractionalDiff():
	HAOZUPAI.isshow=true
	BENTUPAI._name="士族派(本土)"
	#存档
	#派系分化成2个
func ShowDisterPanel():
	disater_panel.show()
	pass

func StartYuanshu():
	if GameManager.sav.have_event["battleYuanshu"]==false:
		GameManager.sav.have_event["battleYuanshu"]=true
	GameManager.sav.targetValue=30
	GameManager.sav.currenceValue=0
	GameManager.sav.targetResType=GameManager.ResType.battle
	GameManager.sav.targetTxt="当前讨伐对象：{currence}/{target}"
	GameManager.sav.TargetDestination="battle"
	#显示军事行动还有30把
	pass
	#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"混乱对话结束")#显示对话
