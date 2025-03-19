extends Control
class_name DiskInBattle
@export var datas:Array[TextureProgressBar]
@onready var selectHero=$"../"

@onready var control = $".."
const jiandao = preload("res://Asset/other/剪刀.png")
const bu = preload("res://Asset/other/布.png")
const shitou = preload("res://Asset/other/石头.png")
const Success=preload("res://.godot/imported/Success.svg-af58d452c13e928b2a282a117f5e080e.ctex")
const fail=preload("res://Asset/other/0_red.png")


#var battleCircle=[
#	{"name":"无风险","initPos":0,"radian":90},
# Called when the node enters the scene tree for the first time.
var selectgeneral
#ne
func _endReward():
	pass
	#print(点击完毕)
	#点击通过
	#判断是否完成任务
	#$PointerScifiB.hide()

@onready var enemy = $enemy

func _ready():
	SignalManager.endReward.connect(_endReward)
	_initBattleTypePng(0,GameManager.sav.battleTasks[taskIndex].sdType)
	for i in range(1,3):
		var sd=GameManager.sav.battleTasks[i-1].sdType
		_initBattleTypePng(i,sd)
	#初始化其中一个，然后随机获取一个 初始化按照gamemanager数据来
	var btdatas=GameManager.battleCircle
	for i in range(0,4):
		var btdata=btdatas[i]
		datas[i].radial_initial_angle=btdata.initPos
		datas[i].radial_fill_degrees=btdata.radian
		
		
	#初始化玩家坐标系
	datas[4].radial_initial_angle=btdatas[4].initPos
	datas[4].radial_fill_degrees=btdatas[4].radian
	changeLanguage()
	refreshPage()
const NOT_JAM_UI_CONDENSED_16 = preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")	
func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="ja":
		pass
	elif currencelanguage=="ru":
		$"VBoxContainer/无风险/Label".add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		$"VBoxContainer/低风险/Label".add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		#task_label.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		$"VBoxContainer/低风险2/Label".add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		$"VBoxContainer/低风险3/Label".add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		$"VBoxContainer/成功率/Label".add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
	else:
		pass	
	
var taskIndex:int=0

var taskComplete=0
	
func _juideCompeleteTask():
	#用100减去安全区的值
	#
	taskComplete=0
	var rewardMax=360-GameManager.battleCircle[0].radian
	#所有风险区的变化最后都会改成无风险值变大
	var generalLevel
	if(selectgeneral!=null):
		generalLevel=selectgeneral.level
	else:
		generalLevel=0
	var mustHave=rewardMax*(generalLevel+10)/20     #+generalLevel*rewardMax/20
	#var mustHave=rewardMax/2
	var targetGet=0
	#print("befoer"+str(targetGet))
	#等级 （reward/100）*mustrewad
	var btdatas=GameManager.sav.battleTasks[taskIndex]
	var tasks=btdatas.task
	var haveRes

	for task in tasks:
		var value=task.value
		var minValue
		if task.res=="coin":
			haveRes=curCoin	
			minValue=int(floor(value*2/3))
		else:
			haveRes=curSoilder		
			minValue=int(floor(value*3/5))
		var sybol=task.symbol
		var iscomplete=false
		if sybol==GameManager.opcost.greater:
			if(haveRes>value):
				iscomplete=true
		elif sybol==GameManager.opcost.less:
			if(haveRes<value and haveRes>minValue):
				iscomplete=true
		elif sybol==GameManager.opcost.equal:
			if(haveRes==value):
				iscomplete=true
		if iscomplete==true:
			targetGet=targetGet+ ((task.reward/100.0)*mustHave)
			taskComplete=taskComplete+1

 	

	# 	{"name": "赵云", "level": 1, "max_level": 10, "randominit": -1}
# 判断选择武将的石头剪刀布
#首先获取选择的武将
	#btdatas.sdType
	var type = GameManager.generals.find_key(selectgeneral)
	
	if (btdatas.sdType==GameManager.RspEnum.SCISSORS&&type==GameManager.RspEnum.PAPER) or\
	(btdatas.sdType==GameManager.RspEnum.PAPER&&type==GameManager.RspEnum.ROCK) or\
	(btdatas.sdType==GameManager.RspEnum.ROCK&&type==GameManager.RspEnum.SCISSORS):
		#print("失败"+str(btdatas.reward))
		targetGet=targetGet-  ((btdatas.reward/100.0)*mustHave)
		 #玩家失败 暂时不扣 免得有bug
	elif btdatas.sdType==type:
		#print("平局")
		pass
		 #平局
	else: 
		targetGet=targetGet+  ((btdatas.reward/100.0)*mustHave)
		taskComplete=taskComplete+1
		#print("获胜")
		#玩家获胜
			
	pass

	
	#可加入每次完成任务，成功率提升10%
	#当玩家的值大于basevalue时，每提升10% 会有5%的提升 上部封顶 但是最多玩家将会获得100%的和平区域 也就是最多为rewardMax
	var levelup= int(floor(curCoin /(btdatas.index)))*2+int(floor(curSoilder/(btdatas.index)))*10+(generalLevel*18)
	GameManager.battleCircle[4].radian=levelup;
	#targetGet=targetGet+levelup
	#if(targetGet>rewardMax):
	#	targetGet=rewardMax
	#看情况开启注释代码
	#封顶
	#当玩家的coin值大于basevalue 每提升10% 会有3%提升
	#print("after"+str(targetGet))
	_changeCircle(targetGet)
		
	pass # Replace with function body.

var curCoin=0
var curSoilder=0

func _processSuccussCircle(coin,soilder):
	curCoin=coin
	curSoilder=soilder
	_juideCompeleteTask()
	pass
	

var battleCircleClone:Array;
func _changeCircle(rewardGet):
	#获取的reward去由高到底转换
	

	battleCircleClone=GameManager.battleCircle.duplicate(true)
	
	
	#{"name":"无风险","initPos":0,"radian":90,"index":0},#
	#{"name":"小风险","initPos":0,"radian":90,"index":1},#
	#{"name":"中风险","initPos":0,"radian":90,"index":2},#
	#{"name":"高风险","initPos":0,"radian":90,"index":3},#
	#{"name":"成功率","initPos":-1,"radian":60,"index":4}
	var cost=rewardGet
	
	if(battleCircleClone[0].radian+rewardGet<0):
		rewardGet=0-battleCircleClone[0].radian

	
	for i in range(3,0,-1):
		
		if(cost>battleCircleClone[i].radian):	
			cost=cost-battleCircleClone[i].radian
			battleCircleClone[i].radian=0
			#修复二边初始角度
			
		else:
			battleCircleClone[i].radian=battleCircleClone[i].radian-cost
			cost=0;
			break;	
			
	
	#这玩意不能改动，有二个方法
	battleCircleClone[0].radian=battleCircleClone[0].radian+rewardGet
	
	
	

	#从起始initindex开始围绕一圈
	var initindex=battleCircleClone[0].index
	var nextInitIndex
	
	var calradian=0
	#下面逻辑会导致旋转图出现混乱，并且没有做保护措施
	if battleCircleClone[0].radian>0:
		calradian=battleCircleClone[0].radian
	if calradian<0:
		calradian=0
	if(initindex+1>3):
		nextInitIndex=0
	else:
		nextInitIndex=initindex+1
	while(nextInitIndex!=initindex):
		var e
		for i in range(battleCircleClone.size()):
			if battleCircleClone[i].index==nextInitIndex:
				e=battleCircleClone[i]
				break
		#有bug待修复

		#此处不能用加法
		e.initPos=fmod((battleCircleClone[0].initPos-calradian),360.0)
		if e.radian>0:
			calradian=calradian+e.radian
		
		if(nextInitIndex+1>3):
			nextInitIndex=0
		else:
			nextInitIndex=nextInitIndex+1
		
	
	
	refresh()



	
func refresh():
	
	for i in range(0,4):
		var btdata=battleCircleClone[i]
		datas[i].radial_initial_angle=btdata.initPos
		datas[i].radial_fill_degrees=btdata.radian
		
		
	#初始化玩家坐标系
	datas[4].radial_initial_angle=battleCircleClone[4].initPos
	datas[4].radial_fill_degrees=battleCircleClone[4].radian
	#玩家坐标只会受到二个影响 一个是coin 一个是soilder
	

var isBoot:bool=false

func lauchProgress(hp):
	if isBoot ==false:
		isBoot=true
		_hp=hp
		_on_SpinButton_pressed()

# Called every frame. 'delta' is the elapsed time since the previous frame.



# 定义转盘的半径和奖品数量
const RADIUS = 200
const PRIZE_COUNT =5

# 定义转盘的中心点
const CENTER = Vector2(0, 0)

# 定义旋转动画的持续时间
const ROTATION_DURATION = 5

var stop_angle

var _hp
func _on_SpinButton_pressed():

	# 开始旋转动画
	$PointerScifiB.show()
	var tween = get_tree().create_tween()
	#add_child(tween)
	#tween.interpolate_property(self, "rotation_degrees", 360 * ROTATION_DURATION, ROTATION_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.start()
	stop_angle = randf_range(0, 360)
	
	
	for data in battleCircleClone:

		if(data.radian>0):
			data.initPos=fmod(data.initPos,360.0)
			var lowerValue=data.initPos-data.radian
			var upperValue=data.initPos
			if(lowerValue<0):
				lowerValue=lowerValue+360
			if(upperValue<0):
				upperValue=upperValue+360	
			if(stop_angle-45== lowerValue and stop_angle-45<upperValue):
				stop_angle+5
				
			
	
	tween.tween_property($PointerScifiB, "rotation_degrees", 360 * ROTATION_DURATION+stop_angle, 2)


	tween.tween_callback(_on_Tween_tween_all_completed)
	
	
# 在旋转动画开始之前生成一个随机角度


# 实例化四张石头剪刀布图片
func _initBattleTypePng(index,type):
	if(type==GameManager.RspEnum.PAPER):
		find_child("ColorRect_"+str(index)).get_child(0).texture=bu
	elif type== GameManager.RspEnum.ROCK:
		find_child("ColorRect_"+str(index)).get_child(0).texture=shitou
	else:
		find_child("ColorRect_"+str(index)).get_child(0).texture=jiandao
	#this["ColorRect_0"].hidden()$ColorRect_0
	pass


func _on_Tween_tween_all_completed():
	await 2
	$PointerScifiB.rotation_degrees=fmod(stop_angle,360)
	var real_angle=stop_angle-45 #减去图片偏差的45度
	var issuccess=false;
	var selectPart
	if(real_angle<0):
		real_angle=real_angle+360
	for data in battleCircleClone:
		if(data.radian>0):
			
		
			var lowerValue=data.initPos-data.radian
			var upperValue=data.initPos
			
			if(lowerValue<0):
				#pass
				#var temp=upperValue
				lowerValue=lowerValue+360
				#lowerValue=temp#+360
			if(upperValue<0):
				print("严重错误 请检查 但可能严重错误被下面if排除")
				pass
				#upperValue=upperValue+360	
			if(real_angle> lowerValue and real_angle<upperValue and lowerValue<upperValue) or (lowerValue>upperValue and not(real_angle> upperValue and real_angle<lowerValue ) or data.radian>=360):
			#if(is_in_sector(real_angle,lowerValue,upperValue)):
				#print(data.name)
				if data.name=="成功率":
					issuccess=true
				else:
					selectPart=data.name
				
				pass
			
	GameManager.sav.hp=GameManager.sav.hp-_hp
	settleGame(selectPart,issuccess)
	#将风险值和成功率一起输入
	#print(real_angle)
	isBoot=false
	
	# 计算停止位置
	
	#
		#{"name":"无风险","initPos":0,"radian":90,"index":0},
	#{"name":"小风险","initPos":0,"radian":90,"index":1},
	#{"name":"中风险","initPos":0,"radian":90,"index":2},
	#{"name":"高风险","initPos":0,"radian":90,"index":3},
	#{"name":"成功率

var buffMultiple=1
var finalScore
func settleGame(end,issuccess):
	#扣除消耗 只会消耗士兵
	#无风险 无扣除
	#小风险 扣除10-20%
	#中风险 扣除30-40%
	#高风险 扣除50-100%
	

	var cost=10000
	var percentage=0
	if end =="无风险":
		cost=0
		percentage=0
	elif end=="小风险":
		percentage=randi_range(10,30)
		pass
	elif end=="中风险":
		percentage=randi_range(30,70)
		pass
	elif end=="高风险":
		percentage=randi_range(70,100)
		pass
	if cost!=0:
		cost= int(floor(curSoilder*percentage)/100)
	#删除cost
	GameManager.sav.coin=GameManager.sav.coin-curCoin
	GameManager.sav.labor_force=GameManager.sav.labor_force-cost

	var _rewardPanel:rewardPanel=PanelManager.new_reward()
	_rewardPanel.coinCost=curCoin
	
	_rewardPanel.soilderCost=cost
	if issuccess==true:
		GameManager.sav.battleResults[taskIndex]=GameManager.BattleResult.win
		print("你win了")
		if GameManager.sav.targetResType==GameManager.ResType.battle:
			GameManager.sav.currenceValue=GameManager.sav.currenceValue+1
		#判断胜利积分
		var enemyPower=GameManager.sav.battleTasks[taskIndex].index*50

		finalScore=GameManager.calculate_points(enemyPower,taskComplete, percentage/100,selectgeneral.level,buffMultiple)
		var items=GameManager.ScoreToItem(finalScore)
		_rewardPanel.showReward(items)
		#一旦完成target的数量，就令其获胜，来到府邸进行下一步操作
		GameManager.sav.completeTask=GameManager.sav.completeTask+1
	else:
		GameManager.sav.battleResults[taskIndex]=GameManager.BattleResult.fail
		print("你输了")
		_rewardPanel.fail()
	#bug 开始修改这里的问题
	curCoin=0
	curSoilder=0
	
	GameManager.sav.currenceTask=GameManager.sav.currenceTask+1
	refreshPage()
	if(selectgeneral!=null):
		GameManager.sav.UseGeneral.push_front(selectgeneral)
	taskIndex=taskIndex+1
	if(taskIndex>=3):
		GameManager.initBattleCircle()
		taskIndex=0
	Txtcount.text=str(GameManager.sav.completeTask)+"/"+str(GameManager.sav.currenceTask)

	
@onready var Txtcount = $count


func refreshPage():
	enemy.namelv=tr("(当前战力:{targetValue})").format({"targetValue": GameManager.sav.battleTasks[taskIndex].index*50}) 
	var btresult= GameManager.BattleResult
	var txt
	for i in range(0,GameManager.sav.battleResults.size()):
		var _ColorRect=find_child("ColorRect_"+str(i+1))
		var tag:TextureRect=_ColorRect.get_node("tag")
	
		if(GameManager.sav.battleResults[i]==btresult.win):
			txt=Success
		elif (GameManager.sav.battleResults[i]==btresult.fail):
			txt=fail
		elif (GameManager.sav.battleResults[i]==btresult.none):
			tag.hide()
			continue
		tag.show()
	
		tag.texture=txt
	
		pass
	#将下面的结果和石头剪刀布都进行修改
	# 显示结果
#定义一个枚举，然后显示当前win还是false
#得保存

