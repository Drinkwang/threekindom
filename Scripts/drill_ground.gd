extends baseComponent

@onready var control= $Control2
@onready var oldsoildereat = $CanvasInventory/oldsoildereat
@onready var train_panel = $CanvasInventory/trainPanel
@onready var battle_pane:battlePanel = $CanvasInventory/battlePane
#const _校场 = preload("res://Asset/bgm/校场.mp3")
@onready var bg = $"内饰"

const xiaopeiBuild = preload("res://Asset/城镇建筑/演武场1.png")
const newBuild = preload("res://Asset/城镇建筑/演武场2.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.endReward.connect(_judWin)
	#判断剧情
	Transitions.post_transition.connect(post_transition)
	control.buttonClick.connect(_buttonListClick)
	super._ready()
	if GameManager.sav.day>=5 or GameManager.sav.have_event["initXuzhou"]==true:
		bg.texture=newBuild
	else:
		bg.texture=xiaopeiBuild
	if GameManager.sav.have_event["findLvbu"]==true and GameManager.sav.have_event["征询曹将军意见"]==false:
		#可改成显示曹将军立绘
		caobao.show()
		GameManager.sav.have_event["征询曹将军意见"]=true
		#pass
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"征询曹将军意见")
		#pass
const bgm = preload("res://Asset/bgm/校场.wav")

func _judWin():
	if(not (GameManager.sav.targetTxt!=null and GameManager.sav.targetTxt.length()>0)):
		return
	if GameManager.sav.targetResType==GameManager.ResType.battle:
		if(GameManager.sav.have_event["firstMeetCaoCao"]==false):
			if GameManager.sav.currenceValue>=3:
				GameManager.sav.have_event["firstMeetCaoCao"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"遇到曹操")
		if(GameManager.sav.have_event["CaoBaointervene"]==false):
			if GameManager.sav.currenceValue>=7:
				GameManager.sav.have_event["CaoBaointervene"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"曹豹干预")
		if GameManager.sav.have_event["battleTaiShan"]==true:
			if(GameManager.sav.have_event["completebattleTaiShan"]==false):	

				if GameManager.sav.currenceValue>=8 and GameManager.sav.have_event["昌豨求饶2"]==false:
					GameManager.sav.have_event["昌豨求饶2"]=true
					DialogueManager.show_example_dialogue_balloon(dialogue_resource,"昌豨求饶2")
				elif GameManager.sav.currenceValue>=5 and GameManager.sav.have_event["臧霸首战"]==false:
					GameManager.sav.have_event["臧霸首战"]=true
					DialogueManager.show_example_dialogue_balloon(dialogue_resource,"臧霸首战")
					#内部分裂
				elif GameManager.sav.currenceValue>=3 and GameManager.sav.have_event["昌豨求饶"]==false:
					GameManager.sav.have_event["昌豨求饶"]=true
					DialogueManager.show_example_dialogue_balloon(dialogue_resource,"昌豨求饶")
					#吕布来了	
		if GameManager.sav.have_event["战斗袁术开始"]==true:
			
			if GameManager.sav.currenceValue>=6:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"征讨袁公路来了使者")
				#袁术信使
				pass
			elif GameManager.sav.currenceValue>=3:
				#曹操的信
	
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"曹操挟天子开始")
		if GameManager.sav.have_event["战斗袁术血战模式"]==true:
			if GameManager.sav.currenceValue>=6:
				pass
			elif GameManager.sav.currenceValue>3:
				pass
		
		if GameManager.sav.currenceValue>=GameManager.sav.targetValue:
			_completeTask()
			

func _completeTask():#将完成任务移动到外层
	if(GameManager.sav.have_event["completeTask2"]==false):
		GameManager.sav.have_event["completeTask2"]=true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"征讨结束")
	elif GameManager.sav.have_event["lvbuJoin"]==false&&GameManager.sav.have_event["battleTaiShan"]==true:	
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"发现吕布")

		
	#在吕布帮助下取得三次军事行动	
	elif GameManager.sav.have_event["lvbuJoin"]==true&&GameManager.sav.have_event["battleTaiShan"]==true:
		if(GameManager.sav.have_event["completebattleTaiShan"]==false):
			GameManager.sav.have_event["completebattleTaiShan"]=true		
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"温侯降伏臧霸")
	elif GameManager.sav.have_event["战斗袁术血战模式"]==true and GameManager.sav.have_event["血战袁术完成"]==false:
		GameManager.sav.have_event["血战袁术完成"]=true
		#吕布背叛，3种可能 丹阳派 叛变，徐州派叛变-豪族派 or 士族派叛变
		#胜利次数大于一半 不进入克苏鲁
		#败北数达到一半 克苏鲁 败北达到6 人吃人绝境  5天 15场duel 3天后不送粮草  报告 大人 徐州粮草出现问题
		#判断是否进入人吃人惨案 胜率低于50%
		#if GameManager.sav.currenceDay<=6:
			#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"克苏鲁线")
			#return 
			#血战 30 场决斗 3天给与选择 5天断粮 7天判断有无克苏鲁 如果输了15场 就自动进入克苏鲁 仅以身免，刘备的最好兄弟牺牲 兄弟甲乙丙 都是同乡 甲被人吃，乙想吃刘备肉被甲劝说，无果，年老的丙用自己肉保住主公，最终乙因为自己最好兄弟甲之死，自己割自己肉给刘备吃 ，最后甲乙丙都死，如果活下来，他们也是新的关羽和张飞，乙也有傲气 
			#21 11
		if GameManager.sav.WAIDIPAI._support_rate<60:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"丹阳线")
	
		elif GameManager.sav.BENTUPAI._support_rate<60:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"士族线")
	
		elif GameManager.sav.HAOZUPAI._support_rate<60:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"豪族线")
			#pass #其实以上三种都是丢徐州 但是通过战斗胜利次数，判断有无进入克苏鲁线
		else:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"不丢徐州线")
			#进入非丢徐州线路 反攻吕布和袁术 受x天
			pass
		
@onready var caocao_letter = $CanvasInventory/caocaoLetter
@onready var caocao_letter_xie_tian_zi = $CanvasInventory/caocaoLetterXieTianZi

func CoerceKing():
	caocao_letter_xie_tian_zi.show()
	battle_pane.hide()

func findLvbu():
	GameManager.sav.have_event["findLvbu"]=true	
	GameManager.sav.TargetDestination="府邸"	

func meetCaoCao():
	caocao_letter.show()
	battle_pane.hide()

	
func caocaoLetterHide():
	caocao_letter.hide()
	caocao_letter_xie_tian_zi.hide()
func post_transition():
	SoundManager.stop_all_ambient_sounds()
	SoundManager.play_ambient_sound(bgm)
	print("fadedone")
	
	if GameManager.sav.have_event["亲征对话结束"]==true and GameManager.sav.have_event["战斗袁术血战模式"]==false:
		#GameManager.sav.have_event["战斗袁术血战模式"]=true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"演武场宣战袁术")
		return 
	_initData()

const EAT_1 = preload("res://Asset/sound/eat1.mp3")
func enterOldSoilderEat():
	oldsoildereat.show()
	GameManager.sav.hp=GameManager.sav.hp-20
	#播放聚餐声音
	SoundManager.play_sound(EAT_1)
	pass
	
	
	
var battleNum=0
@onready var caobao = $"曹豹"

func enterBattleMode():
	GameManager.sav.have_event["战斗袁术血战模式"]=true
	GameManager.sav.hp=100
	#任务开始，10天完成20次duel
	
	GameManager.sav.targetValue=20
	GameManager.sav.currenceValue=0
	GameManager.sav.targetResType=GameManager.ResType.battle

	GameManager.sav.targetTxt="10天完成20次军事行动：{currence}/{target}"
	GameManager.sav.TargetDestination="battle"
	_initData()


func _initData():
	GameManager.currenceScene=self
	if(GameManager.sav.day==1):
		if GameManager.sav.have_event["firstEnterBattle"]==false:
			GameManager.sav.have_event["firstEnterBattle"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
	elif GameManager.sav.day==3:
		if GameManager.sav.have_event["dayThreeEnterBattle"]==false:
			GameManager.sav.have_event["dayThreeEnterBattle"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"初次派遣")
	elif GameManager.sav.day>=5:
		if GameManager.sav.have_event["LiuBeiSucceed"]==false:
			GameManager.sav.have_event["LiuBeiSucceed"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"刘备接任徐州之主")
	if GameManager.sav.have_event["查出药囊后休息前"]==true and GameManager.sav.have_event["锦囊咨询丹阳派"]==false:
		caobao.dialogue_start="演武场克苏鲁剧情支线"
		caobao.show()
	
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
		"visible":"false"
	},
	{
		"id":"4",
		"context":"休息",#前往大街
		"visible":"false"
	},

	]

	if GameManager.sav.have_event["战斗袁术血战模式"]==true:
		initData[3].visible="true"
		initData[0].visible="false"
		if GameManager.sav.currenceValue<9:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"今日收入为")
		#==5张飞惩戒	
		elif GameManager.sav.currenceValue==9 and GameManager.sav.currenceValue==12:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"每日物质送不来")
		elif GameManager.sav.currenceValue==15:
			#进入克苏鲁
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"克苏鲁线自相啖食0")
		elif GameManager.sav.currenceValue==18:
			#克苏鲁第一天
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"克苏鲁线自相啖食")
			
			pass
		elif GameManager.sav.currenceValue==21:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"克苏鲁线2")
		elif GameManager.sav.currenceValue==24:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"克苏鲁线3")
		elif GameManager.sav.currenceValue==27:
			#视情况修改代码
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"张飞杀曹豹")
		#30进入结尾
		#守9天 进入大结局，青梅煮酒
	else:
		#initData[3].visible="false"
		initData[0].visible="true"
	if(GameManager.sav.day>=3):
		initData[2].visible="true"
	control._processList(initData)

func drillKeComplete():
	caobao.hide()
	caobao.dialogue_start=""
	GameManager.sav.have_event["锦囊咨询丹阳派"]=true

func _buttonListClick(item):
	if item.context=="离开此地":
		if(GameManager.sav.day==1):
			if GameManager.sav.isLevelUp==false:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"训练还没有结束")
				return
		if(GameManager.sav.day==3):
			if GameManager.sav.hp>10:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"三场战斗还没有结束")
				return 
		if GameManager.sav.have_event["战斗袁术血战模式"]==true:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"血战模式无法离开演武场")
			return
		SceneManager.changeScene(SceneManager.roomNode.STREET,2)#判断条件
		#pass
	elif item.context=="操练士兵":
		train_panel.show()
		pass
	elif item.context=="军事行动":
		#第一次军事行动应该告诉你教程
		if GameManager.sav.day==3:
			if GameManager.sav.have_event["firstBattleTutorial"]==false:
				GameManager.sav.have_event["firstBattleTutorial"]=true
				DialogueManager.show_dialogue_balloon(dialogue_resource,"第一次军事行动教程")
			else:
				battle_pane.point_group.hide()
		else:
			battle_pane.point_group.hide()
		battle_pane.show()
		battle_pane.initData()
		res_panel.position.x=1598
		if GameManager.sav.have_event["battleTaiShan"]==true:
			if GameManager.sav.have_event["臧霸首战之前"]==false:
				GameManager.sav.have_event["臧霸首战之前"]=true
				DialogueManager.show_dialogue_balloon(dialogue_resource,"臧霸首战之前")
		#if(GameManager.sav.have_event["firstBattleTutorial"]==true)：
		#暂时不能发动军事行动
	elif item.context=="休息":
		if(GameManager.sav.currenceDay>=3):
			if GameManager.sav.currenceValue>=9:
				#if 全胜 不会反 end1
				#if 小败 看丹阳忠诚 end 2守 end3
				# 败北数达到一半 克苏鲁
				#放在战斗里面，如果3天内 完成9场则触发吕布造反，
				#3场
				#6场
				#8场 胜利消息 n天就无援助  3场，每个角色限1 
				#10场 胜利消息
				#歼灭   
				#如何判断有无歼灭呢
				#歼灭袁术，和没歼灭，没歼灭继续触发克苏鲁剧情 损失金钱 在转小沛，不然直接转小沛
				#转小沛判断 三种 陈登 糜竺 丹阳是否都高，如果都高 直接触发统治徐州，如果有一方低，则会导致迎接吕布剧情，需要平定吕布和袁术合盟
				# 糜竺 陈登 
				#可让张飞通过压榨丹阳派提供更多物质，保证一定进入丹阳线
				#也可令张飞不可欺压士族
				# 最低一方 将会叛变 迎合吕布，最终判断有无雪中送炭剧情 
				# 陈登和糜竺的支持度，仅限于提供再起支持（高于80），而丹阳则决定徐州归属，如果丹阳高，并且陈登和糜竺有一方低，则血战模式触发 张飞 通过压榨 曹豹给陈登和糜竺平衡，献出物资  吕布一定作乱，如果三方忠诚度都高于60进入徐州可保，如果有一方低于80   
				#糜竺是送亲 送兵 送钱
				#陈登是送道具 
				#无论小沛还是下邳，曹操都会送援助和封官		
				#最终小沛或者下邳，在坚持20天 游戏结束 进入青梅煮酒
				pass
			else:
				pass
				#没歼灭
				#没歼灭
			#血战结束
			#判断3天取得9次胜利没有 如果取得

		if(GameManager.sav.hp>10):
			DialogueManager.show_dialogue_balloon(dialogue_resource,"血战模式无法提前休息")
			return
		#暂时不用rest文本来修改，未来可能会用，把代码移动到这里更直观	
		#GameManager.restLabel=tr("与此同时")	
		GameManager.restFadeScene=SceneManager.DRILL_GROUND	
		GameManager._rest()

	pass

#练兵结束调用这个 初次练兵

func trainBegin():
	control._show_button_5_yellow(1)	
	

func endtrain0():
	control._show_button_5_yellow(-1)
	
	
	
func endtrain():
	control._show_button_5_yellow(0)

func ConsultWithCaoBaoEnd():
	GameManager.sav.TargetDestination="府邸"	
	GameManager.sav.have_event["lvbuDiscussInCaoBao"]=true

@onready var point = $CanvasInventory/point

func showtutorial(num):
	if num ==1:
		battle_pane.point_group.show()
		control._show_button_5_yellow(-1)		
	if(num<8):
		battle_pane["guild_"+str(num)].show()
	if(num>=2 and num<=8):
		battle_pane["guild_"+str(num-1)].hide()
		#battle_pane["guild_"+str(num)].Get# AnimationPlayer".play("YELLOWGUILD")

	if num==8:
		point.show()
	elif num==9:
		point.hide()
		battle_pane.point_group.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func quest2Complete():
	#GameManager.sav.have_event["completeTask2"]=true
	GameManager.sav.TargetDestination="府邸"
	#任务目标 前往府邸
	pass

func taishanComplete():
	#未来此处可能改成具体文本内容
	GameManager.sav.TargetDestination="府邸"
	GameManager.sav.coin=GameManager.sav.coin+200
	GameManager.sav.people_surrport=GameManager.sav.people_surrport+20
	GameManager.sav.labor_force=GameManager.sav.labor_force+1000
	#获得士兵1000人，钱财200，民心上升10
	#任务完成
	#GameManager.clearTask()
	
	
func yuanshuComplete():
	GameManager.sav.TargetDestination="府邸"

	pass
	
func tempLockCaoBao():
	pass
	
func fireLetter():
	pass

func xiapei():
	#小沛故事线-正史
	pass

func xiapi():
	#下邳故事线-if
	pass


@onready var res_panel = $CanvasInventory/resPanel

func _DayGet():
	res_panel.showValue=false
	res_panel.GetValue(GameManager.sav.coin_DayGet,0,GameManager.sav.labor_DayGet)
	SoundManager.play_sound(sounds.buysellsound)
	await 1
	res_panel.showValue=true
	#GameManager._DayGet()
	#if(GameManager.sav.targetTxt!=null and GameManager.sav.targetTxt.length()>0):	
	#	_JudgeTask()
