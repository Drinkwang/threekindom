extends baseComponent

@onready var control = $Control
@onready var policyPanel = $"CanvasLayer/政务面板"

const FancyFade = preload("res://addons/transitions/FancyFade.gd")
# Called when the node enters the scene tree for the first time.
func _ready():

	Transitions.post_transition.connect(post_transition)
	control.buttonClick.connect(_buttonListClick)
	if GameManager.have_event["firstmeetchenqun"]==false:
		control.hide()
	else:
		control.show()
	super._ready()
	#目前没有调用新一天开始重置选项，放在了休息
	#每次睡眠起床都调用这个选项
	
	if GameManager.day==2:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"新的一天")
		policyPanel.contextEX="1.前往府邸回见不同派系的领导人\n2.前往议会通过昨天立的法律"
	elif GameManager.day==3:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第三天")
		policyPanel.contextEX="1.前往城外军事驻地，讨伐土匪"
		
		pass
		#军事行动 镇压土匪
		#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"新的一天")
		#policyPanel.contextEX="1.前往府邸回见不同派系的领导人\n2.前往议会通过昨天立的法律"

	elif GameManager.day==4:
		#条件没写，只会触发一次
		if GameManager.have_event["firstVisitScholars"]==false:
			GameManager.have_event["firstVisitScholars"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第四天")
			policyPanel.contextEX="1.前往城外及军事驻地，选择拜见大儒郑玄"
		
		if GameManager.have_event["firstVisitScholarsEnd"]==true:	
			if GameManager.have_event["firstNewEnd"]==false:
				GameManager.have_event["firstNewEnd"]=true
				GameManager.restFadeScene=SceneManager.BOULEUTERION
				GameManager.restLabel="与此同时"
				GameManager._rest()
				#跳转到议会厅触发剧情 先跳转到rest，然后跳转议会厅触发剧情
				#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第四天")
		#并且结束时 触发终极对话，弹出一个类似那样的框 并写着如此同时 xxxxx
		#大儒辩经文 今天结束时，展示最终对话
	elif GameManager.day==5:
		if GameManager.have_event["DemoFinish"]==false:
			GameManager.have_event["DemoFinish"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"新手关结束")	
		
		#将政务面板更新 里面列举了一堆list
	#如果没见过陈登把control隐藏，如果见过了陈登 control不隐藏


func demoFinish():
	pass
func _initData():
	var initData=[
	{
		"id":"1",
		"context":"(议事厅)", #前往小道通向议事z
		"visible":"false"
	},
	{
		"id":"2",
		"context":"(府邸)", #前往花园并通向小道
		"visible":"false"
	},
	{
		"id":"3",
		"context":"外出",#前往大街
		"visible":"true"
	},
	{
		"id":"4",
		"context":"今日政务",#打开人物面板
		"visible":"true"
	},
	{
		"id":"5",
		"context":"属性面板",#打开属性ui
		"visible":"true"
	},
	{
		"id":"6",
		"context":"休息", #天数加1 进入过度
		"visible":"true"
	}
	]
	control._processList(initData)
	GameManager.currenceScene=self
	
	if(GameManager.have_event["firstmeetchenqun"]==false):
		GameManager.have_event["firstmeetchenqun"]=true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
	

func post_transition():
	print("fadedone")
	_initData()


func _buttonListClick(item):

	if item.context == "外出":
		const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
		FancyFade.new().custom_fade(SceneManager.STREET.instantiate(), 2, DISSOLVE_IMAGE)
		pass
	elif item.context == "今日政务":
		#显示接下来要点击啥
		pass
	elif item.context == "属性面板":
		#显示金钱 民心 xx 武将面板
		pass
	elif item.context == "休息":
	 	#如果休息时=4天，则触发阴谋论剧情
		
		GameManager._rest()

		#FancyFade.new().custom_fade(load("res://Scene/sleepBlank.tscn").instantiate(), 2, DISSOLVE_IMAGE)
	print(item)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func showFirstGuild():
	control.show()
	control._show_button_5_yellow(0)
	$"陈群".hide()

	pass
	
func showchenqun():
	$"陈群".show()
	pass
