extends Control
#创建3个类 代表三个派系 初始解锁2个
@onready var p_1 = $p1
@onready var p_2 = $p2
@onready var p_3 = $p3
@onready var o_1 = $o1
@onready var label_2 = $Label2
@onready var button = $lawPanel/DetailPanel/Button

const TABLE_LINE_SPACING := 20
const HEADER_WIDTH := 762.0
const TWO_FACTION_HEADER_LEFT := 575.0
const THREE_FACTION_HEADER_LEFT := 690.0
const HEADER_BASE_FONT_SIZE := 51
const HEADER_MIN_FONT_SIZE := 34

var _isPass:bool=false
var _hasResult:bool=false
# Called when the node enters the scene tree for the first time.
func _ready():
	p_1.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": "__", "RT":"__","SP":"__","OP":"__"})  #本土派
	p_2.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": "__", "RT":"__","SP":"__","OP":"__"})  #外来派
	#enter()
	refreshSysLanguageFont()
	SignalManager.changeLanguage.connect(changeLanguage)
	pass # Replace with function body.

func changeLanguage():
	refreshSysLanguageFont()
	refreshFactionHeader(GameManager.sav.have_event["Factionalization"])
	if _hasResult:
		var totalSp:int=GameManager.sav.BENTUPAI._num_sp+GameManager.sav.WAIDIPAI._num_sp+GameManager.sav.HAOZUPAI._num_sp
		var totalOp:int=GameManager.sav.BENTUPAI._num_op+GameManager.sav.WAIDIPAI._num_op+GameManager.sav.HAOZUPAI._num_op
		var totalNum:int=GameManager.sav.BENTUPAI._num_all+GameManager.sav.WAIDIPAI._num_all+GameManager.sav.HAOZUPAI._num_all
		var totalrate=floor((totalSp*1.0/totalNum*1.0)*100.0)
		o_1.text="{AS}\n{AP}\n{RATE}%\n{FINAL}".format({"AS":totalSp,"AP":totalOp,"RATE":totalrate,"FINAL":tr("通过" if _isPass else "未通过")})

#在进入瞬间判断出结果，然后做一个动画
const bgmxuanhua = preload("res://Asset/sound/议会喧哗声音.mp3")
func refreshSysLanguageFont():
	# Labels and values are separate multiline controls, so every column must use
	# the same row pitch in every locale or the mismatch accumulates per row.
	for table_label in [label_2, p_1, p_2, p_3, o_1]:
		table_label.add_theme_constant_override("line_spacing", TABLE_LINE_SPACING)

@onready var p_label = $Label

func refreshFactionHeader(has_separatist_forces:bool):
	p_label.text=tr("士族派:外来派:豪族派") if has_separatist_forces else tr("本土派:外来派")
	p_label.position.x=THREE_FACTION_HEADER_LEFT if has_separatist_forces else TWO_FACTION_HEADER_LEFT
	p_label.size.x=HEADER_WIDTH
	var fitted_size:=HEADER_BASE_FONT_SIZE
	var font=p_label.get_theme_font("font")
	while fitted_size>HEADER_MIN_FONT_SIZE and font.get_string_size(p_label.text,HORIZONTAL_ALIGNMENT_LEFT,-1,fitted_size).x>HEADER_WIDTH:
		fitted_size-=1
	p_label.add_theme_font_size_override("font_size",fitted_size)

func enter():
	var has_separatist_forces=GameManager.sav.have_event["Factionalization"]
	
	if has_separatist_forces:
		p_3.show()
	else:
		p_3.hide()
	refreshFactionHeader(has_separatist_forces)
	o_1.text="{AS}\n{AP}\n{RATE}\n{FINAL}".format({"AS": "__", "AP":"__" ,"RATE":"__","FINAL":"__"})
	SoundManager.play_sound(bgmxuanhua)
	button.hide()
	#执行这个时 将摇摆人数按照概率分成 摇摆和非摇摆
	var bentuRt = GameManager.sav.BENTUPAI._num_rt
	var haozuRt = GameManager.sav.HAOZUPAI._num_rt
	var waidiRt = GameManager.sav.WAIDIPAI._num_rt
	initRtSO(GameManager.sav.BENTUPAI)
	initRtSO(GameManager.sav.HAOZUPAI)
	initRtSO(GameManager.sav.WAIDIPAI)
	p_1.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.BENTUPAI._num_all, "RT": "__","SP":"__","OP":"__"})
	p_2.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.WAIDIPAI._num_all, "RT": "__","SP":"__","OP":"__"})
	p_3.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.HAOZUPAI._num_all, "RT": "__","SP":"__","OP":"__"})
	await get_tree().create_timer(0.5).timeout  #本土派
	p_1.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.BENTUPAI._num_all, "RT": bentuRt,"SP":"__","OP":"__"})
	p_2.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.WAIDIPAI._num_all, "RT": waidiRt,"SP":"__","OP":"__"})
	p_3.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.HAOZUPAI._num_all, "RT": haozuRt,"SP":"__","OP":"__"})
	await get_tree().create_timer(0.5).timeout  #本土派
	p_1.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.BENTUPAI._num_all, "RT": bentuRt,"SP":GameManager.sav.BENTUPAI._num_sp,"OP":"__"})
	p_2.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.WAIDIPAI._num_all, "RT": waidiRt,"SP":GameManager.sav.WAIDIPAI._num_sp,"OP":"__"})
	p_3.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.HAOZUPAI._num_all, "RT": haozuRt,"SP":GameManager.sav.HAOZUPAI._num_sp,"OP":"__"})

	await get_tree().create_timer(0.5).timeout  #本土派
	p_1.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.BENTUPAI._num_all, "RT": bentuRt,"SP":GameManager.sav.BENTUPAI._num_sp,"OP":GameManager.sav.BENTUPAI._num_op})
	p_2.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.WAIDIPAI._num_all, "RT": waidiRt,"SP":GameManager.sav.WAIDIPAI._num_sp,"OP":GameManager.sav.WAIDIPAI._num_op})
	p_3.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": GameManager.sav.HAOZUPAI._num_all, "RT": haozuRt,"SP":GameManager.sav.HAOZUPAI._num_sp,"OP":GameManager.sav.HAOZUPAI._num_op})
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
	_hasResult=true
	SoundManager.stop_sound(bgmxuanhua)
	button.show()
	

func initRtSO(data:cldata):
	var tongyi:int= randi_range(0,data._num_rt)
	var fandui:int= data._num_rt-tongyi
	data._num_sp=data._num_sp+tongyi
	data._num_op=data._num_op+fandui
	data._num_rt=0
	
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
