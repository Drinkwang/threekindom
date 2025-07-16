extends baseComponent
@onready var control = $Control
const FancyFade = preload("res://addons/transitions/FancyFade.gd")
#var destination:String #放在gameins里面
@onready var scholar = $CanvasLayer/scholar
@onready var shop_panel = $CanvasLayer/shopPanel
const xiaopeiBuild = preload("res://Asset/城镇建筑/集市1.png")
const newBuild = preload("res://Asset/城镇建筑/集市2.png")
@onready var bg = $"内饰"
# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.currenceScene=self
	if GameManager.sav.have_event["initXuzhou"]==true:
		bg.texture=newBuild
	else:
		bg.texture=xiaopeiBuild
	#方便测试,可能会删？我第一次看到方便测试很迷惑
	GameManager.sav.have_event["firstmeetchenqun"]=true

	SignalManager.endReward.connect(_bossMode)
	super._ready()
	Transitions.post_transition.connect(post_transition)
	control.buttonClick.connect(_buttonListClick)


	
	pass # Replace with function body.

func streetTwo():
	control.show()
	control._show_button_5_yellow(4)	
	pass

func streetThree():
	pass
	
const MINISTREET = preload("res://Asset/bgm/ministreet.wav")
#const 街道 = preload("res://Asset/bgm/街道.mp3")	"res://Asset/bgm/ministreet.wav"
func post_transition():
	GameManager.CanClickUI=true
	#print("fadedone")
	_initData()
	SoundManager.play_ambient_sound(MINISTREET)
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
			control._show_button_5_yellow(4)
	if GameManager.sav.day==4:
		GameManager.sav.destination="城门-军事驻地"
		control._show_button_5_yellow(4)
		#拜访大儒
		pass		
	
	
func _initData():
	
	
	#	"锦囊咨询丹阳派": false, #如果上个为true，到演武场，则令曹豹出现，并可以点击触发支线
	#卖粮第几天
	#"支线触发完毕获得骨杖":false,#
	#0改成最终触发条件，这个应该是
	if GameManager.sav.finalKeChoice!=-1 and GameManager.sav.have_event["锦囊咨询丹阳派"]==true and GameManager.sav.have_event["支线触发完毕获得骨杖"]==false:
		GameManager.sav.have_event["支线触发完毕获得骨杖"]=true
		var keValue=GameManager.sav.finalKeChoice
		if keValue==0:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"选项克苏鲁诱饵")
		elif keValue==1:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"选项克苏鲁追杀")
		return #选选项，另外点击百姓
	var initData=[
	{	
		"id":"1",
		"context":"府邸", #前往小道通向议事厅 
		"visible":"true",
		"tooltip":"前往府邸进行办公"
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
	#{
		#"id":"5",
		#"context":"军事商店",#打开属性ui
		#"visible":"true"
	#},
	{
		"id":"6",
		"context":"城门-军事驻地", #天数加1 进入过度
		"visible":"true"
	}]
	
	
	if(GameManager.hearsayID>0):
		GameManager.hearsayID=-1
		shop_panel.show()
	

	control._processList(initData)
	if GameManager.hearsayBeforeNode==SceneManager.roomNode.Shop:
		shop_panel.show()
		GameManager.hearsayBeforeNode=null
		
	
func HuntdownKe():
	var _reward:rewardPanel=PanelManager.new_reward()
	var items={
		"items": {InventoryManagerItem.ItemEnum.饥蛊骨签:1},
		"money": 0,
		"population": 0
	}
	#GameManager.ScoreToItem()
	_reward.showTitileReward(tr("恭喜你，你获得-饥蛊骨签"),items)	

func SurrenderKe():
	GameManager.changePeopleSupport(-20)
	#民心-20	
#const HOUSE = preload("res://Scene/house.tscn")
#const BOULEUTERION = preload("res://Scene/Bouleuterion.tscn")
func _buttonListClick(item):

	if(GameManager.sav.destination.length()>0):
		if(GameManager.sav.destination!=item.context and item.context!="商店"):
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
		elif GameManager.sav.destination==item.context:
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
		if GameManager.sav.day<5:
			if GameManager.sav.have_event["小沛第一次见商人"]==false:
				GameManager.sav.have_event["小沛第一次见商人"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"大人还没有开张呢")
			else:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"商人已经走了")
		else:
			if GameManager.sav.have_event["徐州第一次见商人"]==false:
				GameManager.sav.have_event["徐州第一次见商人"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"徐州第一次关顾")
			else:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"徐州多次光顾")	
			#第一次开张
			shop_panel.show()
			shop_panel.initData()
		pass
		#打开商店ui
		#scene=GOVERNMENT_BUILDING
	elif item.context == "军事商店":
		pass
		##打开商店ui换皮或者换页
	elif item.context=="城门-军事驻地":
		if(GameManager.sav.day>=4):

			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"selectOutSide")
			
		else:
			visitDrill()
		


const WASTELAND_0 = preload("res://Asset/bgm/wasteland0.wav")
func gotoWasteland():
	PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeIn)
	SoundManager.play_ambient_sound(WASTELAND_0)
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"探访荒地")
	#显示黑屏
	#播放荒地音效


func gotoTomb():
	GameManager.initBattle()
	PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeIn)
	SoundManager.play_ambient_sound(WASTELAND_0)
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"初次见面_陶谦")
	await 0.5
	PanelManager.Fade_Blank(Color.BLACK,0,PanelManager.fadeType.fadeOut)
	blank.show()
	taoqian.show()
@onready var blank = $CanvasLayer/blank
@onready var taoqian = $CanvasLayer/blank/taoqian
@onready var mizhen = $CanvasLayer/blank/mizhen
@onready var battle_pane = $CanvasLayer/blank/battlePane

func gotoMiMasion():
	GameManager.initBattle()
	#清空战斗面板，做记录，临时
	PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeIn)
	SoundManager.play_ambient_sound(WASTELAND_0)
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"初次见面_血姬")
	await 0.5
	PanelManager.Fade_Blank(Color.BLACK,0,PanelManager.fadeType.fadeOut)
	blank.show()
	mizhen.show()
func gotoHuangDiMiao():
	GameManager.initBattle()
	PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeIn)
	SoundManager.play_ambient_sound(WASTELAND_0)
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"初次见面_骨龙")
	
func PlayMizhen():
	var lady = load("res://Asset/vedio/bloodLady.ogv")
	#不能这样写，因为boss战
	var _func=func():
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"动画播完_血姬")
		battle_pane.show()
		battle_pane.enterBattleMi()
	playBossAni(lady,_func)


func enterBattleMi():
	pass

func enterBattleTao():
	pass
	

@onready var bit_player = $CanvasLayer/blank/bitPlayer

func PlayTaoQian():
	var tao = load("res://Asset/vedio/bloodTao.ogv")
	var _func=func():
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"动画播完_陶谦")
		battle_pane.show()
		battle_pane.enterBattleTao()
	playBossAni(tao,_func)


func _on_video_player_finished():
	bit_player.hide()


func playBossAni(value,lambda:Callable):
	bit_player.show()
	bit_player.stream=value
	bit_player.play()
	bit_player.finished.connect(func():
		_on_video_player_finished()
		if lambda.is_valid():  # 检查 lambda 是否有效
			lambda.call()
		)
func showFirstGuild():
	control.show()
	control._show_button_5_yellow(0)
	
	#$"陈群".hide()
	pass



func merchantSendGift():
	var _reward:rewardPanel=PanelManager.new_reward()
	var items=GameManager.ScoreToItem(1000)
	items.money=0
	items.population=0
	_reward.showTitileReward(tr("你从商人那边获得如下道具"),items)


func visitDrill():
	if GameManager.sav.day==4:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"tip_scholar")
	else:
		SceneManager.changeScene(SceneManager.roomNode.DRILL_GROUND,2)
	
const visitbgm = preload("res://Asset/bgm/拜访大儒.wav")
func visitScholar():
	
	if GameManager.sav.isVisitScholar==true:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"已经大儒辩经内容")
		return
	
	if await GameManager.isTried(50):
		return 	
	SoundManager.play_ambient_sound(visitbgm)
	#PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeInAndOut)
	PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeIn)
	
	await 0.5
	#第一次访问显示大儒辩经
	#播放高山流水音效
	#离开大儒辩经，取消高山流水音效
	if GameManager.sav.have_event["firstVisitScholarsEnd"]==false:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"大儒辩经的剧情")
	if GameManager.sav.have_event["大儒支线1"]==true and GameManager.sav.have_event["大儒辩经启动词1"]==false:
		GameManager.sav.have_event["大儒辩经启动词1"]=true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"大儒辩经支线1")
	elif GameManager.sav.have_event["大儒支线2"]==true and GameManager.sav.have_event["大儒辩经启动词2"]==false:	
		GameManager.sav.have_event["大儒辩经启动词2"]=true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"大儒辩经支线2")		
	elif GameManager.sav.have_event["大儒支线3"]==true and GameManager.sav.have_event["大儒辩经启动词3"]==false:
		GameManager.sav.have_event["大儒辩经启动词3"]=true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"大儒辩经支线3")
	else:
		var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.治国箴言)	
		if num>=1:
		#有道具和无道具			
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"大儒辩经的剧情3")
		elif num<1 and GameManager.sav.have_event["大儒辩经完成"]==true:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"下次前来大儒辩经")
		else:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"大儒辩经的剧情2")
	#SceneManager.changeScene(SceneManager.roomNode.DRILL_GROUND,2)
		

func getScholarReward1():
	var _reward:rewardPanel=PanelManager.new_reward()
	var items={
		"items": {InventoryManagerItem.ItemEnum.论语简注:1},
		"money": 0,
		"population": 0
	}
	#GameManager.ScoreToItem()
	_reward.showTitileReward(tr("恭喜你，你获得-论语简注"),items)	
func getScholarReward2():
	var _reward:rewardPanel=PanelManager.new_reward()
	var items={
		"items": {InventoryManagerItem.ItemEnum.礼记笺疏:1},
		"money": 0,
		"population": 0
	}
	#GameManager.ScoreToItem()
	_reward.showTitileReward(tr("恭喜你，你获得-礼记笺疏"),items)	
	
func getScholarReward3Before():
	GameManager.sav.have_event["大儒辩经完成"]=true	
	
	
func getScholarReward3():
	var _reward:rewardPanel=PanelManager.new_reward()
	var items={
		"items": {InventoryManagerItem.ItemEnum.治国箴言:1},
		"money": 0,
		"population": 0
	}
	#GameManager.ScoreToItem()
	_reward.showTitileReward(tr("恭喜你，你获得-治国箴言"),items)	
	await SignalManager.endReward
	GameManager.sav.coinGet+=100
	GameManager.sav.labor_DayGet+=50
	GameManager.changePeopleSupport(10)
	showbianji()

func holdWoolden():
	playStageMusic()
	PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeOut)
	GameManager.sav.have_event["支线触发完毕调查过竹简"]=true
	#增加道具
	var _reward:rewardPanel=PanelManager.new_reward()
	var items={
		"items": {InventoryManagerItem.ItemEnum.迷魂木筒:1},
		"money": 0,
		"population": 0
	}
	#GameManager.ScoreToItem()
	_reward.showTitileReward(tr("恭喜你，你获得-道具竹简"),items)	
	#reward获得
func BurySheep():
	playStageMusic()
	PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeOut)
	GameManager.changePeopleSupport(-10)
	GameManager.sav.have_event["支线触发完毕调查过竹简"]=true

func playStageMusic():
	#SoundManager.stop_music()
	SoundManager.play_ambient_sound(MINISTREET)	
	
func showbianji():
	PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeOut)
	scholar.visible=true
	
func bianjiEnd():
	control._show_button_5_yellow(1)
	GameManager.sav.destination="自宅"
	
	
func getXueJiItem():
	var _reward:rewardPanel=PanelManager.new_reward()
	var items={
		"items": {InventoryManagerItem.ItemEnum.血姬傀儡:1},
		"money": 0,
		"population": 0
	}
	#GameManager.ScoreToItem()
	bossBattleAfter=true
	GameManager.sav.maxHP=120
	_reward.showTitileReward(tr("恭喜你，你获得-血姬傀儡"),items)	
# Called every frame. 'delta' is the elapsed time since the previous frame.

var bossBattleAfter=false

func getDaoQianItem():
	
	var _reward:rewardPanel=PanelManager.new_reward()
	var items={
		"items": {InventoryManagerItem.ItemEnum.陶谦血袖:1},
		"money": 0,
		"population": 0
	}
	#GameManager.ScoreToItem()
	bossBattleAfter=true
	_reward.showTitileReward(tr("恭喜你，你获得-陶谦血袖"),items)		

func _bossMode():
	if bossBattleAfter==false:
		print("陶谦任务取消发动")
		return
	#挑战完boss后触发，可能没触发
	bossBattleAfter=true
	var to_inventory_xue= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.血姬傀儡)
	var to_inventory_tao= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.陶谦血袖)
	var xue_quantity=InventoryManager.has_item_quantity(to_inventory_xue)
	var tao_quantity=InventoryManager.has_item_quantity(to_inventory_tao)
	
	#改成判断持有的道具
	if tao_quantity>0:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗胜利_陶谦结算")
	elif xue_quantity>0:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗胜利_血姬结算")	
	#GameManager.bossmode=SceneManager.bossMode.none

func _process(delta):
	pass

func confireSold():
	shop_panel.confireSold()


func settleAfter():
	shop_panel.settleAfter()


func sideQuestReturnG(iswin):
	battle_pane.sideQuestReturnG(iswin)
func sideQuestReturnT(iswin):
	battle_pane.sideQuestReturnT(iswin)
