extends Resource
class_name saveData
@export var saveScene:PackedScene=PackedScene.new()

#GameManager
@export var day=0
@export var intellectual_support=100 #士族支持度 一开始为100 当议会中 会出现支持和不支持以及摇摆 
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

@export var haveGuild=true
@export var jumpmain=false
@export var targetTxt=""
@export var targetValue=0
@export var targetResType:GameManager.ResType

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
	"initTask1":false

}
