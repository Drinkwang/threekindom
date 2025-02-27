extends baseComponent

@onready var control= $Control2
@onready var oldsoildereat = $CanvasInventory/oldsoildereat
@onready var train_panel = $CanvasInventory/trainPanel
@onready var battle_pane:battlePanel = $CanvasInventory/battlePane
#const _校场 = preload("res://Asset/bgm/校场.mp3")
@onready var bg = $"演武场"

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
	if GameManager.sav.have_event["征询曹将军意见"]==false:
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
	SoundManager.play_music(bgm)
	print("fadedone")
	
	if GameManager.sav.have_event["亲征对话结束"]==true and GameManager.sav.have_event["战斗袁术血战模式"]==false:
		#GameManager.sav.have_event["战斗袁术血战模式"]=true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"演武场宣战袁术")
		return 
	_initData()

const EAT_1 = preload("res://Asset/sound/eat1.mp3")
func enterOldSoilderEat():
	oldsoildereat.show()
	GameManager.hp=GameManager.hp-20
	#播放聚餐声音
	SoundManager.play_sound(EAT_1)
	pass
	
	
	
var battleNum=0
@onready var caobao = $"CanvasInventory/曹豹"

func enterBattleMode():
	GameManager.sav.have_event["战斗袁术血战模式"]=true
	GameManager.hp=100
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
	else:
		initData[3].visible="false"
		initData[0].visible="true"
	if(GameManager.sav.day>=3):
		initData[2].visible="true"
	control._processList(initData)



func _buttonListClick(item):
	if item.context=="离开此地":
		if(GameManager.sav.day==1):
			if GameManager.sav.isLevelUp==false:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"训练还没有结束")
				return
		if(GameManager.sav.day==3):
			if GameManager.hp>10:
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
		if GameManager.sav.have_event["battleTaiShan"]==true:
			if GameManager.sav.have_event["臧霸首战之前"]==false:
				GameManager.sav.have_event["臧霸首战之前"]=true
				DialogueManager.show_dialogue_balloon(dialogue_resource,"臧霸首战之前")
		#if(GameManager.sav.have_event["firstBattleTutorial"]==true)：
		#暂时不能发动军事行动
	elif item.context=="休息":
		#调用休息的代码，只不过休息的地点换成演武场
		pass

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
