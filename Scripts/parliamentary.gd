extends Control
#创建3个类 代表三个派系 初始解锁2个
@onready var p_1 = $PanelContainer/Label/Label2/p1
@onready var p_2 = $PanelContainer/Label/Label2/p2
@onready var p_3 = $PanelContainer/Label/Label2/p3
@onready var o_1 = $PanelContainer/Label/Label2/o1

const BENTUPAI = preload("res://Asset/tres/bentupai.tres")
const HAOZUPAI = preload("res://Asset/tres/haozupai.tres")
const WAIDIPAI = preload("res://Asset/tres/waidipai.tres")
# Called when the node enters the scene tree for the first time.
func _ready():
	p_1.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": "__", "RT":"__","SP":"__","OP":"__"})  #本土派
	p_2.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": "__", "RT":"__","SP":"__","OP":"__"})  #外来派
	enter()
	pass # Replace with function body.

#在进入瞬间判断出结果，然后做一个动画

func enter():
	o_1.text="{AS}\n{AP}\n{RATE}\n{FINAL}".format({"AS": "__", "AP":"__" ,"RATE":"__","FINAL":"__"})
	
	#执行这个时 将摇摆人数按照概率分成 摇摆和非摇摆
	initRtSO(BENTUPAI)
	initRtSO(HAOZUPAI)
	initRtSO(WAIDIPAI)		
	p_1.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": BENTUPAI._num_all, "RT": "__","SP":"__","OP":"__"})
	p_2.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": WAIDIPAI._num_all, "RT": "__","SP":"__","OP":"__"}) 
	await get_tree().create_timer(0.5).timeout  #本土派
	p_1.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": BENTUPAI._num_all, "RT": BENTUPAI._num_rt,"SP":"__","OP":"__"})
	p_2.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": WAIDIPAI._num_all, "RT": WAIDIPAI._num_rt,"SP":"__","OP":"__"}) 
	await get_tree().create_timer(0.5).timeout  #本土派
	p_1.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": BENTUPAI._num_all, "RT": BENTUPAI._num_rt,"SP":BENTUPAI._num_sp,"OP":"__"})
	p_2.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": WAIDIPAI._num_all, "RT": WAIDIPAI._num_rt,"SP":WAIDIPAI._num_sp,"OP":"__"}) 
	await get_tree().create_timer(0.5).timeout  #本土派
	p_1.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": BENTUPAI._num_all, "RT": BENTUPAI._num_rt,"SP":BENTUPAI._num_sp,"OP":BENTUPAI._num_op})
	p_2.text="{NP}\n{RT}\n{SP}\n{OP}".format({"NP": WAIDIPAI._num_all, "RT": WAIDIPAI._num_rt,"SP":WAIDIPAI._num_sp,"OP":WAIDIPAI._num_op}) 
	await get_tree().create_timer(0.5).timeout
	#合计同意
	#合计反对
	#通过率
	#结果
	var totalSp:int=BENTUPAI._num_sp+WAIDIPAI._num_sp+HAOZUPAI._num_sp
	var totalOp:int=BENTUPAI._num_op+WAIDIPAI._num_op+HAOZUPAI._num_op
	var totalNum:int=BENTUPAI._num_all+WAIDIPAI._num_all+HAOZUPAI._num_all
	var totalrate=(totalSp/totalNum)*100
	var isPass:String="通过"
	if(totalrate>50):
		isPass="通过"
	else:
		isPass="未通过"
	o_1.text="{AS}\n{AP}\n{RATE}%\n{FINAL}".format({"AS": totalSp, "AP":totalOp ,"RATE":totalrate,"FINAL":isPass})
	
	pass


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
