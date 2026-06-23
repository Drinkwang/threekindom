extends baseComponent
@onready var control = $Control
const FancyFade = preload("res://addons/transitions/FancyFade.gd")
#var destination:String #放在gameins里面
@onready var scholar = $CanvasLayer/scholar
@onready var shop_panel = $CanvasLayer/shopPanel
const xiaopeiBuild = preload("res://Asset/城镇建筑/集市1.png")
const newBuild = preload("res://Asset/城镇建筑/集市2.png")
@onready var bg = $"内饰"
@onready var zhenren: Node2D = $CanvasLayer/blank/zhenren


@onready var node_2d_store: _cget_scene_item = $itemsInScene/Node2D_store
@onready var node_2d_bamboo: _cget_scene_item = $itemsInScene/Node2D_bamboo

const wudasha = preload("res://Asset/城镇建筑/夜晚街头无打杀.png")
const dashabg = preload("res://Asset/城镇建筑/洛阳街头.png")
const BLANK_BACKGROUND_DIR = "res://Asset/城镇建筑/out/"
const BLANK_BACKGROUND_EXT = ".png"
const BLANK_EYE_OPEN_TIME = 1.0
const BLANK_FADE_OUT_TIME = 0.18
const BLANK_HOLD_BLACK_TIME = 0.08
var blank_eye_top: ColorRect
var blank_eye_bottom: ColorRect
var blank_background_shake_tween: Tween
var blank_background_origin_position := Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.currenceScene=self
	if GameManager.sav.finalKeChoice!=-1 and GameManager.sav.have_event["锦囊咨询丹阳派"]==true and GameManager.sav.have_event["支线触发完毕获得骨杖"]==false:
		bg.texture=wudasha
		#881 667
		if GameManager.sav.finalKeChoice==0:
			people.position=Vector2(881,667)
	elif GameManager.sav.have_event["initXuzhou"]==true and GameManager.sav.endPath!=GameManager.endPath.xiaopei:
		bg.texture=newBuild
		node_2d_store.position=Vector2(584,100)
		node_2d_bamboo.position=Vector2(305,280)

	else:
		bg.texture=xiaopeiBuild
		node_2d_store.position=Vector2(914,91)
		node_2d_bamboo.position=Vector2(1188,524)
	#方便测试,可能会删？我第一次看到方便测试很迷惑
	
	
	
	GameManager.sav.have_event["firstmeetchenqun"]=true

	SignalManager.endReward.connect(_bossMode)
	super._ready()
	Transitions.post_transition.connect(post_transition)
	control.buttonClick.connect(_buttonListClick)

	#blackMistDissolve()
	
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
	
@onready var tsty: Node2D = $CanvasLayer/tsty
@onready var chop_animation: AnimationPlayer = $CanvasLayer/Sprite2D/AnimationPlayer
@onready var sword_sprite_2d: Sprite2D = $CanvasLayer/Sprite2D

const HUI_3 = preload("res://Asset/sound/hui3.wav")	
func tstyDie():
	
	sword_sprite_2d.show()
	chop_animation.play("chop")
	
	
	
	




	SoundManager.play_sound(HUI_3)


	var _func=func(stringname):
		sword_sprite_2d.hide()
		var tween=get_tree().create_tween()
		SoundManager.stop_sound(HUI_3)
		
		SoundManager.play_sound(sounds.BLOODCC_1)
		tween.tween_property(tsty, "modulate:a",0, 2)
		
		#播放tsty透明度隐藏动画
	chop_animation.animation_finished.connect(_func)
	
	


func zhangyanDie():
	#PanelManager.Fade_Blank(Color.RED,0.5,PanelManager.fadeType.fadeIn)
	#await 0.5
	PanelManager.Fade_Blank(Color.RED,0.5,PanelManager.fadeType.fadeOut)
	#播放红光和抹脖子音效
	bg.texture=dashabg
	pass
	
	
func baseComplete():
	GameManager.sav.TargetDestination="府邸"
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
		
	if (GameManager._boardReward==boardType.boardRewardResult.BreakFree or GameManager._boardGameWin==false) and GameManager._boardMode==boardType.boardMode.high and GameManager.selectBoardCharacter==boardType.boardCharacter.caobao:
		GameManager._boardReward==boardType.boardRewardResult.none
		GameManager.selectBoardCharacter=boardType.boardCharacter.none
		GameManager._boardMode=boardType.boardMode.none
		GameManager.resumeMusic()
		
		if GameManager._boardGameWin==true:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"黑商输掉")
		else:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"玩家终局输掉")
	else:
		
		#加个xxx 需要执行完3天后才能遇到诡异牌
		
		if GameManager.sav.day>=5 and GameManager.sav.have_event["玄阴开放"]==false:
			people.changeAllClick("玄阴秘境")
			people.showEX=true
			people.show()
		if GameManager.sav.day>=5 and GameManager.sav.XuanyinDay>=3:	
			if GameManager.sav.caobaocardgame==-1 and GameManager.sav.mizhucardgame==-1 and  GameManager.sav.chendencardgame==-1:
				people.changeAllClick("遇到诡异牌1")
				people.showEX=false
				people.show()
			if GameManager.sav.caobaocardgame==1 and GameManager.sav.mizhucardgame==1 and  GameManager.sav.chendencardgame==1:
				people.changeAllClick("遇到诡异牌2")
				people.showEX=false
				people.show()
			if GameManager.sav.caobaocardgame==3 and GameManager.sav.mizhucardgame==3 and  GameManager.sav.chendencardgame==3:
				people.changeAllClick("遇到诡异牌3")
				people.showEX=false
				people.show()	
		if 	GameManager.sav.have_event["庆功宴结束"]==true and GameManager.sav.currenceValue>=1 and GameManager.sav.have_event["新剧情_基建开始"]==false:
			people.changeAllClick("基建前置剧情")
			people.showEX=true
			people.show()		
		if GameManager.sav.have_event["基建项目开启"]==true and GameManager.getConstructValue()>=3 and GameManager.sav.have_event["三基建完成"]==false:
			GameManager.sav.have_event["三基建完成"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"基建完成提示")
			
#-1 0 小试牛刀开启 1小试牛刀通过 2 对局试炼开启 3对局试验通过 4 诡秘怪谈开启 5诡秘怪谈通过		
	var initData=[
	{	
		"id":"1",
		"context":"府邸", #前往小道通向议事厅 
		"visible":"true",
		#"tooltip":"前往府邸进行办公"
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
		res_panel.position.x=1564
		res_panel.position.y=803
		res_panel.scale=Vector2(0.765,0.765)	

	control._processList(initData)
	items_in_scene.showItems()
	if GameManager.hearsayBeforeNode==SceneManager.roomNode.Shop:
		shop_panel.show()
		GameManager.hearsayBeforeNode=null
		
@onready var merchant: Node2D = $CanvasLayer/blank/merchant

func constructBefore():
	GameManager.sav.have_event["新剧情_基建开始"]=true
	GameManager.sav.TargetDestination=tr("请前往府邸触发下一阶段剧情")
	GameManager.sav.targetTxt=tr("请前往府邸触发下一阶段剧情")
	#GameManager.sav.currenceValue=1
	#people.hide()

func getXuanYin():
	resetResPanel()
	var _reward:rewardPanel=PanelManager.new_reward()
	var items={
		"items": {InventoryManagerItem.ItemEnum.玄阴玉符:1},
		"money": 0,
		"population": 0
	}
	GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.BADAO]=""
	_reward.showTitileReward(tr("恭喜你，你从黑商手中获得-玄阴玉符"),items)	
	GameManager.sav.have_event["获得玄阴"]=true
	
func HuntdownKe():
	var _reward:rewardPanel=PanelManager.new_reward()
	var items={
		"items": {InventoryManagerItem.ItemEnum.饥蛊骨签:1},
		"money": 0,
		"population": 0
	}
	#GameManager.ScoreToItem()
	_reward.showTitileReward(tr("恭喜你，你获得-饥蛊骨签"),items)
	GameManager.sav.have_event["获得古棒"]=true
	_initData()
	#执行完返回府邸有新动画

func SurrenderKe():
	GameManager.changePeopleSupport(-20)
	_initData()
	#执行完返回府邸有新动画
	#民心-20	
#const HOUSE = preload("res://Scene/house.tscn")


@onready var res_panel: propertyPanel = $CanvasLayer/resPanel

func miniResScale():
	res_panel.position.x=1564
	res_panel.position.y=803
	res_panel.scale=Vector2(0.765,0.765)	

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

			#miniResScale()
			if GameManager.sav.have_event["boss战开始"]==true and GameManager.sav.caobaocardgame==4:
				if await GameManager.isTried(20):
					return 		
				SoundManager.stop_music()
				SoundManager.play_music(sounds._2__MENTAL_VORTEX)
				
				
				
				if GameManager.sav.have_event["遇见黑商"]==false:
					GameManager.sav.have_event["遇见黑商"]=true
					#PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeOut)
					#blank.show()
				#播放诡秘的曲子
					#merchant.show()
					DialogueManager.show_example_dialogue_balloon(dialogue_resource,"决战黑商boss战")
				else:
					enterBlackMerchant()	
			else:
				showPanelPage()
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

func enterBlackMerchant():
	PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeOut)
	blank.show()
				


	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"决战黑商boss战2")
		
func showPanelPage():
	if GameManager.sav.have_event["徐州第一次见商人"]==false:
		GameManager.sav.have_event["徐州第一次见商人"]=true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"徐州第一次关顾")
		shop_panel.show()
		shop_panel.initData()
	elif GameManager.sav.endPath==GameManager.endPath.xiaopei and GameManager.sav.have_event["小沛再见商人"]==false:
		GameManager.sav.have_event["小沛再见商人"]=true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"商人回归小沛")
		shop_panel.show()
		shop_panel.initData()
	else:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"徐州多次光顾")	
				#第一次开张
		shop_panel.show()
		shop_panel.initData()

func finalBoardGame():
	GameManager._boardMode=boardType.boardMode.high
	GameManager.selectBoardCharacter=boardType.boardCharacter.caobao
	SceneManager.changeScene(SceneManager.roomNode.BoardGame,2)
	
func cancelBlankMerchant():
	clearBlankBackground()
	GameManager.resumeMusic()
	blank.hide()
	merchant.hide()
	#resetResPanel()

const DUNGEON_3 = preload("res://Asset/bgm/dungeon3.wav")
const WASTELAND_0 = preload("res://Asset/bgm/wasteland0.wav")
func gotoWasteland():
	PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeIn)
	SoundManager.play_ambient_sound(WASTELAND_0)
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"探访荒地")
	#显示黑屏
	#播放荒地音效


func gotoTomb():
	if await GameManager.isTried(90):
		return
	GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.CHENDENG]=tr("")
	GameManager.initBattle()
	PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeIn)
	SoundManager.play_ambient_sound(WASTELAND_0)
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"初次见面_陶谦")
	#await 0.5
	#PanelManager.Fade_Blank(Color.BLACK,0,PanelManager.fadeType.fadeOut)
	#blank.show()
	#taoqian.show()
@onready var blank = $CanvasLayer/blank
@onready var blank_background: TextureRect = $CanvasLayer/blank/blankBackground
@onready var taoqian = $CanvasLayer/blank/taoqian
@onready var mizhen = $CanvasLayer/blank/mizhen
@onready var gulong: Node2D = $CanvasLayer/blank/gulong


@onready var battle_pane = $CanvasLayer/blank/battlePane

func gotoMiMasion():
	if await GameManager.isTried(90):
		return
	GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.MIZHU]=tr("")
	GameManager.initBattle()
	#清空战斗面板，做记录，临时
	PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeIn)
	SoundManager.play_ambient_sound(WASTELAND_0)
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"初次见面_血姬")
func gotoHuangDiMiao():
	if await GameManager.isTried(90):
		return
	GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.CAOBAO]=tr("")
	GameManager.initBattle()
	PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeIn)
	SoundManager.play_ambient_sound(DUNGEON_3)
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"初次见面_镇魂龙")
	
	
	#await 0.5
	#PanelManager.Fade_Blank(Color.BLACK,0,PanelManager.fadeType.fadeOut)
	
	#blank.show()
	#gulong.show()


	
func PlayMizhen():
	var lady = load("res://Asset/vedio/bloodLady.ogv")
	#不能这样写，因为boss战
	var _func=func():

		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"动画播完_血姬")
		battle_pane.show()
		battle_pane.enterBattleMi()
	playBossAni(lady,_func)



	

@onready var bit_player = $CanvasLayer/blank/bitPlayer

func PlayTaoQian():
	SoundManager.stop_music()
	var tao = load("res://Asset/vedio/bloodTao.ogv")
	var _func=func():

		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"动画播完_陶谦")
		battle_pane.show()
		battle_pane.enterBattleTao()
	playBossAni(tao,_func)



func PlayGulong():
	var tao = load("res://Asset/vedio/GULONGTEST.ogv")
	var _func=func():

		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"动画播完_镇魂龙")
		battle_pane.show()
		battle_pane.enterBattleHuang()
	playBossAni(tao,_func)


func _on_video_player_finished():
	bit_player.hide()


func playBossAni(value,lambda:Callable):
	bit_player.show()
	res_panel.hide()
	bit_player.stream=value
	bit_player.play()
	bit_player.finished.connect(func():
		res_panel.show()
		res_panel.position.x=1564
		res_panel.position.y=803
		res_panel.scale=Vector2(0.765,0.765)
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
		#bug
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"大儒辩经的剧情")
	elif GameManager.sav.have_event["大儒支线1"]==true and GameManager.sav.have_event["大儒辩经启动词1"]==false:
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
	GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.DARU]=""
	#GameManager.ScoreToItem()
	_reward.showTitileReward(tr("恭喜你，你获得-论语简注"),items)	
func getScholarReward2():
	var _reward:rewardPanel=PanelManager.new_reward()
	var items={
		"items": {InventoryManagerItem.ItemEnum.礼记笺疏:1},
		"money": 0,
		"population": 0
	}
	GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.DARU]=""
	#GameManager.ScoreToItem()
	_reward.showTitileReward(tr("恭喜你，你获得-礼记笺疏"),items)	
	
func getScholarReward3Before():
	GameManager.sav.have_event["大儒辩经完成"]=true	
	GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.DARU]=""
	
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
	GameManager.sav.summonMaxNum=2
	#GameManager.changePeopleSupport(10)
	showbianji()

func holdWoolden():
	playStageMusic()
	PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeOut)
	clearBlankBackground()
	GameManager.sav.have_event["支线触发完毕调查过竹简"]=true
	GameManager.sav.have_event["获得过木桶标记"]=true
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
	GameManager.sav.Merit_points+=3
	playStageMusic()
	PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeOut)
	clearBlankBackground()
	GameManager.changePeopleSupport(-10)
	GameManager.sav.have_event["支线触发完毕调查过竹简"]=true
	GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.KESULU]=""
	
	GameManager.sav.have_event["错失木桶"]=true
	
func playStageMusic():
	SoundManager.stop_all_ambient_sounds()
	SoundManager.play_ambient_sound(MINISTREET)	

func _ensure_blank_eye_nodes():
	if blank_eye_top == null or not is_instance_valid(blank_eye_top):
		blank_eye_top = ColorRect.new()
		blank_eye_top.name = "blankEyeTop"
		blank_eye_top.mouse_filter = Control.MOUSE_FILTER_IGNORE
		blank_eye_top.color = Color.BLACK
		blank_eye_top.visible = false
		blank_eye_top.z_index = 1000
		blank.add_child(blank_eye_top)
	if blank_eye_bottom == null or not is_instance_valid(blank_eye_bottom):
		blank_eye_bottom = ColorRect.new()
		blank_eye_bottom.name = "blankEyeBottom"
		blank_eye_bottom.mouse_filter = Control.MOUSE_FILTER_IGNORE
		blank_eye_bottom.color = Color.BLACK
		blank_eye_bottom.visible = false
		blank_eye_bottom.z_index = 1000
		blank.add_child(blank_eye_bottom)

func _blank_rect_size() -> Vector2:
	var rect_size = blank.size
	if rect_size.x <= 0 or rect_size.y <= 0:
		rect_size = get_viewport().get_visible_rect().size
	return rect_size

func _layout_blank_reveal_nodes():
	var rect_size = _blank_rect_size()
	if blank_eye_top != null:
		blank_eye_top.position = Vector2.ZERO
		blank_eye_top.size = Vector2(rect_size.x, rect_size.y * 0.5)
	if blank_eye_bottom != null:
		blank_eye_bottom.position = Vector2(0, rect_size.y * 0.5)
		blank_eye_bottom.size = Vector2(rect_size.x, rect_size.y * 0.5)

func _blank_background_path(background_name: String) -> String:
	if background_name.begins_with("res://"):
		return background_name
	if background_name.get_extension().length() > 0:
		return BLANK_BACKGROUND_DIR + background_name
	return BLANK_BACKGROUND_DIR + background_name + BLANK_BACKGROUND_EXT

func _set_blank_background(background_name: String) -> bool:
	if blank_background == null:
		blank_background = blank.get_node_or_null("blankBackground") as TextureRect
	if blank_background == null:
		blank_background = TextureRect.new()
		blank_background.name = "blankBackground"
		blank_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
		blank_background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		blank_background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		blank_background.visible = false
		blank_background.size = _blank_rect_size()
		blank.add_child(blank_background)
		blank.move_child(blank_background, 0)
	blank_background_origin_position = blank_background.position
	var path = _blank_background_path(background_name)
	if not ResourceLoader.exists(path):
		push_warning("blank background not found: " + path)
		return false
	blank_background.texture = load(path)
	blank_background.visible = true
	return true

func openEyesToBlankBackground(background_name: String, duration: float = BLANK_EYE_OPEN_TIME):
	await get_tree().create_timer(0.5).timeout
	if not _set_blank_background(background_name):
		return
	blank.show()
	blank.color = Color(0, 0, 0, 0)
	blank_background.show()
	_ensure_blank_eye_nodes()
	_layout_blank_reveal_nodes()
	blank_eye_top.visible = true
	blank_eye_bottom.visible = true
	PanelManager.Fade_Blank(Color.BLACK, BLANK_FADE_OUT_TIME, PanelManager.fadeType.fadeOut)
	await get_tree().create_timer(BLANK_FADE_OUT_TIME + BLANK_HOLD_BLACK_TIME).timeout
	var rect_size = _blank_rect_size()
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(blank_eye_top, "size:y", 0.0, duration)
	tween.tween_property(blank_eye_bottom, "position:y", rect_size.y, duration)
	tween.tween_property(blank_eye_bottom, "size:y", 0.0, duration)
	await tween.finished
	blank_eye_top.visible = false
	blank_eye_bottom.visible = false

func showBlankBackground(background_name: String):
	if not _set_blank_background(background_name):
		return
	blank.show()
	blank.color = Color(0, 0, 0, 0)
	_layout_blank_reveal_nodes()

func startBlankBackgroundShake(strength: float = 18.0, step_time: float = 0.045):
	if blank_background == null:
		blank_background = blank.get_node_or_null("blankBackground") as TextureRect
	if blank_background == null:
		push_warning("blankBackground node not found under street blank")
		return
	stopBlankBackgroundShake(false)
	blank_background_origin_position = blank_background.position
	blank_background_shake_tween = get_tree().create_tween()
	blank_background_shake_tween.set_loops()
	blank_background_shake_tween.tween_property(blank_background, "position", blank_background_origin_position + Vector2(-strength, -strength * 0.35), step_time)
	blank_background_shake_tween.tween_property(blank_background, "position", blank_background_origin_position + Vector2(strength, strength * 0.25), step_time)
	blank_background_shake_tween.tween_property(blank_background, "position", blank_background_origin_position + Vector2(-strength * 0.45, strength * 0.35), step_time)
	blank_background_shake_tween.tween_property(blank_background, "position", blank_background_origin_position + Vector2(strength * 0.35, -strength * 0.25), step_time)

func stopBlankBackgroundShake(reset_position: bool = true):
	if blank_background_shake_tween != null:
		blank_background_shake_tween.kill()
		blank_background_shake_tween = null
	if reset_position and blank_background != null:
		blank_background.position = blank_background_origin_position

func changeBlankBackground(background_name: String, duration: float = 0.6):
	if blank_background == null:
		blank_background = blank.get_node_or_null("blankBackground") as TextureRect
	if blank_background == null:
		push_warning("blankBackground node not found under street blank")
		return
	var path = _blank_background_path(background_name)
	if not ResourceLoader.exists(path):
		push_warning("blank background not found: " + path)
		return
	if duration>0:
		blank.show()
		blank.color = Color(0, 0, 0, 0)
		blank_background.visible = true
		var cover = ColorRect.new()
		cover.name = "blankBackgroundTransition"
		cover.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cover.color = Color(0, 0, 0, 0)
		cover.position = Vector2.ZERO
		cover.size = _blank_rect_size()
		cover.z_index = 900
		blank.add_child(cover)
		var half_time = max(duration * 0.5, 0.01)
		var tween = get_tree().create_tween()
		tween.tween_property(cover, "color:a", 1.0, half_time)
		tween.tween_callback(func():
			blank_background.texture = load(path)
		)
		tween.tween_property(cover, "color:a", 0.0, half_time)
		tween.tween_callback(cover.queue_free)
		await tween.finished
	else:
		blank_background.texture = load(path)
func clearBlankBackground(hide_blank: bool = true):
	resetResPanel()
	stopBlankBackgroundShake()
	if blank_background != null:
		blank_background.visible = false
	if blank_eye_top != null:
		blank_eye_top.visible = false
	if blank_eye_bottom != null:
		blank_eye_bottom.visible = false
	blank.color = Color.BLACK
	if hide_blank:
		blank.hide()
	
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
	GameManager.sav.have_event["获得娃娃"]=true
	
	bossBattleAfter=true
	GameManager.sav.maxHP=120
	_reward.showTitileReward(tr("恭喜你，你获得-血姬傀儡"),items)	
# Called every frame. 'delta' is the elapsed time since the previous frame.

var bossBattleAfter=false


func gotoXuanyin():
	SoundManager.stop_music()
	PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeIn)
	SoundManager.play_ambient_sound(WASTELAND_0)
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"探访玄阴")


func getDaoQianItem():
	var _reward:rewardPanel=PanelManager.new_reward()
	var items={
		"items": {InventoryManagerItem.ItemEnum.陶谦血袖:1},
		"money": 0,
		"population": 0
	}
	#GameManager.ScoreToItem()
	bossBattleAfter=true
	GameManager.sav.have_event["获得血袖"]=true
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
	#if GameManager.winGulong==true:
	#	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗胜利_镇魂龙")
	#	return
	#改成判断持有的道具
	if battle_pane._mode==SceneManager.bossMode.mi:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗胜利_血姬结算")	
	elif battle_pane._mode==SceneManager.bossMode.tao:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗胜利_陶谦结算")
	elif battle_pane._mode==SceneManager.bossMode.zhenren:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗胜利_真人结算")

func _process(delta):
	pass


func meetBoardCrazy():
	SoundManager.stop_music()
	SoundManager.play_music(sounds._2__MENTAL_VORTEX)
	var colornew=Color.RED
	colornew.a=0.5
	PanelManager.Fade_Blank(colornew,0.5,PanelManager.fadeType.fadeIn)

func confireSold():
	shop_panel.confireSold()


func settleAfter():
	shop_panel.settleAfter()


func sideQuestReturnG(iswin):
	if iswin==false:
		GameManager.sav.have_event["错失娃娃"]=true	#
	battle_pane.sideQuestReturnG(iswin)
func sideQuestReturnT(iswin):
	if iswin==false:
		GameManager.sav.have_event["错失血袖"]=true
	battle_pane.sideQuestReturnT(iswin)

func sideQuestReturnD(iswin):
	if iswin==false:
		GameManager.sav.have_event["错失亮银"]=true		
	battle_pane.sideQuestReturnD(iswin)

@onready var items_in_scene: Node2D = $itemsInScene
@onready var people: Node2D = $CanvasLayer/people


#-1 0 小试牛刀开启 1小试牛刀通过 2 对局试炼开启 3对局试验通过 4 诡秘怪谈开启 5诡秘怪谈通过
func meetBoardGame(_value):
	if _value==1:
		GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.BADAO]=tr("寻访城内卡牌高手，体验仕诡牌对局")
		GameManager.sav.caobaocardgame=0
		GameManager.sav.mizhucardgame=0
		GameManager.sav.chendencardgame=0
	elif _value==2:
		
		GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.BADAO]=tr("挑战仕诡牌对局，赢取诡异卡")
		GameManager.sav.caobaocardgame=2
		GameManager.sav.mizhucardgame=2
		GameManager.sav.chendencardgame=2	
	elif _value==3:
		GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.BADAO]=tr("仕诡牌「诡秘乱局」，破解诡异之力")
		InventoryManager._remove_item(GameManager.inventoryPackege,InventoryManagerItem.仕诡卡尸皇,1)
		InventoryManager._remove_item(GameManager.inventoryPackege,InventoryManagerItem.仕诡卡骨龙,1)
		InventoryManager._remove_item(GameManager.inventoryPackege,InventoryManagerItem.仕诡卡血姬,1)
		GameManager.sav.caobaocardgame=4
		GameManager.sav.mizhucardgame=4
		GameManager.sav.chendencardgame=4
		PanelManager.Fade_Blank(Color.RED,0.5,PanelManager.fadeType.fadeOut)
		SoundManager.stop_music()
		GameManager.resumeMusic()		


func have_Xuanyin():
	var have=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.玄阴玉符)
	return have>=1
func have_ThreeItems():
	var have1=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.血姬傀儡)
	var have2=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.陶谦血袖)
	var have3=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.龙胆亮银枪)
	return have1>=1 and have2>=1 and have3>=1 


#返回大街 玄阴秘境
func returnStreet():
	clearBlankBackground()
	SoundManager.stop_ambient_sound(WASTELAND_0)
	GameManager.resumeMusic()
	playStageMusic()
	PanelManager.Fade_Blank(Color.BLACK,0.5,PanelManager.fadeType.fadeOut)	
	if GameManager.sav.have_event["玄阴首次遇宝"]==false:
		GameManager.sav.have_event["玄阴首次遇宝"]=true
		var _reward:rewardPanel=PanelManager.new_reward()
		var items={
		"items": null,
		"money": 100,
		"population": 0
		}
	
		_reward.showTitileReward(tr("恭喜你，你捡到一个钱袋"),items)	



func getZhenrenItem():
	var _reward:rewardPanel=PanelManager.new_reward()
	var items={
		"items": {InventoryManagerItem.ItemEnum.霸道之息:1},
		"money": 0,
		"population": 0
	}
	#GameManager.ScoreToItem()
	bossBattleAfter=true
	_reward.showTitileReward(tr("恭喜你，修道真人陨落，他体内的气息转变为你的力量"),items)	
const ZHENREN = preload("res://Asset/vedio/zhenren.ogv")
func playzhenren():
	#var tao = load("res://Asset/vedio/GULONGTEST.ogv")
	var _func=func():
		
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"真相揭露_真人")
		battle_pane.show()
		#battle_pane.enterBattleHuang()
	playBossAni(ZHENREN,_func)
	

func enterBattleZhenren():
	GameManager.tempRestoreGeneral()
	res_panel.position.x=1564
	res_panel.position.y=803
	res_panel.scale=Vector2(0.765,0.765)
	battle_pane.show()
	battle_pane.enterBattleZhenRen()


func zhenrenFinish():
	blank.hide()
	bossBattleAfter=false
	resetResPanel()
	GameManager.endtempRestoreGeneral()



func resetResPanel():
	GameManager.currenceScene.res_panel.position.x=1403
	GameManager.currenceScene.res_panel.position.y=622
	GameManager.currenceScene.res_panel.scale=Vector2(1,1)

func headRed():
	
	var newColor=Color.RED
	newColor.a=0.5
	PanelManager.Fade_Blank(newColor,0.5,PanelManager.fadeType.fadeIn)
	#await 0.5	
	#battle_pane.battle_circle.enemy.modulate=Color.RED


const long = preload("res://Asset/人物/镇魂龙最终.png")
func headRepair():
	battle_pane.battle_circle.enemyName="骨龙"
	battle_pane.battle_circle.changeHead(long)

func enterXuanYinSecret():
	if await GameManager.isTried(90):
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"进入玄阴之战")
		return
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"玄阴之战")


func blackMistDissolve():
	SoundManager.play_sound(sounds.fog)
	var viewport_size = get_viewport().get_visible_rect().size
	var center = viewport_size / 2
	var particles = GPUParticles2D.new()
	particles.name = "BlackMistEffect"
	particles.position = center
	particles.emitting = false
	particles.one_shot = true
	particles.explosiveness = 0.8
	particles.amount = 60
	particles.lifetime = 1.8
	particles.preprocess = 0.0
	particles.speed_scale = 1.0
	particles.z_index = 100
	$CanvasLayer.add_child(particles)
	var material = ParticleProcessMaterial.new()
	material.particle_flag_align_y = false
	material.direction = Vector3(0, -1, 0)
	material.spread = 180.0
	material.gravity = Vector3.ZERO
	material.initial_velocity_min = 60.0
	material.initial_velocity_max = 180.0
	material.angular_velocity_min = -30.0
	material.angular_velocity_max = 30.0
	var scale_curve = Curve.new()
	scale_curve.add_point(Vector2(0.0, 0.1))
	scale_curve.add_point(Vector2(0.2, 1.0))
	scale_curve.add_point(Vector2(0.7, 0.8))
	scale_curve.add_point(Vector2(1.0, 0.0))
	material.scale_curve = scale_curve
	var alpha_curve = Curve.new()
	alpha_curve.add_point(Vector2(0.0, 0.0))
	alpha_curve.add_point(Vector2(0.15, 0.8))
	alpha_curve.add_point(Vector2(0.6, 0.6))
	alpha_curve.add_point(Vector2(1.0, 0.0))
	material.alpha_curve = alpha_curve
	var _grad = Gradient.new()
	_grad.set_color(0, Color(0.02, 0.02, 0.04, 1.0))
	_grad.set_color(1, Color(0.1, 0.1, 0.15, 1.0))
	_grad.set_color(2, Color(0.2, 0.2, 0.25, 0.6))
	_grad.set_color(3, Color(0.3, 0.3, 0.35, 0.0))
	_grad.set_offset(0, 0.0)
	_grad.set_offset(1, 0.3)
	_grad.set_offset(2, 0.7)
	_grad.set_offset(3, 1.0)
	material.color_ramp = _grad
	material.color = Color(0.05, 0.05, 0.08, 1.0)
	material.scale_min = 0.3
	material.scale_max = 1.2
	material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	material.emission_sphere_radius = 30.0
	particles.process_material = material
	var texture = preload("res://Asset/particle/2/vnbvx_5.png")
	particles.texture = texture
	particles.emitting = true
	await get_tree().create_timer(particles.lifetime + 0.5).timeout
	if is_instance_valid(particles):
		particles.queue_free()
