extends baseComponent
class_name  drill_ground
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
					battle_pane.refreshHead()
					#修改头像
					#内部分裂
				elif GameManager.sav.currenceValue>=3 and GameManager.sav.have_event["昌豨求饶"]==false:
					GameManager.sav.have_event["昌豨求饶"]=true
					DialogueManager.show_example_dialogue_balloon(dialogue_resource,"昌豨求饶")
					battle_pane.refreshHead()
					#吕布来了	
		if GameManager.sav.have_event["战斗袁术开始"]==true:
			if GameManager.sav.currenceValue>3 and GameManager.sav.have_event["曹豹和吕布勾连0"]==false:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"得知吕布和曹豹勾连")
				GameManager.sav.have_event["曹豹和吕布勾连0"]=true
			if GameManager.sav.currenceValue>=6 and GameManager.sav.have_event["袁术来使"]==false:
				GameManager.sav.have_event["袁术来使"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"征讨袁公路来了使者")
				#袁术信使
				pass
			elif GameManager.sav.currenceValue>=9:
				###
				#GameManager.sav.have_event["袁术来使"]=true
				#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"征讨袁公路来了使者")
	
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"曹操挟天子开始")
		if GameManager.sav.have_event["战斗袁术血战模式"]==true:
			if GameManager.sav.currenceValue>=6:
				pass
			elif GameManager.sav.currenceValue>3:
				pass
		
		if GameManager.sav.currenceValue>=GameManager.sav.targetValue:
			_completeTask()
				# 如果你满足条件，则弹出对话
		if GameManager.sav.extraBattleDialogContext.length()>0 and GameManager.sav.extraBattleTaskTargetNum>0 and GameManager.sav.extraCureenTaskCNum>=GameManager.sav.extraBattleTaskTargetNum and GameManager.sav.extraBattleTaskBootNum<=GameManager.sav.currenceValue:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,GameManager.sav.extraBattleDialogContext)
			GameManager.sav.extraBattleTaskBootNum=-1
			GameManager.sav.extraBattleTaskTargetNum=-1
			GameManager.sav.extraBattleTaskEnum=SceneManager.etraTaskType.none
			GameManager.sav.extraCureenTaskCNum=0
			GameManager.sav.extraBattleDialogContext=""
			#_completeTask()				

func zhangbaQianlai():
	#此处改臧霸头像
	pass


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
	GameManager.CanClickUI=true
	SoundManager.stop_all_ambient_sounds()
	SoundManager.play_ambient_sound(bgm)
	print("fadedone")
		#移出ready
	if GameManager.sav.have_event["discussLvbu"]==true and GameManager.sav.have_event["征询曹将军意见"]==false:
		#可改成显示曹将军立绘
		caobao.show()
		GameManager.sav.have_event["征询曹将军意见"]=true
		#pass
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"征询曹将军意见")
		#pass
		return
		
	if GameManager.sav.have_event["亲征对话结束"]==true and GameManager.sav.have_event["战斗袁术血战模式"]==false:
		#GameManager.sav.have_event["战斗袁术血战模式"]=true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"演武场宣战袁术")
		return 
		
	if GameManager.sav.have_event["曹豹和吕布勾连1"]==true and GameManager.sav.have_event["曹豹和吕布勾连2"]==false:
		#chendeng.show()
		#mizhu.show()
		#mizhu.showEX=false
		#chendeng.showEX=false
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"得知吕布和曹豹勾连2")
		GameManager.sav.have_event["曹豹和吕布勾连1"]=true
		return 		
		
	var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.龙胆亮银枪)	
	if num==0:	
		if GameManager.sav.have_event["预获得龙胆枪休息"]==true:
			caobao.show() #也可以改成点击
			caobao.showEX=true
			caobao.changeAllClick("获得龙胆枪")
	
		
	if GameManager.bossmode==scenemanager.bossMode.huang and GameManager.sav.have_event["曹豹支线3"]==false:
		GameManager.sav.hp=0
		caobao.show()
		
		if GameManager.bossmoderesult==true:
			GameManager.sav.have_event["预获得龙胆枪"]=true
			print("可以拿到龙胆枪")
			#赢了，第二天获得龙胆影月枪
		GameManager.sav.have_event["曹豹支线3"]=true #第二天可以获得新道具
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"曹豹结尾")
		
		return 
		

	_initData()

const EAT_1 = preload("res://Asset/sound/eat1.mp3")
func enterOldSoilderEat():
	oldsoildereat.show()
	GameManager.sav.hp=GameManager.sav.hp-20
	#播放聚餐声音
	SoundManager.play_sound(EAT_1)
	pass
	


func getLongdan():
	caobao.hide()
	var _reward:rewardPanel=PanelManager.new_reward()
	
	var items={
		"items": {InventoryManagerItem.ItemEnum.龙胆亮银枪:1},
		"money": 0,
		"population": 0
	}
	#GameManager.ScoreToItem()
	_reward.showTitileReward(tr("恭喜你，你获得-龙胆亮银枪"),items)	
	
	
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
	#觉得无用的注释GameManager.sav.TargetDestination="battle"
	_initData()


func refreshData():
	#_initData()


	if caobao.dialogue_start.length()>0:
		caobao.show()
	else:
		caobao.hide()

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
	elif GameManager.sav.have_event["刘备成长1"]==true and GameManager.sav.have_event["刘备成长2"]==false:
		GameManager.sav.have_event["刘备成长2"]==true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"刘备的成长2")
	if GameManager.selectBoardCharacter==boardType.boardCharacter.caobao and GameManager._boardMode!=boardType.boardMode.none and GameManager._boardGameWin==true:
		caobao.show()
		GameManager.selectBoardCharacter=boardType.boardCharacter.none 
		GameManager._boardMode=boardType.boardMode.none
		GameManager.resumeMusic()
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"常规获胜")
	elif GameManager.selectBoardCharacter==boardType.boardCharacter.caobao and GameManager._boardMode!=boardType.boardMode.none and GameManager._boardGameWin==false:
		caobao.show()
		GameManager.resumeMusic()
		GameManager.selectBoardCharacter=boardType.boardCharacter.none 
		GameManager._boardMode=boardType.boardMode.none 
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"常规失败")	
	elif GameManager.sav.have_event["曹豹牌局无人"] ==false and GameManager.sav.caobaocardgame==4 and (GameManager.sav.mizhucardgame<5 or GameManager.sav.chendencardgame<=5):
		caobao.hide()
		GameManager.sav.have_event["曹豹牌局无人"] =true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"牌局无人")
	
	
	elif GameManager.trainResult==SceneManager.trainResult.win:
		if GameManager.trainGeneral=="关羽":
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"关羽比武胜利")

		elif GameManager.trainGeneral=="张飞":
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"张飞比武胜利")
	
		elif GameManager.trainGeneral=="赵云":
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"赵云比武胜利")
			

	elif GameManager.trainResult==SceneManager.trainResult.fail:
		if GameManager.trainGeneral=="关羽":
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"关羽比武失败")

		elif GameManager.trainGeneral=="张飞":
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"张飞比武失败")
	
		elif GameManager.trainGeneral=="赵云":
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"赵云比武失败")
			

	
		
	elif GameManager.sav.have_event["查出药囊后休息前"]==true and GameManager.sav.have_event["锦囊咨询丹阳派"]==false and caobao.showEX==false:
		caobao.changeAllClick("演武场克苏鲁剧情支线")
		caobao.showEX=true
		caobao.show()
	
	elif GameManager.sav.have_event["曹豹支线1"]==false and GameManager.sav.have_event["battleTaiShan"]==true and caobao.showEX==false:
		caobao.changeAllClick("曹豹支线1")
		caobao.show()

		caobao.showEX=true
			#插入糜贞送药
			#糜竺嫁妹支线2
			#tsty.show()		
			
	elif GameManager.sav.have_event["曹豹支线2"]==false and GameManager.sav.caobaoSideWait==1:
		if GameManager.sav.have_event["曹豹资助"]==false:#暂时没想好写啥
			caobao.show()

			#caobao.showEX=false
			GameManager.sav.have_event["曹豹资助"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"插入曹豹资助")
				
	elif GameManager.sav.have_event["曹豹支线2"]==false and GameManager.sav.caobaoSideWait==0 and caobao.showEX==false:	
		caobao.changeAllClick("曹豹支线2")
		caobao.show()
		
		caobao.showEX=true	
	else:
		if GameManager.sav.day>=7 and GameManager.sav.have_event["开启比武训练"]==false:
			GameManager.sav.have_event["开启比武训练"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"比武训练解锁")
		
		elif GameManager.sav.caobaocardgame>=0  and caobao.showEX==false:
			#如果小于4 则移出3 
			
			
			#@export var mizhucardgame=-1
			#@export var chendencardgame=-1
			
			if GameManager.sav.have_event["boss战开始"]==false and GameManager.sav.caobaocardgame==4 and GameManager.sav.mizhucardgame==5 and GameManager.sav.chendencardgame==5:
				caobao.changeAllClick("来把仕诡牌2")
				caobao.show()

				caobao.showEX=true
			elif GameManager.sav.have_event["boss战开始"]==false and GameManager.sav.caobaocardgame==4 and (GameManager.sav.mizhucardgame<5 or GameManager.sav.chendencardgame<=5):
				caobao.hide()
			else:
				caobao.changeAllClick("来把仕诡牌")

					
				caobao.show()
				caobao.showEX=false
	
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
		
	items_in_scene.showItems()	
	control._processList(initData)

func select1(issuccuss):
	GameManager.sav.mizhuSideWait=3
	GameManager.sav.have_event["曹豹支线1"]=true
	if issuccuss==true:
		GameManager.sav.have_event["曹豹正确选择1"]=true
	else:
		GameManager.sav.have_event["曹豹正确选择1"]=false


func boardVictory():

	if GameManager._boardReward==boardType.boardRewardResult.item:
		var _reward:rewardPanel=PanelManager.new_reward()
	
		var items={
			"items": null,
			"money": 0,
			"population": 40
		}

		_reward.showTitileReward(tr("你战胜了曹豹，你获得曹豹赠送你的40名士兵"),items)	
	elif GameManager._boardReward==boardType.boardRewardResult.card:
		var _reward:rewardPanel=PanelManager.new_reward()
	
		var items={
			"items": {InventoryManagerItem.ItemEnum.仕诡卡血姬:1},
			"money": 0,
			"population": 0
		}
		_reward.showTitileReward(tr("你战胜了曹豹，你获得曹豹珍藏的诡异卡"),items)	
	GameManager._boardReward=boardType.boardRewardResult.none
func select2(issuccuss):
	GameManager.sav.have_event["曹豹支线2"]=true


	if issuccuss==true:
		GameManager.sav.have_event["曹豹正确选择2"]=true
	else:
		GameManager.sav.have_event["曹豹正确选择2"]=false

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
		if GameManager.sav.have_event["开启比武训练"]==true:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"训练选项")
		else:
			trainUseMoney()

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
		caobao.hide()	
		battle_pane.show()
		battle_pane.initData()
		res_panel.position.x=1564
		res_panel.position.y=803
		res_panel.scale=Vector2(0.765,0.765)
		if GameManager.sav.have_event["battleTaiShan"]==true:
			if GameManager.sav.have_event["臧霸首战之前"]==false:
				GameManager.sav.have_event["臧霸首战之前"]=true
				DialogueManager.show_dialogue_balloon(dialogue_resource,"臧霸首战之前")
		elif GameManager.sav.have_event["战斗袁术开始"]==true:
			if GameManager.sav.have_event["袁术也进军"]==false:
				GameManager.sav.have_event["袁术也进军"]==true
				DialogueManager.show_dialogue_balloon(dialogue_resource,"征讨袁术开始")
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

func caobaoLevelUpSoilder():
	refreshData()
	#GameManager._propertyPanel.GetValue(200,0,0)
	
	
	var _reward:rewardPanel=PanelManager.new_reward()
	
	var items={
		"items":null,
		"money": 0,
		"population": 100
	}

	_reward.showTitileReward(tr("你获得了曹豹帮你训练的100士兵"),items,false)	

func trainUseMoney():
	res_panel.position.x=1564
	res_panel.position.y=803
	res_panel.scale=Vector2(0.765,0.765)
	train_panel.show()
	caobao.hide()

func trainBegin():
	control._show_button_5_yellow(1)	
	

func endtrain0():
	control._show_button_5_yellow(-1)
	
	
	
func endtrain():
	control._show_button_5_yellow(0)

func ConsultWithCaoBaoEnd():
	_initData()
	caobao.hide()
	GameManager.sav.TargetDestination="府邸"	
	GameManager.sav.have_event["lvbuDiscussInCaoBao"]=true

@onready var point = $CanvasInventory/point

func showtutorial(num):
	
	if num ==1:
		battle_pane.istour=true
		#获得当前敌人种类
		

		
		
		var btdatas=GameManager.sav.battleTasks[0]
		
		if (btdatas.sdType==GameManager.RspEnum.SCISSORS):
			#type==GameManager.RspEnum.PAPER
			battle_pane._on_control_3_gui_input(null)
		elif(btdatas.sdType==GameManager.RspEnum.PAPER):
			battle_pane._on_control_2_gui_input(null)
		elif(btdatas.sdType==GameManager.RspEnum.ROCK):
			battle_pane._on_control_1_gui_input(null)

			

		
		#选择一个非完成克制的武将，或者被克制的武将
		battle_pane.point_group.show()
		control._show_button_5_yellow(-1)
		point.show()
		#请做移动资源的曲线
		var tween=get_tree().create_tween()
		tween.tween_property(battle_pane.soild_slider, "value",30, 5)
		tween.tween_property(battle_pane.soild_slider, "value",0, 5)
		var tween2=get_tree().create_tween()
		tween2.tween_property(battle_pane.coin_slider, "value",30, 5)
		tween2.tween_property(battle_pane.coin_slider, "value",0, 5)		
		
	if(num<4):
		battle_pane["guild_"+str(num)].show()
	if(num>=2 and num<=8):
		battle_pane["guild_"+str(num-1)].hide()

	if num==2:
		point.hide()
		#调整value为完成任务，如果没有则不调整
		
		
		var btdatas=GameManager.sav.battleTasks[0]
		var tween=get_tree().create_tween()
		var tween2=get_tree().create_tween()
		var tasks=btdatas.task
		var ResSlider
		
		for task in tasks:
			var value=task.value
			var minValue
			if task.res=="coin":
				ResSlider=battle_pane.coin_slider	
				minValue=int(floor(value*2/3))
			else:
				ResSlider=battle_pane.soild_slider		
				minValue=int(floor(value*3/5))
			var sybol=task.symbol
			var iscomplete=false
			var movevalue
			if sybol==GameManager.opcost.greater:
				
				movevalue=value+1
			elif sybol==GameManager.opcost.less:
		
				movevalue=minValue+1
			
			elif sybol==GameManager.opcost.equal:
				#把slider调整相等
				movevalue=value

			tween.tween_property(ResSlider, "value",movevalue, 2)
		
		
		
		#好难
	
	

	

	if  num==3:

		
		var btdatas=GameManager.sav.battleTasks[0]
		
		if (btdatas.sdType==GameManager.RspEnum.SCISSORS):
			#type==GameManager.RspEnum.PAPER
			battle_pane._on_control_1_gui_input(null)
		elif(btdatas.sdType==GameManager.RspEnum.PAPER):
			battle_pane._on_control_2_gui_input(null)
		elif(btdatas.sdType==GameManager.RspEnum.ROCK):
			battle_pane._on_control_3_gui_input(null)
		

		#请做选择克制武将的曲线
		#
	if num ==4:
		#还原所有曲线，取消选择武将，金钱设置为0
		battle_pane.istour=false
		
		
		
		battle_pane.control_3.check_box.button_pressed=false
		battle_pane.control_2.check_box.button_pressed=false
		battle_pane.control_1.check_box.button_pressed=false
		
		battle_pane.soild_slider.value=0
		battle_pane.coin_slider.value=0
		
		
		battle_pane.selectIndex=0

		battle_pane.battle_circle._juideCompeleteTask()	 
		battle_pane.battle_circle.selectgeneral=null
		battle_pane._refreshSlider()
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


func openBoardGame():
	GameManager.selectBoardCharacter=boardType.boardCharacter.caobao
	GameManager.showBoardGameDialogue()

func openBoardDialogue():
	if GameManager._boardMode!=boardType.boardMode.high:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"进入仕诡牌游戏")
	else:
		if GameManager.sav.have_event["曹豹诡秘乱局启动"]==false:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"诡秘乱局初次启动")
			GameManager.sav.have_event["曹豹诡秘乱局启动"]=true
		else:
			
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"进入仕诡牌游戏")
			#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"来把仕诡牌2")
	
@onready var items_in_scene: Node2D = $itemsInScene


func huangjinSurrender():
	GameManager.sav.labor_force+=100
	GameManager.sav.currenceValue+=1
	_completeTask()	


func cangxiSurrender():
	
	
	var _reward:rewardPanel=PanelManager.new_reward()
	var items={
		"items": {InventoryManagerItem.ItemEnum.珍品礼盒:2},
		"money": 200,
		"population": 0
	}
	#GameManager.ScoreToItem()
	_reward.showTitileReward(tr("恭喜你，你获得昌豨献上的财宝"),items)		
	GameManager.sav.currenceValue+=2
	pass
	
func jilinEscape():
	GameManager.sav.people_surrport+=10
	GameManager.sav.currenceValue+=1
	pass

func finalBossBefore():
	GameManager.sav.have_event["boss战开始"]=true
	caobao.hide()

func enterContest(mode):
	if(await GameManager.isTried(50)):
		return 


	var characterScore
	var haveWeapon=false	
	if GameManager.trainGeneral=="关羽":
		characterScore=GameManager.sav.guanyuTrainNum
		haveWeapon=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.青龙偃月刀)>=1	
	elif GameManager.trainGeneral=="张飞":
		characterScore=GameManager.sav.zhangfeiTrainNum	
		haveWeapon=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.丈八蛇矛)>=1
	elif GameManager.trainGeneral=="赵云":
		characterScore=GameManager.sav.zhaoyunTrainNum
		haveWeapon=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.龙胆亮银枪)>=1


	if (characterScore<1 and mode==1) or (characterScore<2 and mode==2):
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"当前比武未解锁")
		GameManager.trainLevel=0
		GameManager.trainGeneral=""
		return
	elif (characterScore>=2 and characterScore<3  and mode==2 and not haveWeapon):
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"当前比武未解锁2")
		GameManager.trainLevel=0
		GameManager.trainGeneral=""
		return
	if GameManager.sav.isLevelUp==true:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"已经练兵过了")
		GameManager.trainLevel=0
		GameManager.trainGeneral=""
		return	

	GameManager.sav.hp-=50
	GameManager.sav.isLevelUp=true
	GameManager.trainLevel=mode+1
	if GameManager.trainGeneral=="关羽":
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"关羽比武")
	elif GameManager.trainGeneral=="张飞":
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"张飞比武")
	elif GameManager.trainGeneral=="赵云":
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"赵云比武")
	#SoundManager.stop_music()
	#SceneManager.changeScene(SceneManager.roomNode.BoardGame,2)

func enterRealContest():
	SoundManager.stop_music()
	SceneManager.changeScene(SceneManager.roomNode.TrainBattle,2)

#发放奖励，无事发生,首次2倍 3倍 5倍  1 1.3 1.5
func winTrain():
	var generals=GameManager.sav.generals
	var found_general
	for key in generals.keys():
		if generals[key]["name"] == GameManager.trainGeneral:
			found_general= generals[key]
			break

	var isFirst=false
	if GameManager.trainGeneral=="关羽":
		
		
		if GameManager.sav.guanyuTrainNum<GameManager.trainLevel:			
			GameManager.sav.guanyuTrainNum+=1
			found_general["level"] += 1	
			isFirst=true
		winReward(isFirst,GameManager.trainGeneral)
	elif GameManager.trainGeneral=="张飞":
		if GameManager.sav.zhangfeiTrainNum<GameManager.trainLevel:			
			GameManager.sav.zhangfeiTrainNum+=1
			found_general["level"] += 1	
			isFirst=true		
		winReward(isFirst,GameManager.trainGeneral)
	elif GameManager.trainGeneral=="赵云":
		if GameManager.sav.zhaoyunTrainNum<GameManager.trainLevel:			
			GameManager.sav.zhaoyunTrainNum+=1
			found_general["level"] += 1	
			isFirst=true		
		winReward(isFirst,GameManager.trainGeneral)
	
func winReward(isFirst,generalName):
	var _reward:rewardPanel=PanelManager.new_reward()
	var score=0
	var modename=""
	var isFinal=false
	if GameManager.trainLevel==1:
		modename=tr("小试牛刀")
		if isFirst==true:
			score=1800
		else:
			score=900


	elif GameManager.trainLevel==2:
		if isFirst==true:
			score=2700

		else:
			score=1000
		modename=tr("锋芒初露")
	elif GameManager.trainLevel==3:
		if isFirst==true:
			isFinal=true
			score=4000

		else:
			score=1200
		modename=tr("炉火纯青")
			
	var items=GameManager.ScoreToItem(score)
	if isFirst==true:
		if isFinal==true:
			GameManager.sav.maxHP+=10
			_reward.showTitileReward(tr("首次通过{name}的至高难度！你的最大体力值永久提升10点，并立即晋升该武将等级！").format({"name":tr(generalName),"modename":modename}),items)	
		else:
			_reward.showTitileReward(tr("你与{name}在【{modename}】模式下，首次比武获胜了，提升武将等级").format({"name":tr(generalName),"modename":modename}),items)	
	else:
		_reward.showTitileReward(tr("你与{name}在【{modename}】模式下，比武获胜了").format({"name":generalName,"modename":modename}),items)		
	GameManager.trainResult==SceneManager.trainResult.none
	GameManager.trainGeneral=""	


@onready var puzzle_game: Control = $CanvasInventory/puzzleGame

func confirmBuild():
	GameManager.sav.coin-=GameManager.puzzleCostMoney
	GameManager.sav.labor_force-=GameManager.puzzleCostPeople
	
	if GameManager.sav.have_event["基建修塔教程"]==false:
		DialogueManager.show_example_dialogue_balloon(GameManager.sys,"基建筑墙教程")
		GameManager.sav.have_event["基建修塔教程"]=true			
	puzzle_game.initGame()
func loseGame():
	puzzle_game._on_lose_button_down()

func loseTrain():
	pass
func returnMain():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"来把仕诡牌")	
func succussAfter():
	GameManager.sav.have_event["刘备成长0"]=true
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"刘备的成长")	
#func gotoYIHUI():
	#SceneManager.changeScene(SceneManager.roomNode.BOULEUTERION,2)
