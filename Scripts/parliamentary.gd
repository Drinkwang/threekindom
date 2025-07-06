extends Control
#创建3个类 代表三个派系 初始解锁2个
@onready var p_1 = $p1
@onready var p_2 = $p2
@onready var p_3 = $p3
@onready var o_1 = $o1
@onready var label_2 = $Label2
@onready var title = $PanelContainer/Label
@onready var button = $lawPanel/DetailPanel/Button

var _isPass:bool=false
# Called when the node enters the scene tree for the first time.
func _ready():
	p_1.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": "__", "RT":"__","SP":"__","OP":"__"})  #本土派
	p_2.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": "__", "RT":"__","SP":"__","OP":"__"})  #外来派
	#enter()
	refreshSysLanguageFont()
	pass # Replace with function body.

#在进入瞬间判断出结果，然后做一个动画
const bgmxuanhua = preload("res://Asset/sound/议会喧哗声音.mp3")
func refreshSysLanguageFont():
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="ja":
		label_2.add_theme_constant_override("line_spacing",7)
		
	elif currencelanguage=="lzh":
		label_2.add_theme_constant_override("line_spacing",4)	
	elif currencelanguage=="ru":
		var rufont=preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")
		label_2.add_theme_font_override("font",rufont)	
		label_2.add_theme_constant_override("line_spacing",5)	
		title.add_theme_font_override("font",rufont)	
		label_2.position=Vector2(238,233)
		#p_1.add_theme_font_override("font",rufont)	
		#p_2.add_theme_font_override("font",rufont)	
		#p_3.add_theme_font_override("font",rufont)	
		#o_1.add_theme_font_override("font",rufont)	

@onready var p_label = $PanelContainer/Label

func enter():
	var has_separatist_forces=GameManager.sav.have_event["Factionalization"]
	
	if has_separatist_forces:
		p_label.text=tr("士族派:丹阳派:豪族派")
		p_3.show()
	else:
		p_3.hide()
		p_label.text=tr("本地派:外来派")
	o_1.text="{AS}\n{AP}\n{RATE}\n{FINAL}".format({"AS": "__", "AP":"__" ,"RATE":"__","FINAL":"__"})
	SoundManager.play_sound(bgmxuanhua)
	button.hide()
	#执行这个时 将摇摆人数按照概率分成 摇摆和非摇摆
	initRtSO(GameManager.sav.BENTUPAI)
	initRtSO(GameManager.sav.HAOZUPAI)
	initRtSO(GameManager.sav.WAIDIPAI)		
	p_1.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.BENTUPAI._num_all, "RT": "__","SP":"__","OP":"__"})
	p_2.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.WAIDIPAI._num_all, "RT": "__","SP":"__","OP":"__"}) 
	p_3.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.HAOZUPAI._num_all, "RT": "__","SP":"__","OP":"__"}) 
	await get_tree().create_timer(0.5).timeout  #本土派
	p_1.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.BENTUPAI._num_all, "RT": GameManager.sav.BENTUPAI._num_rt,"SP":"__","OP":"__"})
	p_2.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.WAIDIPAI._num_all, "RT": GameManager.sav.WAIDIPAI._num_rt,"SP":"__","OP":"__"}) 
	p_3.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.HAOZUPAI._num_all, "RT": GameManager.sav.HAOZUPAI._num_rt,"SP":"__","OP":"__"}) 
	await get_tree().create_timer(0.5).timeout  #本土派
	p_1.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.BENTUPAI._num_all, "RT": GameManager.sav.BENTUPAI._num_rt,"SP":GameManager.sav.BENTUPAI._num_sp,"OP":"__"})
	p_2.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.WAIDIPAI._num_all, "RT": GameManager.sav.WAIDIPAI._num_rt,"SP":GameManager.sav.WAIDIPAI._num_sp,"OP":"__"}) 
	p_3.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.HAOZUPAI._num_all, "RT": GameManager.sav.HAOZUPAI._num_rt,"SP":GameManager.sav.HAOZUPAI._num_sp,"OP":"__"}) 
	
	await get_tree().create_timer(0.5).timeout  #本土派
	p_1.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.BENTUPAI._num_all, "RT": GameManager.sav.BENTUPAI._num_rt,"SP":GameManager.sav.BENTUPAI._num_sp,"OP":GameManager.sav.BENTUPAI._num_op})
	p_2.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.WAIDIPAI._num_all, "RT": GameManager.sav.WAIDIPAI._num_rt,"SP":GameManager.sav.WAIDIPAI._num_sp,"OP":GameManager.sav.WAIDIPAI._num_op}) 
	p_3.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.HAOZUPAI._num_all, "RT": GameManager.sav.HAOZUPAI._num_rt,"SP":GameManager.sav.HAOZUPAI._num_sp,"OP":GameManager.sav.HAOZUPAI._num_op}) 

	await get_tree().create_timer(0.5).timeout
	#合计同意
	#合计反对
	#通过率
	#结果
	#摇摆增加放在这里进行结算
	var totalSp:int=GameManager.sav.BENTUPAI._num_sp+GameManager.sav.WAIDIPAI._num_sp+GameManager.sav.HAOZUPAI._num_sp
	var totalOp:int=GameManager.sav.BENTUPAI._num_op+GameManager.sav.WAIDIPAI._num_op+GameManager.sav.HAOZUPAI._num_op
	var totalNum:int=GameManager.sav.BENTUPAI._num_all+GameManager.sav.WAIDIPAI._num_all+GameManager.sav.HAOZUPAI._num_all
	var totalrate=floor((totalSp*1.0/totalNum*1.0)*100.0)

	
	
	
	var isPass:String="通过"
	if(totalrate>50):
		_isPass=true
		isPass="通过"
		GameManager.excuteLaw()#在执行法律面板
	else:
		_isPass=false
		isPass="未通过"
		
		#GameManager.
	o_1.text="{AS}\n{AP}\n{RATE}%\n{FINAL}".format({"AS": totalSp, "AP":totalOp ,"RATE":totalrate,"FINAL":tr(isPass)})
	SoundManager.stop_sound(bgmxuanhua)
	button.show()
	

func initRtSO(data:cldata):
	var tongyi:int= randf_range(0,data._num_rt)
	var fandui:int= data._num_rt-tongyi
	data._num_sp=data._num_sp+tongyi
	data._num_op=data._num_op+fandui
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

const yihuiting = preload("res://dialogues/议会厅.dialogue")
func _on_button_button_down():
	self.hide()
	if GameManager.sav.have_event["firstParliamentary"]==false:
		GameManager.sav.have_event["firstParliamentary"]=true
		DialogueManager.show_example_dialogue_balloon(yihuiting,"第一次会议结束")
		pass # Replace with function body.
	if _isPass==false:
		DialogueManager.show_example_dialogue_balloon(yihuiting,"未通过法案")
