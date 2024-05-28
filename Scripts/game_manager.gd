extends Node

#GameManager
var day

var intellectual_support #士族支持度 一开始为100 当议会中 会出现支持和不支持以及摇摆 

#以下三个值均为三股不同力量士族可以篡改的值 其中士族可以把控群众支持度，商贾可以把控金钱，丹阳派系的军官可以把控劳动力
var people_surrport #群众支持度 数值
var  coin #金钱 数值
var labor_force #劳动力 可以当作军队进行使用 劳动力转换成军队需要消耗值 骑兵 步兵 弓兵

var Merit_points:int
var currenceScene
var have_event = {
	"firsthouse": false,
	"firststreet": false,
	"firstgovernment":false,
	"firstgovermentTip":false,	
	"firstPolicyOpShow":false,
	"firstPolicyCorrect":false,
	"firstTabLaw":false,#为false不显示tab面板 只触发一次对话
	"firstLawExecute":false,#为false 不显示close选项 只触发一次对话
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
	pass


func extractByGroup(index):
	return policy_Item.filter(func(item): item.group== index)

func extractById(id):
	return policy_Item.filter(func(item): item.group== id)[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
