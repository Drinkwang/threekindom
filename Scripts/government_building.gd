extends baseComponent
class_name  government_building

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
	GameManager.CanClickUI=true
	SoundManager.stop_all_ambient_sounds()
	SoundManager.play_ambient_sound(府邸)

	print("fadedone")
	if(GameManager.hearsayID==1):
		chenden.show()
		mizhu.show()
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"商人售卖利益")
		return
	elif GameManager.hearsayID==2:
		chenden.show()
		mizhu.show()
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"出现分化")

		return
	elif GameManager.hearsayID==3:
		chenden.hide()
		mizhu.show()
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"糜竺第三次市井")

		return	
	_initData()


@onready var tsty = $"陶商陶应"


func _initGroup(group):
	if group==2:
		pass
	pass

@onready var bg = $"内饰"
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
	changePanelPos()	
	
	pass # Replace with function body.
var candoSub=true
func hearSayEnd():

	if(GameManager.hearsayID==1):
		
		#const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
		SceneManager.changeScene(GameManager.hearsayBeforeNode,2)

	elif GameManager.hearsayID==2:
		SceneManager.changeScene(GameManager.hearsayBeforeNode,2)
	elif GameManager.hearsayID==3:
		GameManager.hearsayID=3
		GameManager.restLabel=tr("陈登在议事厅，灯下独思")		
		SceneManager.rest_scene(SceneManager.roomNode.BOULEUTERION)
	GameManager.hearsayID=-1


func _initData():
	candoSub=true
	if GameManager.bossmode==scenemanager.bossMode.mi and GameManager.sav.have_event["糜竺支线3"]==false:
		GameManager.sav.hp=0
		mizhu.show()
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"糜贞结尾")
		GameManager.sav.have_event["糜竺支线3"]=true
		return 
	if GameManager.sav.day==1:
		if	GameManager.sav.have_event["firstgovernment"]==false:
			#control._show_button_5_yellow(1)
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
			GameManager.sav.have_event["firstgovernment"]=true
			candoSub=false
	#elif GameManager.day==2:
	elif GameManager.sav.day==5:
		if	GameManager.sav.have_event["initXuzhou"]==false:
			GameManager.sav.have_event["initXuzhou"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"府邸第一天")
			GameManager.play_BGM()
			candoSub=false
	elif GameManager.sav.day>5:
		if GameManager.sav.have_event["chaosEnd"]==true and GameManager.sav.have_event["泰山诸将曹操消息"]==false:
				GameManager.sav.have_event["泰山诸将曹操消息"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"告知曹操信件")
				candoSub=false #征讨袁术开始*/	
		elif GameManager.sav.have_event["findLvbu"]==true and GameManager.sav.have_event["discussLvbu"]==false:
				GameManager.sav.have_event["discussLvbu"]=true
				candoSub=false#此处需要跟曹豹将军沟通
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"商讨吕布是否留下") 
				#修改任务目标为跟曹豹谈一谈 
				GameManager.sav.TargetDestination="演武场"
				#征讨袁术开始*/	
		elif  GameManager.sav.have_event["lvbuDiscussInCaoBao"]==true and GameManager.sav.have_event["lvBuFinalDiscuss"]==false:
				GameManager.sav.have_event["lvBuFinalDiscuss"]=true
				candoSub=false

				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第二次商讨吕布是否留下") #征讨袁术开始*/	
		elif GameManager.sav.have_event["lvbuJoin"]==true and GameManager.sav.have_event["canSummonLvbu"]==false:
			if GameManager.sav.currenceDay>=1:
				GameManager.sav.have_event["canSummonLvbu"]=true
				candoSub=false
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"可召见吕布")
		elif GameManager.sav.have_event["completebattleTaiShan"]==true and GameManager.sav.have_event["庆功宴是否举办"]==false:
			GameManager.sav.have_event["庆功宴是否举办"]=true
			candoSub=false
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"徐州得安")
		elif GameManager.sav.have_event["战斗袁术开始"]==true: 
			candoSub=false
			#判断任务完成 如果任务完成，那么就开始对话指令，且不能离开
			pass

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
		_JudgeTask()#这里必然进去
	#elif GameManager.sav.day==4:
	#	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"府邸第一天")
	
	

#

func mizhenGift():
	mizhu.hide()
	var _reward:rewardPanel=PanelManager.new_reward()
	var items={
		"items": {InventoryManagerItem.ItemEnum.益气丸:2},
		"money": 0,
		"population": 0
	}
	#GameManager.ScoreToItem()
	GameManager.sav.hp=GameManager.sav.hp+10
	_reward.showTitileReward(tr("恭喜你，你获得-益气丸x2"),items)		

func subHoldWoold():
	GameManager.sav.have_event["支线触发完毕查出锦囊"]=true
				
	pass
	#DialogueManlogue_balloon(dialogue_resource,"城外克苏鲁事件触发")
	#dialog
	
var costHp_SummonOne=50
var costHp_policy=35
func _buttonListClick(item):
	#35点
	if item.context == "执行政策":
		#if policy_panel.tab_bar.current_tab==0:
		policy_panel._initData()
		policy_panel.initControls()
		var group=GameManager.getPolicyGroup()
		#GameManager.currenceScene.selectPolicy(self["control_"+index].data)
		#DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"xxx")
		#判断自己的逻辑
	#应该是第二天

		if group==-1 and GameManager.sav.policyExcute==false and GameManager.sav.day>=5:
			if GameManager.sav.have_event["第一次民心政策"]==false and GameManager.sav.randomIndex<=1:
				GameManager.sav.have_event["第一次民心政策"]=true
				DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"民生政策")		
		
		
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
			if(GameManager.sav.have_event["initTask1"]==false and GameManager.sav.have_event["糜竺推荐陈登"]==true):
				#pass 跳转到下一个政策
				#GameManager.sav.have_event["initTask1"]=true
				policy_panel.show()
				
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"主线第一次指定政策")
			elif GameManager.sav.have_event["糜竺推荐陈登"]==false:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"没有对话前不能执行政策")
			else:
				policy_panel.show()
		else:
			policy_panel.show()

	#50点	
	elif item.context == "召见手下":
		if await GameManager.isTried(costHp_SummonOne):
			return

		if(GameManager.sav.have_event["initTask1"]==false and GameManager.sav.have_event["initXuzhou"]==true):
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"未完成前召见手下")
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
				#elif GameManager.sav.have_event["战斗袁术开始"]==true and GameManager.sav.TargetDestination=="你需要跟糜竺和陈登分别对话":
					
				#	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"城中混乱状况")
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




func eatTea1(issuccuss=false):
	GameManager.sav.mizhuSideWait=3
	GameManager.sav.have_event["糜竺支线1"]=true
	if issuccuss==true:
		GameManager.sav.have_event["糜竺正确选择1"]=true
	else:
		GameManager.sav.have_event["糜竺正确选择1"]=false
		#GameManager.sav.hp
func eatTea2(issuccuss=false):

	GameManager.sav.have_event["糜竺支线2"]=true


	if issuccuss==true:
		GameManager.sav.have_event["糜竺正确选择2"]=true
	else:
		GameManager.sav.have_event["糜竺正确选择2"]=false


func showMizhuTouchMain():
	mizhu.show()
	mizhu.showEX=true
	#chenden.hide()
	mizhu.dialogue_start="府邸主线"
	mizhu.dialogue_doubleclick="府邸主线"
	GameManager.changeTaskLabel("与手下谈谈")
	pass

func showFirstMission():
	GameManager.sav.policyExcute=false
	GameManager.changeTaskLabel("")
	GameManager.sav.have_event["糜竺推荐陈登"]=true
	GameManager.sav.targetValue=1000
	GameManager.sav.targetResType=GameManager.ResType.coin
	GameManager.sav.targetTxt=tr("当前凑集资金：{currence}/{target}")
	GameManager.sav.TargetDestination="府邸"

	chenden.hide()
	mizhu.hide()
func exit():
	SceneManager.changeScene(SceneManager.roomNode.STREET,2)
var getCoin
func selectPolicy(data):
	var id=data.id
	GameManager.sav.policyExcute=true
	if id==1:
		#额外buff填写
		selectCorrect()
	elif id==2:	
		#额外buff填写
		selectCorrect()
	elif id==3:
		policy_panel.bancontrol(3,policy_panel.itemStatus.ban)
		
		#执行初始错误决策，体力回复
		GameManager.sav.hp=GameManager.sav.hp+35
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"错误决策0")

		#pass
	elif id==policymanager.policyID.P_COMMERCIAL_INPLACE_AID:
		policy_panel.bancontrol(1,policy_panel.itemStatus.ban)
		hidePolicy()
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"以商代赈")
		GameManager.sav.HAOZUPAI.ChangeSupport(10)
		GameManager.sav.BENTUPAI.ChangeSupport(-10)
		
		#200-500
		getCoin=randi_range(200,500)
		GameManager.sav.coin=GameManager.sav.coin+getCoin
		GameManager.sav.have_event["initTask1"]=true
		#商业促进
	elif id== policymanager.policyID.P_SUPPLIES_SELF_SUFFIENCY:
		policy_panel.bancontrol(2,policy_panel.itemStatus.ban)
		hidePolicy()
		GameManager.sav.have_event["initTask1"]=true
		GameManager.sav.HAOZUPAI.ChangeSupport(-5)
		
		GameManager.sav.coin=GameManager.sav.coin+200
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
		GameManager.sav.HAOZUPAI.ChangeSupport(10)
		GameManager.sav.BENTUPAI.ChangeSupport(-20)
		
		GameManager.sav.coin_DayGet=GameManager.sav.coin_DayGet+30
		GameManager.sav.have_event["initTask1"]=true
		#提升关税
		#GameManager._engerge.ref
	elif id==policymanager.policyID.P_PrecisionPurge:
		#-豪族和军方 获得一笔钱
		
		
		GameManager.sav.BENTUPAI.ChangeSupport(10)
		GameManager.sav.HAOZUPAI.ChangeSupport(-5)
		GameManager.changePeopleSupport(5)
		
		hidePolicy()
		GameManager.sav.coin_DayGet+=30
		GameManager.sav.labor_DayGet+=10
		GameManager.sav.currenceValue+=2
		#天数-2
		#GameManager.resideValue=tr("士族派好感上升10，豪族派好感下降5，徐州百姓的民心上升5，每日获取金额+10，内奸剩余被发现的天数-2")
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"精确除奸")
		GameManager.sav.have_event["chaoChenDenPolicyExcute"]=true
	elif id==policymanager.policyID.P_BalancePurge:
		#-豪族和军方 获得道具
		
		GameManager.sav.BENTUPAI.ChangeSupport(5)
		GameManager.sav.HAOZUPAI.ChangeSupport(5)

		hidePolicy()
		GameManager.sav.coin_DayGet+=10
		GameManager.sav.labor_DayGet+=5
		
		
		var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.益气丸)
		var remainder = InventoryManager.add_item(GameManager.inventoryPackege, itemid, 1, false)
		
		GameManager.resideValue=tr("士族派好感上升5，豪族派好感上升5，每日获取金额+10，每日获得劳动力+5，获得益气丸x2")
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"平衡除奸")
		GameManager.sav.have_event["chaoChenDenPolicyExcute"]=true
	elif id==policymanager.policyID.P_SwiftPurge:
		#所有派系-10，并且获得人口和金币
		hidePolicy()
		GameManager.sav.BENTUPAI.ChangeSupport(-5)
		GameManager.sav.HAOZUPAI.ChangeSupport(-5)
		GameManager.sav.WAIDIPAI.ChangeSupport(-5)
		GameManager.sav.coin_DayGet-=5
		GameManager.sav.labor_DayGet-=5
		GameManager.sav.coin+=300
		GameManager.sav.labor_force+=150
		GameManager.resideValue=tr("士族派好感下降5，豪族派好感下降5，丹阳派好感下降5，每日获取金额-5，每日获取劳动力-5，金钱+300,劳动力+150")
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"加速除奸")
		GameManager.sav.have_event["chaoChenDenPolicyExcute"]=true		
	elif id==policymanager.policyID.P_LessCoin:
		if GameManager.sav.coin<1000:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"金币无法支持")
			GameManager.sav.hp=GameManager.sav.hp+35
			return
		hidePolicy()
		var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.论语简注)
		var heart=5
		if num>0:
			heart=10
		GameManager.sav.coin-=1000
		GameManager.sav.randomIndex=randi_range(2,3)
		GameManager.resideValue=tr("你消耗了1000金，恢复了{heart}点民心").format({"heart":heart})
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"执行政策")
		GameManager.changePeopleSupport(5)
	elif id==policymanager.policyID.P_LessLabor:
		if GameManager.sav.labor_force<1000:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"劳动力无法支持")
			GameManager.sav.hp=GameManager.sav.hp+35
			return
		hidePolicy()
		var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.论语简注)
		var heart=5
		GameManager.sav.randomIndex=randi_range(2,3)
		if num>0:
			heart=10		
		GameManager.resideValue=tr("你消耗了500点劳动力，恢复了{heart}点民心").format({"heart":heart})
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"执行政策")
		GameManager.sav.labor_force-=500
		GameManager.changePeopleSupport(5)
	elif id==policymanager.policyID.P_MoreBlood:
		if GameManager.sav.people_surrport<40:
			GameManager.sav.hp=GameManager.sav.hp+35
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"民心无法支持了")
			return
		hidePolicy()
		GameManager.sav.randomIndex=randi_range(2,3)
		var addcoin=300
		var addLabor=100
		var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.论语简注)
		if num>0:
			addcoin=500
			addLabor=200
		GameManager.resideValue=tr("你消耗了20点民心,获得了{addcoin}金币和{addLabor}劳动力").format({"addcoin":addcoin,"addLabor":addLabor})
	
		GameManager.policyAction= func():
			GameManager.changePeopleSupport(-20)
			GameManager.sav.coin+=500
			GameManager.sav.labor_force+=200
				
		#储存方法
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"执行政策")
		
		
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
	GameManager.sav.hp=GameManager.sav.hp-costHp_SummonOne
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
			mizhu.show()
			chenden.show()
			policy_panel.hide()
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"收集资金任务完成")#显示对话
			return
		elif(true):
			pass
		#任务完成交付任务
		if GameManager.sav.TargetDestination.length()>0:

			deliverTask()
			return
	#判断task 完成 所到地点
	else:
		deliverUncompleteTask()

func deliverUncompleteTask():
	if GameManager.sav.have_event["chaoDialogEnd"]==true:
		if(GameManager.sav.have_event["chaosEnd"]==false):	
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
	elif candoSub==true:
		if GameManager.sav.have_event["竹简幻觉剧情"]==true and GameManager.sav.have_event["支线触发完毕查出锦囊"]==false:
			
			
			var to_inventory= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.迷魂木筒)
			var quantity=InventoryManager.has_item_quantity(to_inventory)
			if quantity>=1:
				tsty.show()
				return
				#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"城外克苏鲁事件触发")
		elif GameManager.sav.have_event["支线触发完毕查出锦囊休息"]==true and GameManager.sav.have_event["支线触发完毕获得锦囊之前"]==false:
			GameManager.sav.have_event["支线触发完毕获得锦囊之前"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"克苏鲁府邸调查支线")
			return
		#今日重点完成任务
		#判断该不该显示糜竺邀请，同时时间节点到中期，显示任务糜竺-中央，点击触发额外剧情,进入平定泰山诸将时，这里弹出
		if GameManager.sav.have_event["糜竺支线1"]==false and GameManager.sav.have_event["battleTaiShan"]==true:
			mizhu.changeAllClick("糜竺嫁妹支线1")
			mizhu.show()
			mizhu.showEX=true
			#插入糜贞送药
			#糜竺嫁妹支线2
			#tsty.show()		
			
		elif GameManager.sav.have_event["糜竺支线2"]==false and GameManager.sav.mizhuSideWait==1:
			if GameManager.sav.have_event["糜贞送药"]==false:
				mizhu.show()
				mizhu.showEX=false
				GameManager.sav.have_event["糜贞送药"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"插入糜贞送药")
				
		elif GameManager.sav.have_event["糜竺支线2"]==false and GameManager.sav.mizhuSideWait==0:	
			mizhu.changeAllClick("糜竺嫁妹支线2")
			mizhu.show()
			mizhu.showEX=true
	else :
		if GameManager.sav.day>5:
			if(GameManager.sav.have_event["initTask1"]==true):
				pass
				#if(GameManager.sav.have_event["initTask1"]==false):
				#	chenden.show()
				#	chenden.changeAllClick("点击陈登")
				#if(GameManager.sav.have_event["initTask1"]==false):
				#	mizhu.show()
				#	mizhu.changeAllClick("点击糜竺")	
					#chenden
				#判断陈登有无第一次对话，若无则生成
				#判断糜竺有无进行第一次对话，若无则生成	
				#如果没有支线则生成
			#pass							
			
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

		if GameManager.sav.have_event["战斗袁术开始"]==true and GameManager.sav.have_event["chaoDialogEnd"]==false:
			if GameManager.sav.have_event["亲征跟糜竺对话"]==false:
				mizhu.show()
				mizhu.dialogue_start="亲征前跟糜竺对话"
				
			if GameManager.sav.have_event["亲征跟陈登对话"]==false:	
				chenden.show()
				chenden.dialogue_start="亲征前跟陈登对话"
			
			if GameManager.sav.have_event["亲征跟糜竺对话"]==false and GameManager.sav.have_event["亲征跟陈登对话"]==false: 
				GameManager.sav.TargetDestinationBefore="交互提示："
				GameManager.sav.TargetDestination="你需要跟糜竺和陈登分别对话"
			elif GameManager.sav.have_event["亲征跟糜竺对话"]==true and GameManager.sav.have_event["亲征跟陈登对话"]==false: 
				
				GameManager.sav.TargetDestination="你需要跟陈登对话"
			elif GameManager.sav.have_event["亲征跟糜竺对话"]==false and GameManager.sav.have_event["亲征跟陈登对话"]==true:
				GameManager.sav.TargetDestination="你需要跟糜竺对话" 


func liubeiBattleAfterMizhu():
	mizhu.hide()
	GameManager.sav.have_event["亲征跟糜竺对话"]=true
	liubeiBattleAfterEvent()

func liubeiBattleAfterChenDen():
	chenden.hide()
	GameManager.sav.have_event["亲征跟陈登对话"]=true
	liubeiBattleAfterEvent()
	
func liubeiBattleAfterEvent():
	if GameManager.sav.have_event["亲征跟糜竺对话"]==true and GameManager.sav.have_event["亲征跟陈登对话"]==true:
		#后续剧情
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"亲征对话陈登和糜竺")#显示对话			
		#pass	

func enterBattleModeBefore():
	#任务改变去演武场
	GameManager.sav.TargetDestination="演武场"
	GameManager.sav.have_event["亲征对话结束"]=true
	#
	
@onready var hp_panel = $CanvasLayer/hpPanel
func collectMoneyComplete():
	GameManager.sav.TargetDestination="rest"	
	#mizhu.show()
	#chenden.show()
	mizhu.dialogue_start="与糜竺对话2"
	chenden.dialogue_start="与陈登对话2"
	#ameManager.sav.targetResType=GameManager.ResType.rest
	hp_panel.playLabelChange()
	

func chaosBegin():
	GameManager.sav.have_event["chaosBegin"]=true
	mizhu.show()
	chenden.show()
	GameManager.changeTaskLabel(tr("与手下谈谈"))
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
	GameManager.sav.policyExcute=false
	chenden.hide()	
	if GameManager.sav.have_event["chaoMizhuEnd"]==true:
		chaosDialogEnd()
	FractionalDiff()
	#生成一个
func chaosDialogEnd():
	#
	#可以离开，但是会有提示如何做
	#GameManager.sav
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

func FractionalDiff():
	GameManager.sav.HAOZUPAI.isshow=true
	GameManager.sav.HAOZUPAI._num_all=GameManager.sav.BENTUPAI._num_all/2
	GameManager.sav.BENTUPAI._num_all=GameManager.sav.BENTUPAI._num_all-GameManager.sav.HAOZUPAI._num_all
	GameManager.initPaixi(GameManager.sav.HAOZUPAI)
	GameManager.initPaixi(GameManager.sav.BENTUPAI)
	GameManager.sav.BENTUPAI._name="士族派"
	SignalManager.changeSupport.emit()
	GameManager.sav.have_event["Factionalization"]=true
	changePanelPos()
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
	#getFactionByIndex().isDoneOp
	#if _faction.isd==false:
	#xxxx
	if getFactionByIndex().isDoneOp==true:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"已经约过该派系")#显示对话
		return
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
		if _faction==cldata.factionIndex.lvbu:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"消耗资金_吕布")#显示对话
		else:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"消耗资金")#显示对话
	else:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"资金不足安抚")#显示对话
	
#选项资金安抚
func financialConfort():
	var _c=getFactionByIndex()
	_c.isDoneOp=true
	var rindex=GameManager.sav.randomIndex
	#减去资金
	GameManager.sav.coin=GameManager.sav.coin-200
	_c.ChangeAllPeople(3+rindex)
	GameManager.sav.hp-=costHp_SummonOne
	if _faction==cldata.factionIndex.lvbu:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"扩充吕布实力")#显示对话
	else:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"资金赠送完成")#显示对话
	

func getFactionByIndex()->cldata:
	
	var _confortV
	if _faction==cldata.factionIndex.bentupai:
		_confortV=GameManager.sav.BENTUPAI
	elif _faction==cldata.factionIndex.weidipai:
		_confortV=GameManager.sav.WAIDIPAI
	elif _faction==cldata.factionIndex.haozupai:
		_confortV=GameManager.sav.HAOZUPAI
		
		
	return _confortV
	
#选项赠送礼物
func sendgift():
	var _c=getFactionByIndex()
	var rindex=GameManager.sav.randomIndex
	InventoryManager._remove_item(GameManager.inventoryPackege,InventoryManagerItem.珍品礼盒,1)
	#+5
	var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.礼记笺疏)
	if num>=1:
		GameManager.extraValue=5
		_c.ChangeSupport(20+rindex)
	else:
		GameManager.extraValue=0
		_c.ChangeSupport(15+rindex)
	_c.isDoneOp=true
	GameManager.sav.hp-=costHp_SummonOne
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"赠礼完成")
	
@onready var send_gift_panel = $sendGiftPanel
#《经济刺激法案》需通过，还剩6天！
	
func sendgiftChoice():
	var rindex=GameManager.sav.randomIndex
	var _c=getFactionByIndex()

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
var lalongPolicy=0
#选项政策拉拢 #政策拉拢后 摇摆派系全部变成支持派系 25 50 75 100
func policyCo_opt():
	#按照徐州派要求，你得在 法律法规中通过【民田开垦】这条法律，如果通过 你将提升好感度，并且使该派系摇摆人数下降
	#获取一个即将要的政策，是否通过议会厅 通过好感度上升，没通过好感度下降
	#当玩家选择法律通过时，才会那啥
	if GameManager.getCDByFaction(_faction) >0:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"当前还在cd中")
		return
	#显示对话
	
	#var index= int(_faction)  #可能需要一个转换函数进行转换
	var lawIndex= GameManager.getIndexByFractionIndex(_faction)		
	var maxLaw=0

	if GameManager.sav.laws[lawIndex].size()>0:
		maxLaw=GameManager.sav.laws[lawIndex].max()
	else:
		maxLaw=1
	
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
		
		var pick= randi_range(0,unUseArr.size()-1)
		var policyIndex=unUseArr[pick]
		lawName=policy_panel.getPolicyName(lawIndex,policyIndex) #12
		lalongPolicy=-policyIndex
		GameManager.sav.courtingLaws[getFactionByIndex()._name]=lawName
		#GameManager.sav.laws[lawIndex].append(-policyIndex)
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"政策拉拢")#显示对话	
	
	else:
			
		#你的政策槽已满，无法添加新的拉拢政策。
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"法律已经满格了")#显示对话			
		return
		#你当前所有法律已经设置满格了，无法提供额外的法律去拉拢派系

func consent():
	if lalongPolicy!=0:
		var lawIndex= GameManager.getIndexByFractionIndex(_faction)
		if lawIndex==0:
			GameManager.sav.xuzhouCD=7
		elif lawIndex==1:
			GameManager.sav.haozuCD=7
		elif lawIndex==2:
			GameManager.sav.danyangCD=7
		elif lawIndex==3:
			GameManager.sav.lvbuCD=7
		var data=getFactionByIndex()
		data.isDoneOp=true
		GameManager.sav.laws[lawIndex].append(lalongPolicy)
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"成功拉拢")#显示对话	
		GameManager.sav.hp-=costHp_SummonOne
	else:
		print("意外拉拢错误，请监察源码")	

func cancelConsent():
	lalongPolicy=0
	SummonFaction(_faction)
var ForValueCost=0
var ForValueGet=0

#你通过索取可以获得500金，但会消耗徐州派30点忠诚度，请问是否执行
#索取可获500金，但将消耗徐州派30点忠诚度。是否执行？
func claim():
	var _c=getFactionByIndex()
	var rindex=GameManager.sav.randomIndex
	ForValueCost=10+5*rindex
	ForValueGet=_c._num_all*5
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"索取从派系")#显示对话


func suppress():

	var _c=getFactionByIndex()
	
	ForValueGet=(100-_c._support_rate)*5*(_c._num_defections+1)
	ForValueCost=(100-_c._support_rate)*10*(_c._num_defections+1)

	if _c._support_rate>=60:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"贸然镇压")#显示对话
	else:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"决定镇压")#显示对话

func confireSuppress():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"镇压成功")#显示对话
	
	GameManager._propertyPanel.GetValue(-ForValueCost,0,-ForValueGet)
	ForValueCost=0
	ForValueGet=0
	GameManager.sav.hp-=costHp_SummonOne
	var _c=getFactionByIndex()
	_c.isDoneOp=true
	_c._support_rate=100
	_c.isrebellion=true
	_c._num_defections+=1
	SignalManager.changeFraction.emit()
	#发一个信号，有派系确认为对你没有敌意的派系

func CF_CallingSoldier():
	var _c=getFactionByIndex()
	_c.isDoneOp=true
	GameManager.sav.hp-=costHp_SummonOne
	_c.ChangeSupport(-ForValueCost)
	GameManager.sav.labor_force=GameManager.sav.labor_force+ForValueGet
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"调用士兵完成")#显示对话

	
func CF_claim():
	GameManager.sav.hp-=costHp_SummonOne
	var _c=getFactionByIndex()
	_c.ChangeSupport(-ForValueCost)
	_c.isDoneOp=true
	#减去资金
	GameManager.sav.coin=GameManager.sav.coin+ForValueGet
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"索取完成")


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


func burnSac():
	#pass
	#民心-5
	GameManager.changePeopleSupport(-5)
	

func holdSac():
	#GameManager.sav.have_event["支线触发完毕调查过竹简"]=true
	#增加道具
	var _reward:rewardPanel=PanelManager.new_reward()
	var items={
		"items": {InventoryManagerItem.ItemEnum.黄麻药囊:1},
		"money": 0,
		"population": 0
	}
	#GameManager.ScoreToItem()
	_reward.showTitileReward(tr("恭喜你，你获得-黄麻药囊"),items)	
	
@onready var factionView= $CanvasLayer/faction

func changePanelPos():
	if factionView==null:
		return
	if GameManager.sav.have_event["Factionalization"]==true:
		factionView.position.y=655
	else:	
	#f GameManager.sav.
		factionView.position.y=730
	pass

func JudFundTask():
	#在府邸意外凑齐钱时会判断任务是否完成,这个会触发第一次赈灾，这是bug
	if(GameManager.sav.have_event["completeTask1"]==false):#仅完成收集资金任务
		_JudgeTask()
const _2__MENTAL_VORTEX = preload("res://Asset/bgm/2- Mental Vortex.mp3")
func zhangyanCrazy():
	PanelManager.Fade_Blank(Color.RED,0.5,PanelManager.fadeType.fadeIn)
	await 0.5
	PanelManager.Fade_Blank(Color.RED,0.5,PanelManager.fadeType.fadeOut)
	SoundManager.stop_music()
	SoundManager.play_music(_2__MENTAL_VORTEX)
	#屏幕发红
	#音乐切换
	
	pass
const HUI_3 = preload("res://Asset/sound/hui3.wav")	

@onready var hui_animation_player = $Sprite2D/AnimationPlayer
@onready var sprite_hui = $Sprite2D

func zhangyanChop():
	SoundManager.play_sound(HUI_3)
	sprite_hui.show()
	hui_animation_player.play("chop")

	var _func=func(stringname):sprite_hui.hide()
	hui_animation_player.animation_finished.connect(_func)
	#挥舞音乐
	#张yan挥刀，陶跑
	pass

func resumeMusic():
	SoundManager.stop_music()

	
	var music_file = "res://Asset/music/Ambient " + str(GameManager.musicId) + ".wav"
	GameManager.play_music(music_file)	

