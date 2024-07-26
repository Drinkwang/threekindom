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
		datas[i].item.radial_fill_degrees=btdata.radian
		
		
	#初始化玩家坐标系
	datas[4].radial_initial_angle=btdatas[4].initPos
	datas[4].item.radial_fill_degrees=btdatas[4].radian
	
	
	
	
	
	
	
#func intBattleTask():
	#
	#for battleTarget in range(3):
		#battleTasks[battleTarget]={}
		#battleTasks[battleTarget].index=completeTask+battleTarget+1
		#var taskNum:int=randi_range(1, 2)
		#if taskNum==1:
			#var resTyoe=randi_range(1, 2)
			#var res
			#var costNum
			#if(resTyoe==1):
				#res="coin"
				#costNum=15*battleTasks[battleTarget].index
			#else:
				#res="human"
				#costNum=50*battleTasks[battleTarget].index
			#var syTyoe:int=randi_range(0, 2)
			#var sy =opcost.values()[syTyoe]
			#battleTasks[battleTarget].task=[{"res":res,"symbol":sy,"value":costNum}]
		#elif taskNum==2:
			#var syTyoe1=randi_range(0, 2)
#
			#var sy1 =opcost.values()[syTyoe1]
			#var syTyoe2=randi_range(0, 2)
			#var sy2=opcost.values()[syTyoe2]
			#battleTasks[battleTarget].task=[{"res":"coin","symbol":sy1,"value":15*battleTasks[battleTarget].index},{"res":"human","symbol":sy2,"value":50*battleTasks[battleTarget].index}]
		#var sdType:int=randf_range(0, 3)
		#battleTasks[battleTarget].sdType=RspEnum.values()[sdType-1]	
	
	
func _juideCompeleteTask():
	#用100减去安全区的值
	#
	var rewardMax=100-GameManager.battleCircle[0].radian
	#所有风险区的变化最后都会改成无风险值变大


	var btdatas=GameManager.battleTasks
	# 	{"name": "赵云", "level": 1, "max_level": 10, "randominit": -1}
# 判断选择武将的石头剪刀布
#首先获取选择的武将
	btdatas.sdType
	var type = GameManager.generals.find_key(selectgeneral)
	if btdatas.sdType+1%3==type:
		pass
		 #玩家失败
	elif btdatas.sdType==type:
		pass
		 #平局
	else: 
		#玩家获胜
		pass
	
	pass
	
	#会获取reward 所有任务加起来将会占 轻度损伤 中毒损伤 高度损伤合计值  等级越高，reward也越高，同理失败reward也越高，但是平局会有基础reward
	#士兵和钱财会提高成功率，但不会将低损伤
	

	#var cloneData=datas.duplicate()
	##var initValue:int=-1
	#while cloneData.size()>0:
		#var item:TextureProgressBar=cloneData.pick_random();
		#if initValue==-1:
			#initValue=randi_range(0,360)
		#else:
			#initValue=initValue+90
		#item.radial_initial_angle=initValue
		#item.radial_fill_degrees=90
		#cloneData.remove_at(cloneData.find(item))

		
		
	pass # Replace with function body.


func _processSuccussCircle():
	
	pass
	
	
	
func refresh():
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
