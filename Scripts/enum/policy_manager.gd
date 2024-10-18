extends Node
class_name  policymanager


var policy_Item=[
	{
		"id":policyID.P_LIMIT_SUPPLIES,
		"index":1,
		"name":"上策-限制军需物资法",
		"detail":"所有军队领袖，严禁擅自动用粮草物资，必须经士族批准后方可动用。一切军需，须经过严格审批备案，不得私自行动。", #前往花园并通向小道
		"group":0
	},
	{
		"id":policyID.P_SUPPLIES_CHECK,
		"index":2,
		"name":"中策-军需审批规定",
		"detail":"军队领袖应向相关报备所需物资，并等待审批后方可调用。一切军需申请，必须经过严格审批程序，禁止私自调度。", #前往花园并通向小道
		"group":0
	},
	{
		"id":policyID.P_SUPPLIES_COMMIT,
		"index":3,
		"name":"下策-物资调度违规处罚法",
		"detail":"凡有违反调度规定者，不分情节轻重，一律拉出军营，以极刑示众。对于私自调用粮草者，立即斩首示众，家属一并流放，绝不宽贷。", #前往花园并通向小道
		"group":0
	},	
	
	
	
	#主线第一个计策
	{
		"id":policyID.P_COMMERCIAL_INPLACE_AID,
		"index":1,
		"name":"上策-以商代赈",
		"detail":"将给与商人更多指示性目标,用行政命令迫使商业协助完成粮食问题，军队好感上升，获得一笔钱", #每天获取钱下降，任务凑钱正常
		"group":1
	},
	{
		"id":policyID.P_SUPPLIES_SELF_SUFFIENCY,
		"index":2,
		"name":"中策-军粮自给",
		"detail":"维持现状，继续让军队自行解决粮食问题，丹阳派好感小幅度下跌，获得资金200", #前往花园并通向小道，ps_任务凑齐的钱会少
		"group":1
	},
	{
		"id":policyID.P_RAISE_TAX,
		"index":3,
		"name":"下策-增大消费税",
		"detail":"增大城市人口商业来往的纳税，会增加城市居民生活开销负担，但会让城市获得日均收入上升，徐州派好感小幅度下跌，军队好感上升 ", #前往花园并通向小道#，每天获取钱上升，任务凑钱多
		"group":1
	},	
]
enum policyID{
	P_LIMIT_SUPPLIES=1,
	P_SUPPLIES_CHECK=2,
	P_SUPPLIES_COMMIT=3,
	P_COMMERCIAL_INPLACE_AID,
	P_SUPPLIES_SELF_SUFFIENCY,
	P_RAISE_TAX,

	
	
	
}

func extractByGroup(index):
	return policy_Item.filter(func(item): item.group== index)


# 函数可能有问题，目前好像暂时没有使用，试用前注意修改其中问题
func extractPolicyItem(index,group):
	#return policy_Item.filter(func(item): item.group== id)[0]
	var ele=GameManager.policy_Item.filter(func(ele): return ele.group == group and ele.index==index)[0]
	return ele

