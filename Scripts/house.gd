extends baseComponent
@onready var res_panel = $CanvasLayer/resPanel

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
	
	
@onready var bti_rect = $btiRect
@onready var bit_player = $bitPlayer


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
	
	var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.迷魂木筒)

	if num>=1 and GameManager.sav_have_event["竹简幻觉剧情"]==false:
		bti_rect.show()
		GameManager.sav_have_event["竹简幻觉剧情"]=true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"克苏鲁梦境")
		#竹筒剧情完了，再次调用这边
		#竹筒幻觉剧情 播放音效，改变背景，然后吓醒了 我觉得这个剧情可以放在早上，如果早上没有主线，则触发这个剧情，然后得知是一场噩梦
		return 
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
		
		if GameManager.sav.have_event["firstVisitScholarsEnd"]==true and GameManager.sav.day<=5:	
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
	
	#判断以下，是首日获取 还是第二次获取
	if GameManager.sav.day>=6:
		if(GameManager.sav.isGetCoin==false):
			GameManager.sav.isGetCoin=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"今日收入为")
	#if()
	
	
		#将政务面板更新 里面列举了一堆list
	#如果没见过陈登把control隐藏，如果见过了陈登 control不隐藏
const daybgm = preload("res://Asset/bgm/白天在家or办公.wav")	
const nightbgm = preload("res://Asset/bgm/夜晚在家.wav")
func post_transition():
	print("fadedone")
	if GameManager.sav.hp<=20:
		SoundManager.play_music(nightbgm)
	else:
		SoundManager.play_music(daybgm)
	_initData()

func PlayBitPlayer():
	bti_rect.hide()
	bit_player.show()
	bit_player.finished.connect(_on_video_player_finished)
	bit_player.play()

func _on_video_player_finished():
	bit_player.hide()
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"克苏鲁梦境结束")


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
		GameManager.sav.isGetCoin=false
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
			pass
			#if GameManager.sav.have_event["xxxx"]==false:
			#	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"xxxx")	
			#	return	
		control._show_button_5_yellow(-1)

			
		GameManager._rest()	 
		#判断有无道具 有道具且等于false	
				


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
	#跳转徐州
	pass

func demoFinishWenGuanShow():

	$"陈群".hide()
	$"文官".show()
	pass
@onready var title = $title2
@onready var demo_end = $CanvasLayer/DemoEnd

func demoFinish():
	$"陈群".hide()
	$"文官".hide()
	#title.show()
	#demo_end.show()
	
	#if day==5:
	#demo 完结 正式版内容
	const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
		
	FancyFade.new().custom_fade(SceneManager.GOVERNMENT_BUILDING.instantiate(), 2, DISSOLVE_IMAGE)


func fadeInAndOut():
	PanelManager.Fade_Blank(Color.BLACK,1,PanelManager.fadeType.fadeInAndOut)


func _on_demo_end_button_down():
	get_tree().quit()
	pass # Replace with function body.



func _DayGet():
	res_panel.showValue=false
	res_panel.GetValue(GameManager.sav.coin_DayGet,0,GameManager.sav.labor_DayGet)
	SoundManager.play_sound(sounds.buysellsound)
	await 0.8
	res_panel.showValue=false
	GameManager._DayGet()
	
	extraTask()
	if(GameManager.sav.targetTxt!=null and GameManager.sav.targetTxt.length()>0):	
		_JudgeTask()
	# 好的我了解了，还有别的事么？
	# 对，还有一键
	# 很好，继续努力。如果任务没有完成 提示三选一


func extraTask():
	if GameManager.sav.day>5 and GameManager.sav.day<8:
		if GameManager.sav.have_event["支线发现羊尸"]==false:
			GameManager.sav.have_event["支线发现羊尸"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"支线开始")	
		#将任务可检索设置成true
		#如果任务为false  设置成true 并触发对话
		elif GameManager.sav.have_event["支线触发完毕查出锦囊"]==true and GameManager.sav.have_event["支线触发完毕查出锦囊休息"]==false:
			GameManager.sav.have_event["支线触发完毕查出锦囊休息"]=true
		elif GameManager.sav.have_event["查出药囊后休息前"]==false:
			var to_inventory= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.黄麻药囊)
			var quantity=InventoryManager.has_item_quantity(to_inventory)
			if quantity>0:
				GameManager.sav.have_event["查出药囊后休息前"]=true
				#下一步去演武场，判断这个==true，将曹豹显示并修改任务
	else:
		pass
		#将任务设置成false
		


func _JudgeTask():
	var value=0
	if GameManager.sav.targetResType==GameManager.ResType.coin:
		value=GameManager.sav.coin
	elif GameManager.sav.targetResType==GameManager.ResType.people:
		pass
		#value	
	elif GameManager.sav.targetResType==GameManager.ResType.rest:
		value=GameManager.sav.currenceValue
		if GameManager.sav.have_event["chaosBegin"]==true:
			if GameManager.sav.have_event["chaosEnd"]==false:
				if value>=GameManager.sav.targetValue:
					GameManager.sav.have_event["chaosEnd"]=true
					#完成城中之乱-泰山
					hp_panel.playLabelChange()
					GameManager.sav.TargetDestination="府邸"
					DialogueManager.show_example_dialogue_balloon(dialogue_resource,"袁术之乱结束")	
				else:
					DialogueManager.show_example_dialogue_balloon(dialogue_resource,"每天袁术内应搞事")	
	if(GameManager.sav.have_event["completeTask1"]==true):
		if(GameManager.sav.have_event["initTask2"]==false):
			GameManager.sav.have_event["initTask2"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"有拦路虎")
			#显示对话
			#任务完成
	
			#if GameManager.sav.have_event["battleYuanshu"]==true:
			#if(GameManager.sav.have_event["completebattleYuanshu"]==false):	
			
	
func secondMissonStart():
	GameManager.sav.targetValue=10
	GameManager.sav.currenceValue=0
	GameManager.sav.targetResType=GameManager.ResType.battle
	GameManager.sav.targetTxt="当前讨伐对象：{currence}/{target}"
	GameManager.sav.TargetDestination="battle"
	#win 10次90
	#GameManager.sav.TargetDestination=="府邸"
	pass
	
const BENTUPAI = preload("res://Asset/tres/bentupai.tres")
const HAOZUPAI = preload("res://Asset/tres/haozupai.tres")
const WAIDIPAI = preload("res://Asset/tres/waidipai.tres")	
#准备改成5天，然后民心下降改成5点
func yuanshuChaos(value):
	if value==1:
		GameManager.sav.changePeopleSupport(-10)
		#民心下降10,改成5
	elif value==2:
		WAIDIPAI.ChangeSupport(-10)
		#丹阳派下降10
	elif value==3:
		BENTUPAI.ChangeSupport(-10)
		#徐州度下降10
	elif value==4:
		WAIDIPAI.ChangeSupport(-10)
		BENTUPAI.ChangeSupport(-10)
		GameManager.sav.changePeopleSupport(-10)
		#全部下降10
@onready var caocao_letter = $CanvasLayer/caocaoLetter
		
func showCaoCaoLetter():
	caocao_letter.show()
	
#完成任务不应该显示 休息进入下一天
func lookDoneCaoCaoLetter():
	#设置目标是前往宅邸
	GameManager.sav.TargetDestination="府邸"
	caocao_letter.hide()
	pass
	
func sheepGnawed():
	pass
	#street 显示xxx
	#GameManager.sav.have_event["支线发现羊尸"]=true
