extends Resource
class_name saveData
@export var saveScene:PackedScene=PackedScene.new()

#GameManager
@export var day=0
#@export var intellectual_support=100 #士族支持度 一开始为100 当议会中 会出现支持和不支持以及摇摆 
@export var people_surrport=100 #群众支持度 数值
@export var  coin=100 #金钱 数值
@export var coin_DayGet=20
@export var labor_force=100 #劳动力 可以当作军队进行使用 劳动力转换成军队需要消耗值 骑兵 步兵 弓兵
@export var labor_DayGet=5
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
#任务完成下一步目标
@export var TargetDestination:String #放在gameins里面
#如果是战斗，存储的数量
@export var currenceValue:int=0
#目前天数,非主线，支线进展推进变量
@export var currenceDay:int=3
#是否获取金钱
@export var isGetCoin=false

#资源派系没存
@export var haveGuild=true
@export var jumpmain=false
@export var targetTxt=""
@export var targetValue=10000
@export var targetResType:GameManager.ResType
@export var policy_Item_index=1#政策数量
var _data = InventoryInventories.new()
@export var GrainIndex=0
@export var laws=[[],[],[]]
@export var RewardLaw=""
@export var xuzhouCD=-1
@export var haozuCD=-1
@export var danyangCD=-1
@export var lvbuCD=-1

#0-3 给与4档随机数，为忠诚度15-18 相关
@export var randomIndex=0

@export var curLawName=""

@export var curLawNum1=-1
@export var curLawNum2=-1


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
	"Factionalization":false,
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
	"徐州第一次见商人":false
}
