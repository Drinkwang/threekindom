extends Node


const DESTINATION = preload("res://Destination.tscn")
@export var shopPanel:ShopPanel
const MANUAL_TEST = preload("res://ManualTest.tscn")
#以下三个值均为三股不同力量士族可以篡改的值 其中士族可以把控群众支持度，商贾可以把控金钱，丹阳派系的军官可以把控劳动力
var _savePanel:savePanel
var restLabel:String=""

#用于临时储存的值
var resideValue
enum RspEnum{
	PAPER=0,
	ROCK=1,
	SCISSORS=2,
	None=3,
	
	
}

enum ResType{
	none,
	coin,
	people,
	item,
	heart,
	battle,
	rest,
	
}

enum BattleResult{
	none=0,
	win=1,
	fail=2
	
	
}

#清理任务
func clearTask():
	sav.targetValue=1000000
	sav.targetTxt=""
	sav.TargetDestination=""
	sav.currenceValue=0

const inventoryPackege="e4530fc7-c5d6-41af-9b6e-35249272186a"
@export var sav:saveData=saveData.new()
const sys = preload("res://dialogues/系统.dialogue")
func changePeopleSupport(num):
	sav.people_surrport=sav.people_surrport+num
	if(sav.people_surrport>100):
		sav.people_surrport=100
	elif sav.people_surrport<0:
		sav.people_surrport=0
		#if失败逻辑
	if(sav.people_surrport<60 and sav.isAlertRisk==false):
		sav.isAlertRisk=true
		DialogueManager.show_example_dialogue_balloon(sys,"民变风险")
func getCurLawExist()->bool:

	return sav.curLawName!=null and sav.curLawName.length()>0 and sav.curLawNum1!=-1 and sav.curLawNum2!=-1
#@export var curLawNum1=-1
#@export var curLawNum2=-1
enum opcost{
	greater,
	less,
	equal
	
	
}
var _engerge:energe


#var _rewardPanel:rewardPanel 移动导savedate里


#剩余粮食_用于赈灾系统
var resideGrain=0

#判断是否累了的框，不用保存
var triedResult=false
var triedPanel
signal triedPanelDone
func isTried(costNum)->bool:


	if triedPanel!=null:
		return true
	if(sav.hp-costNum<0):
		#显示累了框

		if triedPanel==null:
			triedResult=true
			triedPanel=PanelManager.show_Tied()
		await triedPanelDone
		triedPanel=null
	else:
		triedResult=false
	return	triedResult


var battleCircle=[
	{"name":"无风险","initPos":0,"radian":90,"index":0},
	{"name":"小风险","initPos":0,"radian":90,"index":1},
	{"name":"中风险","initPos":0,"radian":90,"index":2},
	{"name":"高风险","initPos":0,"radian":90,"index":3},
	{"name":"成功率","initPos":90,"radian":0,"index":4}
	
	#初始值会带有一些随机元素，但会根据优势更偏进好的 初始成功率不大于30  做任务降低损失增大成功率 
]
const HAOZUPAI = preload("res://Asset/tres/haozupai.tres")
const BENTUPAI = preload("res://Asset/tres/bentupai.tres")
const WAIDIPAI = preload("res://Asset/tres/waidipai.tres")
const LVBU = preload("res://Asset/tres/lvbu.tres")

var currenceScene
var restFadeScene


var policy_Item=[
	{
		"id":1,
		"index":1,
		"name":"上策-限制军需物资法",
		"detail":"所有军队领袖，严禁擅自动用粮草物资，必须经士族批准后方可动用。一切军需，须经过严格审批备案，不得私自行动。", #前往花园并通向小道
		"group":0
	},
	{
		"id":2,
		"index":2,
		"name":"中策-军需审批规定",
		"detail":"军队领袖应向相关报备所需物资，并等待审批后方可调用。一切军需申请，必须经过严格审批程序，禁止私自调度。", #前往花园并通向小道
		"group":0
	},
	{
		"id":3,
		"index":3,
		"name":"下策-物资调度违规处罚法",
		"detail":"凡有违反调度规定者，不分情节轻重，一律拉出军营，以极刑示众。对于私自调用粮草者，立即斩首示众，家属一并流放，绝不宽贷。", #前往花园并通向小道
		"group":0
	},	
	
	
	
	#主线第一个计策
	{
		"id":4,
		"index":1,
		"name":"上策-以商代赈",
		"detail":"将给与商人更多指示性目标,用行政命令迫使商业协助完成粮食问题，军队好感上升，但商业具有不稳定性，获得一笔不定额的金钱", #每天获取钱下降，任务凑钱正常
		"group":1
	},
	{
		"id":5,
		"index":2,
		"name":"中策-军粮自给",
		"detail":"维持现状，继续让军队自行解决粮食问题，丹阳派好感小幅度下跌，因为政策不变可能会获得一笔因为政策惯性的收益", #前往花园并通向小道，ps_任务凑齐的钱会少
		"group":1
	},
	{
		"id":6,
		"index":3,
		"name":"下策-增大消费税",
		"detail":"增大城市人口商业来往的纳税，会增加城市居民生活开销负担，但会让城市获得日均收入上升，所有派系好感小幅度下跌", #前往花园并通向小道#，每天获取钱上升，任务凑钱多
		"group":1
	},	
]

#var dialogBegin=false
# Called when the node enters the scene tree for the first time.
func _ready():
	#DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	_enterDay()
	SkipPrologue()
	#_inventoryManager


#func _on_dialogue_ended():
	#dialogBegin=false
#	pass
func initBattle():
	sav.UseGeneral=[]
	#all改成any
	if(sav.battleResults.size()!=3 or sav.battleResults.any(func(e):e!=BattleResult.none)):
		sav.battleResults=[
		BattleResult.none,
		BattleResult.none,
		BattleResult.none
	#初始值会带有一些随机元素，但会根据优势更偏进好的 初始成功率不大于30  做任务降低损失增大成功率 
		]
		
		initBattleCircle()
	#同时初始化3个将军攻克面板	

func array_sum(arr: Array) -> int:
	var sum = 0
	for i in arr:
		sum += i
	return sum

func refreshPaixis():
	initPaixi(BENTUPAI)
	initPaixi(WAIDIPAI)
	#传递信号，政策看法

func _enterDay(value=true):
	if(value==true):
		GameManager.sav.day=GameManager.sav.day+1
	refreshPaixis()
	initBattle()
	sav.hp=100
	sav.isLevelUp=false;
	sav.isMeet=false
	sav.isGetCoin=false
	sav.isVisitScholar=false
	sav.randomIndex=randi_range(0,3)
	
	if GameManager.sav.xuzhouCD>0:
		GameManager.sav.xuzhouCD-=1

	if GameManager.sav.haozuCD>0:
		GameManager.sav.haozuCD-=1

	if GameManager.sav.danyangCD>0:
		GameManager.sav.danyangCD-=1

	if GameManager.sav.targetResType==GameManager.ResType.rest:
		GameManager.sav.currenceValue=GameManager.sav.currenceValue+1
		
		if GameManager.sav.have_event["chaosBegin"]==true:#第三个任务
			if GameManager.sav.currenceValue==2:
				pass#克苏鲁现象

	if GameManager.sav.have_event["chaoDialogEnd"]==true:
		if(GameManager.sav.have_event["chaosEnd"]==false):	
			sav.currenceDay=sav.currenceDay+1#	
		elif (GameManager.sav.have_event["lvbuJoin"]==true) and GameManager.sav.have_event["canSummonLvbu"]==false:
			sav.currenceDay=sav.currenceDay+1#	
			#判断是否能召见吕布，如果可以，依然执行这个方法
#利用上这个把taskindex局限于0-3 选样，并把这个数量和攻克
#用task的index用作当前任务数
#失败惩罚
#每次通关3关将taskindex回复为0
#并重新计算copletetask
#		{"name":"高风险","initPos":0,"radian":90},

func intBattleTask():
	var nums={}

	for battleTarget in range(3):
		sav.battleTasks[battleTarget]={}
		sav.battleTasks[battleTarget].index=sav.currenceTask+battleTarget+1
		var taskNum:int=randi_range(1, 2)
		if taskNum==1:
			var resTyoe=randi_range(1, 2)
			var res
			var costNum
			if(resTyoe==1):
				res="coin"
				costNum=15*sav.battleTasks[battleTarget].index
				#最小值是10*xxx
				#*10/15
			else:
				res="human"
				costNum=50*sav.battleTasks[battleTarget].index
				#最小值是30*xxx
				#*3/5
			var syTyoe:int=randi_range(0, 2)
			var sy =opcost.values()[syTyoe]
			nums=generate_random_numbers(100,2)
			sav.battleTasks[battleTarget].task=[{"res":res,"symbol":sy,"value":costNum,"reward":nums[0]}]
			sav.battleTasks[battleTarget].reward=nums[1]
		elif taskNum==2:
			var syTyoe1=randi_range(0, 2)
			nums=generate_random_numbers(100,3)
			var sy1 =opcost.values()[syTyoe1]
			var syTyoe2=randi_range(0, 2)
			var sy2=opcost.values()[syTyoe2]
			sav.battleTasks[battleTarget].task=[{"res":"coin","symbol":sy1,"value":15*sav.battleTasks[battleTarget].index,"reward":nums[0]},{"res":"human","symbol":sy2,"value":50*sav.battleTasks[battleTarget].index,"reward":nums[1]}]
			sav.battleTasks[battleTarget].reward=nums[2]
		var sdType:int=randf_range(0, 3)
		sav.battleTasks[battleTarget].sdType=RspEnum.values()[sdType-1]

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
	for value in sav.generals.values():
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
#每次立法，重新刷新派系
func initPaixi(data:cldata):
	
	#data._num_sp=(data._num_all*data._support_rate)/100+0.5
	data._num_op=(data._num_all*(100-data._support_rate))/100+0.5
	var paixiindex=GameManager.getIndexByFractionIndex(data.index)
	var lawOP=0
	if paixiindex!=GameManager.sav.curLawNum1 and GameManager.sav.curLawNum1>0:
		lawOP=((GameManager.sav.curLawNum2-1)*10.0/100.0)*(data._num_all-data._num_op)
		lawOP=floor(lawOP)

	#如果是相同派系，则为0，不同派系，将（index-1）*9到10 的百分比赋值给它
	data._num_op=data._num_op+lawOP
	var initRt=randf_range(0,max(data._num_op*2,data._num_all-data._num_op))
	if GameManager.sav.curLawNum1<=0:
		initRt=0
	data._num_rt=initRt
	data._num_sp=(data._num_all-data._num_op-data._num_rt)
	data.isrebellion=false
	#data._num_op
	pass
func extractByGroup(index):
	return policy_Item.filter(func(item): item.group== index)


# 函数可能有问题，目前好像暂时没有使用，试用前注意修改其中问题
func extractPolicyItem(index,group):
	#return policy_Item.filter(func(item): item.group== id)[0]
	var ele=GameManager.policy_Item.filter(func(ele): return ele.group == group and ele.index==index)[0]
	return ele
	
#需要在saveData定义一个对子的数据结构判断1是否执行 2是否执行	
func getPolicyGroup() -> int:
	if sav.policyExcute==false:
		if sav.day<4:
			return 1
		if sav.day==5:
			return 2
		
	return -1
	#如果处于主线状态，则取出来的是主线，否则取出来的是随机数

func getTaskCurrenceValue():
	var cur=0
	if sav.targetResType==ResType.coin:
		cur=sav.coin
	elif sav.targetResType==ResType.people:
		cur=sav.labor_force
	else:
		cur=sav.currenceValue#暂时该值未定义
	return cur

func _DayGet():
	sav.coin=sav.coin+sav.coin_DayGet
	sav.labor_force=sav.labor_force+sav.labor_DayGet

func _rest(value=true):
	const DISSOLVE_IMAGE = preload("res://addons/transitions/images/circle-inverted.png")
	_enterDay(value)
	
	Transitions.change_scene_to_instance( SceneManager.SLEEP_BLANK.instantiate(), Transitions.FadeType.Instant)



func getIndexByFractionIndex(factionIndex:cldata.factionIndex)->int:
	#index==0 士族
	#index==1 豪族
	#index==2 军方
	
	#var xuzhouCD=-1
	#var haozuCD=-1
	#var danyangCD=-1
	#var lvbuCD=-1
	#将cd代码放在外部
	var index
	if factionIndex==cldata.factionIndex.weidipai:
		index=2
	elif factionIndex==cldata.factionIndex.bentupai:
		index=0
	elif factionIndex==cldata.factionIndex.haozupai:
		index=1
	elif factionIndex==cldata.factionIndex.lvbu:

		index=3	
	
	return index	


var waidipai=cldata.factionIndex.weidipai
var bentupai=cldata.factionIndex.bentupai
var haozupai=cldata.factionIndex.haozupai
var lvbu=cldata.factionIndex.lvbu

func getcldateByindex(factionIndex:int)->cldata:
	#index==0 士族
	#index==1 豪族
	#index==2 军方
	

	if factionIndex==2:
		return preload("res://Asset/tres/waidipai.tres")
		#index=2
	elif factionIndex==0:
		return preload("res://Asset/tres/bentupai.tres")
		#index=0
	elif factionIndex==1:
		return preload("res://Asset/tres/haozupai.tres")
		#index=1
	elif factionIndex==cldata.factionIndex.lvbu:
		return preload("res://Asset/tres/haozupai.tres")
		#index=3	
	return null



#获取政策拉拢的cd  未来说不定改成每个派系操作的cd
func getCDByFaction(factionIndex:cldata.factionIndex):
	if factionIndex==cldata.factionIndex.weidipai:
		return sav.danyangCD
	elif factionIndex==cldata.factionIndex.bentupai:
		return sav.xuzhouCD
	elif factionIndex==cldata.factionIndex.haozupai:
		return sav.haozuCD
	elif factionIndex==cldata.factionIndex.lvbu:
		return sav.lvbuCD	
	else:
		return -1


const InventoryManagerName = "InventoryManager"

var lawAction: Callable
var RewardLaw
func excuteLaw():
	sav.laws[sav.curLawNum1].append(sav.curLawNum2)
	#var arr:Array
	RewardLaw=sav.RewardLaw
	lawAction= Callable() 
	if sav.curLawName=="农田开坑":#只有buff
		#RewardLaw="每日收入+50，徐州好感度+10，一次性收入+200" #收入每日增加 徐州派好感度上升
		
		lawAction= func():
			GameManager.sav.coin_DayGet=GameManager.sav.coin_DayGet+50
			GameManager.sav.coin=GameManager.sav.coin+200
			#徐州好感度+10
			BENTUPAI.ChangeSupport(10)
			print("农田开坑")

	elif sav.curLawName=="兴办教育":#只有buff
		#RewardLaw="每日人口+10，徐州好感度+5，获得道具“诸子百家”x1 " #人口每日增加 徐州派好感上升 获得道具xxx
		lawAction= func():
			BENTUPAI.ChangeSupport(5)
			GameManager.sav.labor_DayGet=GameManager.sav.labor_DayGet+10
			#获得诸子百家
			
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.诸子百家论集)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 1, false)

			print("兴办教育")		
	elif sav.curLawName=="整治街容":#只有buff
		#RewardLaw="一次性人口+100，徐州好感度+10，群众支持度+5 " #人口一次性增加 徐州派好感上升
		
		lawAction= func():
			GameManager.sav.labor_force=GameManager.sav.labor_force+100
			BENTUPAI.ChangeSupport(10)
			GameManager.changePeopleSupport(5)
			print("整治街容")			
	elif sav.curLawName=="重农抑商":
		#RewardLaw="收益：每日收入+80，徐州好感度+15 冲突：豪族好感度-20 " 
		lawAction= func():
			GameManager.sav.labor_DayGet=GameManager.sav.labor_DayGet+80
			print("重农抑商")	
	elif sav.curLawName=="士族优先":
		#RewardLaw="收益：徐州好感度+20，获得道具“珍品礼盒”x1，一次性人口+150 冲突：丹阳派好感度-15  "
		lawAction= func():
			print("士族优先")			
	elif sav.curLawName=="物价稳定":
		#RewardLaw="收益：每日收入+100，群众支持度+10 冲突：豪族好感度-30 "
		lawAction= func():
			print("物价稳定")			
	elif sav.curLawName=="屯田制":
		#RewardLaw="收益：每日人口+30，每日收入+120，一次性人口+200 冲突：丹阳派好感度-20，豪族好感度-10  "
		lawAction= func():
			print("屯田制")			
	elif sav.curLawName=="府兵制":
		#RewardLaw="收益：每日收入+150，获得道具“胜战锦囊”x2，一次性收入+1000  冲突：丹阳派好感度-30，群众支持度-10  "
		lawAction= func():
			print("府兵制")			
	elif sav.curLawName=="品级制":
		#RewardLaw="收益：徐州好感度+50，每日人口+50，获得道具“珍品礼盒”x2，一次性人口+300 冲突：豪族好感度-40，丹阳派好感度-25  "
		lawAction= func():
			print("品级制")			
#豪族		
	elif sav.curLawName=="促进商贸":#只有buff 收入每日增加 获得一笔钱财
		#RewardLaw="每日收入+10，徐州好感度+5，一次性收入+300，随机道具x1 "
		lawAction= func():
			print("促进商贸")			
	elif sav.curLawName=="诚信经营":#只有buff 所有派系好感度上升
		#RewardLaw="所有派系好感度+20，群众支持度+5，一次性人口+80"
		lawAction= func():
			print("诚信经营")			
	elif sav.curLawName=="行业准则":#只有buff 所有派系好感度随机上升
		#RewardLaw="所有派系好感度+5，每日收入+20，获得道具“珍品礼盒”x1，一次性收入+100"		
		lawAction= func():
			print("行业准则")			
	elif sav.curLawName=="禁止军商":
		#RewardLaw="收益：每日收入+50，豪族好感度+15，一次性收入+600 冲突：丹阳派好感度-25  "
		lawAction= func():
			print("禁止军商")			
	elif sav.curLawName=="商业税收法":
		#RewardLaw="收益：每日收入+80，获得道具“益气丸”x2，一次性收入+800  冲突：徐州好感度-20"
		lawAction= func():
			print("商业税收法")			
	elif sav.curLawName=="货币法":
		#RewardLaw="收益：每日收入+100，群众支持度+10 冲突：丹阳派好感度-30 "
		lawAction= func():
			print("货币法")			
	elif sav.curLawName=="商业竞争法":
		#RewardLaw="收益：每日收入+120，豪族好感度+20，一次性收入+1000 冲突：徐州好感度-25，丹阳派好感度-15"
		lawAction= func():
			print("商业竞争法")			
	elif sav.curLawName=="商品流通法":
		#RewardLaw="收益：每日收入+150，每日随机道具x1，一次性人口+200 冲突：徐州好感度-30，群众支持度-10  "
		lawAction= func():
			GameManager.sav.coin_DayGet=GameManager.sav.coin_DayGet+150
			#每日随机道具											
	elif sav.curLawName=="商业诚信法":
		#RewardLaw="收益：获得道具“珍品礼盒”x2，每日收入+200，一次性收入+1500  冲突：徐州好感度-40，丹阳派好感度-20  "
		lawAction= func():
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.珍品礼盒)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 2, false)
			GameManager.sav.coin_DayGet=GameManager.sav.coin_DayGet+200
			GameManager.sav.coin=GameManager.sav.coin+1500
			BENTUPAI.ChangeSupport(-40)
			WAIDIPAI.ChangeSupport(-20)
#丹阳派
	elif sav.curLawName=="军纪法":#所有好感度上升
		#RewardLaw="所有派系好感度+15，获得道具“胜战锦囊”x1 "
		lawAction= func():
			BENTUPAI.ChangeSupport(15)
			WAIDIPAI.ChangeSupport(15)
			HAOZUPAI.ChangeSupport(15)
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.胜战锦囊)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 1, false)
			
	elif sav.curLawName=="战备法":#获得若干随机道具
		#益气丸, 胜战锦囊, 诸子百家论集
		
		#RewardLaw="随机获得3个道具，一次性人口+100"
		lawAction= func():
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.益气丸)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 1, false)
			
			itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.胜战锦囊)
			InventoryManager.add_item(inventoryPackege, itemid, 1, false)

			itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.诸子百家论集)
			InventoryManager.add_item(inventoryPackege, itemid, 1, false)


			GameManager.sav.labor_force=GameManager.sav.labor_force+100
	elif sav.curLawName=="边防法":#获得一些人口增加
		#RewardLaw="一次性人口+100，丹阳派好感度+5，群众支持度+5，一次性收入+400  "
		lawAction= func():
			GameManager.sav.labor_force=GameManager.sav.labor_force+100
			WAIDIPAI.ChangeSupport(5)
			GameManager.changePeopleSupport(5)
			GameManager.sav.coin=GameManager.sav.coin+400
			print("边防法")	
	elif sav.curLawName=="军事训诂":
		#RewardLaw="收益：丹阳派好感度+20，获得道具“胜战锦囊”x2，一次性人口+150 冲突：徐州好感度-15  "
		lawAction= func():
			#print("军事训诂")	
			BENTUPAI.ChangeSupport(-15)
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.胜战锦囊)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 2, false)
			sav.labor_force=sav.labor_force+150
			WAIDIPAI.ChangeSupport(20)
	elif sav.curLawName=="军事装备法":
		#RewardLaw="收益：每日收入+50，获得道具“益气丸”x2 冲突：豪族好感度-20 "
		lawAction= func():
			GameManager.sav.coin_DayGet=GameManager.sav.coin_DayGet+50
			HAOZUPAI.ChangeSupport(-20)
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.益气丸)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 2, false)
			
			#print("军事装备法")	
	elif sav.curLawName=="军事训练法":
		#RewardLaw="收益：丹阳派好感度+30，每日人口+20，一次性人口+200 冲突：徐州好感度-25  "
		lawAction= func():
			print("军事训练法")	
			WAIDIPAI.ChangeSupport(30)
			BENTUPAI.ChangeSupport(-25)
			GameManager.sav.labor_DayGet=GameManager.sav.labor_DayGet+20
			GameManager.sav.labor_force=GameManager.sav.labor_force+200
	elif sav.curLawName=="军事优拔法":
		#RewardLaw="收益：丹阳派好感度+40，获得道具“胜战锦囊”x3，一次性收入+800 冲突：豪族好感度-30，群众支持度-10  "									
		lawAction= func():
			WAIDIPAI.ChangeAllPeople(40)
			HAOZUPAI.ChangeSupport(-30)
			changePeopleSupport(-10)
			GameManager.sav.coin=GameManager.sav.coin+800
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.胜战锦囊)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 3, false)
			print("军事优拔法")	
	elif sav.curLawName=="律令兵制":
		#RewardLaw="收益：每日人口+100，获得道具“珍品礼盒”x2，一次性人口+250 冲突：徐州好感度-35，豪族好感度-15  "#获得银月枪
		lawAction= func():
			GameManager.sav.labor_DayGet=GameManager.sav.labor_DayGet+100
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.珍品礼盒)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 2, false)
			GameManager.sav.labor_force=GameManager.sav.labor_force+250
			BENTUPAI.ChangeSupport(-35)
			HAOZUPAI.ChangeSupport(-15)
			print("律令兵制")	
	elif sav.curLawName=="国防策略法":
		#RewardLaw="民心+50，每日人口+50，获得道具“胜战锦囊”x4，一次性收入+1200  ，徐州好感度-50，豪族好感度-40  "		
		lawAction= func():
			GameManager.sav.labor_DayGet=GameManager.sav.labor_DayGet+50
			GameManager.changePeopleSupport(50)
			HAOZUPAI.ChangeSupport(-40)
			BENTUPAI.ChangeSupport(-50)
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.胜战锦囊)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 4, false)
	

	currenceScene.SettleLawRevenue()
	
	#GetLawClaimRevenue()
	#DialogueManager.show_dialogue_balloon()
		
		
	#弹出对话框，法律已经通过，并获得了什么额外效果
	
var items = [
	{"name": InventoryManagerItem.ItemEnum.益气丸, "cost": 200},
	{"name": InventoryManagerItem.ItemEnum.胜战锦囊, "cost": 300},
	{"name": InventoryManagerItem.ItemEnum.诸子百家论集, "cost": 250},
	{"name": InventoryManagerItem.ItemEnum.珍品礼盒, "cost": 350}
]
const POPULATION_PER_POINT=2
func ScoreToItem(player_score,num=-1):
	var gained_items: Dictionary = {}  # 使用字典记录道具和数量
	var rng = RandomNumberGenerator.new()
	# 随机决定获得几种道具 (1-3种)
	var item_types = rng.randi_range(1,  items.size())
	var has_at_least_one_item = false 
	# 随机分配道具
	var remaining_score = player_score
	var resideNum=num
	for i in range(item_types):
		if remaining_score <= 0:
			break
		rng = RandomNumberGenerator.new()	
		# 随机选择一种道具
		
		var available_items = items.filter(func(item): return not gained_items.has(item.name))
		if available_items.size()==0:
			break
		
		var item = available_items[rng.randi_range(0, available_items.size() - 1)]
		# 随机决定该道具数量 (1-3)
		var max_count=remaining_score/item.cost
		if resideNum!=-1:
			max_count.min(max_count,resideNum)
		#print(max_count)
		var item_count
		if max_count>=1 and has_at_least_one_item==false:
			item_count =min(rng.randi_range(1, max_count),3)
			has_at_least_one_item=true
		else:	
			item_count = min(rng.randi_range(0, max_count),3)
		
		# 计算道具消耗的积分 (这里假设每件道具消耗10积分，可调整)
		var item_cost = item_count * item.cost
		if item_cost < remaining_score and item_count!=0:
			#item_count = remaining_score / 10
			#item_cost = item_count * 10
		
			# 更新剩余积分
			remaining_score -= item_cost
		
			# 记录获得的道具
			if gained_items.has(item.name):
				gained_items[item.name] += item_count
			else:
				gained_items[item.name] = item_count

			if resideNum!=-1:
				resideNum=resideNum-item_count
				if(resideNum==0):
					break
	# 随机分配剩余积分到人口和金钱
	var population = 0
	var money = 0
	rng = RandomNumberGenerator.new()	
	if remaining_score > 0:
		# 随机决定分配给人口的最大可能数量
		var max_population = remaining_score / POPULATION_PER_POINT
		if max_population > 0:
			population = rng.randi_range(0, max_population)
		# 分配给人口的积分
		var population_cost = population * POPULATION_PER_POINT
		# 剩余积分全转为金钱
		money = (remaining_score - population_cost)
		rng = RandomNumberGenerator.new()	
		money = rng.randi_range(0, money)
	
	# 输出结果
	print("结算结果:")
	print("获得的道具:")
	for item in gained_items:
		print("- ", item, ": ", gained_items[item], "个")
	print("获得的金钱: ", money)
	print("获得的人口: ", population)
	
	# 返回结果（可选，方便其他节点使用）
	return {
		"items": gained_items,
		"money": money,
		"population": population
	}
	


func calculate_points(enemy_strength: int, tasks_completed: int, casualty_ratio: float,general_level: int,buffMultiple:float) -> int:
	# 战斗力得分
	var strength_score = 0
	if enemy_strength < 1000:
		strength_score = enemy_strength
	else:
		strength_score = 1000
	
	# 任务得分
	var task_score = 0
	if tasks_completed <= 1:
		task_score =int(enemy_strength*1/10)
	elif tasks_completed <= 3:
		task_score = int(enemy_strength*3/10)
	else:
		task_score = int(enemy_strength*5/10)
	
	# 战损得分（越低越好）
	var casualty_score = 0
	if casualty_ratio <= 0.3:
		casualty_score = 100
	elif casualty_ratio <= 0.7:
		casualty_score = 50
	else:
		casualty_score = 0
	var level_factor = 1.0 + (general_level - 1) / 10
	
   # var total_points = (base_points + strength_bonus + task_bonus - casualty_penalty) * level_factor
	#return max(0, int(total_points))
	# 总积分
	var total_points = (strength_score + task_score + casualty_score)*(1-casualty_ratio)  
	total_points= total_points* level_factor*buffMultiple
	return max(0, int(total_points))
		

func recoverHp(value):
	sav.hp=sav.hp+value
	#GameManager.sav.hp=
	pass

func changeTaskLabel(_value:String):
	if _value.length()>0:	
		GameManager.sav.TargetDestinationBefore=tr("当前任务：")
	else:
		GameManager.sav.TargetDestinationBefore=""
	GameManager.sav.TargetDestination=_value
	_engerge.changeTargetLabel()

#这里用作跳过序章
func SkipPrologue():
	var keys_to_change = [
		"firstmeetchenqun", "firsthouse", "firststreet", "firstgovernment", "firstgovermentTip",
		"firstPolicyOpShow", "firstPolicyCorrect", "firstTabLaw", "firstLawExecute", "firstParliamentary",
		"Factionalization", "firstEnterBattle", "dayThreeEnterBattle", "dayTwoInit", "dayThreeInit",
		"secondStreet", "firstTraining", "firstWar", "firstTrain", "threeStree",
		"firstMeetingEnd", "streetBeginBouleuterion", "firstBattle", "firstBattleTutorial", "firstBattleEnd",
		"firstVisitScholars", "firstVisitScholarsEnd", "firstNewEnd", "DemoFinish"
	]
	
	# Set each key's value to true
	for key in keys_to_change:
		sav.have_event[key] = true
	sav.day=5
