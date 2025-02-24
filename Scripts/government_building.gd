extends baseComponent


@onready var control = $Control
const FancyFade = preload("res://addons/transitions/FancyFade.gd")
@onready var policyBook = $"政府文书"
@onready var policy_panel = $CanvasLayer/policyPanel
@onready var rule_book = $CanvasLayer/ruleBook




var waidipai=cldata.factionIndex.weidipai
var bentupai=cldata.factionIndex.bentupai
var haozupai=cldata.factionIndex.haozupai
var lvbu=cldata.factionIndex.lvbu
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
			GameManager.sav.have_event["initXuzhou"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"府邸第一天")
			#mizhu.show()
	elif GameManager.sav.day>5:
		if GameManager.sav.have_event["chaosEnd"]==true and GameManager.sav.have_event["泰山诸将曹操消息"]==false:
				GameManager.sav.have_event["泰山诸将曹操消息"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"告知曹操信件") #征讨袁术开始*/	
		elif GameManager.sav.have_event["findLvbu"]==true and GameManager.sav.have_event["discussLvbu"]==false:
				GameManager.sav.have_event["discussLvbu"]=true
				#此处需要跟曹豹将军沟通
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"商讨吕布是否留下") #征讨袁术开始*/	
		elif  GameManager.sav.have_event["lvbuDiscussInCaoBao"]==true and GameManager.sav.have_event["lvBuFinalDiscuss"]==false:
				GameManager.sav.have_event["lvBuFinalDiscuss"]=true
				#此处需要跟曹豹将军沟通
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第二次商讨吕布是否留下") #征讨袁术开始*/	
		elif GameManager.sav.have_event["lvbuJoin"]==true and GameManager.sav.have_event["canSummonLvbu"]==false:
			if GameManager.sav.currenceDay>=1:
				GameManager.sav.have_event["canSummonLvbu"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"可召见吕布")
		elif GameManager.sav.have_event["completebattleTaiShan"]==true and GameManager.sav.have_event["庆功宴是否举办"]==false:
			GameManager.sav.have_event["庆功宴是否举办"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"徐州得安")
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
		
	if GameManager.sav.have_event["firstTabLaw"]==true or GameManager.sav.day>=5:
		policy_panel.tab_bar.show()
	else:
		policy_panel.tab_bar.hide()
	policy_panel._initData()

	if GameManager.sav.day==2:
		control._show_button_5_yellow(1)
		

	if(GameManager.sav.targetTxt!=null and GameManager.sav.targetTxt.length()>0):		
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
				GameManager.sav.have_event["initTask1"]=true
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
			optionSummonOnemen()
			#if(GameManager.sav.day<5):
			#判断显示召见手下1 还是召见手下2 还是召见手下3
			#	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"召见手下1")
			#elif GameManager.sav.day>=5:
			#	if GameManager.sav.have_event["lvbuJoin"]==true:
			#		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"召见手下4")
			#	elif GameManager.sav.have_event["lvbuJoin"]==false and GameManager.sav.have_event["Factionalization"]==true:
			#		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"召见手下3")
			#	else:	
			#		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"召见手下2")
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
				elif GameManager.sav.have_event["chaosBegin"]==true and GameManager.sav.have_event["chaoDialogEnd"]==false:
					DialogueManager.show_example_dialogue_balloon(dialogue_resource,"城中混乱状况")
				else:	
				#先提示对话 然后
					exit()	
				pass
		#我必须接受陈登和糜竺的建议 在施政面板做出决策前不能离开这里
		#显示金钱 民心 xx 武将面板
	print(item)
	pass
func victoryPartyEnd():
	GameManager.sav.have_event["战斗袁术开始"]=true
	GameManager.sav.targetValue=15
	GameManager.sav.currenceValue=0
	GameManager.sav.targetResType=GameManager.ResType.battle
	GameManager.sav.targetTxt="当前讨伐对象：{currence}/{target}"
	GameManager.sav.TargetDestination="battle"



func optionSummonOnemen():
	if(GameManager.sav.day<5):
		#判断显示召见手下1 还是召见手下2 还是召见手下3
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"召见手下1")
	elif GameManager.sav.day>=5:	
		if GameManager.sav.have_event["lvbuJoin"]==true:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"召见手下4")
		elif GameManager.sav.have_event["lvbuJoin"]==false and GameManager.sav.have_event["Factionalization"]==true:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"召见手下3")
		else:	
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"召见手下2")	

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
		hidePolicy()
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"以商代赈")
		HAOZUPAI.ChangeSupport(10)
		BENTUPAI.ChangeSupport(-10)
		GameManager.changePeopleSupport(-10)
		GameManager.sav.coin=GameManager.sav.coin+50
		GameManager.sav.have_event["initTask1"]=true
		#商业促进
	elif id== policymanager.policyID.P_SUPPLIES_SELF_SUFFIENCY:
		policy_panel.bancontrol(2,policy_panel.itemStatus.ban)
		hidePolicy()
		GameManager.sav.have_event["initTask1"]=true
		HAOZUPAI.ChangeSupport(-5)
		GameManager.changePeopleSupport(5)
		#@export var  coin=100 #金钱 数值
		#@export var coin_DayGet=20
		#labor_DayGet
		# people_surrport-10
		#GameManager.sav.targetTxt="当前凑集资金：{currence}/{target}"
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"军粮自给")
		#军粮自给，维持现状
	elif id== policymanager.policyID.P_RAISE_TAX:
		policy_panel.bancontrol(3,policy_panel.itemStatus.ban)
		hidePolicy()
		#GameManager.sav.targetResType=GameManager.ResType.coin
		#GameManager.sav.targetValue=200
		#GameManager.sav.targetTxt="当前凑集资金：{currence}/{target}"
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"增加税率")
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
	var value=GameManager.getTaskCurrenceValue()
	#if GameManager.sav.targetResType==GameManager.ResType.coin:
	#	value=GameManager.sav.coin
	#elif GameManager.sav.targetResType==GameManager.ResType.people:
	#	pass
	#判断地点	
	
	if value>=GameManager.sav.targetValue:
		if(GameManager.sav.have_event["completeTask1"]==false):
			#ameManager.clearTask()
			GameManager.sav.have_event["completeTask1"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"收集资金任务完成")#显示对话
			#任务完成
		elif(true):
			pass
		#任务完成交付任务
		if GameManager.sav.TargetDestination.length()>0:

			deliverTask()
	#判断task 完成 所到地点

			
func deliverTask():
	if GameManager.sav.TargetDestination=="府邸":
		#任务2完成 来这边兑现奖励
		#把交付任务完成
		#任务清空
		if GameManager.sav.have_event["deliverTask2"]==false:
			if(GameManager.sav.have_event["completeTask2"]==true):
				GameManager.sav.have_event["deliverTask2"]=true
				GameManager.clearTask()
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"打跑黄巾军")#显示对话
		elif  GameManager.sav.have_event["deliverYuanShu"]==false:
			if(GameManager.sav.have_event["completebattleTaiShan"]==true):
				GameManager.sav.have_event["deliverYuanShu"]=true
				GameManager.clearTask()
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"打跑袁术")#显示对话
		
		if GameManager.sav.have_event["battleTaiShan"]==true:
			if(GameManager.sav.have_event["completebattleTaiShan"]==false):	
				if GameManager.sav.currenceDay>=2:
					GameManager.sav.currenceDay=0
					if GameManager.sav.have_event["firstDisaster"]==false:
						GameManager.sav.have_event["firstDisaster"]=true
						DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第一次赈灾开始")#显示对话
	#第一次赈灾启动 还没设定
					elif GameManager.sav.have_event["secondDisaster"]==false:	
						GameManager.sav.have_event["secondDisaster"]=true
						DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第二次分配粮食")#显示对话
						#第二次赈灾开始
					elif GameManager.sav.have_event["thirdDisaster"]==false:
						DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第三次分配粮食")#显示对话			
						GameManager.sav.have_event["thirdDisaster"]=true
						#第三次赈灾开始	
			
@onready var hp_panel = $CanvasLayer/hpPanel
			
func collectMoneyComplete():
	GameManager.sav.TargetDestination="rest"	
	mizhu.show()
	chenden.show()
	mizhu.dialogue_start="与糜竺对话2"
	chenden.dialogue_start="与陈登对话2"
	#ameManager.sav.targetResType=GameManager.ResType.rest
	hp_panel.playLabelChange()
	

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
	GameManager.sav.have_event["Factionalization"]=true
	#存档
	#派系分化成2个
func ShowDisterPanel():
	disater_panel.show()
	pass

func StartTaishan():
	if GameManager.sav.have_event["battleTaiShan"]==false:
		GameManager.sav.have_event["battleTaiShan"]=true
	GameManager.sav.targetValue=12
	GameManager.sav.currenceValue=0
	GameManager.sav.targetResType=GameManager.ResType.battle
	GameManager.sav.targetTxt="当前讨伐对象：{currence}/{target}"
	GameManager.sav.TargetDestination="battle"
	#显示军事行动还有30把
	pass
	

var _faction:cldata.factionIndex=cldata.factionIndex.bentupai	
func SummonFaction(value:cldata.factionIndex):
	_faction=value
	if(value==cldata.factionIndex.weidipai):
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"选项")#显示对话
			
	elif value==cldata.factionIndex.bentupai:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"选项")#显示对话
	
	elif value==cldata.factionIndex.haozupai:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"选项")#显示对话
	
	elif value==cldata.factionIndex.lvbu:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"选项吕布")#显示对话
	
	
#如果总人数达到100 则无法资助	
func financialConfortChoice():
	if GameManager.sav.coin>=200:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"消耗资金")#显示对话
	else:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"资金不足安抚")#显示对话
	
#选项资金安抚
func financialConfort():
	var _c=getFactionByIndex()
	var rindex=GameManager.sav.randomIndex
	#减去资金
	GameManager.sav.coin=GameManager.sav.coin-200
	_c.ChangeAllPeople(3+rindex)

func getFactionByIndex()->cldata:
	
	var _confortV
	if _faction==cldata.factionIndex.bentupai:
		_confortV=BENTUPAI
	elif _faction==cldata.factionIndex.weidipai:
		_confortV=WAIDIPAI
	elif _faction==cldata.factionIndex.haozupai:
		_confortV=HAOZUPAI
		
		
	return _confortV
	
#选项赠送礼物
func sendgift():
	var _c=getFactionByIndex()
	var rindex=GameManager.sav.randomIndex
	#减去资金
	#GameManager.
	_c.ChangeSupport(15+rindex)
@onready var send_gift_panel = $sendGiftPanel
	
func sendgiftChoice():
	var rindex=GameManager.sav.randomIndex
	var _c=getFactionByIndex()
	#减去资金
	#GameManager.
	#赠送礼物可能会改成10点好感度了  好感度改变 是否摇摆派系也会改变
	#_c.ChangeSupport(15+rindex)
	var to_inventory= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.珍品礼盒)
	var _inventoryManager = get_tree().get_root().get_node("InventoryManager")
	var quantity=_inventoryManager.has_item_quantity(to_inventory)
	if quantity>=1:#拥有礼物
		send_gift_panel.show()
		send_gift_panel._initPanel(_c._name,quantity,int(15+rindex))
		#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"消耗资金")#显示对话
	else:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"你没有礼物")#显示对话
var lawName	
#选项政策拉拢 #政策拉拢后 摇摆派系全部变成支持派系 25 50 75 100
func policyCo_opt():
	#按照徐州派要求，你得在 法律法规中通过【民田开垦】这条法律，如果通过 你将提升好感度，并且使该派系摇摆人数下降
	#获取一个即将要的政策，是否通过议会厅 通过好感度上升，没通过好感度下降
	#当玩家选择法律通过时，才会那啥
	if GameManager.getCDByFaction(_faction) <1:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"当前还在cd中")
		return
	#显示对话
	
	#var index= int(_faction)  #可能需要一个转换函数进行转换
	var lawIndex= GameManager.enablePolicyCooptCD(_faction)		
	var maxLaw=GameManager.sav.laws[lawIndex].max()

	
	#需要将法律法规+1或者+2
	# 有一堆bug 需要修改，到时候需要判断最大值，最大值后面2个有无元素，如果没有 从余下政策，如果余下政策没有再提示已经满格了
	var unUseArr=[]
	
	var maxSize=0
	if(maxLaw>=8):
		#你的政策槽已满，无法添加新的拉拢政策。
		maxSize=9
		#你当前所有法律已经设置满格了，无法提供额外的法律去拉拢派系
	else:
		maxSize=maxLaw+2
	#+1 or +2
	for i in range(1,maxSize):
		if GameManager.sav.laws[lawIndex].has(i)==false:
			unUseArr.append(i)
		pass
	if unUseArr.size()>0:
		
		var pick= randi_range(0,unUseArr.size())
		var policyIndex=unUseArr[pick]
		lawName=policy_panel.getPolicyName(lawIndex,policyIndex) #12
		GameManager.sav.laws[lawIndex].append(-policyIndex)
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"政策拉拢")#显示对话	
	
	else:
			
		#你的政策槽已满，无法添加新的拉拢政策。
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"法律已经满格了")#显示对话			
		return
		#你当前所有法律已经设置满格了，无法提供额外的法律去拉拢派系





#	var _c=getFactionByIndex()
#	var rindex=GameManager.sav.randomIndex

#	_c.ChangeSupport(15+rindex)
	



	
var ForValueCost=0
var ForValueGet=0

#你通过索取可以获得500金，但会消耗徐州派30点忠诚度，请问是否执行
#索取可获500金，但将消耗徐州派30点忠诚度。是否执行？
func claim():
	var _c=getFactionByIndex()
	var rindex=GameManager.sav.randomIndex
	ForValueCost=10+5*rindex
	ForValueGet=_c._num_all*20
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"索取从派系")#显示对话

func CF_CallingSoldier():
	var _c=getFactionByIndex()
	_c.ChangeSupport(-ForValueCost)
	GameManager.sav.labor_force=GameManager.sav.labor_force+ForValueGet
	
func CF_claim():

	var _c=getFactionByIndex()
	_c.ChangeSupport(-ForValueCost)
	#减去资金
	GameManager.sav.coin=GameManager.sav.coin+ForValueGet
	


#调用可征集500名吕布士兵，但将消耗20点吕布忠诚度。是否执行？
func CallingSoldier():
	
	var _c=getFactionByIndex()
	var rindex=GameManager.sav.randomIndex
	ForValueCost=10+5*rindex
	ForValueGet=_c._num_all*100
	
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"征兵从吕布")	

	#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"混乱对话结束")#显示对话
func lvbuJoin():
	GameManager.sav.have_event["lvbuJoin"]=true
	GameManager.sav.labor_force=GameManager.sav.labor_force+1000
	
	#1
	GameManager.sav.targetValue=3
	GameManager.sav.currenceValue=0
	GameManager.sav.currenceDay=0
	GameManager.sav.targetResType=GameManager.ResType.battle
	GameManager.sav.targetTxt="当前讨伐对象：{currence}/{target}"
	GameManager.sav.TargetDestination="battle"
