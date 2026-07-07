extends baseComponent
class_name  government_building

@onready var control = $CanvasLayer/Control
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
	point.show()
	policyBook.show()
	control._show_button_5_yellow(-1)
	#pass
const fanyuesound = preload("res://Asset/sound/翻阅.mp3")
@onready var point: Node2D = $point

func lookDown():
	point.hide()
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
	policy_panel.showTourPoint()
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


@onready var tsty = $"peoples/陶商陶应"


func _initGroup(group):
	if group==2:
		pass
	pass

@onready var bg = $"内饰"
const newBuild = preload("res://Asset/城镇建筑/宅邸亮.png")
const xiaopeiBuild = preload("res://Asset/城镇建筑/小沛亮.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	if (GameManager.sav.day>=5 or GameManager.sav.have_event["initXuzhou"]==true) and GameManager.sav.endPath!=GameManager.endPath.xiaopei:
		bg.texture=newBuild
	else:
		bg.texture=xiaopeiBuild
	#DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
	
	Transitions.post_transition.connect(post_transition)
	control.buttonClick.connect(_buttonListClick)
	control.buttonHover.connect(_buttonListHover)
	super._ready()
	#initData()
	changePanelPos()
	_restoreSavedDialogue()
	
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
		return
	GameManager.hearsayID=-1


func _initData():
	candoSub=true
	
	if GameManager.selectBoardCharacter==boardType.boardCharacter.mizhu and GameManager._boardMode!=boardType.boardMode.none and GameManager._boardGameWin==true:
		candoSub=false
		GameManager.selectBoardCharacter=boardType.boardCharacter.none         
		GameManager._boardMode=boardType.boardMode.none
		if GameManager._boardReward!=boardType.boardRewardResult.BreakFree:
			GameManager.resumeMusic()
			mizhu.show()
			mizhu.changeAllClick("来把仕诡牌")
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"常规获胜")
		else:
			GameManager.resumeMusic()
			mizhu.changeAllClick("来把仕诡牌")
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"黑暗游戏获胜")	
	elif GameManager.selectBoardCharacter==boardType.boardCharacter.mizhu and GameManager._boardMode!=boardType.boardMode.none and GameManager._boardGameWin==false:
		candoSub=false
	
		GameManager.selectBoardCharacter=boardType.boardCharacter.none
		GameManager._boardMode=boardType.boardMode.none
		if GameManager._boardReward!=boardType.boardRewardResult.BreakFree:
			GameManager.resumeMusic()
			mizhu.changeAllClick("来把仕诡牌")
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"常规失败") 
		else:
			GameManager.resumeMusic()
			mizhu.changeAllClick("来把仕诡牌")
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"黑暗游戏失败") 
	
	elif GameManager.bossmode==scenemanager.bossMode.mi and GameManager.sav.have_event["糜竺支线3"]==false:
		GameManager.sav.hp=0
		mizhu.show()
		AchievementManager.set_achievement("NEW_ACHIEVEMENT_1_15")
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"糜贞结尾")
		GameManager.sav.have_event["糜竺支线3"]=true
		GameManager.bossmode=scenemanager.bossMode.none
		return 
	elif GameManager.sav.day==1:
		if	GameManager.sav.have_event["firstgovernment"]==false:
			#control._show_button_5_yellow(1)
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
			GameManager.sav.have_event["firstgovernment"]=true
			candoSub=false
	#elif GameManager.day==2:
	elif GameManager.sav.day==5:
		
		if	GameManager.sav.have_event["initXuzhou"]==false:
			GameManager.musicId=-1
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
				mizhu.show()
				chenden.show()
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
			GameManager.clearTask()
			candoSub=false
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"徐州得安")
		elif GameManager.sav.have_event["新剧情_基建开始"]==true and GameManager.sav.have_event["基建项目开启"]==false:
			mizhu.show()
			chenden.show()
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"凑集2000民夫任务")
			
		elif GameManager.sav.have_event["袁术首次击败"]==true and GameManager.sav.have_event["派系安稳任务触发"]==false: 
			GameManager.sav.have_event["派系安稳任务触发"]=true
			candoSub=false
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"安抚众人任务开始")
		elif GameManager.sav.have_event["关羽求援期间"]==true and GameManager.sav.have_event["关羽求援结束"]==false and GameManager.sav.endPath==GameManager.endPath.xuzhou: 
			GameManager.sav.have_event["关羽求援结束"]=true
			candoSub=false
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"霸道线路开启")
			

		elif  GameManager.sav.have_event["关羽求援结束"]==true and GameManager.sav.have_event["主簿的追随"]==false and GameManager.sav.endPath==GameManager.endPath.xiaopei: 
			GameManager.sav.have_event["主簿的追随"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"主簿的追随")
		elif GameManager.CheckAllFactionsSubdued() and GameManager.sav.have_event["AllFactionsSubdued"]==false and GameManager.LawNum()>=GameManager.maxLawNum:
			GameManager.sav.have_event["AllFactionsSubdued"]=true
			GameManager.sav.LVBU.supressNum=3
			GameManager.sav.LVBU._support_rate=100
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"不用发放津贴了")
			#这个会和有些起冲突 后续
	else:
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
		"context":"召见派系", #前往花园并通向小道
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
		if control.visible==true:
			items_in_scene.showItems()
		control._processList(initData)

	if GameManager.sav.have_event["firstTabLaw"]==true or GameManager.sav.day>=5:
		policy_panel.tab_bar.show()
	else:
		policy_panel.tab_bar.hide()
	policy_panel._initData()

	if GameManager.sav.day==2 and GameManager.sav.have_event["firstMeetingEnd"]==false:
		control._show_button_5_yellow(1)
		

	if(GameManager.sav.targetTxt!=null and GameManager.sav.targetTxt.length()>0):		
		_JudgeTask()#这里必然进去
	#elif GameManager.sav.day==4:
	#	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"府邸第一天")
	
	

func xuzhouStart():
	GameManager.returnBloodRes()
	GameManager.sav.targetValue=12
	GameManager.sav.currenceValue=0
	GameManager.sav.targetResType=GameManager.ResType.rest
	GameManager.sav.targetTxt="撑过旬数：{currence}/{target}"
	GameManager.sav.TargetDestination="rest"
	#lvbu
	GameManager.sav.isGetCoin=true
	#如果所有派系都是忠诚，那么就不需要再发工资了，也加个这方面的剧情
	GameManager.sav.LVBU.isshow=false
	GameManager.initPaixi(GameManager.sav.LVBU)
	SignalManager.changeSupport.emit()
	GameManager.showChapterTitle("终章【主线进度90%】", "霸道之始", 4)
	GameManager.AutoSaveFile()
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
	#待改
	GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.KESULU]=tr("回府邸彻查张阎刺陶一案")
	pass
	#DialogueManlogue_balloon(dialogue_resource,"城外克苏鲁事件触发")
	#dialog
	
var costHp_SummonOne=50
var costHp_policy=35

@onready var caocao_letter: Control = $CanvasLayer/caocaoLetter

func Loss_of_loyalty():
	# 倒数第二章：军情泄露，各派系数值大幅下降
	# 任务目标：恢复全部派系至80以上
	# 豪族派受影响最重（商人对动荡恐惧最大）
	var loyaltyCoeff=1.0
	match GameManager.sav.gameDifficulty:
		1: loyaltyCoeff=0.6
		2: loyaltyCoeff=0.8
		3: loyaltyCoeff=1.0
	GameManager.resideValue=int(20*loyaltyCoeff)
	# 本土派相对最稳
	GameManager.resideValue2=int(15*loyaltyCoeff)
	# 丹阳派受军情直接打击
	GameManager.resideValue3=int(25*loyaltyCoeff)
	# 吕布本就动摇，情报泄露后更甚
	GameManager.resideValue4=int(30*loyaltyCoeff)
	GameManager.sav.HAOZUPAI.ChangeSupport(-GameManager.resideValue)
	GameManager.sav.BENTUPAI.ChangeSupport(-GameManager.resideValue2)
	GameManager.sav.WAIDIPAI.ChangeSupport(-GameManager.resideValue3)
	GameManager.sav.LVBU.ChangeSupport(-GameManager.resideValue4)
	#changePeopleSupport(-20)

func ReconciliatoryFaction():
	#GameManager.sav.have_event["战斗袁术开始"]=true
	GameManager.sav.targetValue=4
	GameManager.sav.currenceValue=0
	GameManager.sav.targetResType=GameManager.ResType.govern
	#好感度大于60 且
	
	
	if GameManager.dontHaveDominance():
		GameManager.sav.targetTxt="安抚派系: {currence}/{target}"
		GameManager.showChapterTitle("第八章【主线进度75%】", "安抚众心", 4)
	else:
		
		GameManager.sav.targetTxt="统御派系: {currence}/{target}"
		GameManager.showChapterTitle("第八章【主线进度75%】", "安抚众心", 4)
	#GameManager.showChapterTitle("第八章【主线进度75%】", "安抚众心", 4)
	GameManager.AutoSaveFile()


func _buttonListHover(item):
	if GameManager.haveMirror():
		if item.context == "执行政策":
		
			GameManager._engerge.startPreviewHp(policy_panel.costhp)
		elif item.context == "召见派系":
			GameManager._engerge.startPreviewHp(costHp_SummonOne)



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
	
		if(GameManager.sav.day==1):
			
			policy_panel.show()

			if(GameManager.sav.have_event["firstgovermentTip"]==false):
				GameManager.sav.have_event["firstgovermentTip"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"enterpolicy")
		elif(GameManager.sav.day==2):
			if GameManager.sav.isMeet==false:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第二天的提示")
			else:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第二天的提示2")
		elif GameManager.sav.day==5:
			if(GameManager.sav.have_event["initTask1"]==false and GameManager.sav.have_event["糜竺推荐陈登"]==true):

				policy_panel.show()
				policy_panel.tab_bar.current_tab=0
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"主线第一次指定政策")
			elif GameManager.sav.have_event["糜竺推荐陈登"]==false:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"没有对话前不能执行政策")
			else:
	
				policy_panel.show()
		else:
			if GameManager.sav.have_event["chaosBegin"]==true and GameManager.sav.have_event["chaoDialogEnd"]==false:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"城中混乱状况")
				return
			elif GameManager.sav.have_event["派系安稳完成"]==true and GameManager.sav.have_event["亲征对话结束"]==false:	
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"亲征状况")	
				return
			if group==-1 and GameManager.sav.policyExcute==false and GameManager.sav.day>=5:
				if GameManager.sav.have_event["第一次民心政策"]==false:
					GameManager.sav.have_event["第一次民心政策"]=true
					DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"民生政策")	
				
			policy_panel.show()

	#50点	
	elif item.context == "召见派系":
		if await GameManager.isTried(costHp_SummonOne):
			return

		if(GameManager.sav.have_event["initTask1"]==false and GameManager.sav.have_event["initXuzhou"]==true):
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"未完成前召见手下")
			return	
			
		elif GameManager.sav.have_event["chaosBegin"]==true and GameManager.sav.have_event["chaoDialogEnd"]==false:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"城中混乱状况")
			return
		elif GameManager.sav.have_event["派系安稳完成"]==true and GameManager.sav.have_event["亲征对话结束"]==false:	

			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"亲征状况")	
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
			#第二天的提示2
			if GameManager.sav.day==2:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第二天的提示2")
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
				elif GameManager.sav.have_event["派系安稳完成"]==true and GameManager.sav.have_event["亲征对话结束"]==false:	

					DialogueManager.show_example_dialogue_balloon(dialogue_resource,"亲征状况")
				else:	
				#先提示对话 然后
					exit()	
				pass

	print(item)
	pass
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
	

@onready var node_2d: Node2D = $CanvasLayer/Node2D

func showFirstHpTutoral():
	color_rect.show()
	node_2d.show()
	$"CanvasLayer/Node2D/5Yellow/AnimationPlayer".play("YELLOWGUILD")
	create_tween().tween_property(color_rect, "color:a", 0.85, 0.4)
func victoryPartyEnd():
	
	GameManager.sav.have_event["庆功宴结束"]=true
	GameManager.sav.targetValue=1
	GameManager.sav.currenceValue=0
	GameManager.sav.targetResType=GameManager.ResType.rest
	
	#这里面板没有刷新
	#后面把process改成发送信号
	GameManager.sav.targetTxt=""
	GameManager.sav.TargetDestination=""
	GameManager.showChapterTitle("第六章【主线进度55%】", "百废待兴", 4)
	GameManager.AutoSaveFile()

	
func oldvictoryPartyEnd():
	GameManager.sav.have_event["战斗袁术开始"]=true
	GameManager.sav.targetValue=12
	GameManager.sav.currenceValue=0
	GameManager.sav.targetResType=GameManager.ResType.battle
	GameManager.sav.targetTxt="征讨次数：{currence}/{target}"
	chenden.hide()
	mizhu.hide()
	GameManager.initSecretBattleContext(3,SceneManager.etraTaskType.useItem,10,"袁术军大胜",("在对纪灵军的军事行动中，累计三次使用胜战锦囊。"))
	GameManager.showChapterTitle("第七章【主线进度65%】", "奉令讨逆", 4)
	GameManager.AutoSaveFile()
func mizhufinal():
	GameManager.sav.have_event["最终糜竺"]=true
	#pass

func optionSummonOnemen():
	if(GameManager.sav.day<5):
		#判断显示召见手下1 还是召见手下2 还是召见手下3
		if GameManager.sav.have_event["firstMeetingEnd"]==false:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"召见手下1")
		else:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"派系斡旋")
			#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"未启用功能")
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
		GameManager.sav.HAOZUPAI.ChangeSupport(10)
		GameManager.changePeopleSupport(-5)
	else:
		GameManager.sav.have_event["错失娃娃"]=true
		GameManager.sav.have_event["糜竺正确选择1"]=false
		GameManager.sav.HAOZUPAI.ChangeSupport(5)
func eatTea2(issuccuss=false):

	GameManager.sav.have_event["糜竺支线2"]=true


	if issuccuss==true:
		GameManager.sav.have_event["糜竺正确选择2"]=true
		if GameManager.sav.have_event["糜竺正确选择2"]==true and GameManager.sav.have_event["糜竺正确选择1"]==true:
			GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.MIZHU]=tr("持铜钥入糜家秘宅，探寻糜贞疯癫缘由")
	else:
		AchievementManager.set_achievement("NEW_ACHIEVEMENT_1_15")
		GameManager.sav.have_event["错失娃娃"]=true
		GameManager.sav.have_event["糜竺正确选择2"]=false

@onready var lvbuc: clickBlock = $"peoples/吕布"

func showMizhuTouchMain():
	mizhu.show()
	mizhu.showEX=true
	#chenden.hide()
	mizhu.changeAllClick("府邸主线")

	GameManager.changeTaskLabel("与手下谈谈")
	GameManager.showChapterTitle("第一章【主线进度5%】", "入主徐州", 4)
	GameManager.AutoSaveFile()

@onready var zhubu: Node2D = $"peoples/主簿"


func showFirstMission():
	GameManager.sav.policyExcute=false
	GameManager.changeTaskLabel("")
	GameManager.sav.have_event["糜竺推荐陈登"]=true
	GameManager.sav.targetValue=1000
	GameManager.sav.targetResType=GameManager.ResType.coin
	GameManager.sav.targetTxt="凑齐资金：{currence}/{target}"
	GameManager.sav.TargetDestination="府邸"

	chenden.hide()
	mizhu.hide()
func exit():
	SceneManager.changeScene(SceneManager.roomNode.STREET,2)
var getCoin
func selectPolicy(data,hp):
	var id=data.id
	if id!=10 and id!=11 and id!=12:
		GameManager.sav.hp-=hp
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

		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"军粮自给")
		#军粮自给，维持现状
	elif id== policymanager.policyID.P_RAISE_TAX:
		policy_panel.bancontrol(3,policy_panel.itemStatus.ban)
		hidePolicy()

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
		
		GameManager.resideValue=tr("士族派好感上升5，豪族派好感上升5，每旬获取金额+10，每旬获得民力+5，获得益气丸x2")
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
		GameManager.resideValue=tr("士族派好感下降5，豪族派好感下降5，丹阳派好感下降5，每旬获取金额-5，每旬获取民力-5，钱+300,民力+150")
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"加速除奸")
		GameManager.sav.have_event["chaoChenDenPolicyExcute"]=true		
	elif id==policymanager.policyID.P_LessCoin:
		var cost=GameManager.getMinxinCost2()
		if GameManager.sav.Merit_points<GameManager.minxinPoint:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"政策点不足")
			return				
		if GameManager.sav.coin<cost:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"钱无法支持")
			return

		var heart= GameManager.getMinxinValue2()
		GameManager.resideValue2=tr("施行政策需消耗钱x{cost}、政策点数x{point}；现有钱：{nowQ}、政策点数：{nowZd}，确定推行吗？").format({"cost":cost,"point":GameManager.minxinPoint,"nowQ":GameManager.sav.coin,"nowZd":GameManager.sav.Merit_points})
		
		GameManager.policyAction= func():	
			hidePolicy()
			GameManager.sav.Merit_points-=GameManager.minxinPoint
			GameManager.sav.coin-=cost
			GameManager.changePeopleSupport(heart)
			GameManager.sav.hp-=hp
			GameManager.sav.policyExcute=true				
		GameManager.resideValue=tr("你消耗了{cost}钱，恢复了{heart}点民心").format({"cost":cost,"heart":heart})
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"民心执行政策")
		
	elif id==policymanager.policyID.P_LessLabor:
		var cost=GameManager.getMinxinCost1()
		if GameManager.sav.Merit_points<GameManager.minxinPoint:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"政策点不足")
			return		
		if GameManager.sav.labor_force<cost:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"劳动力无法支持")
			return
		

		var heart=GameManager.getMinxinValue1()

			
		GameManager.resideValue2=tr("施行政策需消耗民力x{cost}、政策点数x{point}；现有民力：{nowMl}、政策点数：{nowZd}，确定推行吗？").format({"cost":cost,"point":GameManager.minxinPoint,"nowMl":GameManager.sav.labor_force,"nowZd":GameManager.sav.Merit_points})
		
		GameManager.resideValue=tr("你消耗了{cost}点民力，恢复了{heart}点民心").format({"cost":cost,"heart":heart})
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"民心执行政策")
		
		GameManager.policyAction= func():
			hidePolicy()
			GameManager.sav.Merit_points-=GameManager.minxinPoint			
			GameManager.sav.labor_force-=cost
			GameManager.changePeopleSupport(heart)
			GameManager.sav.hp-=hp
			GameManager.sav.policyExcute=true			
	elif id==policymanager.policyID.P_MoreBlood:
		var cost=GameManager.getMinxinCost3()
		if GameManager.sav.Merit_points<GameManager.minxinPoint:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"政策点不足")
			return
		if GameManager.sav.people_surrport<cost:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"民心无法支持了")
			return

		GameManager.sav.randomIndex=randi_range(2,3)
		var addcoin=GameManager.getMinxinValue3()
		var addLabor=GameManager.getMinxinValue4()
		GameManager.resideValue2=tr("施行政策需消耗民心x{cost}、政策点数x{point}；现有民心：{nowH}、政策点数：{nowZd}，确定推行吗？\n【警示：民心数值降至 0 将直接游戏失败】").format({"cost":cost,"point":GameManager.minxinPoint,"nowH":GameManager.sav.people_surrport,"nowZd":GameManager.sav.Merit_points})
	
		GameManager.resideValue=tr("你消耗了{cost}点民心,获得了{addcoin}钱和{addLabor}民力").format({"cost":cost,"addcoin":addcoin,"addLabor":addLabor})
	
		GameManager.policyAction= func():
			hidePolicy()
			GameManager.sav.Merit_points-=GameManager.minxinPoint			
			GameManager.changePeopleSupport(-cost)
			GameManager.sav.coin+=addcoin
			GameManager.sav.labor_force+=addLabor
			GameManager.sav.hp-=hp
			GameManager.sav.policyExcute=true	
		#储存方法
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"民心执行政策")
		
		
func selectCorrect():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"正确决策0")
	hidePolicy()

func selectCorrectBefore():
	if GameManager.sav.have_event["firstPolicyCorrect"]==false:
		GameManager.sav.have_event["firstPolicyCorrect"]=true
		
		if GameManager.sav.gameDifficulty==1:
			GameManager.sav.Merit_points=2
		elif GameManager.sav.gameDifficulty==2:
			GameManager.sav.Merit_points=3
		elif GameManager.sav.gameDifficulty==3:
			GameManager.sav.Merit_points=4
		
		
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
	
@onready var show_pos: Node2D = $"peoples/陶商陶应/showPos"

func meetingEnd():
	GameManager.sav.WAIDIPAI.ChangeSupport(30)
	GameManager.sav.BENTUPAI.ChangeSupport(30)
	GameManager.sav.destination="议事厅"
	GameManager.sav.hp=GameManager.sav.hp-costHp_SummonOne
	GameManager.sav.isMeet=true
	control._show_button_5_yellow(-1)	
@onready var mizhu = $"peoples/糜竺"
@onready var chenden = $"peoples/陈登"
@onready var zhangfei= $peoples/zhangfei
func _firstPhaseBegin():
	mizhu.show()
	chenden.show()
	#mizhu.changeAllClick("点击糜竺")
	#chenden.changeAllClick("点击陈登0")
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
	var iscompleteTask=false	
	if  value is Array:
		if value[0]>=GameManager.sav.targetValue and value[1]>=3:
			iscompleteTask=true
	else:
		if value>=GameManager.sav.targetValue:
			iscompleteTask=true
	
	if iscompleteTask==true:
		
		if(GameManager.sav.have_event["completeTask1"]==false):
			GameManager.sav.have_event["completeTask1"]=true
			mizhu.show()
			chenden.show()
			policy_panel.hide()
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"收集资金任务完成")#显示对话
			return
		elif(GameManager.sav.have_event["三基建完成"]==true and GameManager.sav.have_event["曹操协天子以令诸侯"]==false):
			GameManager.sav.have_event["曹操协天子以令诸侯"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"曹操的信_击败袁术才有委任状")#显示对话
			GameManager.clearTask()
			pass
		#任务完成交付任务
		if GameManager.sav.TargetDestination.length()>0:

			var isr=deliverTask()
			if isr==true:
				return
	#判断task 完成 所到地点
	
	deliverUncompleteTask()

func deliverUncompleteTask():
	if GameManager.sav.have_event["chaoDialogEnd"]==true:
		if(GameManager.sav.have_event["chaosEnd"]==false):	
			if GameManager.sav.currenceDay>=3 and DialogueManager.dialogBegin==false:
				GameManager.sav.currenceDay=0
				if GameManager.sav.have_event["firstDisaster"]==false:
					GameManager.sav.have_event["firstDisaster"]=true
					DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第一次赈灾开始")#显示对话
					return	#第一次赈灾启动 还没设定
				elif GameManager.sav.have_event["secondDisaster"]==false:	
					GameManager.sav.have_event["secondDisaster"]=true
					DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第二次分配粮食")#显示对话
					return	#第二次赈灾开始
				elif GameManager.sav.have_event["thirdDisaster"]==false:
					DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第三次分配粮食")#显示对话			
					GameManager.sav.have_event["thirdDisaster"]=true
					return	#第三次赈灾开始	
	if candoSub==true:
		var jingtieWaitDay=7
		if GameManager.sav.gameDifficulty==3:
			jingtieWaitDay=5
		
		if GameManager.sav.have_event["竹简幻觉剧情"]==true and GameManager.sav.have_event["支线触发完毕查出锦囊"]==false:
			
			
			var to_inventory= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.迷魂木筒)
			var quantity=InventoryManager.has_item_quantity(to_inventory)
			if quantity>=1:
				tsty.show()
				return
				#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"城外克苏鲁事件触发")
		elif GameManager.sav.have_event["津贴系统开始"]==false and GameManager.sav.day>=jingtieWaitDay and GameManager.sav.have_event["initTaskPolicy"]==true:
			GameManager.sav.have_event["津贴系统开始"]=true
			if GameManager.sav.gameDifficulty==3:
				GameManager.sav.allocationDay=2
			else:
				GameManager.sav.allocationDay=1
			GameManager.initDemand()
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"津贴开始2")
			return
		elif GameManager.sav.have_event["支线触发完毕查出锦囊休息"]==true and GameManager.sav.have_event["支线触发完毕获得锦囊之前"]==false and GameManager.sav.endPath==GameManager.endPath.none:
			GameManager.sav.have_event["支线触发完毕获得锦囊之前"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"克苏鲁府邸调查支线")
			return
		elif GameManager.sav.have_event["支线触发完毕获得骨杖"]==true and GameManager.sav.have_event["支线终府邸线索获取完成"]==false:
			GameManager.sav.have_event["支线终府邸线索获取完成"]=true
			
			var to_inventory= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.饥蛊骨签)
			var quantity=InventoryManager.has_item_quantity(to_inventory)
			if quantity>=1:
			
		
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"徐州派揭露真相")
			else:
				GameManager.sav.Merit_points+=1
				GameManager.sav.have_event["错失古棒"]=true
				AchievementManager.set_achievement("NEW_ACHIEVEMENT_1_19")
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"保护陶商揭露真相")
			return
		#今日重点完成任务
		#判断该不该显示糜竺邀请，同时时间节点到中期，显示任务糜竺-中央，点击触发额外剧情,进入平定泰山诸将时，这里弹出
		if GameManager.sav.have_event["糜竺支线1"]==false and GameManager.sav.have_event["chaoMizhuEnd"]==true and GameManager.sav.currenceValue>1 and GameManager.sav.endPath==GameManager.endPath.none:
			
			

			mizhu.changeAllClick("糜竺嫁妹支线1")
			mizhu.show()
			tsty.hide()
			mizhu.showEX=true
			#插入糜贞送药
			#糜竺嫁妹支线2
			#tsty.show()		
			
		elif GameManager.sav.have_event["糜竺支线2"]==false and GameManager.sav.mizhuSideWait==1 and GameManager.sav.endPath==GameManager.endPath.none:
			if GameManager.sav.have_event["糜贞送药"]==false:
				mizhu.hide()
				tsty.hide()
				#mizhu.showEX=false
				GameManager.sav.have_event["糜贞送药"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"插入糜贞送药")
				
		elif GameManager.sav.have_event["糜竺支线2"]==false and GameManager.sav.mizhuSideWait==0 and GameManager.sav.endPath==GameManager.endPath.none:	
			mizhu.changeAllClick("糜竺嫁妹支线2")
			mizhu.show()
			tsty.hide()
			mizhu.showEX=true
		else:
			
			
			if GameManager.sav.endPath==GameManager.endPath.none or GameManager.sav.have_event["最终糜竺"]==true:
			#0 小试牛刀开启 1小试牛刀通过 2 对局试炼开启 3对局试验通过 4 诡秘怪谈开启 5诡秘怪谈通过
				if GameManager.sav.mizhucardgame>=0 or GameManager.sav.have_event["津贴系统开始"]==true:
					mizhu.changeAllClick("来把仕诡牌")
					mizhu.show()
					mizhu.showEX=false
			elif GameManager.sav.have_event["最终糜竺"]==false and GameManager.sav.BENTUPAI._support_rate>=80 and GameManager.sav.have_event["主簿的追随"]==true and zhubu.visible==false:
				mizhu.changeAllClick("糜竺最终支线")
				mizhu.show()
				mizhu.showEX=true
			
			#
	else :
		if GameManager.sav.day>5:
			if(GameManager.sav.have_event["initTask1"]==true):
				pass
		
@onready var allocation_panel: Control = $CanvasLayer/AllocationPanel


func openMonthlySupplyPanel():
	allocation_panel.initData()
	allocation_panel.show()

	if GameManager.sav.have_event["第一次津贴教程"]==false:
		GameManager.sav.have_event["第一次津贴教程"]=true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"津贴教程")
	elif GameManager.sav.allocationDay==1:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"上旬通知")
	elif GameManager.sav.allocationDay==2:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"中旬通知")
	elif GameManager.sav.allocationDay==3:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"下旬通知")
func deliverTask()->bool:
	if GameManager.sav.TargetDestination=="府邸":
		#任务2完成 来这边兑现奖励
		#把交付任务完成
		#任务清空
		if GameManager.sav.have_event["deliverTask2"]==false:
			if(GameManager.sav.have_event["completeTask2"]==true):
				GameManager.sav.have_event["deliverTask2"]=true
				GameManager.clearTask()
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"打跑黄巾军")#显示对话
				return true
		#暂时屏蔽		
		elif  GameManager.sav.have_event["派系安稳完成"]==false and GameManager.sav.targetResType==GameManager.ResType.govern:
			
			if(GameManager.sav.have_event["派系安稳任务触发"]==true):
				GameManager.sav.have_event["派系安稳完成"]=true
				# 改用complete类型，让进度永远为完成任务状态
				# 这样后面好感度变化也不会让任务回退
				GameManager.sav.targetResType = GameManager.ResType.complete
				GameManager.sav.targetValue = 1
				GameManager.sav.TargetDestination = ""
				GameManager.sav.currenceValue = 0
				#设定任务已完成，前往演武场即可
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"刘备决定亲征")#显示对话
				return true
		if GameManager.sav.have_event["派系安稳完成"]==true and GameManager.sav.have_event["亲征对话结束"]==false:
			GameManager.sav.TargetDestination=""
			return true
		#elif:
		#	pass
	return false

func PersonalCampaignBefore():
	
	mizhu.show()
	mizhu.changeAllClick("亲征前跟糜竺对话")
				#得改
	GameManager.changeTaskLabel("与手下谈谈")
	chenden.show()
	chenden.changeAllClick("亲征前跟陈登对话")








func _restoreSavedDialogue():
	# 亲征已触发但未结束时，强制恢复糜竺/陈登的对话句柄
	if GameManager.sav.have_event.get("亲征对话触发")==true and GameManager.sav.have_event.get("亲征对话结束")!=true:
		mizhu.changeAllClick("亲征前跟糜竺对话")
		chenden.changeAllClick("亲征前跟陈登对话")


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
		GameManager.sav.have_event["亲征对话结束"]=true

func enterBattleModeBefore():
		#任务改变去演武场
		GameManager.sav.TargetDestination="演武场"
		GameManager.sav.have_event["亲征对话结束"]=true
	
@onready var hp_panel = $CanvasLayer/hpPanel
func collectMoneyComplete():
	GameManager.compeleteTaskAndChangeDestination("rest")
	#GameManager.sav.TargetDestination="rest"	

	mizhu.changeAllClick("与糜竺对话2")
	chenden.changeAllClick("与陈登对话2")

	hp_panel.playLabelChange()


func chaosBegin():
	GameManager.sav.have_event["chaosBegin"]=true
	mizhu.show()
	chenden.show()
	GameManager.changeTaskLabel("与手下谈谈")
	mizhu.changeAllClick("混乱与糜竺对话")
	chenden.changeAllClick("混乱与陈登对话")
	
	
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
	GameManager.sav.targetTxt="追查进度：{currence}/{target}"
	GameManager.sav.TargetDestination="rest"
@onready var disater_panel = $CanvasLayer/disaterPanel

func confireAllocation():
	disater_panel.confireAllocation()


func cancelAllocation():
	disater_panel.cancelAllocation()

func afterAllocation():
	disater_panel.afterAllocation()
	_initData()
func FractionalDiff():
	GameManager.sav.HAOZUPAI.isshow=true
	GameManager.sav.HAOZUPAI._support_rate=GameManager.sav.BENTUPAI._support_rate
	GameManager.sav.HAOZUPAI._num_all=GameManager.sav.BENTUPAI._num_all/2
	GameManager.sav.BENTUPAI._num_all=GameManager.sav.BENTUPAI._num_all-GameManager.sav.HAOZUPAI._num_all
	GameManager.initPaixi(GameManager.sav.HAOZUPAI)
	GameManager.initPaixi(GameManager.sav.BENTUPAI)
	GameManager.sav.BENTUPAI._name="士族派"
	GameManager.sav.BENTUPAI.detail="徐州本土名门士族集团，以陈登为首，世代宦居徐州，深谙州郡治理与地缘谋略，心向安稳，辅佐刘备以保徐州全境。"
	SignalManager.changeSupport.emit()
	GameManager.sav.have_event["Factionalization"]=true
	GameManager.sav.HAOZUPAI.support_redirect_active=false
	changePanelPos()

	
	#存档
	#派系分化成2个
	
func canSummonLvBu():
	GameManager.sav.LVBU.isshow=true

	GameManager.initPaixi(GameManager.sav.LVBU)
	
	SignalManager.changeSupport.emit()
	GameManager.sav.targetValue=3
	GameManager.sav.currenceValue=0
	GameManager.sav.currenceDay=0
	GameManager.sav.targetResType=GameManager.ResType.battle
	GameManager.sav.targetTxt="征讨次数：{currence}/{target}"	
	changePanelPos()
func ShowDisterPanel():
	disater_panel.show()
	pass

func StartTaishan():
	if GameManager.sav.have_event["battleTaiShan"]==false:
		GameManager.sav.have_event["battleTaiShan"]=true
	GameManager.sav.targetValue=12
	GameManager.sav.currenceValue=0
	GameManager.sav.targetResType=GameManager.ResType.battle
	GameManager.sav.targetTxt="征讨次数：{currence}/{target}"
	GameManager.initSecretBattleContext(3,SceneManager.etraTaskType.dontLoseGame,6,"昌豨求饶支线",("在对泰山军的军事行动中，累计三次达成100%胜率。"))
	#觉得无用的注释GameManager.sav.TargetDestination="battle"
	#显示军事行动还有30把
	
	

var _faction:cldata.factionIndex=cldata.factionIndex.bentupai	
func SummonFaction(value:cldata.factionIndex):
	_faction=value

	if getFactionByIndex().summonNum>=GameManager.sav.summonMaxNum:
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
#	if getFactionByIndex()._num_all>=100:
#		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"已满")#显示对话
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
	_c.summonNum+=1
	var rindex=GameManager.sav.randomIndex
	#减去资金
	GameManager.sav.coin=GameManager.sav.coin-200
	_c.ChangeAllPeople(20+rindex)
	SignalManager.changeFraction.emit()
	if _c._num_all>=100:
		AchievementManager.set_achievement("NEW_ACHIEVEMENT_1_12")
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
	elif _faction==cldata.factionIndex.lvbu:
		_confortV=GameManager.sav.LVBU
		
	return _confortV
	
#选项赠送礼物
func sendgift():
	var _c=getFactionByIndex()
	#var rindex=GameManager.sav.randomIndex
	InventoryManager._remove_item(GameManager.inventoryPackege,InventoryManagerItem.珍品礼盒,1)
	#+5
	var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.黄麻药囊)
	if num>=1:
		GameManager.extraValue=15
		GameManager.isGiftTrigger=true
		AchievementManager.set_achievement("NEW_ACHIEVEMENT_1_1")
		_c.ChangeSupport(30)
	else:
		GameManager.extraValue=0
		GameManager.isGiftTrigger=true
		_c.ChangeSupport(15)
	GameManager.isGiftTrigger=false  # 二次安全清理
	_c.summonNum+=1
	GameManager.sav.hp-=costHp_SummonOne
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"赠礼完成")
	
@onready var send_gift_panel = $sendGiftPanel
#《经济刺激法案》需通过，还剩6天！
	
func sendgiftChoice():
	#var rindex=GameManager.sav.randomIndex
	var _c=getFactionByIndex()

	var to_inventory= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.珍品礼盒)
	var _inventoryManager = get_tree().get_root().get_node("InventoryManager")
	var quantity=_inventoryManager.has_item_quantity(to_inventory)
	if quantity>=1:#拥有礼物
		send_gift_panel.show()
		
		var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.黄麻药囊)
		if num>=1:
			send_gift_panel._initPanel(_c._name,quantity,int(30))	
		else:
			send_gift_panel._initPanel(_c._name,quantity,int(15))	
		#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"消耗资金")#显示对话
	else:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"你没有礼物")#显示对话
var lawName	
var lalongPolicy=0

func _get_needed_law_num_for_courting(lawIndex:int, policyIndex:int)->int:
	var lawPoint:lawpoint=policy_panel.law_panel.get_node("Control"+var_to_str(lawIndex+1)+"-"+var_to_str(policyIndex))
	return _count_needed_law_points(lawPoint, [])

func _count_needed_law_points(point:lawpoint, counted:Array)->int:
	var key=var_to_str(point.num1)+"-"+var_to_str(point.num2)
	if counted.has(key):
		return 0
	counted.append(key)
	var count=0
	if not GameManager.sav.laws[point.num1].has(point.num2):
		count+=1
	for child in point.lawpoins:
		count+=_count_needed_law_points(child, counted)
	return count

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
	var maxLaw=1
	for v in GameManager.sav.laws[lawIndex]:
		if v > 0 and v > maxLaw:
			maxLaw = v
	
	#需要将法律法规+1或者+2
	# 有一堆bug 需要修改，到时候需要判断最大值，最大值后面2个有无元素，如果没有 从余下政策，如果余下政策没有再提示已经满格了
	var unUseArr=[]
	
	var maxSize=0
	if(maxLaw>=8):
		#你的政策槽已满，无法添加新的拉拢政策。
		maxSize=10
		#你当前所有法律已经设置满格了，无法提供额外的法律去拉拢派系
	else:
		maxSize=maxLaw+2
	#+1 or +2
	var currentLawNum=GameManager.LawNum()
	for i in range(1,maxSize):
		var neededLawNum=_get_needed_law_num_for_courting(lawIndex,i)
		if GameManager.sav.laws[lawIndex].has(i)==false and GameManager.sav.laws[lawIndex].has(-i)==false:
			if currentLawNum+neededLawNum<=GameManager.maxLawNum:
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
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"律法齐备无新增空间")#显示对话			
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
		data.summonNum+=1
		GameManager.sav.laws[lawIndex].append(lalongPolicy)
		GameManager.initPaixiFloor(data)
		#initPaixi
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"成功拉拢")#显示对话	
		GameManager.sav.hp-=costHp_SummonOne
	else:
		print("意外拉拢错误，请监察源码")	

func cancelConsent():
	if lalongPolicy != 0:
		var lawIndex= GameManager.getIndexByFractionIndex(_faction)
		GameManager.sav.laws[lawIndex].erase(lalongPolicy)
		lalongPolicy=0
	SummonFaction(_faction)
var ForValueCost=0
var ForValueGet=0

#你通过索取可以获得500金，但会消耗徐州派30点忠诚度，请问是否执行
#索取可获500金，但将消耗徐州派30点忠诚度。是否执行？
func claim():
	var _c=getFactionByIndex()
	var rindex=GameManager.sav.randomIndex
	ForValueCost = int(10 * (1 + max(_c._num_all - 10, 0) * 0.01))+rindex
	ForValueGet=_c._num_all*12
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"索取从派系")


func suppress():

	var _c=getFactionByIndex()
	var suppressCoeff=1.0
	match GameManager.sav.gameDifficulty:
		1: suppressCoeff=0.4
		2: suppressCoeff=0.45
		3: suppressCoeff=0.5
	
	ForValueGet=int(sqrt(100-_c._support_rate)*60*(_c.supressNum+1)*suppressCoeff)
	ForValueCost=int(sqrt(100-_c._support_rate)*110*(_c.supressNum+1)*suppressCoeff)
	#这个可能还高，但是没办法了
	if _c._support_rate>=60:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"贸然镇压")#显示对话
	else:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"决定镇压")#显示对话

func confireSuppress():
	
	#if金额不对，不能增压
	

	
	GameManager._propertyPanel.GetValue(-ForValueCost,0,-ForValueGet)
	ForValueCost=0
	ForValueGet=0
	GameManager.sav.hp-=costHp_SummonOne
	var _c=getFactionByIndex()
	_c.summonNum+=1
	_c._support_rate=100
	_c.isSuppressed=true
	_c.supressNum+=1
	GameManager.awakenDominanceAfterSuppression()
	SignalManager.changeFraction.emit()
	#发一个信号，有派系确认为对你没有敌意的派系
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"镇压成功")#显示对话
func CF_CallingSoldier():
	var _c=getFactionByIndex()
	_c.summonNum+=1
	GameManager.sav.hp-=costHp_SummonOne
	_c.ChangeSupport(-ForValueCost)
	GameManager.sav.labor_force=GameManager.sav.labor_force+ForValueGet
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"调用士兵完成")#显示对话

	
func CF_claim():
	GameManager.sav.hp-=costHp_SummonOne
	var _c=getFactionByIndex()
	_c.ChangeSupport(-ForValueCost)

	_c.summonNum+=1
	#减去资金
	GameManager.sav.coin=GameManager.sav.coin+ForValueGet
	AchievementManager.set_achievement("NEW_ACHIEVEMENT_1_8")
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"索取完成")


#调用可征集500名吕布士兵，但将消耗20点吕布忠诚度。是否执行？
func CallingSoldier():
	var _c=getFactionByIndex()
	var rindex=GameManager.sav.randomIndex	
	ForValueCost = int(10 * (1 + max(_c._num_all - 10, 0) * 0.01))+3*rindex
	ForValueGet=_c._num_all*10
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"征兵从吕布")

	#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"混乱对话结束")#显示对话
func lvbuJoin():
	GameManager.sav.have_event["lvbuJoin"]=true
	GameManager.sav.labor_force=GameManager.sav.labor_force+300
	GameManager.sav.currenceDay=0
	GameManager.changeTaskLabel("歇整一旬来到府邸召见吕布")
	#1

	#觉得无用的注释GameManager.sav.TargetDestination="battle"


func burnSac():
	#pass
	#民心-5
	GameManager.sav.Merit_points+=2
	GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.KESULU]=("")
	GameManager.changePeopleSupport(-5)
	GameManager.sav.have_event["错失锦囊"]=true	

func holdSac():
	#GameManager.sav.have_event["支线触发完毕调查过竹简"]=true
	#增加道具
	GameManager.sav.have_event["获得锦囊"] =true
	var _reward:rewardPanel=PanelManager.new_reward()
	var items={
		"items": {InventoryManagerItem.ItemEnum.黄麻药囊:1},
		"money": 0,
		"population": 0
	}
	GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.KESULU]=tr("携药囊见曹豹，调查张阎毒杀之谜")
	#GameManager.ScoreToItem()
	_reward.showTitileReward(tr("恭喜你，你获得-黄麻药囊"),items)	
	
@onready var factionView= $CanvasLayer/faction
@onready var support_panel: supportPanel = $CanvasLayer/supportPanel

func changePanelPos():
	if factionView==null:
		return
	if GameManager.sav.have_event["canSummonLvbu"]==true:
		factionView.position.y=589#待修改
		support_panel.position.y=742.3#待修改
	elif GameManager.sav.have_event["Factionalization"]==true:
		factionView.position.y=589#待修改
		support_panel.position.y=686#待修改
	else:	
	#f GameManager.sav.
		factionView.position.y=529
	pass

func JudFundTask():
	#在府邸意外凑齐钱时会判断任务是否完成,这个会触发第一次赈灾，这是bug
	if(GameManager.sav.have_event["completeTask1"]==false):#仅完成收集资金任务
		_JudgeTask()


@onready var mizhen: Node2D = $"peoples/糜贞"
const zhen = preload("res://Asset/人物/真糜贞.png")
func jiaMizhenShow():
	mizhen.show()
	mizhen.txt2d=zhen


func haveWaWa()->bool:
	
	var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.血姬傀儡)
	
	return num>=1




func zhangyanCrazy():
	PanelManager.Fade_Blank(Color.RED,0.5,PanelManager.fadeType.fadeIn)
	await 0.5
	PanelManager.Fade_Blank(Color.RED,0.5,PanelManager.fadeType.fadeOut)
	SoundManager.stop_music()
	SoundManager.play_music(sounds._2__MENTAL_VORTEX)
	#屏幕发红
	#音乐切换
	

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



@onready var items_in_scene: Node2D = $itemsInScene


func openBoardGame():
	GameManager.selectBoardCharacter=boardType.boardCharacter.mizhu
	GameManager.showBoardGameDialogue()


func openBoardDialogue():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"进入仕诡牌游戏")


func boardVictory():

	if GameManager._boardReward==boardType.boardRewardResult.item:
		var _reward:rewardPanel=PanelManager.new_reward()
	
		var items={
			"items": null,
			"money": 50,
			"population": 0
		}

		_reward.showTitileReward(tr("你战胜了糜竺"),items)	
	elif GameManager._boardReward==boardType.boardRewardResult.card:
		var _reward:rewardPanel=PanelManager.new_reward()
	
		var items={
			"items": {InventoryManagerItem.ItemEnum.仕诡卡血姬:1},
			"money": 0,
			"population": 0
		}
		_reward.showTitileReward(tr("你战胜了糜竺"),items)	
	elif GameManager._boardReward==boardType.boardRewardResult.BreakFree:
		pass
	GameManager._boardReward=boardType.boardRewardResult.none

	

func updateInfrastruture():
	GameManager.sav.have_event["基建项目开启"]=true 
	#当前目标改成both
	#设立目标完成
	GameManager.sav.targetValue=2000
	GameManager.sav.currenceValue=0

	GameManager.sav.targetResType=GameManager.ResType.construct	
	GameManager.sav.targetTxt="征集民夫数量：{currence1}/{target}\n基建工程数量：{currence2}/3"	
	
	#如果民夫完成前往府邸

#黑暗游戏输了游戏	
func cardLose():
	GameManager.sav.hp=0

@onready var puzzle_game: Control = $CanvasLayer/puzzleGame
func loseGame():
	puzzle_game.loseGameBtn()
func confirmBuild():
	GameManager.sav.coin-=GameManager.puzzleCostMoney
	GameManager.sav.labor_force-=GameManager.puzzleCostPeople
	puzzle_game.initGame()	
	if GameManager.sav.have_event["基建运粮教程"]==false:
		DialogueManager.show_example_dialogue_balloon(GameManager.sys,"基建运粮车教程")
		GameManager.sav.have_event["基建运粮教程"]=true	

func returnMain():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"来把仕诡牌")	


func succussAfter():
	pass
	
	
func lvbuhave_seat():
	lvbuc.position=Vector2(312,-15)
	pass
	
func hidePeople():
	mizhu.hide()

func showPeople():
	mizhu.show()
