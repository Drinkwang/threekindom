extends Node

#GameManager
var day
const DESTINATION = preload("res://Destination.tscn")
var intellectual_support #士族支持度 一开始为100 当议会中 会出现支持和不支持以及摇摆 
const MANUAL_TEST = preload("res://ManualTest.tscn")
#以下三个值均为三股不同力量士族可以篡改的值 其中士族可以把控群众支持度，商贾可以把控金钱，丹阳派系的军官可以把控劳动力
var people_surrport=100 #群众支持度 数值
var  coin=100 #金钱 数值
var labor_force=100 #劳动力 可以当作军队进行使用 劳动力转换成军队需要消耗值 骑兵 步兵 弓兵
var destination:String #放在gameins里面
@export var datas:Array[cldata] 

enum RspEnum{
	ROCK=1,
	PAPER=0,
	SCISSORS=2
	
	
}


enum opcost{
	greater,
	less,
	equal
	
	
}
# 声明变量
var generals:Dictionary = {RspEnum.ROCK:{"name": "关羽", "level": 1, "max_level": 10, "randominit": -1},

RspEnum.PAPER:{"name": "张飞", "level": 1, "max_level": 10, "randominit": -1},

RspEnum.SCISSORS:{"name": "赵云", "level": 1, "max_level": 10, "randominit": -1}
}

# [
# 	{"name": "关羽", "level": 1, "max_level": 10, "randominit": -1},
# 	{"name": "张飞", "level": 1, "max_level": 10, "randominit": -1},
# 	{"name": "赵云", "level": 1, "max_level": 10, "randominit": -1}
# ]
var battleTasks={}



var battleCircle=[
	{"name":"无风险","initPos":0,"radian":90,"index":0},
	{"name":"小风险","initPos":0,"radian":90,"index":1},
	{"name":"中风险","initPos":0,"radian":90,"index":2},
	{"name":"高风险","initPos":0,"radian":90,"index":3},
	{"name":"成功率","initPos":-1,"radian":60,"index":4}
	
	#初始值会带有一些随机元素，但会根据优势更偏进好的 初始成功率不大于30  做任务降低损失增大成功率 
]
const HAOZUPAI = preload("res://Asset/tres/haozupai.tres")
const BENTUPAI = preload("res://Asset/tres/bentupai.tres")
const WAIDIPAI = preload("res://Asset/tres/waidipai.tres")


var Merit_points:int=3
var currenceScene
var have_event = {
	"firstmeetchenqun":false,
	"firsthouse": false,
	"firststreet": false,
	"firstgovernment":false,
	"firstgovermentTip":false,	
	"firstPolicyOpShow":false,
	"firstPolicyCorrect":false,
	"firstTabLaw":false,#为false不显示tab面板 只触发一次对话
	"firstLawExecute":false,#为false 不显示close选项 只触发一次对话
	"firstParliamentary":false,
	#second事件 
	"secondStreet":false,
	"firstTraining":false,
	"firstWar":false,
}

var policy_Item=[
	{
		"id":1,
		"name":"上策-限制军需物资法",
		"detail":"所有军队领袖，严禁擅自动用粮草物资，必须经士族批准后方可动用。一切军需，须经过严格审批备案，不得私自行动。", #前往花园并通向小道
		"group":0
	},
	{
		"id":2,
		"name":"中策-军需审批规定",
		"detail":"军队领袖应向相关报备所需物资，并等待审批后方可调用。一切军需申请，必须经过严格审批程序，禁止私自调度。", #前往花园并通向小道
		"group":0
	},
	{
		"id":3,
		"name":"下策-物资调度违规处罚法",
		"detail":"凡有违反调度规定者，不分情节轻重，一律拉出军营，以极刑示众。对于私自调用粮草者，立即斩首示众，家属一并流放，绝不宽贷。", #前往花园并通向小道
		"group":0
	},	
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var count = 4  # 你可以在这里设置需要的数字数量
	var numbers = generate_random_numbers(100, count)
	print(numbers)
	print("Sum: ", array_sum(numbers))

func array_sum(arr: Array) -> int:
	var sum = 0
	for i in arr:
		sum += i
	return sum

func _enterDay():
	initPaixi(BENTUPAI)
	initPaixi(WAIDIPAI)
	initBattleCircle()
	
	
#		{"name":"高风险","initPos":0,"radian":90},
var completeTask:int=0	
	
func intBattleTask():
	nums={}

	for battleTarget in range(3):
		battleTasks[battleTarget]={}
		battleTasks[battleTarget].index=completeTask+battleTarget+1
		var taskNum:int=randi_range(1, 2)
		if taskNum==1:
			var resTyoe=randi_range(1, 2)
			var res
			var costNum
			if(resTyoe==1):
				res="coin"
				costNum=15*battleTasks[battleTarget].index
			else:
				res="human"
				costNum=50*battleTasks[battleTarget].index
			var syTyoe:int=randi_range(0, 2)
			var sy =opcost.values()[syTyoe]
			nums=generate_random_numbers(100,2)
			battleTasks[battleTarget].task=[{"res":res,"symbol":sy,"value":costNum,"reward":nums[0]}]
			battleTasks[battleTarget].reward=num[1]
		elif taskNum==2:
			var syTyoe1=randi_range(0, 2)
			nums=generate_random_numbers(100,3)
			var sy1 =opcost.values()[syTyoe1]
			var syTyoe2=randi_range(0, 2)
			var sy2=opcost.values()[syTyoe2]
			battleTasks[battleTarget].task=[{"res":"coin","symbol":sy1,"value":15*battleTasks[battleTarget].index,"reward":nums[0]},{"res":"human","symbol":sy2,"value":50*battleTasks[battleTarget].index,"reward":nums[1]}]
			battleTasks[battleTarget].reward=num[2]
		var sdType:int=randf_range(0, 3)
		battleTasks[battleTarget].sdType=RspEnum.values()[sdType-1]

#func _ready():
	#var numbers = generate_random_numbers(100, 2, 3)
	#print(numbers)
	#print("Sum: ", numbers.sum())
func generate_random_numbers(total: int, count: int) -> Array:
	var numbers = []
	
	# Generate (count - 1) random numbers
	for i in range(count - 1):
		var num = randi() % (total - (count - i - 1)) + 1  # Ensure non-zero and space for remaining numbers
		num = max(num, 10)  # Ensure the minimum value is 10
		numbers.append(num)
		total -= num
	
	# The last number is the remainder
	numbers.append(total)
	
	# Shuffle the list to ensure randomness
	numbers.shuffle()
	
	return numbers


var israndom=false
func initBattleCircle():
	initGenerlRandom()
	var indexs=[0,1,2,3]
	var initValue:int=-1	
	var randomInitValue:int=0
	intBattleTask()
	#battleCircle[4].initPos=
	var seq=0
	while indexs.size()>0:
		var randomcircle=randi_range(10,(360-randomInitValue)/2)	
		var index=indexs.pick_random()
		indexs.remove_at(indexs.find(index))
		if initValue==-1:
			initValue=randi_range(0,360)
			randomInitValue=randi_range(0,360)
			battleCircle[index].index=0

		else:
			initValue=initValue+90
			if(indexs.size()!=1):
				randomInitValue=randomInitValue+randomcircle
			else:
				randomInitValue=360-randomInitValue
		
		#var randomcircle=randi_range(10,(360-initValue)/2)		
		if(israndom==true):
			battleCircle[index].radian=randomcircle 
			battleCircle[index].initPos=randomInitValue
		else:
			battleCircle[index].radian=90  #最多占剩余的一半，比如说0-180 1 359/2=179.5+ 
			battleCircle[index].initPos=initValue
		battleCircle[index].index=seq
		seq=seq+1
		
		
		

func initGenerlRandom():
	for value in generals:
		value.randominit=randi_range(0,360)



func MoreBackGround():
	pass


func LessDamage():
	pass
#	var cloneData=datas.duplicate() #复制一份，然后随机选

	#while cloneData.size()>0:
		#var item:TextureProgressBar=cloneData.pick_random();
	

		#item.radial_initial_angle=initValue
		#item.radial_fill_degrees=90
		#cloneData.remove_at(cloneData.find(item))

#	pass
	
func initPaixi(data:cldata):
	
	#data._num_sp=(data._num_all*data._support_rate)/100+0.5
	data._num_op=(data._num_all*(100-data._support_rate))/100+0.5
	data._num_rt=randf_range(0,data._num_op*2)
	data._num_sp=(data._num_all-data._num_op-data._num_rt)
	#data._num_op
	pass
func extractByGroup(index):
	return policy_Item.filter(func(item): item.group== index)

func extractById(id):
	return policy_Item.filter(func(item): item.group== id)[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
