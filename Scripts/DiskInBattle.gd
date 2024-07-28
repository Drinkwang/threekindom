extends Control
class_name DiskInBattle
@export var datas:Array[TextureProgressBar]
@onready var selectHero=$"../"
#var battleCircle=[
#	{"name":"无风险","initPos":0,"radian":90},
# Called when the node enters the scene tree for the first time.
var selectgeneral
func _ready():
	#初始化其中一个，然后随机获取一个 初始化按照gamemanager数据来
	var btdatas=GameManager.battleCircle
	for i in range(0,3):
		var btdata=btdatas[i]
		datas[i].radial_initial_angle=btdata.initPos
		datas[i].radial_fill_degrees=btdata.radian
		
		
	#初始化玩家坐标系
	datas[4].radial_initial_angle=btdatas[4].initPos
	datas[4].radial_fill_degrees=btdatas[4].radian
	
	
	
	

	
func _juideCompeleteTask():
	#用100减去安全区的值
	#
	var rewardMax=360-GameManager.battleCircle[0].radian
	#所有风险区的变化最后都会改成无风险值变大
	var generalLevel=selectgeneral.level
	var mustHave=rewardMax*(generalLevel+10)/20     #+generalLevel*rewardMax/20
	#var mustHave=rewardMax/2
	var targetGet=0
	 
	#等级 （reward/100）*mustrewad
	var btdatas=GameManager.battleTasks
	var tasks=btdatas.task
	var haveRes
	
	for task in tasks:
		var value=task.value
		if task.res=="coin":
			haveRes=curCoin	
		else:
			haveRes=curSoilder		
		var sybol=task.sybol
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
			targetGet=targetGet+ (task.reward/100)*mustHave


 	
		#battleTasks[battleTarget].task=[{"res":"coin","symbol":sy1,"value":15*battleTasks[battleTarget].index,"reward":nums[0]},{"res":"human","symbol":sy2,"value":50*battleTasks[battleTarget].index,"reward":nums[1]}]
	
	# 	{"name": "赵云", "level": 1, "max_level": 10, "randominit": -1}
# 判断选择武将的石头剪刀布
#首先获取选择的武将
	#btdatas.sdType
	var type = GameManager.generals.find_key(selectgeneral)
	
	if btdatas.sdType+1%3==type:
		targetGet=targetGet-  (btdatas.reward/100)*mustHave
		 #玩家失败
	elif btdatas.sdType==type:
		pass
		 #平局
	else: 
		targetGet=targetGet+  (btdatas.reward/100)*mustHave
		#玩家获胜
			
	pass

	#当玩家的值大于basevalue时，每提升10% 会有5%的提升 上部封顶 但是最多玩家将会获得100%的和平区域 也就是最多为rewardMax
	var levelup= int(floor(curCoin /(btdatas.index*30)))*2+int(floor(curSoilder/(btdatas.index*50)))*5
	#targetGet=targetGet+levelup
	#if(targetGet>rewardMax):
	#	targetGet=rewardMax
	#看情况开启注释代码
	#封顶
	#当玩家的coin值大于basevalue 每提升10% 会有3%提升
	_changeCircle(targetGet)
		
	pass # Replace with function body.

var curCoin
var curSoilder

func _processSuccussCircle(coin,soilder):
	curCoin=coin
	curSoilder=soilder
	_juideCompeleteTask()
	pass
	


func _changeCircle(rewardGet):
	#获取的reward去由高到底转换
	

	var btdatas:Array=GameManager.battleCircle
	
	
	#{"name":"无风险","initPos":0,"radian":90,"index":0},#
	#{"name":"小风险","initPos":0,"radian":90,"index":1},#
	#{"name":"中风险","initPos":0,"radian":90,"index":2},#
	#{"name":"高风险","initPos":0,"radian":90,"index":3},#
	#{"name":"成功率","initPos":-1,"radian":60,"index":4}
	var cost=rewardGet
	

	
	
	for i in range(3,0,-1):
		
		if(cost>btdatas[i].radian):	
			cost=cost-btdatas[i].radian
			btdatas[i].radian=0
			#修复二边初始角度
			
		else:
			datas[i].radial_fill_degrees=datas[i].radial_fill_degrees-cost
			#修复二边初始角度
			
			break;	
			
		var btdata=btdatas[i]
		datas[i].radial_initial_angle=btdata.initPos
		datas[i].item.radial_fill_degrees=btdata.radian
	
		#不能直接改data
	btdatas[0].radian=btdatas[0].radian+rewardGet
	
	
	

	#从起始initindex开始围绕一圈
	var initindex=btdatas[0].index
	var nextInitIndex
	
	
	
	var calradian=btdatas[0].radian
	
	if(initindex>3):
		nextInitIndex=0
	else:
		nextInitIndex=btdatas[0].index+1

	while(nextInitIndex!=initindex):
		var e#=btdatas.find(item=>item.index==nextInitIndex)#()
		for i in range(datas.size()):
			if datas[i]==nextInitIndex:
				e=datas[i]
				break
		
		
		nextInitIndex.initPos=calradian
		calradian=calradian+nextInitIndex.radian
		if(initindex>3):
			nextInitIndex=0
		else:
			nextInitIndex=btdatas[0].index+1
		
	
	
	refresh()

	#datas[4].radial_initial_angle=btdatas[4].initPos
	#datas[4].item.radial_fill_degrees=btdatas[4].radian

	
func refresh():
	var btdatas=GameManager.battleCircle
	for i in range(0,3):
		var btdata=btdatas[i]
		datas[i].radial_initial_angle=btdata.initPos
		datas[i].item.radial_fill_degrees=btdata.radian
		
		
	#初始化玩家坐标系
	datas[4].radial_initial_angle=btdatas[4].initPos
	datas[4].item.radial_fill_degrees=btdatas[4].radian
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
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "rotation_degrees", 360 * ROTATION_DURATION, ROTATION_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.start()


	tween.tween_callback(_on_Tween_tween_all_completed)
	
	
# 在旋转动画开始之前生成一个随机角度
	stop_angle = randf_range(0, 360)



func _on_Tween_tween_all_completed():
	await 2
	
	
	# 计算停止位置



	# 显示结果

