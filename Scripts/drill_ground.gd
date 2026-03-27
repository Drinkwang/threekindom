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

@onready var fade: AnimationPlayer = $CanvasLayer/ColorRect/fade

@onready var zhaoyun: Node2D = $zhaoyun
@onready var wumin: Node2D = $wumin

@onready var color_rect: ColorRect = $ColorRect
@onready var fog: TextureRect = $Fog



@onready var danyangSoilder: Node2D = $"丹阳军官"

func danyangFinal():
	GameManager.sav.have_event["最终丹阳"]=true
	#获得人口奖励，待编辑

func wumindissipate():
	fade.play("RESET")
	var tween=create_tween()
	tween.tween_property(zhaoyun, "modulate:a",0, 5)
	#无名消散
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
	initFogAndRect()	

func initFogAndRect():
	if GameManager.sav.have_event["亲征对话结束"]==true and GameManager.sav.have_event["血战袁术完成"]==false:
		if color_rect!=null:
			color_rect.show()
			var day =GameManager.get_bloodmode_day()
		#	var double
		#	if day<8:
		#		double=day
		#	else:
		#		double=8
			color_rect.color.a=0.078+0.02*day
		
		#0.13+0.0
		if GameManager.sav.currenceValue>=21:
			fog.show()
		if not SoundManager.is_music_playing():
			pass
			#要么音乐a
			if GameManager.sav.currenceValue<26:
				#SoundManager.stop_music()
				SoundManager.play_music(sounds.bloodmusic0)
			else:
				SoundManager.play_music(sounds.bloodmusic1)
const bgm = preload("res://Asset/bgm/校场.wav")

func _judWin():
	if(not (GameManager.sav.targetTxt!=null and GameManager.sav.targetTxt.length()>0) or DialogueManager.dialogBegin==true):
		return
	if GameManager.sav.targetResType==GameManager.ResType.battle or GameManager.sav.targetResType==GameManager.ResType.stayFight:
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
				if GameManager.sav.have_event["曹操没法来援助"]==false:
					GameManager.sav.have_event["曹操没法来援助"]=true
					DialogueManager.show_example_dialogue_balloon(dialogue_resource,"曹操挟天子开始")

		if GameManager.sav.currenceValue>=GameManager.sav.targetValue:
			_completeTask()
				# 如果你满足条件，则弹出对话
		elif GameManager.sav.extraBattleDialogContext.length()>0 and GameManager.sav.extraBattleTaskTargetNum>0 and GameManager.sav.extraCureenTaskCNum>=GameManager.sav.extraBattleTaskTargetNum and GameManager.sav.extraBattleTaskBootNum<=GameManager.sav.currenceValue:
			#不能胜利后 触发剧情 然后再触发这个
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
@onready var lvbu: clickBlock = $"吕布"


func _completeTask():#将完成任务移动到外层
	if(GameManager.sav.have_event["completeTask2"]==false):
		GameManager.sav.have_event["completeTask2"]=true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"征讨结束")
		#这个被黄巾那个打断
	elif GameManager.sav.have_event["lvbuJoin"]==false&&GameManager.sav.have_event["battleTaiShan"]==true:	
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"发现吕布")

		
	#在吕布帮助下取得三次军事行动	
	elif GameManager.sav.have_event["canSummonLvbu"]==true&&GameManager.sav.have_event["completebattleTaiShan"]==false:

			GameManager.sav.have_event["completebattleTaiShan"]=true		
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"温侯降伏臧霸")
	elif  GameManager.sav.have_event["曹操协天子以令诸侯"]==true and GameManager.sav.have_event["袁术首次击败"]==false:
		GameManager.sav.have_event["袁术首次击败"]=true
		
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"征讨袁术结束")
	elif GameManager.sav.have_event["战斗袁术血战模式"]==true and GameManager.sav.have_event["血战袁术完成"]==false:
		#GameManager.sav.have_event["血战袁术完成"]=true
		if GameManager.dontHaveDominance()==false and GameManager.sav.HAOZUPAI.supressNum>=3 and GameManager.sav.WAIDIPAI.supressNum>=3 and \
		GameManager.sav.LVBU.supressNum>=3 and GameManager.sav.BENTUPAI.supressNum>=3:
			
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"不丢徐州线")
		else:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"丹阳线")
	
	#	elif GameManager.sav.BENTUPAI._support_rate<60:
	#		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"士族线")
	
	#	elif GameManager.sav.HAOZUPAI._support_rate<60:
	#		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"豪族线")
			#pass #其实以上三种都是丢徐州 但是通过战斗胜利次数，判断有无进入克苏鲁线
	#	else:
	#		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"不丢徐州线")
			#进入非丢徐州线路 反攻吕布和袁术 受x天
	#		pass
		
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
		caobaoshow()
		GameManager.sav.have_event["征询曹将军意见"]=true
		#pass
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"征询曹将军意见")
		#pass
		return
		
	if GameManager.sav.have_event["亲征对话结束"]==true and GameManager.sav.have_event["战斗袁术血战模式"]==false:
		#GameManager.sav.have_event["战斗袁术血战模式"]=true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"演武场宣战袁术")
		#如果没播放音乐 就播放
		
		SoundManager.stop_music()
		SoundManager.play_music(sounds.bloodmusic0)		
		initFogAndRect()
		#20-120
		#32 12
		return 
	if GameManager.sav.have_event["袁术首次击败"]==true and GameManager.sav.have_event["关押曹豹"]==true:
		GameManager.sav.have_event["关押曹豹"]=false
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"放出曹豹")
		return
	if GameManager.sav.have_event["曹豹和吕布勾连1"]==true and GameManager.sav.have_event["曹豹和吕布勾连2"]==false:
		#chendeng.show()
		#mizhu.show()
		#mizhu.showEX=false
		#chendeng.showEX=false
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"得知吕布和曹豹勾连2")
		GameManager.sav.have_event["曹豹和吕布勾连2"]=true
		return 		
		
	var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.龙胆亮银枪)	
	if num==0:	
		if GameManager.sav.have_event["预获得龙胆枪休息"]==true:
			caobaoshow() #也可以改成点击
			caobao.showEX=true
			caobao.changeAllClick("获得龙胆枪")
	
		
	if GameManager.bossmode==scenemanager.bossMode.huang and GameManager.sav.have_event["曹豹支线3"]==false:
		GameManager.sav.hp=0
		
		caobaoshow()
		
		if GameManager.bossmoderesult==true:
			GameManager.sav.have_event["预获得龙胆枪"]=true
			print("可以拿到龙胆枪")
			#赢了，第二天获得龙胆影月枪
		GameManager.sav.have_event["曹豹支线3"]=true #第二天可以获得新道具
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"曹豹结尾")
		
		return 
		
	if GameManager.sav.have_event["最终泰山"]==true and GameManager.sav.have_event["辕门射戟"]==false:# 吕布辕门射戟
		GameManager.sav.have_event["辕门射戟"]=true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"吕布辕门射戟")
		return
	_initData()
	#wuminBanView()
func caobaoshow():
	if GameManager.sav.have_event["关押曹豹"]==false and GameManager.sav.have_event["战斗袁术血战模式"]==false:
		caobao.show()
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
	
	GameManager.sav.targetValue=32
	GameManager.sav.currenceValue=0
	GameManager.sav.targetResType=GameManager.ResType.stayFight
	GameManager.initBattle()
	GameManager.sav.targetTxt="血战模式：{currence}/{target}"
	#觉得无用的注释GameManager.sav.TargetDestination="battle"
	_initData()
	
	battle_pane.refreshData()

func refreshData():
	#_initData()


	if caobao.dialogue_start.length()>0:
		caobaoshow()
	else:
		caobao.hide()
@onready var guanyu: Node2D = $guanyu

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
			GameManager.sav.have_event["刘备成长2"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"刘备的成长2")
		elif GameManager.selectBoardCharacter==boardType.boardCharacter.caobao and GameManager._boardMode!=boardType.boardMode.none and GameManager._boardGameWin==true:
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
	
		elif GameManager.sav.endPath!=GameManager.endPath.none and GameManager.sav.have_event["回忆无名"]==false:
			GameManager.sav.have_event["回忆无名"]=true
			#还没开发完毕，滤镜，还有回忆的场景，明天测试和开发
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"前置剧情·赵云荐士")
		elif GameManager.trainResult==SceneManager.trainResult.win:
			if GameManager.trainGeneral=="关羽":
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"关羽比武胜利")

			elif GameManager.trainGeneral=="张飞":
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"张飞比武胜利")
	
			elif GameManager.trainGeneral=="无名":
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"赵云比武胜利")
			

		elif GameManager.trainResult==SceneManager.trainResult.fail:
			if GameManager.trainGeneral=="关羽":
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"关羽比武失败")

			elif GameManager.trainGeneral=="张飞":
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"张飞比武失败")
	
			elif GameManager.trainGeneral=="无名":
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"赵云比武失败")
			

	
		
		elif GameManager.sav.have_event["查出药囊后休息前"]==true and GameManager.sav.have_event["锦囊咨询丹阳派"]==false and caobao.showEX==false:
			caobao.changeAllClick("演武场克苏鲁剧情支线")
			caobao.showEX=true
			caobaoshow()
	
		elif GameManager.sav.have_event["曹豹支线1"]==false and GameManager.sav.have_event["battleTaiShan"]==true and caobao.showEX==false:
			caobao.changeAllClick("曹豹支线1")
			caobaoshow()
			caobao.showEX=true
	
			
		elif GameManager.sav.have_event["曹豹支线2"]==false and GameManager.sav.caobaoSideWait==1:
			if GameManager.sav.have_event["曹豹资助"]==false:#暂时没想好写啥
				caobaoshow()


				GameManager.sav.have_event["曹豹资助"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"插入曹豹资助")
				
		elif GameManager.sav.have_event["曹豹支线2"]==false and GameManager.sav.caobaoSideWait==0 and caobao.showEX==false:	
			caobao.changeAllClick("曹豹支线2")
			caobaoshow()
		
			caobao.showEX=true	
		else:
			if GameManager.sav.day>=7 and GameManager.sav.have_event["开启比武训练"]==false:
				GameManager.sav.have_event["开启比武训练"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"比武训练解锁")
		
			elif GameManager.sav.caobaocardgame>=0  and caobao.showEX==false:
			#如果小于4 则移出3 
			
			
			#@export var mizhucardgame=-1
			#@export var chendencardgame=-1
				if GameManager.sav.endPath!=GameManager.endPath.xiaopei:
					if GameManager.sav.have_event["boss战开始"]==false and GameManager.sav.caobaocardgame==4 and GameManager.sav.mizhucardgame==5 and GameManager.sav.chendencardgame==5:
					
						caobao.changeAllClick("来把仕诡牌2")
						caobaoshow()
						caobao.showEX=true
					elif GameManager.sav.have_event["boss战开始"]==false and GameManager.sav.caobaocardgame==4 and (GameManager.sav.mizhucardgame<5 or GameManager.sav.chendencardgame<=5):
						caobao.hide()
					else:
						caobao.changeAllClick("来把仕诡牌")
						caobaoshow()
						caobao.showEX=false
				elif GameManager.sav.have_event["最终丹阳"]==false and GameManager.sav.WAIDIPAI._support_rate>=80 and GameManager.sav.have_event["主簿的追随"]==true:
					danyangSoilder.show()
					danyangSoilder.changeAllClick("丹阳将领投靠")

					
		
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

	if GameManager.sav.have_event["战斗袁术血战模式"]==true and GameManager.sav.have_event["血战袁术完成"]==false:
		initData[3].visible="true"
		initData[0].visible="false"
		if  GameManager.sav.isGetCoin==false:
			if GameManager.sav.currenceValue<15:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"每日物质送来")
			elif GameManager.sav.currenceValue==15 or GameManager.sav.currenceValue==18:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"每日物质送不来")
			elif GameManager.sav.currenceValue==21:
				#进入克苏鲁
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"克苏鲁线自相啖食0")
			elif GameManager.sav.currenceValue==26:
				#克苏鲁第一天
				SoundManager.stop_music()
				SoundManager.play_music(sounds.bloodmusic1)				
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"克苏鲁线自相啖食")
			
				pass
			elif GameManager.sav.currenceValue==28:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"克苏鲁线2")
			elif GameManager.sav.currenceValue==30:
				GameManager.sav.have_event["无名之死"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"克苏鲁线3")
			elif GameManager.sav.currenceValue==32:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"克苏鲁线3")

	else:
		#initData[3].visible="false"
		initData[0].visible="true"
	if(GameManager.sav.day>=3):
		initData[2].visible="true"
		
	items_in_scene.showItems()	
	control._processList(initData)

#@onready var eatpeople: Node2D = $eatpeople

@onready var jia: Node2D = $eatpeople/jia
@onready var jia_body: clickBlock = $eatpeople/jiaBody

@onready var bing: clickBlock = $eatpeople/bing

@onready var meat:Node2D  = $eatpeople/meat
@onready var yi: Node2D = $eatpeople/yi
@onready var wumin_inmeat: Node2D = $eatpeople/wumin
@onready var finger: Node2D = $eatpeople/finger




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

		_reward.showTitileReward(tr("你战胜了曹豹"),items)	
	elif GameManager._boardReward==boardType.boardRewardResult.card:
		var _reward:rewardPanel=PanelManager.new_reward()
	
		var items={
			"items": {InventoryManagerItem.ItemEnum.仕诡卡血姬:1},
			"money": 0,
			"population": 0
		}
		_reward.showTitileReward(tr("你战胜了曹豹"),items)	
	GameManager._boardReward=boardType.boardRewardResult.none
func select2(issuccuss):
	GameManager.sav.have_event["曹豹支线2"]=true


	if issuccuss==true:
		GameManager.sav.have_event["曹豹正确选择2"]=true
		
		if GameManager.sav.have_event["曹豹支线2"]==true and GameManager.sav.have_event["曹豹正确选择1"]==true:
			
			GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.CAOBAO]=tr("夜探黄帝遗迹，揭穿盗宝阴谋")
	else:
		GameManager.sav.have_event["曹豹正确选择2"]=false

func drillKeComplete():
	caobao.hide()
	caobao.dialogue_start=""
	GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.KESULU]=""
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
		if GameManager.sav.have_event["战斗袁术血战模式"]==true and GameManager.sav.have_event["血战袁术完成"]==false:
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
		#battle_pane._refreshGeneral()
		res_panel.position.x=1564
		res_panel.position.y=803
		res_panel.scale=Vector2(0.765,0.765)
		if GameManager.sav.have_event["battleTaiShan"]==true:
			if GameManager.sav.have_event["臧霸首战之前"]==false:
				GameManager.sav.have_event["臧霸首战之前"]=true
				DialogueManager.show_dialogue_balloon(dialogue_resource,"臧霸首战之前")
			elif GameManager.sav.have_event["战斗袁术开始"]==true:
				if GameManager.sav.have_event["袁术也进军"]==false:
					GameManager.sav.have_event["袁术也进军"]=true
					DialogueManager.show_dialogue_balloon(dialogue_resource,"征讨袁术开始")
		elif GameManager.sav.have_event["吕布之怒"]==true and GameManager.sav.have_event["吕布怒气_演武场"]==false:
			GameManager.sav.have_event["吕布怒气_演武场"]=true
			#这个过后就变成吕布
			DialogueManager.show_dialogue_balloon(dialogue_resource,"吕布的怒气")
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
		#得修改，只要当日决斗为3即可，没必要非得10，否则有bug
		if (GameManager.sav.UseGeneral.size()<3 and GameManager.sav.have_event["关羽求援期间"]==false) \
		or(GameManager.sav.UseGeneral.size()<2 and GameManager.sav.have_event["关羽求援期间"]==true and GameManager.sav.have_event["关羽求援结束"]==false and GameManager.sav.have_event["无名之死"]==false) \
		or(GameManager.sav.UseGeneral.size()==0 and GameManager.sav.have_event["无名之死"]==true and GameManager.sav.have_event["关羽求援结束"]==false):
			DialogueManager.show_dialogue_balloon(dialogue_resource,"血战模式无法提前休息")
			return
		#暂时不用rest文本来修改，未来可能会用，把代码移动到这里更直观	
		#GameManager.restLabel=tr("与此同时")	
		GameManager.restFadeScene=SceneManager.DRILL_GROUND	
		GameManager._rest()

	pass

#练兵结束调用这个 初次练兵

func showbattletutorial():
	DialogueManager.show_exaple_top_dialogue_balloon(dialogue_resource,"第一次军事行动教程_上")
	
func showbattletutorial2():
	DialogueManager.show_dialogue_balloon(dialogue_resource,"第一次军事行动教程_下")
	
	
@onready var chendao: clickBlock = $"陈到"
	
	
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
	if GameManager.sav.have_event["战斗袁术血战模式"]==true and GameManager.sav.have_event["血战袁术完成"]==false:
		train_panel.control_2.hide()
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
@onready var zhangfei: Node2D = $zhangfei

@onready var point = $CanvasInventory/point

var _tween:Tween
var _tween2:Tween

func showtutorial_back(num):
	
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
		_tween=get_tree().create_tween()
		_tween.tween_property(battle_pane.soild_slider, "value",30, 5)
		_tween.tween_property(battle_pane.soild_slider, "value",0, 5)
		_tween2=get_tree().create_tween()
		_tween2.tween_property(battle_pane.coin_slider, "value",30, 5)
		_tween2.tween_property(battle_pane.coin_slider, "value",0, 5)		
		
	if(num<4):
		battle_pane["guild_"+str(num)].show()
	if(num>=2 and num<=3):
		battle_pane["guild_"+str(num-1)].hide()

	if num==2:
		
		#调整value为完成任务，如果没有则不调整
		
		
		var btdatas=GameManager.sav.battleTasks[0]
		_tween.kill()
		_tween2.kill()
		_tween=get_tree().create_tween()
		_tween2=get_tree().create_tween()
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

			_tween.tween_property(ResSlider, "value",movevalue, 0.05)
		

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
	elif num==5:

		_tween.kill()
		_tween2.kill()
		
		battle_pane.coin_slider.value=0
		battle_pane.soild_slider.value=0		
		point.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.




@onready var animation_player: AnimationPlayer = $CanvasInventory/battlePane/AnimationPlayer

func changePot(type:SceneManager.potType):
	if type==SceneManager.potType.Full:
		meat.txt2d=full_pot
	elif type==SceneManager.potType.Empty:
		meat.txt2d=empty_pot
	elif type==SceneManager.potType.Strange:
		meat.txt2d=strange_pot
	elif type==SceneManager.potType.Dying:
		meat.txt2d=dying_pot
	elif type==SceneManager.potType.Herbal:
		meat.txt2d=herbal_pot
	elif type==SceneManager.potType.Blood:
		meat.txt2d=blood_pot
const dying_pot = preload("res://Asset/锅_将熄.png")
const blood_pot = preload("res://Asset/锅_带血.png")
const herbal_pot = preload("res://Asset/锅_草药.png")
const strange_pot= preload("res://Asset/肉汤怪异.png")
const empty_pot = preload("res://Asset/肉汤无.png")
const full_pot = preload("res://Asset/肉汤满.png")
#人物被刀受伤
func makePeoplehurt(_c):
	var tween=get_tree().create_tween()
	
	tween.tween_property(_c, "modulate", Color(0.8, 0, 0, 1), 5)

#逐渐消失，消失后hide
func makePeopleDie(_c):
		#sword_sprite_2d.hide()
	var tween=get_tree().create_tween()
	#SoundManager.play_sound(sounds.BLOODCC_1)
	tween.tween_property(_c, "modulate:a",0, 2)
	await get_tree().create_timer(2).timeout
	_c.hide()

#从甲的的尸体崩出手指然后放到移动到无名旁边，是对话框外

@onready var fog_player: AnimationPlayer = $Fog/fogPlayer

func addExtraFog():
	fog_player.play("fogadd")

func findFinger():
	finger.show()
	var tween=get_tree().create_tween()

	tween.tween_property(finger, "scale", Vector2(0.5,0.5), 1)
	tween.tween_property(finger, "position", wumin_inmeat.position, 1)
	tween.chain()
	tween.tween_property(finger, "modulate:a", 0, 1)
	await get_tree().create_timer(2).timeout
	finger.hide()
	
#
func jiaLeave():
	var tween=get_tree().create_tween()
	tween.tween_property(jia, "position", Vector2(0,250), 1)
#移动到甲的尸体旁边
func wuminandjia():
	
	var tween=get_tree().create_tween()

	tween.tween_property(wumin_inmeat, "position", Vector2(145,-161), 2)
	#wumin_inmeat
#移动到乙的旁边被推开
func wuminandyi1():
	
	finger.position=Vector2(-153,-8)
	wumin_inmeat.position=Vector2(-271,-33)

func wuminandyi2():
	var tween=get_tree().create_tween()

	tween.tween_property(yi, "position", Vector2(-226,-166), 1)

#func wuminandyi3():
	#var tween = get_tree().create_tween()
	##tween.set_target(wumin_inmeat)
	#
	## ========== 第一步：快速冲过去 ==========
	## 移动到目标位置（快进）
	#tween.tween_property(wumin_inmeat, "position", Vector2(-226,-166), 0.25)
	## 冲击感缓动：先快后慢
	#tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	#
	## 可选：冲过去时放大到0.5倍（同步执行缩放）
#
	#tween.parallel().tween_property(wumin_inmeat, "scale", Vector2(1.2, 1.2), 0.25)
	#
	## ========== 第二步：立刻弹回原位置 ==========
	## chain() 表示“上一步完成后立刻执行”
	#tween.chain()
	## 弹回初始位置（慢一点，有被推开的惯性感）
	#tween.tween_property(wumin_inmeat, "position", Vector2(-271,-33), 0.45)
	## 回弹缓动：先慢后快，模拟被推开的弹力
	#tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	#
	## 可选：回弹时恢复原缩放
	#
	#tween.parallel().tween_property(wumin_inmeat, "scale", Vector2(1, 1), 0.45)
	#
func wuminmove():
	var tween=get_tree().create_tween()

	tween.tween_property(wumin_inmeat, "position", Vector2(-73,-320), 2)
	
	#wumin_inmeat.position=Vector2(-271,-33)

func showtutorial(num):

	if num==1:
		battle_pane.guild_1.show()
		battle_pane.istour=true
		battle_pane.rect_1.show()
	elif num==2:
		battle_pane.guild_1.hide()
		battle_pane.guild_2.show()
		battle_pane.rect_2.show()
		battle_pane.rect_1.hide()
	elif num==3:
		battle_pane.guild_2.hide()
		battle_pane.guild_3.show()
		battle_pane.rect_3.show()
		battle_pane.rect_2.hide()		
	elif num==4:
		battle_pane.guild_3.hide()
		battle_pane.rect_4.show()
		battle_pane.rect_3.hide()				
	elif num==5:
		battle_pane.istour=false
		battle_pane.point_group.hide()
		var target_guild_node = battle_pane["rect_4"]
		target_guild_node.hide()
		battle_pane.rect_4.hide()
	
	
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
	
func guanyuBan():
	GameManager.sav.have_event["关羽求援期间"]=true
	#battle_pane.control_1.hide()
	#无需写实，但需要屏蔽注册 比武对话
	#train_panel.control_1.hide()
	pass	
	
func wuminBan():
	#写实ban
	GameManager.sav.have_event["无名之死"]=true
	#wuminBanView()
	
#func wuminBanView():
	#if GameManager.sav.have_event["无名之死"]==true:
		#battle_pane.control_3.hide()
		#train_panel.control_3.hide()	
	
func yuanshuComplete():
	GameManager.sav.TargetDestination="府邸"

	pass
	
func tempLockCaoBao():
	GameManager.sav.WAIDIPAI.ChangeSupport(-10)
	GameManager.sav.LVBU.ChangeSupport(20)
	GameManager.sav.have_event["关押曹豹"]=true
	
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
	
	
	if GameManager.sav.currenceValue==9:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"张飞鞭挞讨好士族")
		#==5张飞惩戒		
	#GameManager._DayGet()
	#if(GameManager.sav.targetTxt!=null and GameManager.sav.targetTxt.length()>0):	
	#	_JudgeTask()
func _dontGet():
	
	if GameManager.sav.currenceValue==24:
		
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"张飞杀曹豹")

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
	DialogueManager.dialogBegin=false
	_judWin()	


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
	
	GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.BADAO]=("寻访商人，揭示仕诡牌真相")
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
	elif GameManager.trainGeneral=="无名":
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
	elif GameManager.trainGeneral=="无名":
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
	elif GameManager.trainGeneral=="无名":
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
	caobao.hide()
	items_in_scene.hide()
	puzzle_game.initGame()	
	if GameManager.sav.have_event["基建修塔教程"]==false:
		DialogueManager.show_example_dialogue_balloon(GameManager.sys,"基建筑墙教程")
		GameManager.sav.have_event["基建修塔教程"]=true			

func loseGame():
	caobao.show()
	items_in_scene.show()
	
	puzzle_game._on_lose_button_down()

func loseTrain():
	pass
func returnMain():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"来把仕诡牌")	
func succussAfter():
	guanyu.show()
	items_in_scene.show()
	
	GameManager.sav.have_event["刘备成长0"]=true
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"刘备的成长")	
#func gotoYIHUI():
	#SceneManager.changeScene(SceneManager.roomNode.BOULEUTERION,2)
func xiaopei():
	GameManager.sav.have_event["血战袁术完成"]=true
	
	
	GameManager.sav.endPath=GameManager.endPath.xiaopei
	GameManager.restLabel=tr("昔日徐州牧已成过眼云烟，今日刘备退守小沛。咽下屈辱，只为在绝境中苟全火种。这一步隐忍，不仅是为了活下去，更是为了在未来的某一天，将失去的一切都拿回来！")

	SceneManager.rest_scene(SceneManager.roomNode.HOUSE)
	#播放声音
	#SoundManager.play_sound(bgs194)	
	#GameManager.restFadeScene=SceneManager.HOUSE	
	#GameManager._rest()
func hidePeople():
	caobao.hide()

func showPeople():
	caobao.show()
