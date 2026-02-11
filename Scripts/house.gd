extends baseComponent
@onready var res_panel = $CanvasLayer/resPanel

@onready var control = $CanvasLayer/Control
@onready var policyPanel = $"CanvasLayer/政务面板"

@onready var propertyPanel = $"CanvasLayer/属性面板"

@onready var hp_panel = $CanvasLayer/hpPanel
const NOT_JAM_UI_CONDENSED_16 = preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")
const FancyFade = preload("res://addons/transitions/FancyFade.gd")

@onready var support_panel = $CanvasLayer/supportPanel


const xiaopeiBuild = preload("res://Asset/城镇建筑/小沛自宅.png")
const newBuild = preload("res://Asset/城镇建筑/徐州自宅.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	preload("res://Asset/tres/bentupai.tres")#没用但必须有，让资源提前单例加载
	
	
	Transitions.post_transition.connect(post_transition)
	control.buttonClick.connect(_buttonListClick)
	if GameManager.sav.day==1||GameManager.sav.day==0:
		if GameManager.sav.have_event["firstmeetchenqun"]==false:
			GameManager.changeTaskLabel(tr(""))
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
	
	if GameManager.sav.have_event["chaoMizhuEnd"]==true and GameManager.sav.isGetCoin==false and GameManager.sav.currenceValue>1:

		
		demo_end_v.show()
		demo_end_v.play()		
		

@onready var bti_rect = $btiRect
@onready var bit_player = $bitPlayer

@onready var guanyu: Node2D = $guanyu

func xiaopeiStart():
	GameManager.sav.targetValue=14
	GameManager.sav.currenceValue=0
	GameManager.sav.targetResType=GameManager.ResType.rest
	GameManager.sav.targetTxt="撑过天数：{currence}/{target}"
	GameManager.sav.TargetDestination="rest"
	#暂时先这样写
	
@onready var demo_end_v: VideoStreamPlayer = $demoEnd
	
	
func _initData():
	
	GameManager.play_BGM()

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
	
	#记得demo注销
	if GameManager.sav.have_event["chaoMizhuEnd"]==true and GameManager.sav.isGetCoin==false and GameManager.sav.currenceValue>1:
		title.show()
		demo_end.show()
		hp_panel.hide()
		res_panel.hide()
		support_panel.hide()
		SoundManager.stop_all_ambient_sounds()
		SoundManager.stop_music()
		
		#demo_end_v.show()
		#demo_end_v.play()		
		
		return
		pass
	if control.visible==true:	
		items_in_scene.showItems()	
	else:
		items_in_scene.hideItems()	


	GameManager.currenceScene=self

	if GameManager.sav.day>=6:
		if(GameManager.sav.isGetCoin==false):
			#放幻觉 并return
			
			var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.迷魂木筒)

			if num>=1 and GameManager.sav.have_event["竹简幻觉剧情"]==false:
				bti_rect.show()
				GameManager.sav.have_event["竹简幻觉剧情"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"克苏鲁梦境")
				SoundManager.stop_music()

				hp_panel.hide()
				res_panel.hide()
				support_panel.hide()
	
				
				GameManager.musicId=0
				SoundManager.stop_all_ambient_sounds()
				SoundManager.play_ambient_sound(nightbgm)
				#SoundManager.play_sound()#暂时不播放音效，待测试
	
		#竹筒剧情完了，再次调用这边
		#竹筒幻觉剧情 播放音效，改变背景，然后吓醒了 我觉得这个剧情可以放在早上，如果早上没有主线，则触发这个剧情，然后得知是一场噩梦
				return 
			elif GameManager.sav.have_event["关羽求援期间"]==true and GameManager.sav.have_event["关羽求援结束"]==false:
				GameManager.sav.have_event["关羽求援结束"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"关羽回来")
				return
			GameManager.sav.isGetCoin=true
			GameManager.resideValue=tr("大人今日收入为{_coin}，招募的士兵为{_labor}").format({"_coin":GameManager.sav.coin_DayGet,"_labor":GameManager.sav.labor_DayGet})
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"今日收入为")
	control._processList(initData)
	
	
	if GameManager.sav.day==1:
		if(GameManager.sav.have_event["firstmeetchenqun"]==false):
			GameManager.sav.have_event["firstmeetchenqun"]=true
			GameManager.sav.curGovAff=tr("1.前往府邸看看堆积的工作\n2.前往演武场会见自己的老下属")
			#GameManager.changeTaskLabel(tr("完成今日政务所有事项"))
		
		
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
	if GameManager.sav.day==2:
		if GameManager.sav.have_event["dayTwoInit"]==false:
			GameManager.sav.have_event["dayTwoInit"]=true
			control._show_button_5_yellow(1)  #将这些逻辑放在
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"新的一天")
			
			GameManager.sav.curGovAff=tr("1.前往府邸回见不同派系的领导人\n2.前往议会通过昨天立的法律")
			GameManager.changeTaskLabel(tr("完成今日政务所有事项"))
			GameManager.sav.destination="府邸"
		#设置des
	elif GameManager.sav.day==3:
		if GameManager.sav.have_event["dayThreeInit"]==false:
			control._show_button_5_yellow(1)
			GameManager.sav.have_event["dayThreeInit"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第三天")
			GameManager.sav.curGovAff=tr("1.前往城外军事驻地，讨伐土匪")
			GameManager.changeTaskLabel(tr("完成今日政务所有事项"))
			GameManager.sav.destination="城门-军事驻地"

	elif GameManager.sav.day==4:
		#条件没写，只会触发一次
		if GameManager.sav.have_event["firstVisitScholars"]==false:
			GameManager.sav.have_event["firstVisitScholars"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第四天")
			control._show_button_5_yellow(1)			
			GameManager.sav.curGovAff=tr("1.前往城外及军事驻地，选择拜见大儒郑玄")
			#GameManager.changeTaskLabel("前往城外及军事驻地，选择拜见大儒郑玄")
		if GameManager.sav.have_event["firstVisitScholarsEnd"]==true and GameManager.sav.day<=5:	
			if GameManager.sav.have_event["firstNewEnd"]==false:
				GameManager.sav.have_event["firstNewEnd"]=true
				GameManager.restFadeScene=SceneManager.BOULEUTERION
				GameManager.sav.curGovAff=""
				SoundManager.stop_music()
				GameManager.restLabel=tr("与此同时")
				GameManager._rest(false)
				#跳转到议会厅触发剧情 先跳转到rest，然后跳转议会厅触发剧情
				#DialogueManager.show_example_dialogue_balloon(dialogue_resource,"第四天")
		#并且结束时 触发终极对话，弹出一个类似那样的框 并写着如此同时 xxxxx
		#大儒辩经文 今天结束时，展示最终对话
	elif GameManager.sav.day==5:
		#demo内容未来可删
		
		
		if GameManager.sav.have_event["DemoFinish"]==false:
			GameManager.changeTaskLabel("")
			GameManager.sav.have_event["DemoFinish"]=true
			control.hide()
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"新手关结束")	
	
	#判断以下，是首日获取 还是第二次获取	
const siku1 = preload("res://Asset/sound/似哭似笑1.mp3")
const siku2 = preload("res://Asset/sound/似哭似笑2.mp3")
func resumeBgm():
	GameManager.play_BGM()
	
	SoundManager.stop_all_ambient_sounds()
	SoundManager.play_ambient_sound(daybgm)
@onready var zhubu = $"文官"
	
	#将政务面板更新 里面列举了一堆list
	#如果没见过陈登把control隐藏，如果见过了陈登 control不隐藏
const daybgm = preload("res://Asset/bgm/白天在家or办公.wav")	
const nightbgm = preload("res://Asset/bgm/夜晚在家.wav")
func post_transition():
	GameManager.CanClickUI=true
	SoundManager.stop_all_ambient_sounds()
	if GameManager.sav.alreadyHP>=80:
		SoundManager.play_ambient_sound(nightbgm)
		#判断条件做最终支线，显示任务主簿，和点击点击事件
		if GameManager.sav.have_event["锦囊咨询丹阳派"]==true and GameManager.sav.have_event["支线触发完毕获得骨杖"]==false :#and GameManager.sav.have_event["温侯降伏臧霸"]==true:
			zhubu.show()
			zhubu.showEX=true
		#特殊事件触发时
			zhubu.dialogue_start="支线克苏鲁最终开始"
		elif GameManager.sav.endPath==GameManager.endPath.xiaopei and GameManager.sav.have_event["泰山预备"]==false:
			taishanSoilder.show()
	else:
		SoundManager.play_ambient_sound(daybgm)
	_initData()
	
	
@onready var taishanSoilder: Node2D = $"泰山军官"

func gotostreetAndKe(value):
	GameManager.sav.finalKeChoice=value
	SceneManager.changeScene(SceneManager.roomNode.STREET,2)

func PlayBitPlayer():
	bti_rect.hide()
	bit_player.show()
	bit_player.finished.connect(_on_video_player_finished)
	bit_player.play()

func _on_video_player_finished():
	bit_player.hide()
	hp_panel.show()
	res_panel.show()
	support_panel.show()
	GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.KESULU]=tr("召见陶商、陶应，解梦境预示")
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"克苏鲁梦境结束")


func _buttonListClick(item):

	if item.context == "外出":
		SceneManager.changeScene(SceneManager.roomNode.STREET,2)
	elif item.context == "今日政务":
		control._show_button_5_yellow(-1)
		policyPanel.refreshContext()
		policyPanel.show()
		pass
	elif item.context == "属性面板":
		#当前功能demo不开放
		#DialogueManager.show_example_dialogue_balloon(sys,"当前功能demo不开放")	
		
		#正式功能需要取消注释
		refreshPropertyPanel()
		propertyPanel.show()
		
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
			pass
			#if GameManager.sav.have_event["xxxx"]==false:
			#	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"xxxx")	
			#	return	
		control._show_button_5_yellow(-1)
		if GameManager.musicId!=0:
			GameManager.musicId=-GameManager.musicId
		
		
		#逻辑不能放在这里
		if(GameManager.sav.alreadyHP<10):
			GameManager.sav.lazydays+=1	
			GameManager.sav.lazyValue=GameManager.sav.lazyValue+1
			if GameManager.sav.lazydays>=3:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"连续多日怠惰")
				return	
				#连续多日怠惰
			else:
				var lazyRan=0.2*GameManager.sav.lazyValue
				var random_value = randf()  # 生成0.0到1.0的随机数
				if random_value <= lazyRan:
					DialogueManager.show_example_dialogue_balloon(dialogue_resource,"单日概率怠惰")
					return
				#怠惰概率 1次 10% 
		else:
			if GameManager.sav.lazyValue>0:
				GameManager.sav.lazyValue=GameManager.sav.lazyValue-1
			GameManager.sav.lazydays=0
			print("已经清除怠惰")	
		SoundManager.stop_music()	
		GameManager._rest()	 
		#判断有无道具 有道具且等于false	
				




func oneDayidleness():
	GameManager.sav.HAOZUPAI.ChangeSupport(-5)
	GameManager.sav.BENTUPAI.ChangeSupport(-5)
	GameManager.sav.WAIDIPAI.ChangeSupport(-5)
	SoundManager.stop_music()	
	GameManager._rest()	 	
func moreDayidness():
	GameManager.sav.HAOZUPAI.ChangeSupport(-10)
	GameManager.sav.BENTUPAI.ChangeSupport(-10)
	GameManager.sav.WAIDIPAI.ChangeSupport(-10)
	GameManager.changePeopleSupport(-5)
	SoundManager.stop_music()	
	GameManager._rest()	 
func refreshPropertyPanel():

	var contextEx=tr("当前天数：%d")%GameManager.sav.day+"\n"
	contextEx=contextEx+tr("每日钱财收入：%d")%GameManager.sav.coin_DayGet+"\n"
	contextEx=contextEx+tr("每日劳动力获取：%d")%GameManager.sav.labor_DayGet+"\n"
	contextEx=contextEx+"------------------------------"+"\n"
	contextEx=contextEx+tr("武将等级（括弧为战斗力）")+"\n"
	contextEx=contextEx+tr("关羽：lv%d（%d）")%[GameManager.sav.generals[GameManager.RspEnum.ROCK].level,500]+"\n"
	contextEx=contextEx+tr("张飞：lv%d（%d）")%[GameManager.sav.generals[GameManager.RspEnum.PAPER].level,500]+"\n"
	contextEx=contextEx+tr("无名：lv%d（%d）")%[GameManager.sav.generals[GameManager.RspEnum.SCISSORS].level,500]+"\n"	
	contextEx=contextEx+"------------------------------"+"\n"
	contextEx=contextEx+tr("当前派系对你的看法")+"\n"
	
	contextEx=contextEx+tr("%s：%s")%[tr(GameManager.sav.BENTUPAI._name),getFractionView(GameManager.sav.BENTUPAI._support_rate)]+"\n"
	if GameManager.sav.have_event["Factionalization"]==true:
		contextEx=contextEx+tr("%s：%s")%[tr(GameManager.sav.HAOZUPAI._name),getFractionView(GameManager.sav.HAOZUPAI._support_rate)]+"\n"
	contextEx=contextEx+tr("%s：%s")%[tr(GameManager.sav.WAIDIPAI._name),getFractionView(GameManager.sav.WAIDIPAI._support_rate)]+"\n"
	
	
	#1优化参与军事行动的策略，通过战胜对手获得足够的资金收益。  
	#2积极参与大儒辩经活动，进行辩论小游戏，获取道具与金钱奖励。  
	#3制定有利可图的律法以增加税收，同时向城内派系索取资金，利用好的策略确保稳定的金钱来源。


	
	#4通过任务、立法、军事行动等方式，系统性地收集资源，确保资源储备充足以支持武将升级与道具购买。  
	#5可以选择武将进行升级，确保在军事行动中拥有更强的作战能力。  
	#6可以购买增益类道具在军事行动中取得更大的优势。

	
	var comindex=0
	if GameManager.sav.targetResType==GameManager.ResType.coin:
		comindex=0
	elif GameManager.sav.targetResType==GameManager.ResType.none:
		comindex=2
	elif GameManager.sav.targetResType==GameManager.ResType.govern:
		comindex=4
	elif GameManager.sav.targetResType==GameManager.ResType.construct:
		comindex=3
	else:
		comindex=1	
	#通过演武场、大儒辩经、立法、从其它派系索取钱财 尽可能实现收集资金的目标
	#通过收集尽可能多的资源，升级武将购买道具并在军事行动取得进一步的优势
	contextEx=contextEx+tr("今日建议：%s")%getrecommendStr(comindex)+"\n"
	propertyPanel.contextEX=contextEx
	

func getrecommendStr(index):
	var Rstr
	var rindex=randi_range(0,2)
	if index==0:
		if rindex==0:
			Rstr=tr("优化参与军事行动的策略，通过战胜对手获得足够的资金收益。")
		elif rindex==1:
			Rstr=tr("积极参与大儒辩经活动，进行辩论小游戏，获取道具与金钱奖励。")
		elif rindex==2:
			Rstr=tr("制定有利可图的律法以增加税收，同时向城内派系索取资金，利用好的策略确保稳定的金钱来源。")
						  
	elif index==1:
		if rindex==0:
			Rstr=tr("通过任务、立法、军事行动等方式，系统性地收集资源，确保资源储备充足以支持武将升级与道具购买。")
		elif rindex==1:
			Rstr=tr("可以选择武将进行升级，确保在军事行动中拥有更强的作战能力。")
		elif rindex==2:
			Rstr=tr("可以购买增益类道具在军事行动中取得更大的优势。")
	elif index==3:
		if rindex==0:
			Rstr=tr("完成演武场、府邸、议事厅高阶基建，可获取更强属性增益")
		elif rindex==1:
			Rstr=tr("先在初级基建玩法中熟悉策略，再挑战高阶关卡")
		elif rindex==2:
			Rstr=tr("任意难度下，完成3类不同基建即可达成基建计划")
		
	elif index==4:
		if GameManager.dontHaveDominance():
			Rstr=tr("赠送礼物、推动派系法案通过，可提升派系支持度")
		else:
			if rindex==0:
				Rstr=tr("赠送礼物、推动派系法案通过，可提升派系支持度")
			elif rindex==1:
				Rstr=tr("面对派系忠诚度不足的局面，除怀柔安抚外，亦可采取强硬手段。")
			elif rindex==2:
			
				Rstr=tr("累计镇压3次后，派系将对你永远保持忠诚")
	else:
		Rstr=tr("暂无")	
	return Rstr

func getFractionView(point):
	var viewStr=""
	if point>=90:
		viewStr=tr("忠诚")
	elif point<90 and point>=70:
		viewStr=tr("友好")
	elif point<70 and point>=60:
		viewStr=tr("中立")
	elif point<60 and point>=40:
		viewStr=tr("戒备")
	else:
		viewStr=tr("敌对")
	return viewStr
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func showFirstGuild():
	control.show()
	point.hide()
	control._show_button_5_yellow(0)
	$"陈群".hide()
	#这句代码没有作用，以防万一添加进行初始化
	GameManager.sav.policyExcute=false
	GameManager.initSecretFunc()
	GameManager.changeTaskLabel(tr("完成今日政务所有事项"))
	pass


@onready var point: Node2D = $point
	
func showchenqun():
	$"陈群".show()
	point.show()
	GameManager.changeTaskLabel(tr("跟陈群对话"))
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
@onready var title = $CanvasLayer/title
@onready var demo_end = $CanvasLayer/DemoEnd
const bgs194 = preload("res://Asset/sound/公元194末.mp3")
func demoFinish():
	$"陈群".hide()
	$"文官".hide()
	
	

	GameManager.restLabel=tr("公元194年末，刘备入主徐州，同时他将州治迁往下邳，一场新的权力的游戏开始了！")

	#GameManager.restFadeScene=SceneManager.HOUSE
	
	#正式版
	GameManager.restFadeScene=SceneManager.GOVERNMENT_BUILDING
	#播放声音
	SoundManager.play_sound(bgs194)
	GameManager.wait_time=bgs194.get_length()
	GameManager._rest(false)#正式游戏false
	
	
	#府邸改成 进去触发对话，对话完触发主线内容
	#const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
		


func fadeInAndOut():
	PanelManager.Fade_Blank(Color.BLACK,1,PanelManager.fadeType.fadeInAndOut)


func _on_demo_end_button_down():
	get_tree().quit()
	pass # Replace with function body.



func _DayGet():
	#
	isdetermine=false
	res_panel.showValue=false
	res_panel.GetValue(GameManager.sav.coin_DayGet,0,GameManager.sav.labor_DayGet)
	SoundManager.play_sound(sounds.buysellsound)
	await 0.8
	res_panel.showValue=false

	

	if(GameManager.sav.targetTxt!=null and GameManager.sav.targetTxt.length()>0):	
		_JudgeTask()	#主线
	else:
		extraTask()	#支线
	# 好的我了解了，还有别的事么？
	# 对，还有一键
	# 很好，继续努力。如果任务没有完成 提示三选一


func extraTask():
	
	if GameManager.sav.day>6 and GameManager.sav.day<=9:
		if GameManager.sav.have_event["支线发现羊尸"]==false:
			GameManager.sav.have_event["支线发现羊尸"]=true
			GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.KESULU]=tr("探查城外羊尸，判断妖邪与否")
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"支线开始")	
		#将任务可检索设置成true
		#如果任务为false  设置成true 并触发对话
		elif GameManager.sav.have_event["支线触发完毕查出锦囊"]==true and GameManager.sav.have_event["支线触发完毕查出锦囊休息"]==false:
			GameManager.sav.have_event["支线触发完毕查出锦囊休息"]=true
			GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.KESULU]=tr("回府邸彻查张阎刺陶一案")
	if GameManager.sav.have_event["查出药囊后休息前"]==false:  #支线都不该在血战模式后触发
		var to_inventory= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.黄麻药囊)
		var quantity=InventoryManager.has_item_quantity(to_inventory)
		if quantity>0:
			GameManager.sav.have_event["查出药囊后休息前"]=true
				#下一步去演武场，判断这个==true，将曹豹显示并修改任务
	if  GameManager.sav.day>9:
		if GameManager.sav.have_event["支线发现羊尸"]==true:
			GameManager.sav.have_event["支线发现羊尸"]=false
		if GameManager.sav.have_event["支线发现羊尸"]==false and GameManager.sav.have_event["支线触发完毕调查过竹简"]==false and GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.KESULU]!="":
			GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.KESULU]=""
		#将任务设置成false
		var num1=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.论语简注)	
		var num2=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.礼记笺疏)	
		if(GameManager.sav.have_event["大儒支线1"]==false):
			GameManager.sav.have_event["大儒支线1"]=true
			GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.DARU]=tr("拜访郑玄，借名望安定徐州人心")
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"大儒辩经1启动之前")	
		elif GameManager.sav.have_event["大儒支线2"]==false and num1>=1 and GameManager.sav.have_event["泰山诸将曹操消息"]==true:
			GameManager.sav.have_event["大儒支线2"]=true
			GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.DARU]=tr("与郑玄论《礼记》，安抚徐州士人")
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"大儒辩经2启动之前")			
		elif GameManager.sav.have_event["大儒支线3"]==false and num2>=1 and GameManager.sav.have_event["基建项目开启"]==true:
			GameManager.sav.have_event["大儒支线3"]=true
			GameManager.sav.SIDEQUEST_MAP[SceneManager.sideQuest.DARU]=tr("前往郑玄隐居处，听学《周礼》")
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"大儒辩经3启动之前")
		elif GameManager.sav.have_event["泰山预备"]==true and GameManager.sav.have_event["最终泰山"]==false and GameManager.sav.taishanWait>=2 and GameManager.sav.have_event["夏侯偷马"]==false:
			GameManager.sav.taishanWait=50
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"泰山诸将任务完成")
			GameManager.sav.have_event["最终泰山"]=true
	#判断忠诚度
	var chaonum=0	
	enterdetermineInternalUnrest()

func _JudgeTask():
	var hasSide=true
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
					hasSide=false
				else:
					hasSide=false
					DialogueManager.show_example_dialogue_balloon(dialogue_resource,"每天袁术内应搞事")	
	if(GameManager.sav.have_event["completeTask1"]==true):
		if(GameManager.sav.have_event["initTask2"]==false):
			GameManager.sav.have_event["initTask2"]=true
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"有拦路虎")
			hasSide=false
			#显示对话
			#任务完成
	
			#if GameManager.sav.have_event["battleYuanshu"]==true:
			#if(GameManager.sav.have_event["completebattleYuanshu"]==false):	
	if hasSide==true:
		extraTask()		
	
func secondMissonStart():
	GameManager.sav.targetValue=10
	GameManager.sav.currenceValue=0
	GameManager.sav.targetResType=GameManager.ResType.battle
	GameManager.sav.targetTxt="征讨次数：{currence}/{target}"
	#觉得无用的注释GameManager.sav.TargetDestination="battle"
	GameManager.initSecretBattleContext(1000,SceneManager.etraTaskType.costMoney,9,"黄巾军降伏")
	#win 10次90
	#GameManager.sav.TargetDestination=="府邸"
	pass
	

#准备改成5天，然后民心下降改成5点
func yuanshuChaos(value):
	if value==1:
		GameManager.changePeopleSupport(-10)
		#民心下降10,改成5
	elif value==2:
		GameManager.sav.WAIDIPAI.ChangeSupport(-10)
		#丹阳派下降10
	elif value==3:
		GameManager.sav.BENTUPAI.ChangeSupport(-10)
		#徐州度下降10
	elif value==4:
		GameManager.sav.WAIDIPAI.ChangeSupport(-10)
		GameManager.sav.BENTUPAI.ChangeSupport(-10)
		GameManager.changePeopleSupport(-10)
		#全部下降10
@onready var caocao_letter = $CanvasLayer/caocaoLetter
		
	
@onready var caocao_letter_2: Control = $CanvasLayer/caocaoLetter2
		
func showCaoCaoLetter():
	caocao_letter.show()
	
var isdetermine=false
#完成任务不应该显示 休息进入下一天
func lookDoneCaoCaoLetter():
	#设置目标是前往宅邸
	GameManager.sav.TargetDestination="府邸"
	caocao_letter.hide()
	enterdetermineInternalUnrest()

#有bug需要改
func enterdetermineInternalUnrest():
	if isdetermine==false:
		isdetermine=true
		determineInternalUnrest()	

var randomIndex=0
#以下是叛乱逻辑
const sys = preload("res://dialogues/系统.dialogue")
func determineInternalUnrest():
	var _UnrestNum=0
	randomIndex=GameManager.sav.randomIndex
	var fractions:Array=[GameManager.sav.HAOZUPAI,GameManager.sav.WAIDIPAI,GameManager.sav.BENTUPAI]
	for fraction in fractions:
		var _support_rate=fraction._support_rate
		if _support_rate < 60.0:
			# 计算叛变概率：支持率越低，概率越高
			# 线性插值：支持率 60 -> 5% 概率，支持率 0 -> 80% 概率
			var rebellion_chance = lerp(0.05, 0.80, (60.0 - _support_rate) / 60.0)
			# 随机数判断是否叛变
			if randf() < rebellion_chance:
				fraction.isrebellion = true
				_UnrestNum=_UnrestNum+1	
	
	var _LVBUsupport_rate=GameManager.sav.LVBU._support_rate
	if _LVBUsupport_rate < 80.0:
			# 计算叛变概率：支持率越低，概率越高
			# 线性插值：支持率 60 -> 5% 概率，支持率 0 -> 80% 概率
		var rebellion_chance = lerp(0.25, 0.80, (80.0 - _LVBUsupport_rate) / 80.0)
			# 随机数判断是否叛变
		if randf() < rebellion_chance:
			GameManager.sav.LVBU.isrebellion = true
			_UnrestNum=_UnrestNum+1	
	
	
	
	if _UnrestNum>0:
		DialogueManager.show_example_dialogue_balloon(sys,"有内乱禀报")
var determineValue1=0
var determineType:GameManager.ResType=GameManager.ResType.none
var determineDetail=""
func resetDeterminValue():
	determineValue1=0
	determineType=GameManager.ResType.none
	determineDetail=""

func settleDeterminValue():
	if(determineType==GameManager.ResType.coin):
		GameManager.sav.coin=GameManager.sav.coin-determineValue1
	elif determineType==GameManager.ResType.people:
		GameManager.sav.labor_force=GameManager.sav.labor_force-determineValue1
	elif determineType==GameManager.ResType.heart:
		GameManager.changePeopleSupport(-determineValue1)
	
	
func determineInternalUnrestXuzhou():
	resetDeterminValue()
	if GameManager.sav.BENTUPAI.isrebellion==true:
		GameManager.sav.BENTUPAI._num_defections=GameManager.sav.BENTUPAI._num_defections+1
		determineValue1=30*randomIndex+(GameManager.sav.BENTUPAI._num_defections)*30
		
		if randf() < 0.5||GameManager.sav.labor_force<determineValue1:
			determineType=GameManager.ResType.heart
			determineValue1=5+randomIndex+(GameManager.sav.BENTUPAI._num_defections-1)*2
			DialogueManager.show_example_dialogue_balloon(sys,"士族叛乱1")
		else:
			determineType=GameManager.ResType.people
			
			DialogueManager.show_example_dialogue_balloon(sys,"士族叛乱2")
		return
	determineInternalUnrestHaozu()

func determineInternalUnrestHaozu():
	settleDeterminValue()
	resetDeterminValue()
	if GameManager.sav.HAOZUPAI.isrebellion==true:
		GameManager.sav.HAOZUPAI._num_defections=GameManager.sav.HAOZUPAI._num_defections+1
		determineValue1=50*randomIndex+(GameManager.sav.HAOZUPAI._num_defections)*50
		if randf() < 0.5||GameManager.sav.coin<determineValue1:
			determineValue1=5+randomIndex+(GameManager.sav.HAOZUPAI._num_defections-1)*2
			determineType=GameManager.ResType.heart
			DialogueManager.show_example_dialogue_balloon(sys,"豪族叛乱1")
		else:
			
			determineType=GameManager.ResType.coin			
			DialogueManager.show_example_dialogue_balloon(sys,"豪族叛乱2")
		return
	determineInternalUnrestDanyang()	
func determineInternalUnrestDanyang():
	settleDeterminValue()
	resetDeterminValue()
	if GameManager.sav.WAIDIPAI.isrebellion==true:
		GameManager.sav.WAIDIPAI._num_defections=GameManager.sav.WAIDIPAI._num_defections+1
		determineValue1=randomIndex+GameManager.sav.WAIDIPAI._num_defections
		#判断道具总数之和
		var _num=InventoryManager.canUseItemNum()

		if randf() < 0.5 and _num>=determineValue1:

			determineValue1=InventoryManager.costItemRandom(determineValue1)
			determineDetail=generate_consumed_string(determineValue1)
			determineType=GameManager.ResType.item	
			DialogueManager.show_example_dialogue_balloon(sys,"丹阳叛乱1")
		else:
			determineValue1=5+randomIndex+(GameManager.sav.WAIDIPAI._num_defections-1)*2
			determineType=GameManager.ResType.heart			
			DialogueManager.show_example_dialogue_balloon(sys,"丹阳叛乱2")
		return
	determineInternalUnrestLvbu()
func determineInternalUnrestLvbu():
	settleDeterminValue()
	resetDeterminValue()
	if GameManager.sav.LVBU.isrebellion==true:
		var rand = randi() % 4
		var valid_choice = false
		var costItem= randomIndex + GameManager.sav.LVBU._num_defections
		var costCoin=50 * randomIndex + (GameManager.sav.LVBU._num_defections) * 50
		var costPeople=30 * randomIndex + (GameManager.sav.LVBU._num_defections) * 30
		var costHeart=5 + randomIndex + (GameManager.sav.LVBU._num_defections - 1) * 2
		#var costItemDetail=InventoryManager.costItemRandom()
	# 收集可满足的资源类型
		var valid_options = []
		if InventoryManager.canUseItemNum() >= costItem:
			valid_options.append([GameManager.ResType.item, costItem])
		if GameManager.sav.coin >= costCoin:
			valid_options.append([GameManager.ResType.coin, costCoin,tr("金币-%d") %costCoin])
		if GameManager.sav.labor_force >= costPeople:
			valid_options.append([GameManager.ResType.people, costPeople,tr("劳动力-%d") %costPeople])
		if GameManager.sav.people_surrport >= costHeart:
			valid_options.append([GameManager.ResType.heart, costHeart,tr("民心-%d") %costHeart])

		# 如果有可满足的资源，随机选择一种
		if valid_options.size() > 0:
			var choice = valid_options[randi() % valid_options.size()]
			if(choice[0]!=GameManager.ResType.item):
				
				determineType = choice[0]
				determineValue1 = choice[1]
				determineDetail=choice[2]
			else:
				determineValue1=InventoryManager.costItemRandom(choice[1])
				determineDetail=generate_consumed_string(determineValue1)
				determineType=GameManager.ResType.item
		else:
		# 否则默认选择 heart
			determineType = GameManager.ResType.heart
			determineValue1 = costHeart
			determineDetail=tr("民心-%d") %costHeart
		DialogueManager.show_example_dialogue_balloon(sys,"吕布叛乱")
		return

	determineInternalUnrestMinxin()
func determineInternalUnrestMinxin():
	settleDeterminValue()
	resetDeterminValue()
	var rebellion_chance = lerp(0.05, 0.80, (60.0 - GameManager.sav.people_surrport) / 60.0)
			# 随机数判断是否叛变
	if randf() > rebellion_chance:
		shizuLawTest()
		return
		
	var rand = randi() % 4
	var valid_choice = false
	var costItem= randomIndex + GameManager.sav.LVBU._num_defections
	var costCoin=50 * randomIndex + (GameManager.sav.LVBU._num_defections) * 50
	var costPeople=30 * randomIndex + (GameManager.sav.LVBU._num_defections) * 30
	var costHeart=5 + randomIndex + (GameManager.sav.LVBU._num_defections - 1) * 2
		#var costItemDetail=InventoryManager.costItemRandom()
	# 收集可满足的资源类型
	var valid_options = []
	if InventoryManager.canUseItemNum() >= costItem:
		valid_options.append([GameManager.ResType.item, costItem])
	if GameManager.sav.coin >= costCoin:
		valid_options.append([GameManager.ResType.coin, costCoin,tr("金币-%d") %costCoin])
	if GameManager.sav.labor_force >= costPeople:
		valid_options.append([GameManager.ResType.people, costPeople,tr("劳动力-%d") %costPeople])
	if GameManager.sav.people_surrport >= costHeart:
		valid_options.append([GameManager.ResType.heart, costHeart,tr("民心-%d") %costHeart])

	# 如果有可满足的资源，随机选择一种
	if valid_options.size() > 0:
		var choice = valid_options[randi() % valid_options.size()]
		if(choice[0]!=GameManager.ResType.item):	
			determineType = choice[0]
			determineValue1 = choice[1]
			determineDetail=choice[2]
			if determineType==GameManager.ResType.coin:
				DialogueManager.show_example_dialogue_balloon(sys,"民心叛乱2")		
			elif determineType==GameManager.ResType.people:
				DialogueManager.show_example_dialogue_balloon(sys,"民心叛乱3")		
			elif determineType==GameManager.ResType.heart:
				DialogueManager.show_example_dialogue_balloon(sys,"民心叛乱4")		
		else:
			determineValue1=InventoryManager.costItemRandom(choice[1])
			determineDetail=generate_consumed_string(determineValue1)
			determineType=GameManager.ResType.item
			DialogueManager.show_example_dialogue_balloon(sys,"民心叛乱1")
	else:
	# 否则默认选择 heart
		determineType = GameManager.ResType.heart
		determineValue1 = costHeart
		determineDetail=tr("民心-%d") %costHeart
		DialogueManager.show_example_dialogue_balloon(sys,"民心叛乱4")
		

func shizuLawTest():
	if GameManager.sav.xuzhouCD==0:
		GameManager.sav.xuzhouCD=-1
		GameManager.sav.laws[0]= GameManager.sav.laws[0].filter(func(x): return x >= 0)
		GameManager.sav.courtingLaws.erase(GameManager.sav.BENTUPAI._name)
		GameManager.sav.BENTUPAI.ChangeSupport(-10)
		DialogueManager.show_example_dialogue_balloon(sys,"士族法律未通过")
		return
	haozuLawTest()
func haozuLawTest():
	if GameManager.sav.haozuCD==0:
		GameManager.sav.haozuCD=-1
		GameManager.sav.laws[1]= GameManager.sav.laws[1].filter(func(x): return x >= 0)
		GameManager.sav.courtingLaws.erase(GameManager.sav.HAOZUPAI._name)
		GameManager.sav.HAOZUPAI.ChangeSupport(-10)
		DialogueManager.show_example_dialogue_balloon(sys,"豪族法律未通过")
		return
	danyangLawTest()

func danyangLawTest():
	if GameManager.sav.danyangCD==0:
		GameManager.sav.danyangCD=-1
		GameManager.sav.laws[2]= GameManager.sav.laws[2].filter(func(x): return x >= 0)
		GameManager.sav.courtingLaws.erase(GameManager.sav.WAIDIPAI._name)
		DialogueManager.show_example_dialogue_balloon(sys,"丹阳法律未通过")
		GameManager.sav.WAIDIPAI.ChangeSupport(-10)
		return


func generate_consumed_string(consumed: Dictionary) -> String:
	var result = []
	for item_type in consumed:
		if consumed[item_type] > 0:  # 只处理消耗数量大于 0 的道具
			var item_name = InventoryManager.get_item_db(item_type).name
			result.append(tr("%s损失x%d") % [item_name, consumed[item_type]])
	#
	## 用逗号连接所有描述
	return "，".join(result)
	
@onready var items_in_scene: Node2D = $itemsInScene

@onready var caobao: Node2D = $caobao


@onready var wenguan: Node2D = $"文官"
@onready var chenqun: Node2D = $"陈群"

	
func sheepGnawed():
	pass
	#street 显示xxx
	#GameManager.sav.have_event["支线发现羊尸"]=true
