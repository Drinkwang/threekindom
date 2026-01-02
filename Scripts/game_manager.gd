extends Node


const DESTINATION = preload("res://Destination.tscn")
@export var shopPanel:ShopPanel
const MANUAL_TEST = preload("res://ManualTest.tscn")
#以下三个值均为三股不同力量士族可以篡改的值 其中士族可以把控群众支持度，商贾可以把控金钱，丹阳派系的军官可以把控劳动力
var _savePanel:savePanel
var restLabel:String=""
var wait_time=2
var hearsayID=-1 #秘闻id，购买秘闻修改 如果是商店=0
var hearsayBeforeNode=null
#用于临时储存的值
var resideValue
var resideValue2
var selectPuzzleDiffcult:SceneManager.puzzlediffucult=SceneManager.puzzlediffucult.easy
var PuzzleScene
enum RspEnum{
	PAPER=0,
	ROCK=1,
	SCISSORS=2,
	None=3,
	
	
}

# 总试玩时间（秒）
const TOTAL_Play_Test_SECONDS := 15 * 60   # 15 分钟

func _on_trial_time_up():
	DialogueManager.show_example_dialogue_balloon(sys,"本次试玩时间已到")

enum ResType{
	none,
	coin,
	people,
	item,
	heart,
	battle,
	rest,
	construct,#基建和人口,
	govern,
	complete
	
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
var sys = preload("res://dialogues/系统.dialogue")

func changePeopleSupport(num):
	sav.people_surrport=sav.people_surrport+num
	if(sav.people_surrport>100):
		sav.people_surrport=100
	elif sav.people_surrport<0:
		sav.people_surrport=0
		_engerge.hide()
		DialogueManager.gameover=true
		DialogueManager.show_example_dialogue_balloon(sys,"民乱四起")
		
		PanelManager.new_ChaoView()
		#展示gameover
		#隐藏血条
		#隐藏control
		#显示GameOver
		
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

var _propertyPanel:propertyPanel


var CanClickUI:bool=true
#var _rewardPanel:rewardPanel 移动导savedate里


#剩余粮食_用于赈灾系统
var resideGrain=0
var swordManGameState:gameState=gameState.pause
enum gameState{pause,start}
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


var CanFindItems=[
	{"name":"item1InHouse","alreadyGet":false,"id":1,"scene":SceneManager.roomNode.HOUSE},
	{"name":"item2InHouse","alreadyGet":false,"id":2,"scene":SceneManager.roomNode.HOUSE},
	{"name":"item3InHouse","alreadyGet":false,"id":3,"scene":SceneManager.roomNode.HOUSE},
	
	
	
	{"name":"item1InStree","alreadyGet":false,"id":1,"scene":SceneManager.roomNode.STREET},
	{"name":"item2InStree","alreadyGet":false,"id":2,"scene":SceneManager.roomNode.STREET},
	{"name":"item3InStree","alreadyGet":false,"id":3,"scene":SceneManager.roomNode.STREET},
	#{"name":"item4InStree","alreadyGet":false,"id":4,"scene":SceneManager.roomNode.STREET},
	#{"name":"item5InStree","alreadyGet":false,"id":5,"scene":SceneManager.roomNode.STREET},
	
	
	
	
	{"name":"item1InBouleuterion","alreadyGet":false,"id":1,"scene":SceneManager.roomNode.BOULEUTERION},
	{"name":"item2InBouleuterion","alreadyGet":false,"id":2,"scene":SceneManager.roomNode.BOULEUTERION},
	{"name":"item3InBouleuterion","alreadyGet":false,"id":3,"scene":SceneManager.roomNode.BOULEUTERION},
	

	{"name":"item1InBattle","alreadyGet":false,"id":1,"scene":SceneManager.roomNode.DRILL_GROUND},
	{"name":"item2InBattle","alreadyGet":false,"id":2,"scene":SceneManager.roomNode.DRILL_GROUND},
				
	#初始值会带有一些随机元素，但会根据优势更偏进好的 初始成功率不大于30  做任务降低损失增大成功率 
]


var CanFindSecretItems=[
	{"name":"key_item1","alreadyGet":false,"id":2,"scene":SceneManager.roomNode.BOULEUTERION},

	{"name":"key_item2","alreadyGet":false,"id":1,"scene":SceneManager.roomNode.GOVERNMENT_BUILDING},
	{"name":"key_item3","alreadyGet":false,"id":3,"scene":SceneManager.roomNode.DRILL_GROUND},

	
	#初始值会带有一些随机元素，但会根据优势更偏进好的 初始成功率不大于30  做任务降低损失增大成功率 
]
#存放替换战力的选项
var secretBattleSav=-1

func initSecretFunc():
	var available_items 
	var available_secret_items
	sav.todayCanFindItems=[]
	randomize()
	var maxLen=randi_range(0,3)
	if sav.day<4:
		if sav.day==1:

			available_secret_items=CanFindSecretItems[1]
	
		elif sav.day==2:
			sav.todayCanFindItems.append(CanFindSecretItems[1])
			available_secret_items=CanFindSecretItems[0]
		elif sav.day==3:
			available_secret_items=CanFindSecretItems[2]

		sav.todayCanFindItems.append(available_secret_items)
		
	for i in range(0,maxLen):
		available_items = CanFindItems.filter(func(item): return not sav.todayCanFindItems.has(item.name))
		var available_item = available_items[randi_range(0,available_items.size()-1)]
		if available_secret_items!=null:
			if available_secret_items.scene==available_item.scene and available_secret_items.id==available_item.id:
				continue
		available_item.alreadyGet=false
		sav.todayCanFindItems.append(available_item)
	
	#如果在游戏后期则不会获取怪谈道具



var currenceScene
var restFadeScene



#var dialogBegin=false
# Called when the node enters the scene tree for the first time.
func _ready():
	

	sav=saveData.new()
	_enterDay()
	SkipPrologue()
	initSetting()

func OpenSettingMenu():
	PanelManager.new_SettingMenu()	

func ReturnMenu():
	DialogueManager.gameover=false
	SceneManager.changeScene(SceneManager.roomNode.MainMenu,2)

var musicId=0

func _input(event):
	# 检测 ESC 键
	if event.is_action_pressed("ui_cancel") and not event.is_echo() and DialogueManager.dialogBegin==false and currenceScene!=null:
		#pass
		var balloon= DialogueManager.get_dialogue_balloon()
		if balloon==null:
			openSetting()
			
func openSetting():
	if PanelManager.isOpenSetting==true:
		return
	if !(currenceScene is mainHall):
		DialogueManager.show_example_dialogue_balloon(sys,"ESC按钮")
	else:
		DialogueManager.show_example_dialogue_balloon(sys,"选项暂不可开")	
		print("目前场景不能通过esc按钮执行任何操作")	
	
				
			
func initBattle():
	sav.UseGeneral=[]
	#all改成any
	
	sav.battleResults=[
		BattleResult.none,
		BattleResult.none,
		BattleResult.none
	#初始值会带有一些随机元素，但会根据优势更偏进好的 初始成功率不大于30  做任务降低损失增大成功率 
	]
		
	initBattleCircle()
	SignalManager.initBattle.emit()
	#同时初始化3个将军攻克面板	

func array_sum(arr: Array) -> int:
	var sum = 0
	for i in arr:
		sum += i
	return sum

func tempRestoreGeneral():
	#GameManager.sav.sideUseGeneral=GameManager.sav.UseGeneral
	GameManager.sav.UseGeneral=[]
	#for i in range(0,3):
	var datas=GameManager.sav.battleTasks.values()
	var data=datas[0]
	#data.task=[]
	GameManager.sav.sideValue=data.index

	sav.tempsavbattleResults=sav.battleResults
	sav.battleResults=[
		BattleResult.none,
		BattleResult.none,
		BattleResult.none
	#初始值会带有一些随机元素，但会根据优势更偏进好的 初始成功率不大于30  做任务降低损失增大成功率 
	]

func endtempRestoreGeneral():
	for i in range(0,3):
		var datas=GameManager.sav.battleTasks.values()
		var data=datas[i]

		data.index=GameManager.sav.sideValue+i

	#sav.battleResults=sav.tempsavbattleResults


func costHp(value):
	#sav.alreadyHP+=value
	if sav.hp-value>0:
		sav.hp-=value
	else:
		sav.hp=0
func refreshPaixis():
	initPaixi(sav.BENTUPAI)
	initPaixi(sav.WAIDIPAI)
	#initPaixi(sav.HAOZUPAI)
	if sav.have_event["Factionalization"]:
		initPaixi(sav.HAOZUPAI)
	#传递信号，政策看法

func _enterDay(value=true):
	if(value==true):
		sav.day=sav.day+1
		refreshPaixis()
		initBattle()
		initSecretFunc()#初始化获得道具相关
		sav.isSoldItem=false
		sav.hp=sav.maxHP
		sav.isLevelUp=false;
		sav.isMeet=false
		sav.isGetCoin=false
		sav.isVisitScholar=false
		sav.randomIndex=randi_range(0,3)
		sav.alreadyHP=0	
		if sav.xuzhouCD>0:
			sav.xuzhouCD-=1

		if sav.haozuCD>0:
			sav.haozuCD-=1

		if sav.danyangCD>0:
			sav.danyangCD-=1
		if GameManager.sav.XuanyinDay<3 and GameManager.sav.have_event["玄阴开放"]==true:
			GameManager.sav.XuanyinDay+=1

#@export var mizhuSideWait=-1
#@export var chendenSideWait=-1
#@export var caobaoSideWait=-1
	if sav.mizhuSideWait!=-1 and sav.mizhuSideWait>0:
		sav.mizhuSideWait-=1
	if sav.chendenSideWait!=-1 and sav.chendenSideWait>0:
		sav.chendenSideWait-=1	
	if sav.caobaoSideWait!=-1 and sav.caobaoSideWait>0:
		sav.caobaoSideWait-=1

	if sav.targetResType==ResType.rest:
		sav.currenceValue=sav.currenceValue+1
		
		if sav.have_event["chaosBegin"]==true:#第三个任务
			if sav.currenceValue==2:
				pass#克苏鲁现象

	if sav.have_event["chaoDialogEnd"]==true:
		if(sav.have_event["chaosEnd"]==false):	
			sav.currenceDay=sav.currenceDay+1#	
		elif (sav.have_event["lvbuJoin"]==true) and sav.have_event["canSummonLvbu"]==false:
			sav.currenceDay=sav.currenceDay+1#	
			#判断是否能召见吕布，如果可以，依然执行这个方法
#利用上这个把taskindex局限于0-3 选样，并把这个数量和攻克
#用task的index用作当前任务数
#失败惩罚
#每次通关3关将taskindex回复为0
#并重新计算copletetask
#		{"name":"高风险","initPos":0,"radian":90},


func dontHaveDominance():
	var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.霸道之息)	

	return num==0


func showGuimiAchi():
	PanelManager.new_GuiMiAchiView()

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
		var sdType:int=randf_range(0, 2)#从3修改
		sav.battleTasks[battleTarget].sdType=sdType
		#RspEnum.values()[sdType-1]

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

@export var bossmode:SceneManager.bossMode#SceneManager.bossMode.none
@export var bossmoderesult:bool
func initPaixi(data:cldata):
	
	#data._num_sp=(data._num_all*data._support_rate)/100+0.5
	data._num_op=(data._num_all*(100-data._support_rate))/100+0.5
	var paixiindex=getIndexByFractionIndex(data.index)
	var lawOP=0
	if paixiindex!=sav.curLawNum1 and sav.curLawNum1>0:
		lawOP=((sav.curLawNum2-1)*10.0/100.0)*(data._num_all-data._num_op)
		lawOP=floor(lawOP)

	#如果是相同派系，则为0，不同派系，将（index-1）*9到10 的百分比赋值给它
	data._num_op=data._num_op+lawOP
	var initRt=randf_range(0,min(data._num_op*2,data._num_all-data._num_op))
	if sav.curLawNum1<=0:
		initRt=0
	data._num_rt=initRt
	data._num_sp=(data._num_all-data._num_op-data._num_rt)
	data.isrebellion=false
	data.isDoneOp=false
	#data._num_op
	pass


var extraValue=0

	
#需要在saveData定义一个对子的数据结构判断1是否执行 2是否执行	
func getPolicyGroup() -> int:
	if sav.policyExcute==false:
		if sav.day<4:
			return 1
		if sav.day==5:
			return 2
		if sav.have_event["chaoChendengEnd"]==true and sav.have_event["chaoChenDenPolicyExcute"]==false:
			return 3


	return -1
	#如果处于主线状态，则取出来的是主线，否则取出来的是随机数

func getTaskCurrenceValue():
	var cur=0
	if sav.targetResType==ResType.coin:
		cur=sav.coin
	elif sav.targetResType==ResType.people:
		cur=sav.labor_force
	elif sav.targetResType==ResType.construct:
		cur=[sav.labor_force,getConstructValue()]
	elif sav.targetResType==ResType.govern:
		cur=getgovernValue()
	elif sav.targetResType==ResType.complete:
		cur=99999999
	else:
		cur=sav.currenceValue#暂时该值未定义
	return cur


func getgovernValue():
	var cv=0
	if sav.WAIDIPAI._support_rate>=60 or sav.WAIDIPAI._num_defections>=3:
		cv+=1
	elif sav.BENTUPAI._support_rate>=60 or sav.BENTUPAI._num_defections>=3:
		cv+=1
	elif sav.LVBU._support_rate>=60 or sav.LVBU._num_defections>=3:
		cv+=1	
	elif sav.HAOZUPAI._support_rate>=60 or sav.HAOZUPAI._num_defections>=3:
		cv+=1
	return cv

func getConstructValue():
	var cv=0
	if sav.constructRiver>0:
		cv+=1
	if sav.constructGrain>0:
		cv+=1
	if sav.constructTower>0:
		cv+=1
	return cv
	#pass

	#sav.coin=sav.coin+sav.coin_DayGet
	#sav.labor_force=sav.labor_force+sav.labor_DayGet

func _rest(value=true):
	const DISSOLVE_IMAGE = preload("res://addons/transitions/images/circle-inverted.png")
	
	if GameManager.sav.have_event["预获得龙胆枪"]==true:
		GameManager.sav.have_event["预获得龙胆枪休息"]=true
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

var SoldItemStr=""
var SoldCoin=0
var waidipai=cldata.factionIndex.weidipai
var bentupai=cldata.factionIndex.bentupai
var haozupai=cldata.factionIndex.haozupai
var lvbu=cldata.factionIndex.lvbu

func getcldateByindex(factionIndex:int)->cldata:
	#index==0 士族
	#index==1 豪族
	#index==2 军方

	if factionIndex==2:
		return sav.WAIDIPAI #preload("res://Asset/tres/waidipai.tres")
		#index=2
	elif factionIndex==0:
		return sav.BENTUPAI #preload("res://Asset/tres/bentupai.tres")
		#index=0
	elif factionIndex==1:
		return sav.HAOZUPAI #preload("res://Asset/tres/haozupai.tres")
		#index=1
	elif factionIndex==cldata.factionIndex.lvbu:
		return sav.LVBU#preload("res://Asset/tres/haozupai.tres")
		#index=3	
	return null


func getFractionByEnum(factionIndex:cldata.factionIndex):
	#index==0 士族
	#index==1 豪族
	#index==2 军方

	if factionIndex==cldata.factionIndex.weidipai:
		return sav.WAIDIPAI #preload("res://Asset/tres/waidipai.tres")
		#index=2
	elif factionIndex==cldata.factionIndex.bentupai:
		return sav.BENTUPAI #preload("res://Asset/tres/bentupai.tres")
		#index=0
	elif factionIndex==cldata.factionIndex.haozupai:
		return sav.HAOZUPAI #preload("res://Asset/tres/haozupai.tres")
		#index=1
	elif factionIndex==cldata.factionIndex.lvbu:
		return sav.LVBU#preload("res://Asset/tres/haozupai.tres")
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
var policyAction:Callable

var getItemAction:Callable



#读档时
func loadLaw():
	lawAction= Callable() 
	if sav.curLawName=="农田开坑":#只有buff
		#RewardLaw="每日收入+50，徐州好感度+10，#一次性收入+200" #收入每日增加 徐州派好感度上升
		
		lawAction= func():
			sav.coin_DayGet=sav.coin_DayGet+50
			#sav.coin=sav.coin+200
			#徐州好感度+10
			sav.BENTUPAI.ChangeSupport(10)
			print("农田开坑done")

	elif sav.curLawName=="兴办教育":#只有buff
		#RewardLaw="每日人口+10，徐州好感度+5，获得道具“诸子百家”x1 " #人口每日增加 徐州派好感上升 获得道具xxx
		lawAction= func():
			sav.BENTUPAI.ChangeSupport(5)
			sav.labor_DayGet=sav.labor_DayGet+10
			#获得诸子百家
			
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.诸子百家论集)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 1, false)

			print("兴办教育done")		
	elif sav.curLawName=="整治街容":#只有buff
		#RewardLaw="一次性人口+100，徐州好感度+10，群众支持度+5 " #人口一次性增加 徐州派好感上升
		
		lawAction= func():
			sav.labor_force=sav.labor_force+100
			sav.BENTUPAI.ChangeSupport(10)
			changePeopleSupport(5)
			print("整治街容done")			
	elif sav.curLawName=="重农抑商":
		#RewardLaw="收益：每日收入+80，徐州好感度+15 冲突：豪族好感度-20 " 
		lawAction= func():
			sav.labor_DayGet=sav.labor_DayGet+80
			sav.BENTUPAI.ChangeSupport(15)
			sav.HAOZUPAI.ChangeSupport(-20)
			
			print("重农抑商done")	
	elif sav.curLawName=="士族优先":
		#RewardLaw="收益：徐州好感度+20，获得道具“珍品礼盒”x1，一次性人口+150 冲突：丹阳派好感度-15  "
		lawAction= func():
			sav.BENTUPAI.ChangeSupport(20)
			sav.WAIDIPAI.ChangeSupport(-15)
			sav.labor_force+=150
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.珍品礼盒)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 1, false)			
			print("士族优先done")			
	elif sav.curLawName=="物价稳定":
		#RewardLaw="收益：每日收入+100，群众支持度+10 冲突：豪族好感度-30 "
		lawAction= func():
			sav.coin_DayGet+=100
			sav.people_surrport+=10
			sav.HAOZUPAI.ChangeSupport(-30)
			print("物价稳定done")			
	elif sav.curLawName=="屯田制":
		#RewardLaw="收益：每日人口+30，每日收入+120，一次性人口+200 
		#冲突：丹阳派好感度-20，豪族好感度-10  "
		lawAction= func():
			sav.labor_DayGet+=30
			sav.coin_DayGet+=120
			sav.labor_force+=200
			sav.WAIDIPAI.ChangeSupport(-20)
			sav.HAOZUPAI.ChangeSupport(-10)
			print("屯田制done")			
	elif sav.curLawName=="府兵制":
		#RewardLaw="收益：每日收入+150，获得道具“胜战锦囊”x2，一次性收入+1000  冲突：丹阳派好感度-30，群众支持度-10  "
		lawAction= func():
			sav.coin_DayGet+=150
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.胜战锦囊)
			sav.WAIDIPAI.ChangeSupport(-30)
			changePeopleSupport(-10)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 2, false)					
			print("府兵制done")			
	elif sav.curLawName=="品级制":
		#RewardLaw="收益：徐州好感度+50，每日人口+50，获得道具“珍品礼盒”x2，一次性人口+300 冲突：豪族好感度-40，丹阳派好感度-25  "
		lawAction= func():
			sav.BENTUPAI.ChangeSupport(50)
			sav.labor_DayGet+=50
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.珍品礼盒)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 2, false)
			sav.labor_force+=300 
			sav.HAOZUPAI.ChangeSupport(-40)
			sav.WAIDIPAI.ChangeSupport(-25)
											
			print("品级制done")			
#豪族		
	elif sav.curLawName=="促进商贸":#只有buff 收入每日增加 获得一笔钱财
		#RewardLaw="每日收入+10，徐州好感度+5，一次性收入+100，随机道具x1 "
		lawAction= func():
			sav.labor_DayGet+=10
			sav.BENTUPAI.ChangeSupport(5)
			sav.labor_force+=100
			var items:Array=[InventoryManagerItem.ItemEnum.珍品礼盒,InventoryManagerItem.ItemEnum.益气丸, InventoryManagerItem.ItemEnum.胜战锦囊, InventoryManagerItem.ItemEnum.诸子百家论集]
			var rindex= randi_range(0,items.size()-1)
			var itemname= InventoryManagerItem.item_by_enum(items[rindex])
			var remainder = InventoryManager.add_item(inventoryPackege, itemname, 1, false)
			#bedone
			print("促进商贸")			
	elif sav.curLawName=="诚信经营":#只有buff 所有派系好感度上升
		#RewardLaw="所有派系好感度+20，群众支持度+5，一次性人口+80"
		lawAction= func():
			sav.BENTUPAI.ChangeSupport(20)
			sav.WAIDIPAI.ChangeSupport(20)
			sav.HAOZUPAI.ChangeSupport(20)
			changePeopleSupport(5)
			sav.labor_force+=80
			print("诚信经营done")			
	elif sav.curLawName=="行业准则":#只有buff 所有派系好感度随机上升
		#RewardLaw="所有派系好感度+5，每日收入+20，获得道具“珍品礼盒”x1，一次性收入+100"		
		lawAction= func():
			sav.BENTUPAI.ChangeSupport(5)
			sav.WAIDIPAI.ChangeSupport(5)
			sav.HAOZUPAI.ChangeSupport(5)
			sav.coin+=100
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.珍品礼盒)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 1, false)			
			
			print("行业准则done")			
	elif sav.curLawName=="禁止军商":
		#RewardLaw="收益：每日收入+50，豪族好感度+15，一次性收入+600 冲突：丹阳派好感度-25  "
		lawAction= func():
			sav.labor_DayGet+=50
			sav.HAOZUPAI.ChangeSupport(15)
			sav.coin+=600
			sav.WAIDIPAI.ChangeSupport(-25)
			print("禁止军商done")			
	elif sav.curLawName=="商业税收法":
		#RewardLaw="收益：每日收入+80，获得道具“益气丸”x2，一次性收入+800  冲突：徐州好感度-20"
		lawAction= func():
			sav.labor_DayGet+=80
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.益气丸)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 2, false)

			sav.coin+=800
			sav.BENTUPAI.ChangeSupport(-20)
			print("商业税收法done")			
	elif sav.curLawName=="货币法":
		#RewardLaw="收益：每日收入+100，群众支持度+10 冲突：丹阳派好感度-30 "
		lawAction= func():
			sav.labor_DayGet+=100
			changePeopleSupport(10)
			sav.WAIDIPAI.ChangeSupport(-30)			
			print("货币法")			
	elif sav.curLawName=="商业竞争法":
		#RewardLaw="收益：每日收入+120，豪族好感度+20，一次性收入+1000 冲突：徐州好感度-25，丹阳派好感度-15"
		lawAction= func():
			print("商业竞争法done")			
			sav.labor_DayGet+=120
			sav.HAOZUPAI.ChangeSupport(20)
			sav.coin+=1000
			sav.BENTUPAI.ChangeSupport(-25)
			sav.WAIDIPAI.ChangeSupport(-15)
	elif sav.curLawName=="商品流通法":
		#RewardLaw="收益：每日收入+150，每日随机道具x1，一次性人口+200 冲突：徐州好感度-30，群众支持度-10  "
		lawAction= func():
			sav.coin_DayGet=sav.coin_DayGet+150
			sav.dailyGetRandomItem=true
			sav.labor_force+=200
			sav.BENTUPAI.ChangeSupport(-30)
			changePeopleSupport(-10)
			#每日随机道具											
	elif sav.curLawName=="商业诚信法":
		#RewardLaw="收益：获得道具“珍品礼盒”x2，每日收入+200，一次性收入+1500  冲突：徐州好感度-40，丹阳派好感度-20  "
		lawAction= func():
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.珍品礼盒)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 2, false)
			sav.coin_DayGet=sav.coin_DayGet+200
			sav.coin=sav.coin+1500
			sav.BENTUPAI.ChangeSupport(-40)
			sav.WAIDIPAI.ChangeSupport(-20)
#丹阳派
	elif sav.curLawName=="军纪法":#所有好感度上升
		#RewardLaw="所有派系好感度+15，获得道具“胜战锦囊”x1 "
		lawAction= func():
			sav.BENTUPAI.ChangeSupport(15)
			sav.WAIDIPAI.ChangeSupport(15)
			sav.HAOZUPAI.ChangeSupport(15)
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


			sav.labor_force=sav.labor_force+100
	elif sav.curLawName=="边防法":#获得一些人口增加
		#RewardLaw="一次性人口+100，丹阳派好感度+5，群众支持度+5，一次性收入+400  "
		lawAction= func():
			sav.labor_force=sav.labor_force+100
			sav.WAIDIPAI.ChangeSupport(5)
			changePeopleSupport(5)
			sav.coin=sav.coin+400
			print("边防法")	
	elif sav.curLawName=="军事训诂":
		#RewardLaw="收益：丹阳派好感度+20，获得道具“胜战锦囊”x2，一次性人口+150 冲突：徐州好感度-15  "
		lawAction= func():
			#print("军事训诂")	
			sav.BENTUPAI.ChangeSupport(-15)
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.胜战锦囊)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 2, false)
			sav.labor_force=sav.labor_force+150
			sav.WAIDIPAI.ChangeSupport(20)
	elif sav.curLawName=="军事装备法":
		#RewardLaw="收益：每日收入+50，获得道具“益气丸”x2 冲突：豪族好感度-20 "
		lawAction= func():
			sav.coin_DayGet=sav.coin_DayGet+50
			sav.HAOZUPAI.ChangeSupport(-20)
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.益气丸)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 2, false)
			
			#print("军事装备法")	
	elif sav.curLawName=="军事训练法":
		#RewardLaw="收益：丹阳派好感度+30，每日人口+20，一次性人口+200 冲突：徐州好感度-25  "
		lawAction= func():
			print("军事训练法")	
			sav.WAIDIPAI.ChangeSupport(30)
			sav.BENTUPAI.ChangeSupport(-25)
			sav.labor_DayGet=sav.labor_DayGet+20
			sav.labor_force=sav.labor_force+200
	elif sav.curLawName=="军事优拔法":
		#RewardLaw="收益：丹阳派好感度+40，获得道具“胜战锦囊”x3，一次性收入+800 冲突：豪族好感度-30，群众支持度-10  "									
		lawAction= func():
			sav.WAIDIPAI.ChangeAllPeople(40)
			sav.HAOZUPAI.ChangeSupport(-30)
			changePeopleSupport(-10)
			sav.coin=sav.coin+800
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.胜战锦囊)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 3, false)
			print("军事优拔法")	
	elif sav.curLawName=="律令兵制":
		#RewardLaw="收益：每日人口+100，获得道具“珍品礼盒”x2，一次性人口+250 冲突：徐州好感度-35，豪族好感度-15  "#获得银月枪
		lawAction= func():
			sav.labor_DayGet=sav.labor_DayGet+100
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.珍品礼盒)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 2, false)
			sav.labor_force=sav.labor_force+250
			sav.BENTUPAI.ChangeSupport(-35)
			sav.HAOZUPAI.ChangeSupport(-15)
			print("律令兵制")	
	elif sav.curLawName=="国防策略法":
		#RewardLaw="民心+50，每日人口+50，获得道具“胜战锦囊”x4，一次性收入+1200  ，徐州好感度-50，豪族好感度-40  "		
		lawAction= func():
			sav.labor_DayGet=sav.labor_DayGet+50
			changePeopleSupport(50)
			sav.HAOZUPAI.ChangeSupport(-40)
			sav.BENTUPAI.ChangeSupport(-50)
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.胜战锦囊)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 4, false)
	



var RewardLaw
func excuteLaw():
	sav.laws[sav.curLawNum1].append(sav.curLawNum2)
	#var arr:Array
	RewardLaw=tr(sav.RewardLaw)
	
	
	
	loadLaw()
	

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
	#sav.hp=
	pass

func changeTaskLabel(_value:String):
	if _value.length()>0:	
		sav.TargetDestinationBefore=tr("当前任务：")
	else:
		sav.TargetDestinationBefore=""
	sav.TargetDestination=_value
	_engerge.changeTargetLabel()

var trainGeneral=""
var trainLevel=0
var trainResult:SceneManager.trainResult=SceneManager.trainResult.none
func changeChendenHeart(addValue):
	sav.chendenfav+=addValue

func changeMizhuHeart(addValue):
	sav.mizhufav+=addValue
	
func changeCaobaoHeart(addValue):
	sav.caobaofav+=addValue
	

#这里用作跳过序章
func SkipPrologue():
	var keys_to_change = [
		"firstmeetchenqun", "firsthouse", "firststreet", "firstgovernment", "firstgovermentTip",
		"firstPolicyOpShow", "firstPolicyCorrect", "firstTabLaw", "firstLawExecute", "firstParliamentary",
		"firstEnterBattle", "dayThreeEnterBattle", "dayTwoInit", "dayThreeInit",
		"secondStreet", "firstTraining", "firstWar", "firstTrain", "threeStree",
		"firstMeetingEnd", "streetBeginBouleuterion", "firstBattle", "firstBattleTutorial", "firstBattleEnd",
		"firstVisitScholars", "firstVisitScholarsEnd", "firstNewEnd", "DemoFinish"
	]
	initBattle()
	# Set each key's value to true
	for key in keys_to_change:
		sav.have_event[key] = true
	sav.day=5
	initSecretFunc()

var _setting:SettingsResource

func initSetting():
	var path="user://save_data_setting.tres"
	if(FileAccess.file_exists(path)):
		_setting=load(path)

		_load_settings()#把语言系统设置，然后应用分辨率 应用全屏，引用音效、没了
	#else:
		
func _load_settings():
	


	if _setting.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	
	var system_locale = _setting.language
	TranslationServer.set_locale(system_locale)
	if system_locale=="zh_HK" or system_locale=="zh_TW":
		TranslationServer.set_locale("lzh")
		#option_button.select(1)
	
	var res =_setting.resolution.split("x")
	var width = int(res[0])
	var height = int(res[1])
	
	DisplayServer.window_set_size(Vector2i(width, height))
	# 居中窗口
	var screen_size = DisplayServer.screen_get_size()
	var window_pos = (screen_size - Vector2i(width, height)) / 2
	DisplayServer.window_set_position(window_pos)	
	
	SoundManager.set_sound_volume(GameManager._setting.sfx_volume)
	#await get_tree().create_timer(0.1).timeout
	SoundManager.set_music_volume(GameManager._setting.music_volume)
	#await get_tree().create_timer(0.1).timeout
	#SoundManager.set_sound_ui_volume(GameManager._setting.people_volume)
	#await get_tree().create_timer(0.1).timeout
	SoundManager.set_ambient_sound_volume(GameManager._setting.bgs_volume)

func clear_children(parent: Node) -> void:
	for child in parent.get_children():
		if !(child is Label):
			parent.remove_child(child)
			child.queue_free()  # 或 child.free()


func haveMirror()->bool:
	var sxnum=InventoryManager.inventory_item_quantity(inventoryPackege,InventoryManagerItem.洞察之镜) 
	if sxnum>0:
		return true
	else:
		return false
		
		
func AutoSaveFile():
	
	
	if _setting!=null and _setting.isAutoSave==false:
		return
	
	_engerge.showAutoSaveANI()
	var tempSavs:Array=[null,null,null]
	sav.autoSave=true
	
	if(currenceScene!=null):
		sav.saveScene.pack(currenceScene)

	for i in range(1,4):
		var path="user://save_data{index}.tres".format({"index":i})
		if(FileAccess.file_exists(path)):
			tempSavs[i-1]=load(path)
			if tempSavs[i-1].autoSave==true:
				ResourceSaver.save(sav,"user://save_data{index}.tres".format({"index":str(i)}))
				_engerge.endAutoSave()
				return
				
	for i in range(1,4):
		if tempSavs[i-1]==null:
			ResourceSaver.save(sav,"user://save_data{index}.tres".format({"index":str(i)}))
			_engerge.endAutoSave()
			return
	#获取tempSavs时间最小的 进行存档
 # If all slots are occupied, find the slot with the earliest current_datetime
	var earliest_index: int = -1
	var earliest_time: int = 9223372036854775807 # Max int for comparison (future timestamp)

	for i in range(3):
		if tempSavs[i] != null:
			# Parse current_datetime string (format: "year/month/day/hour/minute")
			var time_str: String = tempSavs[i].current_datetime
			var time_parts = time_str.split("/")
			if time_parts.size() == 5:
				var time_dict = {
					"year": int(time_parts[0]),
					"month": int(time_parts[1]),
					"day": int(time_parts[2]),
					"hour": int(time_parts[3]),
					"minute": int(time_parts[4]),
					"second": 0 # Assuming seconds are not included
				}
				# Convert to Unix timestamp for comparison
				var timestamp = Time.get_unix_time_from_datetime_dict(time_dict)
				if timestamp < earliest_time:
					earliest_time = timestamp
					earliest_index = i

	# Save to the slot with the earliest time
	if earliest_index != -1:
		ResourceSaver.save(sav, "user://save_data{index}.tres".format({"index": str(earliest_index)}))
	#await 2
	_engerge.endAutoSave()

func _imporveRelation(data:cldata):
	if DialogueManager.dialogBegin==false:
		if data.isSuppressed==true:
			data.rebellionUpdateNum+=1
			resideValue=data._name
			resideValue2=data._num_defections-data.rebellionUpdateNum
			if data.rebellionUpdateNum>=data._num_defections:
				DialogueManager.show_example_dialogue_balloon(sys,"讨好叛乱1")
				data.rebellionUpdateNum=0
				data.isSuppressed=false
			else:
				DialogueManager.show_example_dialogue_balloon(sys,"讨好叛乱2")
			
func play_music(file_path: String) -> AudioStreamPlayer:
	var stream = load(file_path)
	var music=null
	if stream!=null:
		music= SoundManager.play_music(stream)
	else:
		print("载入音频出错"+file_path)
	return music
	
	
func play_PeopleVolume(file_path: String) -> AudioStreamPlayer:
	var stream = load(file_path)
	var music=null
	if stream!=null:
		music= SoundManager.play_ui_sound(stream)
	else:
		print("载入音频出错"+file_path)
	return music	
func setCoin(value):
	sav.coin=value



func play_BGM():
	#, 5, 6, 7
	if musicId <= 0:
		var available_ids = [1, 2, 3, 4, 8, 9, 10]
		# 如果 musicId 是负数，排除对应的编号
		if musicId < 0:
			var exclude_id = abs(musicId)
			if exclude_id >= 1 and exclude_id <= 10:
				available_ids.erase(exclude_id)
		# 从剩余编号中随机选择
		musicId = available_ids[randi() % available_ids.size()]	
	

		var music_file = "res://Asset/music/Ambient " + str(musicId) + ".wav"
		play_music(music_file)	


func play_BoardBGM(speed=1):
	#, 
	SoundManager.stop_music()
	var tempmusicId=-1
	if tempmusicId <= 0:
		var available_ids = [5, 6, 7]
	

		# 从剩余编号中随机选择
		tempmusicId = available_ids[randi() % available_ids.size()]	
	

		var music_file = "res://Asset/music/Ambient " + str(tempmusicId) + ".wav"
		var music=play_music(music_file)	
		music.pitch_scale=speed
func play_FinalBoardBGM():
	
	SoundManager.stop_music()
	var music_file = "res://Asset/music/finalwork.wav"
	play_music(music_file)	

func clearTutorial():
	sav.have_event["卡牌新手教程"]=false
	sav.have_event["卡牌中级教程"]=false
	sav.have_event["卡牌高级教程"]=false	

var selectBoardCharacter:boardType.boardCharacter=boardType.boardCharacter.none
var _boardMode:boardType.boardMode=boardType.boardMode.none
#初始
var _boardReward:boardType.boardRewardResult=boardType.boardRewardResult.none
var _boardGameWin:bool=false
func selectBoardMode(mode:boardType.boardMode):
	if await GameManager.isTried(20):
		return
	_boardMode=mode
	#提示
	
	

	var characterScore=0	
	if GameManager.selectBoardCharacter==boardType.boardCharacter.caobao:
		characterScore=GameManager.sav.caobaocardgame
	elif GameManager.selectBoardCharacter==boardType.boardCharacter.chenden:
		characterScore=GameManager.sav.chendencardgame	
	elif GameManager.selectBoardCharacter==boardType.boardCharacter.mizhu:
		characterScore=GameManager.sav.mizhucardgame		
	#0 小试牛刀开启 1小试牛刀通过 2 对局试炼开启 3对局试验通过 4 诡秘怪谈开启 5诡秘怪谈通过	

	if (characterScore<2 and mode==boardType.boardMode.middle) or (characterScore<4 and mode==boardType.boardMode.high):
		DialogueManager.show_example_dialogue_balloon(boardDialogue,"当前模式未解锁")
	else:
		currenceScene.openBoardDialogue()
	
func enterBoardGame():
	#切入boardGame场景
	GameManager.sav.hp-=20
	SoundManager.stop_music()
	SceneManager.changeScene(SceneManager.roomNode.BoardGame,2)


const boardDialogue = preload("res://dialogues/桌游.dialogue")
var rewardPanel:bool=false
func showBoardGameDialogue():
	

	
	#tri 20
	DialogueManager.show_example_dialogue_balloon(boardDialogue,"选择仕诡牌")
	pass
func resumeMusic():
	SoundManager.stop_music()

	if GameManager.musicId==0:
		return
		
	var music_file = "res://Asset/music/Ambient " + str(GameManager.musicId) + ".wav"
	var music=GameManager.play_music(music_file)
	if music!=null:	
		music.pitch_scale=1


func initSecretBattleContext(targetValue,mode,BootValue,dialogueContext):
	sav.extraBattleTaskBootNum=BootValue
	sav.extraBattleTaskTargetNum= targetValue
	sav.extraBattleTaskEnum=mode
	sav.extraBattleDialogContext=dialogueContext


func enterCrazy():
	var newColor=Color.RED
	newColor.a=0.5
	PanelManager.Fade_Blank(newColor,0.5,PanelManager.fadeType.fadeIn)
	#await 0.5
	#PanelManager.Fade_Blank(Color.RED,0.5,PanelManager.fadeType.fadeOut)
	SoundManager.stop_music()
	SoundManager.play_music(sounds._2__MENTAL_VORTEX)


func enterNormal():
	
	PanelManager.Fade_Blank(Color.RED,0.5,PanelManager.fadeType.fadeOut)
	SoundManager.stop_music()
	GameManager.resumeMusic()	

var puzzleCostMoney=0
var puzzleCostPeople=0
func doContructtion(diff):
	if diff==0:
		GameManager.selectPuzzleDiffcult=scenemanager.puzzlediffucult.easy
		puzzleCostMoney=100
		puzzleCostPeople=50
	elif diff==1:
		GameManager.selectPuzzleDiffcult=scenemanager.puzzlediffucult.middle
		puzzleCostMoney=150
		puzzleCostPeople=75
	elif diff==2:
		GameManager.selectPuzzleDiffcult=scenemanager.puzzlediffucult.high
		puzzleCostMoney=150
		puzzleCostPeople=100
	DialogueManager.show_example_dialogue_balloon(sys,"基建选项2")


func selectPuzzleLevel():
	DialogueManager.show_example_dialogue_balloon(sys,"基建选项")

func resetConstructTutorial():
	if GameManager.currenceScene is government_building:
		GameManager.sav.have_event["基建运粮教程"]=false
	elif currenceScene is bouleuterion:
		GameManager.sav.have_event["基建运河教程"]=false
	elif currenceScene is drill_ground:
		GameManager.sav.have_event["基建修塔教程"]=false
	pass


func cancelContructtion():
	currenceScene.returnMain()
