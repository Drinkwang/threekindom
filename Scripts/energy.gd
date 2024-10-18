extends Control
class_name energe
@onready var progress_bar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager._engerge=self
	changerate(GameManager.hp)
	pass # Replace with function body.


func _process(delta):
	if(GameManager.sav.targetTxt!=null and GameManager.sav.targetTxt.length()>0):
		showTargetLabel()
func changerate(rate):
	progress_bar.value=rate

@onready var target_label = $TargetLabel

func showTargetLabel():
	var targetValue=GameManager.sav.targetValue
	#获取当前值的枚举类型，根据枚举类型获取对应资源数值，并把资源数值填写进下面的函数
	var currenceValue=GameManager.getTaskCurrenceValue()
	# target，currence
	
	if currenceValue>=currenceValue:
		target_label.text="任务已完成，休息进入下一天推进剧情"
	else:
		target_label.text=GameManager.sav.targetTxt.format({"target":targetValue,"currence":currenceValue})
	pass



func _on_item_button_button_down():
	pass # Replace with function body.


func _on_save_button_button_down():
	PanelManager.show_Save_panel()
	pass # Replace with function body.
