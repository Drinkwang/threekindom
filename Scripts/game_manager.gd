extends Node


const DESTINATION = preload("res://Destination.tscn")
@export var shopPanel:ShopPanel
const MANUAL_TEST = preload("res://ManualTest.tscn")
#以下三个值均为三股不同力量士族可以篡改的值 其中士族可以把控群众支持度，商贾可以把控钱，丹阳派系的军官可以把控民力
var _savePanel:savePanel
var restLabel:String=""
var wait_time=2
var hearsayID=-1 #秘闻id，购买秘闻修改 如果是商店=0
var backhearsayID=0
var hearsayBeforeNode=null
#用于临时储存的值
var resideValue
var resideValue2
var resideValue3
var resideValue4
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
	construct,#基建和民力,
	govern,
	complete,
	stayFight
	
}

enum endPath{
	
	none,
	xiaopei,
	xuzhou,
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
	GameManager._propertyPanel.GetValue(0,0,0)
	if(sav.people_surrport>100):
		sav.people_surrport=100
	elif sav.people_surrport<=0:
		sav.people_surrport=0
		_engerge.hide()
		#DialogueManager.gameover=true
		if GameManager.sav.have_event["战斗袁术血战模式"]==true and GameManager.sav.have_event["血战袁术完成"]==false:
			DialogueManager.show_example_dialogue_balloon(sys,"军心溃散刘备力竭被俘")
		else:
			DialogueManager.show_example_dialogue_balloon(sys,"民乱四起")
		
		PanelManager.new_ChaoView()
		#展示gameover
		#隐藏血条
		#隐藏control
		#显示GameOver
		
		#if失败逻辑
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
var isLoadingSave:bool=false
#var _rewardPanel:rewardPanel 移动导savedate里


#剩余粮食_用于赈灾系统
var resideGrain=0
var swordManGameState:gameState=gameState.pause
enum gameState{pause,start}
#判断是否累了的框，不用保存
var triedResult=false
var triedCostNum=0
var triedPanel
signal triedPanelDone
func isTried(costNum)->bool:


	if triedPanel!=null:
		return true
	triedCostNum=costNum
	if(sav.hp-costNum<0):
		#显示累了框

		if triedPanel==null:
			triedResult=true
			triedPanel=PanelManager.show_Tied()
		await triedPanelDone
		triedPanel=null
	else:
		triedResult=false
	var result=triedResult
	triedCostNum=0
	return	result


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
	if sav.day<4:
		if sav.day==1:
			
			available_secret_items=CanFindSecretItems[1]
	
		elif sav.day==2:
			sav.todayCanFindItems.append(CanFindSecretItems[1])
			available_secret_items=CanFindSecretItems[0]
		elif sav.day==3:
			available_secret_items=CanFindSecretItems[2]

		sav.todayCanFindItems.append(available_secret_items)
		
	for i in range(0,get_daily_find_item_count()):
		available_items = CanFindItems.filter(func(item): return not _today_find_items_has_name(item.name))
		if available_secret_items!=null:
			available_items=available_items.filter(func(item): return not _is_same_find_item_position(item, available_secret_items))
		if available_items.is_empty():
			break
		var available_item = available_items[randi_range(0,available_items.size()-1)]
		available_item.alreadyGet=false
		sav.todayCanFindItems.append(available_item)
	
	#如果在游戏后期则不会获取怪谈道具

func get_daily_find_item_count()->int:
	if sav.day<5:
		return 3
	var maxvalue=1
	if InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.雌雄双股剑)>0:
		maxvalue=3
	return randi_range(0,maxvalue)

func _today_find_items_has_name(item_name:String)->bool:
	for item in sav.todayCanFindItems:
		if item.name==item_name:
			return true
	return false

func _is_same_find_item_position(item, other_item)->bool:
	return item.scene==other_item.scene and item.id==other_item.id



var currenceScene
var restFadeScene


var moupos=null#get_viewport().get_mouse_position()
#var dialogBegin=false
# Called when the node enters the scene tree for the first time.
func _ready():
	

	sav=saveData.new()
	_enterDay()
	SkipPrologue()
	initSetting()
	refreshCallable()
	
	#用这个会触发bug
	#SignalManager.changeFraction.connect(refreshFloor)	

func OpenSettingMenu():
	PanelManager.new_SettingMenu()	

func ReturnMenu():
	DialogueManager.gameover=false
	SceneManager.changeScene(SceneManager.roomNode.MainMenu,2)

var musicId=0

func _input(event):
	# 检测 ESC 键
	if event.is_action_pressed("ui_cancel") and not event.is_echo() and currenceScene!=null:
		# 双重保障：对话框已释放时允许 ESC 打开设置
		#（即使 dialogBegin 因 bug 卡在 true，也不影响 ESC 操作）
		if DialogueManager.get_dialogue_balloon() == null:
			openSetting()
			
func openSetting():
	if PanelManager.isOpenSetting==true:
		return
	if !(currenceScene is mainHall) and !(currenceScene is credit):
		DialogueManager.show_example_dialogue_balloon(sys,"ESC按钮")
	elif currenceScene is credit:
		currenceScene.pauseCredit()
		DialogueManager.show_example_dialogue_balloon(sys,"退出名单")
		
		print("test")
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

func resetAfterBloodBattle():
	initBattle()
	sav.hp=sav.maxHP
	sav.alreadyHP=0
	if _engerge!=null:
		_engerge.previewValue=0
		_engerge.changerate(sav.hp)

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
	if sav.have_event["lvbuJoin"]==true:
		initPaixi(sav.LVBU)

func refreshCallable():
	if not sav.have_event["Factionalization"]:
		if not sav.HAOZUPAI.support_redirect.is_valid():
			sav.HAOZUPAI.support_redirect = func(num): sav.BENTUPAI.ChangeSupport(num)
			sav.HAOZUPAI.support_redirect_active = true
	if not sav.HAOZUPAI.changeFloor.is_valid():
		sav.HAOZUPAI.changeFloor = func():initPaixiFloor(sav.HAOZUPAI)
	if not sav.WAIDIPAI.changeFloor.is_valid():	
		sav.WAIDIPAI.changeFloor = func():initPaixiFloor(sav.WAIDIPAI)
	if not sav.BENTUPAI.changeFloor.is_valid():	
		sav.BENTUPAI.changeFloor = func():initPaixiFloor(sav.BENTUPAI)
func refreshFloor():
	initPaixiFloor(sav.BENTUPAI)
	initPaixiFloor(sav.WAIDIPAI)
	#initPaixi(sav.HAOZUPAI)
	if sav.have_event["Factionalization"]:
		initPaixiFloor(sav.HAOZUPAI)
	SignalManager.changeSupport.emit()


#开始时调用
func initPaixi(data:cldata):
	
	
	#data._num_op=(data._num_all*(100-data._support_rate))/100+0.5
	#var paixiindex=getIndexByFractionIndex(data.index)
	#var lawOP=0
	#if paixiindex!=sav.curLawNum1 and sav.curLawNum1!=-1:
	#	lawOP=((sav.curLawNum2-1)*10.0/100.0)*(data._num_all-data._num_op)*0.4
	#	lawOP=floor(lawOP)

	#如果是相同派系，则为0，不同派系，将（index-1）*9到10 的百分比赋值给它
	#data._num_op=data._num_op+lawOP
	#var initRt=randf_range(0,min(data._num_op*2,data._num_all-data._num_op))
	#if sav.curLawNum1<0:
	#	initRt=0
	#data._num_rt=initRt
	#data._num_sp=(data._num_all-data._num_op-data._num_rt)

	initPaixiFloor(data)
	data.isrebellion=false

	data.summonNum=0


func initPaixiFloor(data:cldata):
	
	# 保存并立即清除送礼标志，防止泄漏到异常路径
	var _giftTriggered = isGiftTrigger
	isGiftTrigger = false

	#data._num_sp=(data._num_all*data._support_rate)/100+0.5
	data._num_op=(data._num_all*(100-data._support_rate))/100+0.5
	var paixiindex=getIndexByFractionIndex(data.index)
	var lawOP=0
	if paixiindex!=sav.curLawNum1 and sav.curLawNum1!=-1:
		lawOP=((sav.curLawNum2-1)*10.0/100.0)*(data._num_all-data._num_op)*0.4
		lawOP=floor(lawOP)

	#如果是相同派系，则为0，不同派系，将（index-1）*9到10 的百分比赋值给它
	data._num_op=data._num_op+lawOP
	var maxRt = max(0, data._num_all - data._num_op)
	var initRt=randf_range(0,min(data._num_op*2, maxRt))
	if data._num_rt>initRt:
		initRt=min(data._num_rt, maxRt)
	if sav.curLawNum1<0:
		initRt=0

	# 送礼特殊处理：新摇摆数必须比原来少至少1
	if _giftTriggered:
		var old_rt = data._num_rt
		initRt = min(initRt, max(0, old_rt - 1))

	data._num_rt=initRt
	data._num_sp=max(0, data._num_all-data._num_op-data._num_rt)
	
	var is_courting_law = GameManager.sav.courtingLaws.has(data._name) and \
	GameManager.sav.courtingLaws[data._name] == GameManager.sav.curLawName

	if is_courting_law:	
		data._num_rt += data._num_op
		data._num_op = 0
		if data._num_sp < 1:
			if data._num_op > 0:
				data._num_op -= 1
				data._num_sp = 1
	SignalManager.changeSupport.emit()
	#sav.floor


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
		
		
		sav.policyExcute=false
		if sav.xuzhouCD>0:
			sav.xuzhouCD-=1

		if sav.haozuCD>0:
			sav.haozuCD-=1

		if sav.danyangCD>0:
			sav.danyangCD-=1
		if GameManager.sav.XuanyinDay<3 and GameManager.sav.have_event["玄阴开放"]==true:
			GameManager.sav.XuanyinDay+=1
		if GameManager.sav.have_event["泰山预备"]==true and GameManager.sav.have_event["最终泰山"]==false:
			GameManager.sav.taishanWait+=1
		if sav.allocationDay>0:
			sav.allocationDay+=1
			#
			if sav.allocationDay>3:
				sav.allocationDay=0
				
		if sav.learnFormChenden==false:
			if sav.acdemicLevel>0:
				sav.acdemicLevel-=1
		else:
			sav.learnFormChenden=false
			
			
		if GameManager.sav.have_event["AllFactionsSubdued"]==true:
			if GameManager.sav.Merit_points<3:
				GameManager.sav.Merit_points+=1
#@export var mizhuSideWait=-1
#@export var chendenSideWait=-1
#@export var caobaoSideWait=-1
	if sav.mizhuSideWait!=-1 and sav.mizhuSideWait>0:
		if sav.have_event["糜贞送药"]==false and sav.mizhuSideWait==1:
			pass
		else:
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


const ALLOWANCE_PRESSURE_START_DAY := 10
const ALLOWANCE_PRESSURE_PER_DAY := 0.003
const ALLOWANCE_MAX_PRESSURE := 0.15
const MONTHLY_ALLOWANCE_MAX_ITEM_COUNT := 9
const MONTHLY_ALLOWANCE_ITEM_COST_MULTIPLIER := 0.7

func get_allowance_pressure_multiplier(day: int) -> float:
	var pressure_days := maxi(day - ALLOWANCE_PRESSURE_START_DAY, 0)
	var pressure := minf(pressure_days * ALLOWANCE_PRESSURE_PER_DAY, ALLOWANCE_MAX_PRESSURE)
	return 1.0 + pressure

func initDemand():
	var point=GameManager.sav.day*10+50
	var allowanceCoeff=1.0
	match GameManager.sav.gameDifficulty:
		1: allowanceCoeff=1
		2: allowanceCoeff=1
		3: allowanceCoeff=1.2
	point=int(point*allowanceCoeff*get_allowance_pressure_multiplier(GameManager.sav.day))
	sav.HAOZUPAI.allocationStatue=-1

	sav.LVBU.allocationStatue=-1
	
	
	initSoleDemand(sav.WAIDIPAI,point)
	initSoleDemand(sav.BENTUPAI,point)
	
	if GameManager.sav.have_event["Factionalization"]==true:
		initSoleDemand(sav.HAOZUPAI,point)		
	#sav.WAIDIPAI.demand={}
	#sav.BENTUPAI.demand={}
	#
	#sav.HAOZUPAI.demand={}
	if GameManager.sav.have_event["lvbuJoin"]==true:
		initSoleDemand(sav.LVBU,point*2)
		#sav.LVBU.demand={}

func initSoleDemand(sav,value):
	var items=GameManager.ScoreToItem(
		value,
		-1,
		MONTHLY_ALLOWANCE_MAX_ITEM_COUNT,
		MONTHLY_ALLOWANCE_ITEM_COST_MULTIPLIER
	)
	sav.demand=items
	sav.allocationStatue=0

func clearAllocationDemands():
	for i in range(0,4):
		var data=getcldateByindex(i)
		data.demand={}
		data.allocationStatue=-1
	
	
func canDistributeAllowance():
	return sav.BENTUPAI.allocationStatue==0 or sav.WAIDIPAI.allocationStatue==0 or sav.HAOZUPAI.allocationStatue==0 or (sav.LVBU.allocationStatue==0 and GameManager.sav.have_event["lvbuJoin"]==true)	
func dontHaveDominance():
	var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.霸道之息)	

	return num==0


func showGuimiAchi():
	PanelManager.new_GuiMiAchiView()

func intBattleTask():
	var nums={}
	var battleCoeff=1.0
	match GameManager.sav.gameDifficulty:
		1: battleCoeff=1.0
		2: battleCoeff=1.2
		3: battleCoeff=1.4
	#gener
	
	#var levels=1.0889-(0.0889*levels)
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
				costNum=int(10*sav.battleTasks[battleTarget].index*battleCoeff)
				#最小值是10*xxx
				#*10/15
			else:
				res="human"
				costNum=int(18*sav.battleTasks[battleTarget].index*battleCoeff)
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
			sav.battleTasks[battleTarget].task=[{"res":"coin","symbol":sy1,"value":int(10*sav.battleTasks[battleTarget].index*battleCoeff),"reward":nums[0]},{"res":"human","symbol":sy2,"value":int(18*sav.battleTasks[battleTarget].index*battleCoeff),"reward":nums[1]}]
			sav.battleTasks[battleTarget].reward=nums[2]
		var sdType:int=randi_range(0, 2)#从3修改
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



var extraValue=0
var isGiftTrigger:bool = false  # 送礼标志，initPaixiFloor 中用于限制摇摆不回升

	
#需要在saveData定义一个对子的数据结构判断1是否执行 2是否执行	
func getPolicyGroup() -> int:
	if sav.policyExcute==false:
		if sav.day<2:
			return 1
		if sav.day==5:
			return 2
		if sav.have_event["chaoChendengEnd"]==true and sav.have_event["chaoChenDenPolicyExcute"]==false and sav.currenceDay<=3 and GameManager.sav.have_event["泰山诸将曹操消息"]==false:
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
	if sav.WAIDIPAI._support_rate>=80 or sav.WAIDIPAI.supressNum>=3:
		cv+=1
	if sav.BENTUPAI._support_rate>=80 or sav.BENTUPAI.supressNum>=3:
		cv+=1
	if sav.LVBU._support_rate>=80 or sav.LVBU.supressNum>=3:
		cv+=1	
	if sav.HAOZUPAI._support_rate>=80 or sav.HAOZUPAI.supressNum>=3:
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

var needC
var PunishC
func _rest(value=true):
	if GameManager.sav.have_event["进入青梅煮酒"]==false:
		# 血战模式下保留血战BGM的连续性，避免休息后音乐重新从头播放
		var isBloodBattle = GameManager.sav.have_event["战斗袁术血战模式"]==true and GameManager.sav.have_event["血战袁术完成"]==false
		if not isBloodBattle:
			SoundManager.stop_music()
			if GameManager.musicId!=0:
				GameManager.musicId=-GameManager.musicId
	const DISSOLVE_IMAGE = preload("res://addons/transitions/images/circle-inverted.png")
	if DialogueManager.gameover==true:
		return

	if GameManager.sav.have_event["预获得龙胆枪"]==true:
		GameManager.sav.have_event["预获得龙胆枪休息"]=true
	_enterDay(value)
	
	Transitions.change_scene_to_instance( SceneManager.SLEEP_BLANK.instantiate(), Transitions.FadeType.Instant)

# 怠惰检测 + 对话触发（统一入口，house.gd / TiredPanel 共用）
func checkAndHandleLazy() -> bool:

	if GameManager.sav.endPath==GameManager.endPath.xuzhou and GameManager.sav.have_event["主簿的追随"]==false:
		GameManager.sav.have_event["主簿的追随"]=true	
		return true
	if GameManager.sav.have_event["关羽求援结束"] ==true and GameManager.sav.have_event["主簿的追随"] ==false:
		DialogueManager.show_example_dialogue_balloon(sys,"小沛最终不能休息")
		return true
	GameManager.resideValue2=GameManager.LawNum()
	if GameManager.sav.endPath!=GameManager.endPath.none:
		var allcount = GameManager.sav.battleResults.size() - GameManager.sav.battleResults.count(GameManager.BattleResult.none)

		#var diffFactor=0
		
		#if GameManager.sav.gameDifficulty==1:
		var diffFactor=GameManager.sav.gameDifficulty*5
	
		if(GameManager.sav.have_event["夏侯偷马"]==true and GameManager.sav.endPath==GameManager.endPath.xuzhou):
			needC=3
			PunishC=25+diffFactor
		elif GameManager.sav.endPath==GameManager.endPath.xiaopei and GameManager.sav.have_event["吕布之怒"]==true:
			needC=3#吕布
			PunishC=20+diffFactor
		else:
			if GameManager.sav.endPath==GameManager.endPath.xiaopei:
				needC=1
				PunishC=10+diffFactor
			elif GameManager.sav.endPath==GameManager.endPath.xuzhou:
				needC=2
				PunishC=15+diffFactor
		if allcount<needC:
			if GameManager.sav.have_event["主簿的追随"]==false:
				DialogueManager.show_example_dialogue_balloon(sys,"最终自言自语")
				return true
			else:
				DialogueManager.show_example_dialogue_balloon(sys,"最终主簿告知")
				return	true
	
	

	resideValue = ceil(float(sav.day)/perLawCycle)
	var resideValue2 = LawNum()
	if sav.endPath==endPath.none and resideValue2<resideValue and resideValue2<15:
		sav.lazydays+=1
		sav.lazyValue+=1
		if sav.lazydays>=3:
			sav.lazydays=0
			sav.lazyValue=0
			DialogueManager.show_example_dialogue_balloon(sys,"连续多日怠惰")
			return true
		else:
			#var lazyRan=0.5*sav.lazyValue
			#if randf()<=lazyRan:
			DialogueManager.show_example_dialogue_balloon(sys,"单日概率怠惰")
			return true
	else:
		if sav.lazyValue>0:
			sav.lazyValue-=1
		sav.lazydays=0
	return false

# 以下两个函数由 dialogue 的 do 命令调用
func moreDayidness():
	if sav.have_event["Factionalization"]==true:
		sav.HAOZUPAI.ChangeSupport(-10)
	sav.BENTUPAI.ChangeSupport(-10)
	sav.WAIDIPAI.ChangeSupport(-10)
	changePeopleSupport(-5)
	_rest()

func oneDayidness():
	if sav.have_event["Factionalization"]==true:
		sav.HAOZUPAI.ChangeSupport(-5)
	sav.BENTUPAI.ChangeSupport(-5)
	sav.WAIDIPAI.ChangeSupport(-5)
	_rest()



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
		
		lawAction= func():
			sav.labor_DayGet=sav.labor_DayGet+10
			#获得诸子百家
			sav.daruValue+=2000
#			sav.WAIDIPAI.ChangeSupport(-20)
			print("兴办教育done")		
	elif sav.curLawName=="显绩法":#只有buff
		#RewardLaw="一次性民力+100，徐州好感度+10，群众支持度+5 " #民力一次性增加 徐州派好感上升
		lawAction= func():
			sav.labor_DayGet+=30
			sav.enhancPolicy_coax=true

			print("整治街容done")			
	elif sav.curLawName=="重农抑商":
		#RewardLaw="收益：每日收入+80，徐州好感度+15 冲突：豪族好感度-20 " 
		lawAction= func():
			sav.labor_DayGet=sav.labor_DayGet+80
			#sav.HAOZUPAI.ChangeSupport(-30)
			sav.daruValue+=2000			
			print("重农抑商done")	
	elif sav.curLawName=="士族优先":
		#RewardLaw="收益：徐州好感度+20，获得道具“珍品礼盒”x1，一次性民力+150 冲突：丹阳派好感度-15  "+1000
		lawAction= func():
			sav.daruValue+=2000
			#sav.BENTUPAI.ChangeSupport(-15)
			#sav.WAIDIPAI.ChangeSupport(-15)
			sav.labor_force+=300
			print("士族优先done")			
	elif sav.curLawName=="肃民明制":
		#RewardLaw="收益：每日收入+100，群众支持度+10 冲突：豪族好感度-30 "
		lawAction= func():
			sav.coin_DayGet+=120

			sav.minxinReduceCost=true
			LoadingDiffucultValue()
			#sav.HAOZUPAI.ChangeSupport(-30)
			print("肃民明制done")			
	elif sav.curLawName=="屯田制":
		#RewardLaw="收益：每日民力+30，每日收入+120，一次性民力+200 
		#冲突：丹阳派好感度-20，豪族好感度-10  "
		lawAction= func():
			sav.labor_DayGet+=240
			sav.coin_DayGet+=120
			sav.labor_force+=200
			#sav.WAIDIPAI.ChangeSupport(-20)
			#sav.HAOZUPAI.ChangeSupport(-20)			
			print("屯田制done")			
	elif sav.curLawName=="府兵制":
		#RewardLaw="收益：每日收入+150，获得道具“胜战锦囊”x2，一次性收入+1000  冲突：丹阳派好感度-30，群众支持度-10  "
		lawAction= func():
			sav.coin_DayGet+=300
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.胜战锦囊)
			#sav.WAIDIPAI.ChangeSupport(-20)
			changePeopleSupport(-10)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 8, false)					
			print("府兵制done")			
	elif sav.curLawName=="品级制":#1000
		#RewardLaw="收益：徐州好感度+50，每日民力+50，获得道具“珍品礼盒”x2，一次性民力+300 冲突：豪族好感度-40，丹阳派好感度-25  "
		lawAction= func():

			sav.labor_DayGet+=150
			sav.summonMaxNum=sav.summonMaxNum+1							
			print("品级制done")			
#豪族		
	elif sav.curLawName=="促进商贸":#只有buff 收入每日增加 获得一笔钱财
		#RewardLaw="每日收入+10，徐州好感度+5，一次性收入+100，随机道具x1 "
		lawAction= func():
			sav.labor_DayGet+=10
			sav.HAOZUPAI.ChangeSupport(5)
			sav.coin+=300
			var items:Array=[InventoryManagerItem.ItemEnum.珍品礼盒,InventoryManagerItem.ItemEnum.益气丸, InventoryManagerItem.ItemEnum.胜战锦囊, InventoryManagerItem.ItemEnum.诸子百家论集]
			var rindex= randi_range(0,items.size()-1)
			var itemname= InventoryManagerItem.item_by_enum(items[rindex])
			var remainder = InventoryManager.add_item(inventoryPackege, itemname, 1, false)
			#bedone
			print("促进商贸")			
	elif sav.curLawName=="诚信经营":#只有buff 所有派系好感度上升
		#RewardLaw="所有派系好感度+20，群众支持度+5，一次性民力+80"
		lawAction= func():

			#sav.WAIDIPAI.ChangeSupport(-20)
			sav.shopEnhance+=1
			changePeopleSupport(5)
			sav.labor_force+=80
			print("诚信经营done")			
	elif sav.curLawName=="通商惠利":#只有buff 所有派系好感度随机上升
		#RewardLaw="所有派系好感度+5，每日收入+20，获得道具“珍品礼盒”x1，一次性收入+100"		
		lawAction= func():
			#sav.BENTUPAI.ChangeSupport(-20)
			sav.coin_DayGet+=20
			sav.coin+=400
			
			#sav. todo
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.珍品礼盒)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 1, false)			
			sav.merMustBuy=true
			print("行业准则done")			
	elif sav.curLawName=="禁止军商":
		#RewardLaw="收益：每日收入+50，豪族好感度+15，一次性收入+600 冲突：丹阳派好感度-25  "
		lawAction= func():
			sav.coin_DayGet+=50
			sav.coin+=600
			#sav.WAIDIPAI.ChangeSupport(-25)
			print("禁止军商done")			
	elif sav.curLawName=="宽商减赋法":
		#RewardLaw="收益：每日收入+80，获得道具“益气丸”x2，一次性收入+800  冲突：徐州好感度-20"
		lawAction= func():
			sav.labor_DayGet+=180
			sav.isGoodsDiscount=true
			#sav.BENTUPAI.ChangeSupport(-20)
		
	elif sav.curLawName=="货币法":
		#RewardLaw="收益：每日收入+100，群众支持度+10 冲突：丹阳派好感度-30 "
		lawAction= func():
			sav.shopEnhance+=1
			#sav.labor_DayGet+=100
			changePeopleSupport(10)
			#sav.WAIDIPAI.ChangeSupport(-30)	
			sav.daruValue+=500	
			print("货币法")			
	elif sav.curLawName=="市肆兴隆法":
		#RewardLaw="收益：每日收入+120，豪族好感度+20，一次性收入+1000 冲突：徐州好感度-25，丹阳派好感度-15"
		lawAction= func():
			print("商业竞争法done")			
			sav.labor_DayGet+=120
			sav.shopSelfSell=true

	elif sav.curLawName=="商品流通法":
		#RewardLaw="收益：每日收入+150，每日随机道具x1，一次性民力+200 冲突：徐州好感度-30，群众支持度-10  "
		lawAction= func():
			sav.coin_DayGet=sav.coin_DayGet+150
			sav.shopEnhance+=1
			#sav.dailyGetRandomItem=true
			sav.labor_force+=200
			#sav.BENTUPAI.ChangeSupport(-20)
			changePeopleSupport(-10)
			#每日随机道具											
	elif sav.curLawName=="宽商信规法":
		#RewardLaw="收益：获得道具“珍品礼盒”x2，每日收入+200，一次性收入+1500  冲突：徐州好感度-40，丹阳派好感度-20  "
		lawAction= func():
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.珍品礼盒)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 8, false)
			sav.coin_DayGet=sav.coin_DayGet+200
			#sav.coin=sav.coin+1500
			#sav.BENTUPAI.ChangeSupport(-20)
			#sav.WAIDIPAI.ChangeSupport(-20)
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
		
		#RewardLaw="随机获得3个道具，一次性民力+100"
		lawAction= func():
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.益气丸)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 1, false)
			
			itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.胜战锦囊)
			InventoryManager.add_item(inventoryPackege, itemid, 1, false)

			itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.诸子百家论集)
			InventoryManager.add_item(inventoryPackege, itemid, 1, false)

			GameManager.sav.battleEnhance+=1
			#GameManager.sav.HAOZUPAI.ChangeSupport(-20)
			#sav.labor_force=sav.labor_force+100
	elif sav.curLawName=="侦隐法":#获得一些民力增加
		#RewardLaw="一次性民力+100，丹阳派好感度+5，群众支持度+5，一次性收入+400  "
		lawAction= func():
			sav.labor_force=sav.labor_force+300
			#sav.BENTUPAI.ChangeSupport(-20)
			sav.isInformation=true

			#sav.coin=sav.coin+400
			print("厉兵练卒")	
	elif sav.curLawName=="军事训诂":
		#RewardLaw="收益：丹阳派好感度+20，获得道具“胜战锦囊”x2，一次性民力+150 冲突：徐州好感度-15  "
		lawAction= func():
			#print("军事训诂")	
			#sav.BENTUPAI.ChangeSupport(-25)
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.胜战锦囊)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 3, false)
			sav.labor_force=sav.labor_force+150
	
	elif sav.curLawName=="军事装备法":
		#RewardLaw="收益：每日收入+50，获得道具“益气丸”x2 冲突：豪族好感度-20 "
		lawAction= func():
			sav.coin_DayGet=sav.coin_DayGet+140
			sav.isWeaponLevelUP=true
			
			#print("军事装备法")	
	elif sav.curLawName=="军事训练法":
		#RewardLaw="收益：丹阳派好感度+30，每日民力+20，一次性民力+200 冲突：徐州好感度-25  "
		lawAction= func():
			print("军事训练法")	
			#sav.BENTUPAI.ChangeSupport(-30)
			sav.battleEnhance+=1
			sav.labor_DayGet=sav.labor_DayGet+60
			
	elif sav.curLawName=="军事优拔法":
		#RewardLaw="收益：丹阳派好感度+40，获得道具“胜战锦囊”x3，一次性收入+800 冲突：豪族好感度-30，群众支持度-10  "									
		lawAction= func():

			#sav.HAOZUPAI.ChangeSupport(-30)
			changePeopleSupport(-10)
	
			sav.battleEnhance+=1
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.胜战锦囊)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 3, false)
			print("军事优拔法")	
	elif sav.curLawName=="厉兵练卒法":
		#RewardLaw="收益：每日民力+100，获得道具“珍品礼盒”x2，一次性民力+250 冲突：徐州好感度-35，豪族好感度-15  "#获得银月枪
		lawAction= func():

			sav.labor_DayGet=sav.labor_DayGet+100
			sav.isTrainLevelUP=true
			#sav.BENTUPAI.ChangeSupport(-20)
			#sav.HAOZUPAI.ChangeSupport(-20)
			print("律令兵制")	
	elif sav.curLawName=="国防策略法":
		#RewardLaw="民心+50，每日民力+50，获得道具“胜战锦囊”x4，一次性收入+1200  ，徐州好感度-50，豪族好感度-40  "		
		lawAction= func():
			sav.labor_DayGet=sav.labor_DayGet+50
			changePeopleSupport(20)
			#sav.HAOZUPAI.ChangeSupport(-20)
			#sav.BENTUPAI.ChangeSupport(-20)
			var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.胜战锦囊)
			var remainder = InventoryManager.add_item(inventoryPackege, itemid, 4, false)

	# 统一追加：非简单难度时执行派系代价
	if lawAction.is_valid():
		var _base = lawAction
		lawAction = func():
			_base.call()
			if GameManager.sav.gameDifficulty!=1:
				GameManager.preCostPaixi()

func preCostPaixi():
	_changeLawFactionSupport(-1)

func refundPreCostPaixi():
	_changeLawFactionSupport(1)

func _changeLawFactionSupport(direction:int):
	
	if sav.curLawName=="兴办教育":#只有buff
		

		sav.WAIDIPAI.ChangeSupport(20 * direction)
			#var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.诸子百家论集)
			#var remainder = InventoryManager.add_item(inventoryPackege, itemid, 1, false)

	elif sav.curLawName=="显绩法":#只有buff
		#RewardLaw="一次性民力+100，徐州好感度+10，群众支持度+5 " #民力一次性增加 徐州派好感上升
		sav.HAOZUPAI.ChangeSupport(20 * direction)
	elif sav.curLawName=="重农抑商":
		sav.HAOZUPAI.ChangeSupport(30 * direction)
	elif sav.curLawName=="士族优先":
		#RewardLaw="收益：徐州好感度+20，获得道具“珍品礼盒”x1，一次性民力+150 冲突：丹阳派好感度-15  "+1000
		sav.BENTUPAI.ChangeSupport(15 * direction)
		sav.WAIDIPAI.ChangeSupport(15 * direction)
	elif sav.curLawName=="肃民明制":
		sav.HAOZUPAI.ChangeSupport(30 * direction)

	elif sav.curLawName=="屯田制":
		#RewardLaw="收益：每日民力+30，每日收入+120，一次性民力+200 
		#冲突：丹阳派好感度-20，豪族好感度-10  "
		sav.WAIDIPAI.ChangeSupport(20 * direction)
		sav.HAOZUPAI.ChangeSupport(20 * direction)
	elif sav.curLawName=="府兵制":

		sav.WAIDIPAI.ChangeSupport(20 * direction)
		
	elif sav.curLawName=="品级制":#1000
	
		sav.HAOZUPAI.ChangeSupport(20 * direction)
		sav.WAIDIPAI.ChangeSupport(20 * direction)
	
	elif sav.curLawName=="诚信经营":#只有buff 所有派系好感度上升

		sav.WAIDIPAI.ChangeSupport(20 * direction)
	
	elif sav.curLawName=="通商惠利":#只有buff 所有派系好感度随机上升

		sav.BENTUPAI.ChangeSupport(20 * direction)
	
	elif sav.curLawName=="禁止军商":

		sav.WAIDIPAI.ChangeSupport(25 * direction)
		#	print("禁止军商done")			
	elif sav.curLawName=="宽商减赋法":

		
		sav.BENTUPAI.ChangeSupport(20 * direction)
		
	elif sav.curLawName=="货币法":

		sav.WAIDIPAI.ChangeSupport(30 * direction)
	
	elif sav.curLawName=="市肆兴隆法":

		sav.BENTUPAI.ChangeSupport(20 * direction)
		sav.WAIDIPAI.ChangeSupport(20 * direction)
	elif sav.curLawName=="商品流通法":

		sav.BENTUPAI.ChangeSupport(20 * direction)
										
	elif sav.curLawName=="宽商信规法":

		sav.BENTUPAI.ChangeSupport(20 * direction)
		sav.WAIDIPAI.ChangeSupport(20 * direction)
#丹阳派

	elif sav.curLawName=="战备法":#获得若干随机道具
		#益气丸, 胜战锦囊, 诸子百家论集
		
		#RewardLaw="随机获得3个道具，一次性民力+100"
		
		GameManager.sav.HAOZUPAI.ChangeSupport(20 * direction)
			#sav.labor_force=sav.labor_force+100
	elif sav.curLawName=="侦隐法":#获得一些民力增加

		sav.BENTUPAI.ChangeSupport(20 * direction)

	elif sav.curLawName=="军事训诂":

		sav.BENTUPAI.ChangeSupport(25 * direction)

	elif sav.curLawName=="军事装备法":
		#RewardLaw="收益：每日收入+50，获得道具“益气丸”x2 冲突：豪族好感度-20 "

		sav.HAOZUPAI.ChangeSupport(30 * direction)
		
	elif sav.curLawName=="军事训练法":

		sav.BENTUPAI.ChangeSupport(30 * direction)
	
	elif sav.curLawName=="军事优拔法":

		sav.HAOZUPAI.ChangeSupport(30 * direction)
		
	
	elif sav.curLawName=="厉兵练卒法":

		sav.BENTUPAI.ChangeSupport(20 * direction)
		sav.HAOZUPAI.ChangeSupport(20 * direction)

	elif sav.curLawName=="国防策略法":

		sav.HAOZUPAI.ChangeSupport(20 * direction)
		sav.BENTUPAI.ChangeSupport(20 * direction)

	
	

var maxResPanelX=0

var RewardLaw

func LawNum():
	var count=0

	for laws in GameManager.sav.laws:
		var seen = []  # 用于去重
		for v in laws:
			if v > 0 and not v in seen:
				seen.append(v)
				count += 1
	return count
func excuteLaw():
	# 只有 laws 里还没有才追加，避免重复
	if not sav.curLawNum2 in sav.laws[sav.curLawNum1]:
		sav.laws[sav.curLawNum1].append(sav.curLawNum2)
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


func confirmDeleteFile():
	_savePanel.confirmDeleteFile()	
func ScoreToItem(player_score,num=-1,max_item_count=3,item_cost_multiplier=1.0):
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
		var effective_item_cost=maxi(int(round(item.cost*item_cost_multiplier)),1)
		var max_count=remaining_score/effective_item_cost
		if resideNum!=-1:
			max_count.min(max_count,resideNum)
		#print(max_count)
		var item_count
		if max_count>=1 and has_at_least_one_item==false:
			item_count =min(rng.randi_range(1, max_count),max_item_count)
			has_at_least_one_item=true
		else:	
			item_count = min(rng.randi_range(0, max_count),max_item_count)
		
		var item_cost = item_count * effective_item_cost
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
	# 随机分配剩余积分到民力和钱
	var population = 0
	var money = 0
	rng = RandomNumberGenerator.new()	
	if remaining_score > 0:
		# 随机决定分配给民力的最大可能数量
		var max_population = remaining_score / POPULATION_PER_POINT
		if max_population > 0:
			population = rng.randi_range(0, max_population)
		# 分配给民力的积分
		var population_cost = population * POPULATION_PER_POINT
		# 剩余积分全转为钱
		money = (remaining_score - population_cost)
		rng = RandomNumberGenerator.new()	
		money = rng.randi_range(0, money)
	
	# 输出结果
	print("结算结果:")
	print("获得的道具:")
	for item in gained_items:
		print("- ", item, ": ", gained_items[item], "个")
	print("获得的钱: ", money)
	print("获得的民力: ", population)
	
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
	var level_factor = 1.0 + (general_level - 1) / 30
	
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
	#GameManager.sav.have_event["诡物手册"]=true
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
	sav.BENTUPAI._support_rate=100
	sav.WAIDIPAI._support_rate=100
	sav.day=5
	sav.coin=100
	sav.laws[2].append(1)
	var itemid= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.胜战锦囊)
	var remainder = InventoryManager.add_item(inventoryPackege, itemid, 1, false)	
	initSecretFunc()

var _setting:SettingsResource

func OpenGuiyiBook():
	PanelManager.new_guiyiBook()	

func initSetting():
	var path="user://ysg_data_setting.tres"
	if(FileAccess.file_exists(path)):
		_setting=load(path)

		_load_settings()#把语言系统设置，然后应用分辨率 应用全屏，引用音效、没了
	else:
		_setting = SettingsResource.new()
		# 可选：自定义默认值（如果不想用类里的默认值）
		# _setting.peopleVlan = "zh"
		# _setting.resolution = Vector2i(1920, 1080)
		# _setting.is_fullscreen = false
		# _setting.sound_volume = 0.8
		
		# 保存默认配置到文件（避免下次启动重复创建）
		ResourceSaver.save(GameManager._setting,"user://ysg_data_setting.tres")
		# 首次启动：立即应用默认音量（0.25等），否则AudioServer总线保持 Godot 默认值
		_load_settings()

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
	
	if not _setting.fullscreen:
		DisplayServer.window_set_size(Vector2i(width, height))
		var current_screen_idx = DisplayServer.window_get_current_screen()
		var screen_size = DisplayServer.screen_get_size(current_screen_idx)
		var screen_pos = DisplayServer.screen_get_position(current_screen_idx)
		var window_pos = screen_pos + (screen_size - Vector2i(width, height)) / 2
		window_pos.x = clamp(window_pos.x, screen_pos.x, screen_pos.x + screen_size.x - width)
		window_pos.y = clamp(window_pos.y, screen_pos.y, screen_pos.y + screen_size.y - height)
		DisplayServer.window_set_position(window_pos, current_screen_idx)
	
	SoundManager.set_sound_volume(GameManager._setting.sfx_volume)
	#await get_tree().create_timer(0.1).timeout
	SoundManager.set_music_volume(GameManager._setting.music_volume)
	#await get_tree().create_timer(0.1).timeout
	#SoundManager.set_sound_ui_volume(GameManager._setting.people_volume)
	#await get_tree().create_timer(0.1).timeout
	SoundManager.set_ambient_sound_volume(GameManager._setting.bgs_volume)
	SoundManager.set_sound_ui_volume(GameManager._setting.people_volume)
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
		

func haveUnicornIcon()->bool:
	var sxnum=InventoryManager.inventory_item_quantity(inventoryPackege,InventoryManagerItem.獬豸圣像) 
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
	var DateTime = Time.get_datetime_dict_from_system()
	sav.current_datetime="{year}/{month}/{day}/{hour}/{minute}".format({"year":DateTime.year,"month":DateTime.month,"day":DateTime.day,"hour":DateTime.hour,"minute":DateTime.minute})
	
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
	var earliest_slot: int = -1
	var earliest_time: int = 9223372036854775807 # Max int for comparison (future timestamp)

	for i in range(3):
		if tempSavs[i] != null:
			# Parse current_datetime string (format: "year/month/day/hour/minute")
			var time_str: String = tempSavs[i].current_datetime
			var time_parts = time_str.split("/")
			if time_parts.size() != 5:
				earliest_slot = i + 1
				break
			else:
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
					earliest_slot = i + 1

	# Save to the slot with the earliest time
	if earliest_slot != -1:
		ResourceSaver.save(sav, "user://save_data{index}.tres".format({"index": str(earliest_slot)}))
	#await 2
	_engerge.endAutoSave()

func _imporveRelation(data:cldata):
	if data.isSuppressed==true:
		data.rebellionUpdateNum+=2
		resideValue=data._name
		var _num_defections=max(data._num_defections,6)
		var remaining_rebellion_points = max(0, _num_defections - data.rebellionUpdateNum)
		resideValue2=ceili(remaining_rebellion_points / 2.0)
		
		if data.rebellionUpdateNum>=_num_defections:
			DialogueManager.show_example_dialogue_balloon(sys,"讨好叛乱1")
			data.rebellionUpdateNum=0
			data.isSuppressed=false
		else:
			DialogueManager.show_example_dialogue_balloon(sys,"讨好叛乱2")
	else:
		currenceScene._JudgeTask()

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

func setLabor(value):
	sav.labor_force=value



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
	var music_file = "res://Asset/music/.wav"
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
		if mode==boardType.boardMode.middle and GameManager.sav.middledemoPlay==false:
			GameManager.sav.middledemoPlay=true
		currenceScene.openBoardDialogue()
	
func enterBoardGame():
	#切入boardGame场景
	GameManager.sav.hp-=20
	SoundManager.stop_music()
	SceneManager.changeScene(SceneManager.roomNode.BoardGame,2)


const boardDialogue = preload("res://dialogues/桌游.dialogue")
#var rewardPanel:bool=false
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


func initSecretBattleContext(targetValue,mode,BootValue,dialogueContext,newdetail=""):
	sav.extraCureenTaskCNum=0
	sav.extraBattleTaskBootNum=BootValue
	sav.extraBattleTaskTargetNum= targetValue
	sav.extraBattleTaskEnum=mode
	sav.extraBattleDialogContext=dialogueContext
func removeSecretBattleContext():
	sav.extraCureenTaskCNum=0
	sav.extraBattleTaskBootNum=-1
	sav.extraBattleTaskTargetNum= -1
	sav.extraBattleTaskEnum=SceneManager.etraTaskType.none
	sav.extraBattleDialogContext=""


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


# All three infrastructure minigames use this before starting, so an attempted build can never create negative resources.
func try_spend_construction_resources() -> bool:
	if sav.coin < puzzleCostMoney or sav.labor_force < puzzleCostPeople:
		DialogueManager.show_example_dialogue_balloon(sys, "基建选项资源不足")
		return false
	sav.coin -= puzzleCostMoney
	sav.labor_force -= puzzleCostPeople
	return true


func selectPuzzleLevel():
	if await GameManager.isTried(20):
		return	
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


func pause_construction_minigame() -> void:
	if currenceScene == null:
		return
	var puzzle = currenceScene.get("puzzleGame")
	if puzzle != null and puzzle.has_method("pause_for_giveup_confirmation"):
		puzzle.pause_for_giveup_confirmation()


func resume_construction_minigame() -> void:
	if currenceScene == null:
		return
	var puzzle = currenceScene.get("puzzleGame")
	if puzzle != null and puzzle.has_method("resume_after_giveup_cancel"):
		puzzle.resume_after_giveup_cancel()

#判断有无需求
func justHaveDemand(item):
	if item.is_empty() or GameManager.sav.coin<item.money or GameManager.sav.labor_force<item.population:
		return false
	for key in item.items.keys():
		var _count=item.items[key]
		#查询指定id 自己的数量
		#判断物品数量是否大于cont 如果没有 return false
		var itemname= InventoryManagerItem.item_by_enum(key)
		var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,itemname)
		if num<_count:
			return false
	return true



func cuclulateAllAllocation():
	var items={}

	items.money =0
	items.population=0
	items.items={}
	for i in range(0,4):
	
		var data=getcldateByindex(i)
		var demand=data.demand
		if demand.is_empty() or data.allocationStatue==1 or data.isAutoAllocation==false:
			continue

		items.money+=demand.money
		items.population+=demand.population
		if demand.items is Dictionary:
			for key in demand.items:
			# 如果目标字典已有该键，可根据需求选择累加/覆盖
			# 累加示例（比如物品数量）：
				if key in items.items:
					items.items[key] += demand.items[key]
				else:
					items.items[key] = demand.items[key]
	if items.is_empty() or items.get("money", 0) ==0 and \
		   items.get("population", 0) == 0 and \
		   items.get("items", {}).is_empty():
		return null
	else:
		return items
var getLawPoint=0		
func completeAutoAll():
	getLawPoint=0
	for i in range(0,4):
			
		var data=getcldateByindex(i)
		if data.isAutoAllocation==true and data.allocationStatue==0:
			data.allocationStatue=1
			GameManager.sav.Merit_points+=1
			getLawPoint+=1
	
func iscompleteAll():
	#getLawPoint=0
	for i in range(0,4):
		if i==1 and GameManager.sav.have_event["Factionalization"]==false:
			continue
			
		elif i==3 and GameManager.sav.have_event["lvbuJoin"]==false:
			continue
		var data=getcldateByindex(i)
		if data.allocationStatue==0:
			return false 
			#data.allocationStatue=1
			#GameManager.sav.Merit_points+=1
			#getLawPoint+=1
	return true	
func playDemand(item):
	# 走 GetValue 刷新属性面板（钱、民心、民力）
	GameManager._propertyPanel.GetValue(-item.money, 0, -item.population)
	for key in item.items.keys():
		var _count=item.items[key]
		var itemname= InventoryManagerItem.item_by_enum(key)
		InventoryManager._remove_item(inventoryPackege,itemname,_count)
		#调用事件刷新面板
		#查询指定id 自己的数量
		#item_ui.set_Data(key,_count)
		#消耗指定数量的物品
	SignalManager.changeFraction.emit()
	SignalManager.playDemand.emit()




func get_bloodmode_day():
	var day
	var num = floor(GameManager.sav.currenceValue / 3)
	if num >=10:
		if GameManager.sav.currenceValue==30:
			day=11
		elif GameManager.sav.currenceValue==31:
			day=12
		elif GameManager.sav.currenceValue==32:
			day=13
		elif num>=8:
			day=8+floor((GameManager.sav.currenceValue-24)/2)
		  # 假设 godot 是你要计算的数值，比如 godot=10，则 num=3.333...
	else:
		day=num
	return day
#var bloodmusicid=-1

# 恢复 Windows 原生样式
func restore_system_cursor():
	Input.set_custom_mouse_cursor(null)
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

# 恢复游戏专属样式
func apply_game_cursor():
	var img = load("res://Asset/pointer_scifi_b.png") # 你的图片路径
	# 热点通常设为 Vector2(0,0) 或图片中心
	Input.set_custom_mouse_cursor(img, Input.CURSOR_ARROW, Vector2(0, 0))


func getMinxinValue1():
	var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.论语简注)
	var heart=5

	if num>0:
		heart+=5		
			
	heart= int(heart * (1 + GameManager.sav.BENTUPAI._num_all *0.03)) 
	return heart
		
func getMinxinValue2():
	var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.论语简注)
	var heart=5
	if num>0:
		heart+=5
			
	var factionNum = GameManager.sav.HAOZUPAI._num_all if GameManager.sav.HAOZUPAI.isshow else GameManager.sav.BENTUPAI._num_all
	heart= int(heart * (1 + factionNum *0.03)) 			
	return heart
func getMinxinValue3():
	var addcoin=300
	
	var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.论语简注)
	if num>0:
		addcoin=500

			

	addcoin= int(addcoin * (1 + GameManager.sav.WAIDIPAI._num_all *0.03)) 
	return addcoin
func getMinxinValue4():

	var addLabor=100
	var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.论语简注)
	if num>0:

		addLabor=200
			

	addLabor= int(addLabor * (1 + GameManager.sav.WAIDIPAI._num_all *0.03)) 
			
	return addLabor

func getMinxinCost1():
	var num = GameManager.sav.BENTUPAI._num_all
	return int(500 * (1 + max(num - 10, 0) * 0.01))

func getMinxinCost2():
	var num = GameManager.sav.HAOZUPAI._num_all if GameManager.sav.HAOZUPAI.isshow else GameManager.sav.BENTUPAI._num_all
	return int(1000 * (1 + max(num - 10, 0) * 0.01))

func getMinxinCost3():
	var num = GameManager.sav.WAIDIPAI._num_all
	return int(20 * (1 + max(num - 10, 0) * 0.01))

const savesys = preload("res://dialogues/存档.dialogue")
func showLoadSuccusss():

	await get_tree().process_frame
	DialogueManager.show_example_dialogue_balloon(savesys,"读取存档成功")
	isLoadingSave = false
	#refresh()


func rTaishanName():
	if GameManager.sav.have_event["completebattleTaiShan"]==false:
		return tr("吕布势力")
	else:
		return tr("泰山诸将派")

var perLawCycle=5
var minxinPoint=1
var maxLawNum=12
func CheckAllFactionsSubdued():
	return GameManager.sav.HAOZUPAI.supressNum>=3 and GameManager.sav.WAIDIPAI.supressNum>=3 and \
		GameManager.sav.BENTUPAI.supressNum>=3

func awakenDominanceAfterSuppression() -> bool:
	if not CheckAllFactionsSubdued():
		return false

	var sleeping_dominance_num = InventoryManager.inventory_item_quantity(
		GameManager.inventoryPackege,
		InventoryManagerItem.沉眠的霸道之息
	)
	if sleeping_dominance_num <= 0:
		return false
	AchievementManager.set_achievement("NEW_ACHIEVEMENT_1_22")
	InventoryManager.remove_item(GameManager.inventoryPackege, InventoryManagerItem.沉眠的霸道之息, 1, false)
	InventoryManager.add_item(GameManager.inventoryPackege, InventoryManagerItem.霸道之息, 1)
	return true
		
@export var academicLevelDesc:Dictionary = {0:"见事",1:"见势",2:"见机",3:"见几"}

@export var enemyDesc:Dictionary = {"黄巾流寇":"这些人作战悍不畏死，他们多是农户出身，作战并无太多章法。只是面黄肌瘦却拼死向前，看着令人心惊和心酸。",
	"昌豨":"泰山诸将之一，我听闻此人御下宽厚，部众肯为他效力。与臧霸手下其他人不同。他治军虽严却不苛，算得上是一个人物。",
	"臧霸":"此人盘踞琅琊多年，泰山诸将皆以他为首。我派斥候打探过，说他治军严整，部众愿为效死。曹操来信劝我讨伐，我也知他暗通袁术，但真要动起手来，怕是一场硬仗。",
	"纪灵":"袁术遣此人率步骑攻徐州。我登城观望，见其旗帜齐整，部伍不乱，治军有方。此人若得明主，未尝不能成为名将",
	"吕布":"吕布之勇，天下无双，这一点我不否认。但他取我徐州，害得那家伙死于非命——此仇不报，我刘玄德枉自为人！也是我识人不明，引狼入室，怨不得旁人。如今我屯兵小沛，名义上受他节制，忍气吞声。然大丈夫能屈能伸，眼下我不如他，低头便是。可天下事，尚未可知。",
	"吕布的马":"吕布的那批马我已经让人盯上了。我年轻时替马商跑过腿，略知行情——这批马确实不错，难怪奉先当宝贝。可惜了，马上就是我的了。",
	"纪灵/吕布":"袁术到底还是把吕布拉了过去。他如今与纪灵合兵一处，向我杀来。一个当世飞将，一个淮南悍将，两人联手兵临城下。纵使早知他有异心，事到临头，心中仍是不免一沉。",
	"陶谦":"昔日承其厚恩，心中常怀敬重。如今却化为尸躯，执念缠身。眼见故人沦落至此，心中不胜惋惜，唯有挺身一战。",
	"糜贞":"昔日端庄柔顺，相处良久自有几分感念。如今行事诡异、戾气缠身。糜府怪事频发，疑点重重，今日不得不与之对决。",
	"骨龙":"看似寻常石雕，实则藏有镇世神珠。宝珠异动便引幻象丛生，龙吟震耳、龙威滔天，虚实难辨，绝非寻常对手。",
	"修道真人":"一路行来，不少异事与物件皆出自此人手笔。他隐于幕后暗中布局，为求仙道不惜牺牲万民，理念相悖，只能兵刃相向。"
	}

var diffSrc={
  "1": {
	"name": "清平道",
	"type": "简单难度",
	"desc": "适合剧情党、策略小白，轻松推主线，轻松书写属于你的三国传奇。"
  },
  "2": {
	"name": "坎坷道",
	"type": "标准难度",
	"desc": "适合有策略游戏基础玩家，在有限的资源中做出最优选择，一步步扭转乾坤。"
  },
  "3": {
	"name": "黄泉道",
	"type": "困难难度",
	"desc": "适合资深挑战者，资源管理压力大，从绝境中撕开一线生机。"
  }
}
@export var preSelectDiff=-1
#@export var preSelectDiffSrc=null
func selectDiff(diff):
	if diff ==GameManager.sav.gameDifficulty:
		DialogueManager.show_example_dialogue_balloon(sys,"你当前已经是这个难度了，无需修改")
		return
	if GameManager.sav.have_event["initTaskPolicy"]==true and diff>GameManager.sav.gameDifficulty:
		DialogueManager.show_example_dialogue_balloon(sys,"不可序章外提升难度")
		return
			
	preSelectDiff=diff
	resideValue=get_difficulty_data(preSelectDiff)
	DialogueManager.show_example_dialogue_balloon(sys,"修改难度提示")

func get_difficulty_data(level: int):
	# 把数字转成字符串 key（因为你数据里是 "1","2","3"）
	var key = str(level)
	
	# 判断是否存在这个难度
	if diffSrc.has(key):
		# 直接取出三个变量
		return diffSrc[key]
		#var type = diffSrc[key].type
		#var desc = diffSrc[key].desc
		#
		## 打印测试（你可以删掉，换成自己逻辑）
		#print("难度名称：", name)
		#print("难度类型：", type)
		#print("难度描述：", desc)
		
		# 你可以在这里赋值给全局变量
		# global.difficulty_name = name
		# global.difficulty_type = type
		# global.difficulty_desc = desc
	else:
		print("不存在该难度")
		return


var LAW_COST_POINT=3
func LoadingDiffucultValue():
	
	if GameManager.sav.gameDifficulty==1:
		perLawCycle=6
		minxinPoint=1
		LAW_COST_POINT=2
		maxLawNum=15
		#2点法令点立一个法
	elif GameManager.sav.gameDifficulty==2:
		perLawCycle=5
		minxinPoint=1
		LAW_COST_POINT=3
		maxLawNum=12
		#3点法令点立一个法
	elif GameManager.sav.gameDifficulty==3:
		perLawCycle=4
		minxinPoint=2
		LAW_COST_POINT=4
		maxLawNum=12
		#4点法令点立一个法
		#战斗难度
		#一些惩罚增加
	if GameManager.sav.minxinReduceCost==true:
		minxinPoint=minxinPoint-1
		
	if GameManager.preSelectDiff==-1:		
		return
	var between=GameManager.sav.gameDifficulty-GameManager.preSelectDiff
	GameManager.sav.gameDifficulty=GameManager.preSelectDiff


	
	if sav.day>=10 and between>0:
		apply_difficulty_compensation(between)
	else:
		DialogueManager.show_example_dialogue_balloon(sys,"难度变更成功")
	GameManager.preSelectDiff=-1

const COMP_BASE_RATE = 300
const COMP_MAX_TOTAL = 3000
const COMP_COIN_RATIO = 0.5
const COMP_LABOR_RATIO = 0.3	

func apply_difficulty_compensation(diff_levels: int):
	var progress_factor = 0.5
	var day = sav.day
	if sav.endPath != endPath.none:
		progress_factor = 5.0
	elif day > 55:
		progress_factor = 5.0
	elif day > 35:
		progress_factor = 3.0
	elif day > 25:
		progress_factor = 2.0
	elif day > 15:
		progress_factor = 1.0

	var total_comp = floori(progress_factor * diff_levels * COMP_BASE_RATE)
	total_comp = min(total_comp, COMP_MAX_TOTAL)

	var coin_bonus = floori(total_comp * COMP_COIN_RATIO)
	var labor_bonus = floori(total_comp * COMP_LABOR_RATIO)
	var score_for_items = total_comp - coin_bonus - labor_bonus

	sav.coin += coin_bonus
	sav.labor_force += labor_bonus

	if score_for_items > 0:
		var item_result = ScoreToItem(score_for_items)
		for item_enum in item_result["items"]:
			var item_uuid = InventoryManagerItem.item_by_enum(item_enum)
			if item_uuid:
				InventoryManager.add_item(inventoryPackege, item_uuid, item_result["items"][item_enum])
		sav.coin += item_result["money"]
		sav.labor_force += item_result["population"]

	# 6. 调节民心与派系支持度（按进度小幅提升，不翻倍）
	var people_boost = 0
	var faction_boost = 0
	if progress_factor >= 5.0:
		people_boost = 18* diff_levels
		faction_boost = 14* diff_levels
	elif progress_factor >= 3.0:
		people_boost = 15* diff_levels
		faction_boost = 12* diff_levels
	elif progress_factor >= 2.0:
		people_boost = 12* diff_levels
		faction_boost = 10* diff_levels
	else:
		people_boost = 10* diff_levels
		faction_boost = 8* diff_levels


	changePeopleSupport(people_boost)
	sav.BENTUPAI.ChangeSupport(faction_boost)
	sav.WAIDIPAI.ChangeSupport(faction_boost)
	sav.HAOZUPAI.ChangeSupport(faction_boost)
	resideValue=tr("已下调游戏难度，现为你发放补偿：获得钱{x}、民力{y}、道具若干，民心+{m}、各派系支持度+{f}").format({"x": coin_bonus, "y": labor_bonus, "m": people_boost, "f": faction_boost})
	# 7. 显示补偿提示
	DialogueManager.show_example_dialogue_balloon(sys,"难度补偿")


func get_base_score() -> int:
	return 1500


func get_coin_score() -> int:
	return int(sav.coin / 10)


func get_labor_score() -> int:
	return int(sav.labor_force * 3 / 10)


func get_people_score() -> int:
	return int(sav.people_surrport * 10)


func get_item_score() -> int:
	var score = 0
	score += InventoryManager.inventory_item_quantity(inventoryPackege, InventoryManagerItem.益气丸) * 22
	score += InventoryManager.inventory_item_quantity(inventoryPackege, InventoryManagerItem.胜战锦囊) * 16
	score += InventoryManager.inventory_item_quantity(inventoryPackege, InventoryManagerItem.诸子百家论集) * 10
	score += InventoryManager.inventory_item_quantity(inventoryPackege, InventoryManagerItem.珍品礼盒) * 18
	return score


func get_exploration_score() -> int:
	return get_exploration_percent() * 20


func get_law_point_score() -> int:
	return int(sav.Merit_points * 80)


func get_day_penalty() -> int:
	var day = sav.day
	var penalty = 0
	if day <= 65:
		return 0
	penalty += min(day - 65, 5) * 200
	if day <= 70:
		return penalty
	penalty += min(day - 70, 5) * 420
	if day <= 75:
		return penalty
	penalty += min(day - 75, 15) * 800
	if day <= 90:
		return penalty
	penalty += (day - 90) * 1000
	return penalty


func get_raw_total_score() -> int:
	return get_base_score() + get_coin_score() + get_labor_score() + get_people_score() + get_item_score() + get_exploration_score() + get_law_point_score() - get_day_penalty()


func get_total_score() -> int:
	var raw_total = get_raw_total_score()
	if get_day_penalty() > 0 and raw_total < 3500:
		return clamp(raw_total, 2000, 3499)
	return raw_total


func get_score_rank() -> String:
	var total_score = get_total_score()
	if total_score >= 15800:
		return "S+"
	elif total_score >= 11700:
		return "S"
	elif total_score >= 9600:
		return "A"
	elif total_score >= 7600:
		return "A-"
	elif total_score >= 6500:
		return "B"
	return "B-"



		
func get_exploration_percent() -> int:

	var pts = 30
	var he = sav.have_event

	var faction_quests = [
		"陈登支线1", "陈登支线2", "陈登支线3", "最终陈登",
		"糜竺支线1", "糜竺支线2", "糜竺支线3", "最终糜竺",
		"曹豹支线1", "曹豹支线2", "曹豹支线3", 
		"大儒支线2", "大儒支线3", "大儒辩经完成",
	]
#7
	for q in faction_quests:
		if he.get(q, false): pts += 1

	
	var mystery = ["竹简幻觉剧情", "支线触发完毕获得骨杖", "诡物手册", "支线终府邸线索获取完成"]
	for q in mystery:
		if he.get(q, false): pts += 3
	
	
	
#3
	
	if GameManager._setting.is_clear_normal_line==true:
	
		pts+=12
	else:	
	
		var lvbu = ["辕门射戟","吕布之怒","最终丹阳"]
		for q in lvbu:
			if he.get(q, false): pts += 4
	# -- 特殊道具 (max 9) --
	

	#40+38+25=
	if GameManager._setting.is_clear_overlord_line==true:
		pts+=32
	else:
		if GameManager.sav.endPath==endPath.xuzhou:
			pts+=10
		var items = ["获得锦囊","获得古棒","获得血袖","获得娃娃","获得亮银","获得玄阴"]
		for q in items:
			if he.get(q, false): pts += 2
	# -- 杂项 (max 12+3) --
		if not dontHaveDominance(): pts += 10

	return min(pts, 100)

func clearLevel(index):
	if index==1:
		if GameManager._setting.is_clear_normal_line == false:
			GameManager._setting.is_clear_normal_line=true
			ResourceSaver.save(GameManager._setting,"user://ysg_data_setting.tres")	
	elif index==2:
		if GameManager._setting.is_clear_overlord_line == false:		
			GameManager._setting.is_clear_overlord_line=true
			ResourceSaver.save(GameManager._setting,"user://ysg_data_setting.tres")	
	#SignalManager.changeLanguage.emit()
	

func enterCredit(index):
	GameManager.sav.day=0
	if (GameManager._setting.is_clear_normal_line==false and index==1) or (GameManager._setting.is_clear_overlord_line==false and index==2):
		DialogueManager.show_example_dialogue_balloon(sys,"credit未解锁")
		return
	if index==1:
		GameManager.sav.endPath=GameManager.endPath.xiaopei
		SceneManager.changeScene(SceneManager.roomNode.Credit,2)
	elif index==2:
		GameManager.sav.endPath=GameManager.endPath.xuzhou
		SceneManager.changeScene(SceneManager.roomNode.Credit,2)


func set_enable_rest_remind(_p):
	GameManager._setting.enable_rest_remind=_p
	ResourceSaver.save(GameManager._setting,"user://ysg_data_setting.tres")

func set_always_show_military_input(_input):
	GameManager._setting.showMilitartInput=_input
	ResourceSaver.save(GameManager._setting,"user://ysg_data_setting.tres")


func compeleteTaskAndChangeDestination(des):
	GameManager.sav.targetResType = GameManager.ResType.complete
	GameManager.sav.targetValue = 1
	GameManager.sav.TargetDestination = des
	GameManager.sav.currenceValue = 0


func returnBloodRes():
	GameManager.sav.coin+=GameManager.sav.bloodCoin
	GameManager.sav.labor_force+=GameManager.sav.bloodLabor
	GameManager.sav.bloodCoin=0
	GameManager.sav.bloodLabor=0

func showChapterTitle(chapter: String, title_text: String, duration: float = 2.6) -> ChapterTitlePanel:
	return PanelManager.show_chapter_title({
		"chapter": chapter,
		"title": title_text,
		"duration": duration
	})
