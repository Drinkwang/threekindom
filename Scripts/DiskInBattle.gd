extends Control
class_name DiskInBattle
@export var datas:Array[TextureProgressBar]
@onready var selectHero=$"../"

@onready var control = $".."
const jiandao = preload("res://Asset/other/剪刀.png")
const bu = preload("res://Asset/other/布.png")
const shitou = preload("res://Asset/other/石头.png")
#var battleCircle=[
#	{"name":"无风险","initPos":0,"radian":90},
# Called when the node enters the scene tree for the first time.
var selectgeneral
func _ready():
	_on_SpinButton_pressed()
	_initBattleTypePng(0,GameManager.battleTasks[taskIndex].sdType)
	for i in range(1,3):
		var sd=GameManager.battleTasks[i-1].sdType
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
	
	
	
	
var taskIndex:int=0

func _initPanel():
	_on_SpinButton_pressed()
	pass
	
func _juideCompeleteTask():
	#用100减去安全区的值
	#
	var rewardMax=360-GameManager.battleCircle[0].radian
	#所有风险区的变化最后都会改成无风险值变大
	var generalLevel=selectgeneral.level
	var mustHave=rewardMax*(generalLevel+10)/20     #+generalLevel*rewardMax/20
	#var mustHave=rewardMax/2
	var targetGet=0
	print("befoer"+str(targetGet))
	#等级 （reward/100）*mustrewad
	var btdatas=GameManager.battleTasks[taskIndex]
	var tasks=btdatas.task
	var haveRes
	
	for task in tasks:
		var value=task.value
		if task.res=="coin":
			haveRes=curCoin	
		else:
			haveRes=curSoilder		
		var sybol=task.symbol
		var iscomplete=false
		if sybol==GameManager.opcost.greater:
			if(haveRes>value):
				iscomplete=true
		elif sybol==GameManager.opcost.less:
			if(haveRes<value):
				iscomplete=true
		elif sybol==GameManager.opcost.equal:
			if(haveRes==value):
				iscomplete=true
		if iscomplete==true:
			targetGet=targetGet+ ((task.reward/100.0)*mustHave)
	

 	

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
		#print("获胜")
		#玩家获胜
			
	pass
	#可加入每次完成任务，成功率提升10%
	#当玩家的值大于basevalue时，每提升10% 会有5%的提升 上部封顶 但是最多玩家将会获得100%的和平区域 也就是最多为rewardMax
	var levelup= int(floor(curCoin /(btdatas.index)))*8+int(floor(curSoilder/(btdatas.index)))*10+(generalLevel*18)
	GameManager.battleCircle[4].radian=levelup;
	#targetGet=targetGet+levelup
	#if(targetGet>rewardMax):
	#	targetGet=rewardMax
	#看情况开启注释代码
	#封顶
	#当玩家的coin值大于basevalue 每提升10% 会有3%提升
	print("after"+str(targetGet))
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
		e.initPos=battleCircleClone[0].initPos-calradian
		if e.radian>0:
			calradian=calradian+e.radian
		
		if(nextInitIndex+1>3):
			nextInitIndex=0
		else:
			nextInitIndex=nextInitIndex+1
		
	
	
	refresh()

	datas[4].radial_initial_angle=battleCircleClone[4].initPos
	datas[4].radial_fill_degrees=battleCircleClone[4].radian

	
func refresh():
	
	for i in range(0,4):
		var btdata=battleCircleClone[i]
		datas[i].radial_initial_angle=fmod(btdata.initPos,360.0)
		datas[i].radial_fill_degrees=fmod(btdata.radian,360.0)
		
		
	#初始化玩家坐标系
	#datas[4].radial_initial_angle=btdatas[4].initPos
	#datas[4].radial_fill_degrees=btdatas[4].radian
	#玩家坐标只会受到二个影响 一个是coin 一个是soilder
	

var isBoot:bool=false

func lauchProgress():
	isBoot=true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(isBoot==true):
		#此处不断转动转盘，直到时间平均 1秒转动一圈，
		pass
		#开始转转转



# 定义转盘的半径和奖品数量
const RADIUS = 200
const PRIZE_COUNT =5

# 定义转盘的中心点
const CENTER = Vector2(0, 0)

# 定义旋转动画的持续时间
const ROTATION_DURATION = 5

var stop_angle


func _on_SpinButton_pressed():
	# 开始旋转动画
	$PointerScifiB.show()
	var tween = get_tree().create_tween()
	#add_child(tween)
	#tween.interpolate_property(self, "rotation_degrees", 360 * ROTATION_DURATION, ROTATION_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.start()
	stop_angle = randf_range(0, 360)
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
	var real_angle=stop_angle-45 #减去图片偏差的45度
	if(real_angle<0):
		real_angle=real_angle+360
	for data in battleCircleClone:
		if(data.radian>0):
			var lowerValue=data.radian-data.initPos
			var upperValue=data.initPos
			if(real_angle> fmod(lowerValue,360.0) and real_angle<fmod(upperValue,360.0)):
				print(data.name)
				
				pass
			

	
	print(real_angle)
	
	
	# 计算停止位置



	# 显示结果

