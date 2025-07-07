extends Resource
class_name saveData
@export var saveScene:PackedScene=PackedScene.new()

#GameManager
@export var day=0
#@export var intellectual_support=100 #士族支持度 一开始为100 当议会中 会出现支持和不支持以及摇摆 
@export var people_surrport=100 #群众支持度 数值
@export var coin=100: #金钱 数值

	get:
		return coin
	set(value):

		coin=value
		
		if GameManager.currenceScene is government_building:
			GameManager.currenceScene.JudFundTask()


@export var coin_DayGet=40
@export var labor_force=100 #劳动力 可以当作军队进行使用 劳动力转换成军队需要消耗值 骑兵 步兵 弓兵
@export var labor_DayGet=10
@export var destination:String #放在gameins里面
#@export var datas:Array[cldata] #好像没用
@export var isLevelUp=false
@export var isMeet=false#是否约见手下
@export var haveLaw=false
@export var current_datetime:String =""#0# Time.get_datetime_dict_from_system()
#print("Current date and time:", current_datetime)
#var formatted_time = OS.format_datetime(current_datetime, "%Y-%m-%d %H:%M:%S")

@export var cLaw:int=-1
#寄存使用过的将军
@export var UseGeneral:Array

@export var battleResults:Array[GameManager.BattleResult]=[]

@export var Merit_points:int=3
@export var battleTasks={}
@export var completeTask:int=0

#若通关 则completeTask	
@export var currenceTask:int=0	
@export var curGovAff:String
@export var TargetDestinationBefore:String
#任务完成下一步目标
@export var TargetDestination:String #放在gameins里面
#如果是战斗，存储的数量
@export var currenceValue:int=0
#目前天数,非主线，支线进展推进变量
@export var currenceDay:int=3
#是否获取金钱
@export var isGetCoin=false
#是否已经辩经
@export var isVisitScholar=false
#资源派系没存
@export var haveGuild=true
@export var jumpmain=false
@export var targetTxt=""
@export var targetValue=10000
@export var targetResType:GameManager.ResType
@export var policy_Item_index=1#政策数量
@export var policyExcute=false
@export var isAlertRisk=false
@export var maxHP=100
@export var isSoldItem=false
@export var _data = InventoryInventories.new()
@export var GrainIndex=0
@export var laws=[[],[],[]]
@export var courtingLaws:Dictionary={}

@export var ctLoseBattle=0
@export var ctLoseBattleRate=0


@export var dailyGetRandomItem=false
#@export var policy
var number_bool_map: Dictionary = {
	1: true,
	2: false,
	3: true
}

var SIDEQUEST_MAP:Dictionary={
	SceneManager.sideQuest.CHENDENG:"",
	SceneManager.sideQuest.CAOBAO:"",
	SceneManager.sideQuest.MIZHU:"",
	SceneManager.sideQuest.DARU:"",
	SceneManager.sideQuest.KESULU:""
}

@export var RewardLaw=""
@export var xuzhouCD=-1
@export var haozuCD=-1
@export var danyangCD=-1
@export var lvbuCD=-1
@export var _num_defections=0
#0-3 给与4档随机数，为忠诚度15-18 相关
@export var randomIndex=0

@export var curLawName=""
#辩经目标
@export var curLawNum1=-1
@export var curLawNum2=-1
@export var useItemInBattle=false
@export var hp=100:
	get:
		return hp
	set(value):
		if value<hp:
			alreadyHP+=(hp-value)
		hp=value
		
		if GameManager._engerge!=null:
			GameManager._engerge.changerate(hp)
@export var alreadyHP=0		
@export var lazydays=0
@export var lazyValue=0
@export var finalKeChoice=-1

@export var autoSave:bool=false
@export var HAOZUPAI:cldata=preload("res://Asset/tres/haozupai.tres").duplicate()
@export var BENTUPAI:cldata=preload("res://Asset/tres/bentupai.tres").duplicate()
@export var WAIDIPAI:cldata=preload("res://Asset/tres/waidipai.tres").duplicate()
@export var LVBU:cldata=preload("res://Asset/tres/lvbu.tres").duplicate()

@export var have_event = {
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
	"Factionalization":false,#出现分化
	#second事件 
	"firstEnterBattle":false,#初次进入演武场 第一天
	"dayThreeEnterBattle":false,#第三天进入演武场
	"dayTwoInit":false,#2024-8-15
	"dayThreeInit":false,
	"secondStreet":false,
	"firstTraining":false,
	"firstWar":false,
	"firstTrain":false,
	"threeStree":false,
	"firstMeetingEnd":false,
	"streetBeginBouleuterion":false, #第一次前往议会，新手教程
	"firstBattle":false,#第一次从大厅前往演武场进行军事行动
	"firstBattleTutorial":false,
	"firstBattleEnd":false,
	"firstVisitScholars":false, #第一次在房间里触发即将拜访大儒的剧情
	"firstVisitScholarsEnd":false,
	"firstNewEnd":false, #新手剧情结束么？No
	"DemoFinish":false,
	"initXuzhou":false,
	"LiuBeiSucceed":false,
	"initTask1":false,
	"initTaskPolicy":false,#正式游戏第一次政策离开府邸对话
	"completeTask1":false,
	"firstMeetCaoCao":false,
	"CaoBaointervene":false,
	"initTask2":false,
	"completeTask2":false,
	"deliverTask2":false,
	"chaosBegin":false,
	"chaoChendengEnd":false,
	"chaoMizhuEnd":false,
	"chaoChenDenPolicyExcute":false,
	"chaosEnd":false,
	"chaoDialogEnd":false,
	"battleTaiShan":false,#攻击泰山诸将
	"firstDisaster":false,#第一次赈灾 征伐袁术后1天进入府邸 触发事件后一天
	"secondDisaster":false,#第二次赈灾 征伐袁术后3天进入府邸 触发第一次赈灾后过了2天
	"thirdDisaster":false,#第三次赈灾 征伐袁术后 5天进入府邸 触发第二次赈灾后过了2天  赈灾支线
	"completebattleTaiShan":false,
	"庆功宴是否举办":false,
	"deliverYuanShu":false,
	"征询曹将军意见":false,
	"泰山诸将曹操消息":false,#未知变量
	"臧霸首战之前":false,#泰山诸将1
	"昌豨求饶":false,#泰山诸将2
	"臧霸首战":false,#泰山诸将3
	"昌豨求饶2":false,#泰山诸将3
	"findLvbu":false,#发现吕布
	"discussLvbu":false,
	"lvbuDiscussInCaoBao":false,#未用
	"lvBuFinalDiscuss":false,#未用
	"lvbuJoin":false,
	"canSummonLvbu":false,
	"糜竺推荐陈登":false,
	"战斗袁术开始":false,
	"战斗袁术任务完成":false,
	"亲征跟糜竺对话":false,
	"亲征跟陈登对话":false,
	"亲征对话结束":false,
	#"一阶段取胜"
	"战斗袁术血战模式":false,
	"血战袁术完成":false,
	"曹操协天子以令诸侯":false,#明天开发完成
	"小沛第一次见商人":false,
	"徐州第一次见商人":false,
	"支线发现羊尸":false,#
	
	#如果有主线则不执行支线，直到下一次加载场景
	"支线触发完毕调查过竹简":false,
	"竹简幻觉剧情":false,#持有羊尸 幻觉剧情 第二天前往府邸
	"支线触发完毕查出锦囊":false,#第二日召见
	"支线触发完毕查出锦囊休息":false,
	"支线触发完毕获得锦囊之前":false,
	"查出药囊后休息前":false, #如果药囊存在 而且休息则置为true
	"锦囊咨询丹阳派": false, #如果上个为true，到演武场，则令曹豹出现，并可以点击触发支线
	#卖粮第几天
	"支线触发完毕获得骨杖":false,#
	"军事行动大败提示":false,
	"军事行动大败":false,
	
	#这个支线将在之前或者之后触发、中期后期剧情触发
	"糜竺支线1":false,
	"糜贞送药":false,
	"糜竺支线2":false,
	"糜竺支线3":false,
	"糜竺正确选择1":false,
	"糜竺正确选择2":false,
	
	#这个支线可以同时触发，新手支线 截至就是 陶谦出事
	"陈登支线1":false,
	"陈登送礼":false,
	"陈登支线2":false,
	"陈登支线3":false,
	"陈登正确选择1":false,
	"陈登正确选择2":false,
	
	#盗墓现象，黄帝古龙，给金钱300 和给金钱500 前期可触发
	"曹豹支线1":false,
	"曹豹支线2":false,
	"曹豹支线3":false,
	"曹豹正确选择1":false,
	"曹豹正确选择2":false,
	"大儒支线1":false,
	"大儒支线2":false,
	"大儒支线3":false,	
	"大儒辩经启动词1":false,
	"大儒辩经启动词2":false,
	"大儒辩经启动词3":false,		
	"大儒辩经完成":false
}

@export var mizhuSideWait=-1
@export var chendenSideWait=-1
@export var caobaoSideWait=-1

func ensure_default_fields():
	var default_data = saveData.new().have_event
	for key in default_data.keys():
		if not have_event.has(key):
			have_event[key] = default_data[key]

func testFunc():
	var questContexts=SIDEQUEST_MAP.values().filter(func(a):a.length()>0)
	var size=questContexts.size()
	#courtingLaws.
	for i in courtingLaws:
		print(i)
		print(courtingLaws[i])
	#size()
# 声明变量
@export var generals:Dictionary = {GameManager.RspEnum.ROCK:{"name": "关羽", "level": 1, "max_level": 10, "randominit": -1,"isBattle":false},

GameManager.RspEnum.SCISSORS:{"name": "张飞", "level": 1, "max_level": 10, "randominit": -1,"isBattle":false},

GameManager.RspEnum.PAPER:{"name": "赵云", "level": 1, "max_level": 10, "randominit": -1,"isBattle":false}
}
