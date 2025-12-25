extends baseComponent

class_name  bouleuterion
@onready var control =$CanvasBook/Control
@onready var yishimianban = $CanvasBook/yishimianban

const FancyFade = preload("res://addons/transitions/FancyFade.gd")

@onready var mizhu = $"CanvasBook/糜竺"
@onready var chendeng = $"CanvasBook/陈登"
#@onready var context = $PanelContainer/MarginContainer/VBoxContainer/context
const newBuild = preload("res://Asset/城镇建筑/会议室新.png")
const xiaopeiBuild = preload("res://Asset/城镇建筑/会议室旧.png")
#议事详细
@onready var parliamentary_detail = $CanvasBook/parliamentaryDetail

	#var initData=[
	#{	
	#	"name":"xxx",
	#	"context":"执行政策", #前往小道通向议事厅 
	#	"img":"true"
	#},

@onready var faction = $CanvasBook/faction

#将这个页面的操作面板显示并存档
#dontwork
func implementpolicy():
	GameManager.sav.have_event["firstPolicyOpShow"]=true
	_initData()
	pass
	
#将施政面板显示并存档
func showTab():
	GameManager.sav.have_event["firstTabLaw"]=true
	_initData()
const bgmmeet = preload("res://Asset/bgm/会议室.wav")	
#const 议会2 = preload("res://Asset/bgm/议会2.mp3")
func post_transition():
	GameManager.CanClickUI=true
	SoundManager.stop_all_ambient_sounds()
	SoundManager.play_ambient_sound(bgmmeet)
	print("fadedone")
	_initData()

@onready var bg = $"内饰"

# Called when the node enters the scene tree for the first time.
func _ready():

	Transitions.post_transition.connect(post_transition)
	control.buttonClick.connect(_buttonListClick)
	
	if GameManager.sav.day==4:
		ymlShow()

	super._ready()
	
	changeLanguage()
	SignalManager.changeLanguage.connect(changeLanguage)		
	if GameManager.sav.have_event["initXuzhou"]==true:
		bg.texture=newBuild
	else:
		bg.texture=xiaopeiBuild		
		
	changePanelPos()	
@onready var node_2d = $CanvasBook/Node2D

func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()	
	if currencelanguage=="en":
		node_2d.position=Vector2(615,811)
	elif currencelanguage=="zh":
		node_2d.position=Vector2(400,811)
	elif currencelanguage=="lzh":
		node_2d.position=Vector2(410,811)
	elif currencelanguage=="ja":
		node_2d.position=Vector2(468,811)
		#node_2d.position=Vector2(615,811)
	elif currencelanguage=="ru":
		node_2d.position=Vector2(605,811)
		faction.position=Vector2(5,728.545)
		pass

#@onready var faction = $CanvasBook/faction

func _initFaction():
	pass


func liubeiGrowup():
	#GameManager.hearsayID=-1
	SceneManager.changeScene(SceneManager.roomNode.DRILL_GROUND,2)

func _initData():
	#if	GameManager.sav.have_event["firstgovernment"]==false:
		#DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
		#GameManager.sav.have_event["firstgovernment"]=true
	GameManager.currenceScene=self
	var initData=[
	{	
		"id":"1",
		"context":"开始议事", #前往小道通向议事厅 
		"visible":"true"
	},
	{
		"id":"2",
		"context":"议事说明", #前往花园并通向小道
		"visible":"true"
	},
	{
		"id":"3",
		"context":"离开",#前往大街
		"visible":"true"
	},

	]
	#if GameManager.sav.have_event["firstBoleuterion"]==true:
	
	if GameManager.bossmode==scenemanager.bossMode.tao and GameManager.sav.have_event["陈登支线3"]==false:
		GameManager.sav.hp=0
		chendeng.show()
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"陈登结尾")
		GameManager.sav.have_event["陈登支线3"]=true
		return 	
	
	
	if GameManager.sav.have_event["刘备成长0"]==true and GameManager.sav.have_event["刘备成长1"]==false:

		chendeng.show()
		mizhu.show()
		mizhu.showEX=false
		chendeng.showEX=false
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"刘备的成长")
		GameManager.sav.have_event["刘备成长1"]=true
		return 	
	if GameManager.sav.have_event["曹豹和吕布勾连0"]==true and GameManager.sav.have_event["曹豹和吕布勾连1"]==false:
		chendeng.show()
		mizhu.show()
		mizhu.showEX=false
		chendeng.showEX=false
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"曹豹吕布联姻")
		GameManager.sav.have_event["曹豹和吕布勾连1"]=true
		return 	
	if GameManager.sav.day==4:
		if GameManager.sav.have_event["firstNewEnd"]==true:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"新手教程结束_阴谋论")
			return
	elif GameManager.sav.day==2:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
	
	if GameManager.hearsayID==3:
		chendeng.show()
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"陈登第三次市井")
		return
		
	if control.visible==true:	
		items_in_scene.showItems()
	control._processList(initData)
	
	
	if GameManager.selectBoardCharacter==boardType.boardCharacter.chenden and GameManager._boardMode!=boardType.boardMode.none and GameManager._boardGameWin==true:
			
	
		GameManager.selectBoardCharacter=boardType.boardCharacter.none         
		GameManager._boardMode=boardType.boardMode.none
		if GameManager._boardReward!=boardType.boardRewardResult.BreakFree:
			GameManager.resumeMusic()
			
			
			if GameManager._boardGameWin==true:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"常规获胜")
			else:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"常规失败")	
			chendeng.show()
			chendeng.changeAllClick("来把仕诡牌")				
		else:
			GameManager.resumeMusic()
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"黑暗游戏获胜")	
			chendeng.show()
			chendeng.changeAllClick("来把仕诡牌")	
	elif GameManager.selectBoardCharacter==boardType.boardCharacter.chenden and GameManager._boardMode!=boardType.boardMode.none and GameManager._boardGameWin==false:
	
		GameManager.selectBoardCharacter=boardType.boardCharacter.none
		GameManager._boardMode=boardType.boardMode.none
		
		if GameManager._boardReward!=boardType.boardRewardResult.BreakFree:
			GameManager.resumeMusic()
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"常规失败") 
			chendeng.show()
			chendeng.changeAllClick("来把仕诡牌")	
		else:
			GameManager.resumeMusic()
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"黑暗游戏失败") 
			chendeng.show()
			chendeng.changeAllClick("来把仕诡牌")				
				   
		
	
	elif GameManager.sav.have_event["陈登支线1"]==false and GameManager.sav.day>=5:
		chendeng.show()
		chendeng.showEX=true
		chendeng.changeAllClick("陈登爱吃鱼1")	
		
	elif GameManager.sav.have_event["陈登支线2"]==false and GameManager.sav.have_event["陈登支线1"]==true and GameManager.sav.chendenSideWait==1:
		if GameManager.sav.have_event["陈登送礼"]==false:
			GameManager.sav.have_event["陈登送礼"]=true
			chendeng.show()
			chendeng.showEX=false
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"陈登赞助")
		
	elif GameManager.sav.have_event["陈登支线2"]==false and GameManager.sav.have_event["陈登支线1"]==true and GameManager.sav.chendenSideWait==0:
		chendeng.show()
		chendeng.showEX=true
		chendeng.changeAllClick("陈登爱吃鱼2")	
	else:
		if GameManager.sav.chendencardgame>=0:
			#如果等于4 
			chendeng.changeAllClick("来把仕诡牌")

					
			chendeng.show()
			chendeng.showEX=false
var costhp=50
func chendengWantUpLevel():
	chendeng.hide()
	#GameManager._propertyPanel.GetValue(200,0,0)
	
	
	var _reward:rewardPanel=PanelManager.new_reward()
	
	var items={
		"items":null,
		"money": 200,
		"population": 0
	}

	_reward.showTitileReward(tr("你获得了陈登捐助的200金"),items,false)	
	
const kek = preload("res://Asset/sound/咳嗽1.wav")
func eatFish1(issuccuss=false):
	GameManager.sav.chendenSideWait=3
	GameManager.sav.have_event["陈登支线1"]=true
	SoundManager.play_sound(kek)
	if issuccuss==true:
		GameManager.sav.have_event["陈登正确选择1"]=true
	else:
		GameManager.sav.have_event["陈登正确选择1"]=false
		#GameManager.sav.hp
func eatFish2(issuccuss=false):

	GameManager.sav.have_event["陈登支线2"]=true


	if issuccuss==true:
		GameManager.sav.have_event["陈登正确选择2"]=true
	else:
		GameManager.sav.have_event["陈登正确选择2"]=false
func hearSayEnd():
	GameManager.hearsayID=-1
	SceneManager.changeScene(GameManager.hearsayBeforeNode,2)

func _buttonListClick(item):
	if item.context == "开始议事":
		if GameManager.getCurLawExist()==false:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"当前不存在法律")
			return
		
		if(await GameManager.isTried(costhp)):
			return
			
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"开始议事")
	elif item.context == "议事说明":
		yishimianban.show()
		#显示接下来要点击啥
		pass
	elif item.context == "离开":
		if GameManager.sav.day<5:
			if(GameManager.sav.have_event["firstParliamentary"]==true):
				SceneManager.changeScene(SceneManager.roomNode.STREET,2)
			else:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"不能离开")
		else:
				SceneManager.changeScene(SceneManager.roomNode.STREET,2)
		#显示金钱 民心 xx 武将面板
	print(item)
	pass



func showGuild():
	$CanvasBook/Node2D.show()
	$"CanvasBook/Node2D/5Yellow/AnimationPlayer".play("YELLOWGUILD")
	
func meetingEnd():
	control._show_button_5_yellow(2)
	GameManager.sav.destination="自宅"

func hideGuild():
	$CanvasBook/Node2D.hide()


func showResult():
	if await GameManager.isTried(costhp):
		return 
	GameManager.sav.hp=GameManager.sav.hp-costhp
	parliamentary_detail.show()
	parliamentary_detail.enter()
	
	return

	#preload("res://Scene/street.tscn")
	#SceneManager.STREET.instantiate()	
	#这个代码哪怕不执行，放在这里可以防止cldate的资源管理被覆盖，被蠢godot释放

	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
const _chendenhecha = preload("res://Asset/人物/陈登睁眼.png")
const _chendenhechaOpen = preload("res://Asset/人物/陈登睁眼喝茶.png")
const _chendenOpen = preload("res://Asset/人物/陈登闭喝茶.png")

func chendenhecha():
	chendeng.img=_chendenhecha


func chendenhechaOpen():
	chendeng.img=_chendenhechaOpen


func chendenOpen():
	chendeng.img=_chendenOpen


const _mizhuCLOSE = preload("res://Asset/人物/糜竺眨眼.png")
const _mizhuOpen = preload("res://Asset/人物/糜竺睁眼.png")
const _mizhuxiao = preload("res://Asset/人物/糜竺笑.png")
func mizhuClose():
	mizhu.img=_mizhuCLOSE

func mizhuOpen():
	mizhu.img=_mizhuOpen
	

func mizhuxiao():
	mizhu.img=_mizhuxiao

func ymlShow():
	mizhu.show()
	chendeng.show()
	pass
	
	
func ymlShowEnd():
	GameManager.restLabel=tr("没过多久，刘备也收到了来自徐州的密信")
	GameManager.restFadeScene=null
	GameManager._rest()
	pass
	
	


func SettleLawRevenue():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"通过法案")
	faction.refreshData()
@onready var claimLabel = $CanvasBook/ColorRect/Label

	
func GetLawClaimRevenue():
	var action=GameManager.lawAction
	if action.is_valid():  # 检查Callable是否有效
		action.call()   
		#播放获取金币的声音	
	else:
		print("错误：未定义行动")
	
	var _date=GameManager.getcldateByindex(GameManager.sav.curLawNum1)
	var point
	for i in GameManager.sav.laws[GameManager.sav.curLawNum1]:
		if i<0:
			if abs(i)==GameManager.sav.curLawNum2:
			
				GameManager.sav.laws[GameManager.sav.curLawNum1].erase(i)
				var factions=_date._name
				 #GameManager.sav.courtingLaws[faction]=-1
				GameManager.sav.courtingLaws.erase(factions)
				var rindex=GameManager.sav.randomIndex
				point=10+rindex
				#暂时放在这里
				_date.ChangeSupport(point)
				#执行效果
				claimLabel.text=tr("提示：成功通过拉拢{factions}需求的法律！\n({factions}好感度提升{point}点)\n(该派系摇摆人数减少)").format({"factions":factions,"point":point})
				#下面不一定执行
	
				var animation_player=$CanvasBook/ColorRect/AnimationPlayer
				animation_player.speed_scale = 1.0
				animation_player.play("colorUp")
				await get_tree().create_timer(0.25).timeout
				animation_player.speed_scale = -1.0
				$CanvasBook/ColorRect/AnimationPlayer.play("colorUp")

				GameManager._imporveRelation(_date)
			
				#任务完成 获得忠诚度	
	
	GameManager.sav.curLawName=""
	GameManager.sav.curLawNum1=-1
	GameManager.sav.curLawNum2=-1
	SignalManager.changeSupport.emit()

@onready var factionView = $CanvasBook/faction

func eatFishSound():
	var EAT_2 =load("res://Asset/sound/eat2.mp3")
	SoundManager.play_sound(EAT_2)	
	

func cancelLaw():
	GameManager.sav.laws[GameManager.sav.curLawNum1].erase(GameManager.sav.curLawNum2)	
	GameManager.sav.curLawName=""
	GameManager.sav.curLawNum1=-1
	GameManager.sav.curLawNum2=-1
	faction.refreshData()

@onready var control_2: supportPanel = $CanvasBook/Control2


func changePanelPos():
	if GameManager.sav.have_event["canSummonLvbu"]==true:
		factionView.position.y=590
		control_2.position.y=902
	elif GameManager.sav.have_event["Factionalization"]==true:
		factionView.position.y=590
		control_2.position.y=835
	else:	
	#f GameManager.sav.
		factionView.position.y=520
		control_2.position.y=815
	pass
	



#黑暗游戏输了游戏	
func cardLose():
	GameManager.sav.hp=0


func boardVictory():

	if GameManager._boardReward==boardType.boardRewardResult.item:
		var _reward:rewardPanel=PanelManager.new_reward()
	
		var items={
			"items": {InventoryManagerItem.ItemEnum.益气丸:1},
			"money": 0,
			"population": 0
		}

		_reward.showTitileReward(tr("你战胜了陈登，你获得益气丸一枚"),items)	
	elif GameManager._boardReward==boardType.boardRewardResult.card:
		var _reward:rewardPanel=PanelManager.new_reward()
	
		var items={
			"items": {InventoryManagerItem.ItemEnum.仕诡卡骨龙:1},
			"money": 0,
			"population": 0
		}
		_reward.showTitileReward(tr("你战胜了陈登，你获得陈登珍藏的诡异卡"),items)	
	GameManager._boardReward=boardType.boardRewardResult.none

func openBoardGame():
	GameManager.selectBoardCharacter=boardType.boardCharacter.chenden
	GameManager.showBoardGameDialogue()
@onready var puzzle_game: Control = $CanvasBook/puzzleGame
	
func confirmBuild():
	GameManager.sav.coin-=GameManager.puzzleCostMoney
	GameManager.sav.labor_force-=GameManager.puzzleCostPeople
	puzzle_game.initGame()
	chendeng.hide()
	items_in_scene.hide()
	if GameManager.sav.have_event["基建运河教程"]==false:
		DialogueManager.show_example_dialogue_balloon(GameManager.sys,"基建挖深运河教程")
		GameManager.sav.have_event["基建运河教程"]=true		
	

func loseGame():
	puzzle_game._on_lose_button_down()	
	chendeng.show()
	items_in_scene.show()
	puzzle_game.clearData()
func openBoardDialogue():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"进入仕诡牌游戏")
		
func returnMain():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"来把仕诡牌")		
@onready var items_in_scene: Node2D = $itemsInScene
func succussAfter():
	chendeng.show()
	items_in_scene.show()
	puzzle_game.clearData()
