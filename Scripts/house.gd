extends baseComponent

@onready var control = $Control
@onready var policyPanel = $"CanvasLayer/政务面板"
@onready var hp_panel = $CanvasLayer/hpPanel
const NOT_JAM_UI_CONDENSED_16 = preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")
const FancyFade = preload("res://addons/transitions/FancyFade.gd")
# Called when the node enters the scene tree for the first time.
func _ready():

	Transitions.post_transition.connect(post_transition)
	control.buttonClick.connect(_buttonListClick)
	if GameManager.sav.day==1||GameManager.sav.day==0:
		if GameManager.sav.have_event["firstmeetchenqun"]==false:
			control.hide()
		else:
			control.show()
			hp_panel.show()
	else:
		control.show()
	super._ready()
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="ja":
		title.add_theme_font_size_override("normal_font_size",200)  
		demo_end.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		title.text="[center][rainbow]陰[/rainbow][wave amp=50 frep=100]三国[/wave][rainbow]謀論[/rainbow]: [tornado]徐州編[/tornado][/center]"
	elif currencelanguage=="ru":
		title.add_theme_font_size_override("normal_font_size",80)  
		demo_end.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		title.text="[center][tornado]Тёмные [/tornado][wave amp=50 frep=100]интриги [/wave][rainbow]Троецарствия[/rainbow][/center]"
	elif currencelanguage=="lzh":
		title.text="[center][rainbow]陰[/rainbow][wave amp=50 frep=100]三國[/wave][rainbow]謀論[/rainbow]-[tornado]徐州篇[/tornado][/center]"
		demo_end.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
	elif currencelanguage=="en":
		title.add_theme_font_size_override("normal_font_size",80)
		demo_end.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		title.text="[center]The [rainbow]Three Kingdoms[/rainbow] of [wave amp=50 frep=100]Shadows[/wave]:[tornado]Xuzhou[/tornado][/center]"
	#目前没有调用新一天开始重置选项，放在了休息
	#每次睡眠起床都调用这个选项
	
	


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
#const 街道 = preload("res://Asset/bgm/街道.mp3")
	control._processList(initData)
	GameManager.currenceScene=self
	if GameManager.sav.day==1:
		if(GameManager.sav.have_event["firstmeetchenqun"]==false):
			GameManager.sav.have_event["firstmeetchenqun"]=true
			policyPanel.contextEX=tr("1.前往府邸看看堆积的工作\n2.前往演武场会见自己的老下属")
	
		
		
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
	if GameManager.sav.day==2:
		if GameManager.sav.have_event["dayTwoInit"]==false:
			GameManager.sav.have_event["dayTwoInit"]=true
			control._show_button_5_yellow(1)
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"新的一天")
			policyPanel.contextEX=tr("1.前往府邸回见不同派系的领导人\n2.前往议会通过昨天立的法律")
			GameManager.sav.destination="府邸"
		#设置des
	elif GameManager.sav.day==3:
		if GameManager.sav.have_event["dayThreeInit"]==false:
			control._show_button_5_yellow(1)
			GameManager.sav.have_event["dayThreeInit"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第三天")
			policyPanel.contextEX=tr("1.前往城外军事驻地，讨伐土匪")
			GameManager.sav.destination="城门-军事驻地"
		#军事行动 镇压土匪
		#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"新的一天")
		#policyPanel.contextEX="1.前往府邸回见不同派系的领导人\n2.前往议会通过昨天立的法律"

	elif GameManager.sav.day==4:
		#条件没写，只会触发一次
		if GameManager.sav.have_event["firstVisitScholars"]==false:
			GameManager.sav.have_event["firstVisitScholars"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第四天")
			control._show_button_5_yellow(1)			
			policyPanel.contextEX=tr("1.前往城外及军事驻地，选择拜见大儒郑玄")
		
		if GameManager.sav.have_event["firstVisitScholarsEnd"]==true:	
			if GameManager.sav.have_event["firstNewEnd"]==false:
				GameManager.sav.have_event["firstNewEnd"]=true
				GameManager.restFadeScene=SceneManager.BOULEUTERION
				GameManager.restLabel=tr("与此同时")
				GameManager._rest(false)
				#跳转到议会厅触发剧情 先跳转到rest，然后跳转议会厅触发剧情
				#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第四天")
		#并且结束时 触发终极对话，弹出一个类似那样的框 并写着如此同时 xxxxx
		#大儒辩经文 今天结束时，展示最终对话
	elif GameManager.sav.day==5:
		if GameManager.sav.have_event["DemoFinish"]==false:
			GameManager.sav.have_event["DemoFinish"]=true
			control.hide()
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"新手关结束")	
		
		#将政务面板更新 里面列举了一堆list
	#如果没见过陈登把control隐藏，如果见过了陈登 control不隐藏
const daybgm = preload("res://Asset/bgm/白天在家or办公.wav")	
const nightbgm = preload("res://Asset/bgm/夜晚在家.wav")
func post_transition():
	print("fadedone")
	if GameManager.hp<=20:
		SoundManager.play_music(nightbgm)
	else:
		SoundManager.play_music(daybgm)
	_initData()


func _buttonListClick(item):

	if item.context == "外出":
		const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
		FancyFade.new().custom_fade(SceneManager.STREET.instantiate(), 2, DISSOLVE_IMAGE)
		pass
	elif item.context == "今日政务":
		control._show_button_5_yellow(-1)
		policyPanel.show()
		pass
	elif item.context == "属性面板":
		#显示金钱 民心 xx 武将面板
		pass
	elif item.context == "休息":
	 	#如果休息时=4天，则触发阴谋论剧情
		if(GameManager.sav.day==1):
			if GameManager.sav.have_event["threeStree"]==false:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"还不能休息_新手教程")	
				return
		elif GameManager.sav.day==2:
			if GameManager.sav.have_event["firstParliamentary"]==false:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"还不能休息_新手教程")	
				return

		elif GameManager.sav.day==3:
			if GameManager.sav.have_event["firstBattleEnd"]==false:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"还不能休息_新手教程")	
				return		
		elif GameManager.sav.day==5:
			if GameManager.sav.have_event["xxxx"]==false:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"xxxx")	
				return		
		control._show_button_5_yellow(-1)
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

func demoFinishChenQunShow():
	$"陈群".show()
	$"文官".hide()
	
	pass

func demoFinishWenGuanShow():

	$"陈群".hide()
	$"文官".show()
	pass
@onready var title = $title
@onready var demo_end = $CanvasLayer/DemoEnd

func demoFinish():
	$"陈群".hide()
	$"文官".hide()
	title.show()
	demo_end.show()

func fadeInAndOut():
	PanelManager.Fade_Blank(Color.BLACK,1,PanelManager.fadeType.fadeInAndOut)


func _on_demo_end_button_down():
	get_tree().quit()
	pass # Replace with function body.

