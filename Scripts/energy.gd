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
	
	if currenceValue>=targetValue:
		if(GameManager.sav.TargetDestination=="rest"):
			target_label.text="任务已完成，休息进入下一天推进剧情"
		elif GameManager.sav.TargetDestination=="自宅":
			target_label.text="任务已完成，请返回自宅触发下一阶段剧情"
		elif GameManager.sav.TargetDestination=="府邸":
			target_label.text="任务已完成，请前往府邸触发下一阶段剧情"
		elif GameManager.sav.TargetDestination=="议事厅":
			target_label.text="任务已完成，请前往议事厅触发下一阶段剧情"
		elif GameManager.sav.TargetDestination=="演武场":
			target_label.text="任务已完成，请前往演武场触发下一阶段剧情"
		elif GameManager.sav.TargetDestination=="大儒辩经":
			target_label.text="任务已完成，请前往城外和大儒辩经触发下一阶段剧情"
		else:
			GameManager.sav.TargetDestination=GameManager.sav.TargetDestination	
	else:
		target_label.text=GameManager.sav.targetTxt.format({"target":targetValue,"currence":currenceValue})
	pass
@onready var animation_player = $TargetLabel/AnimationPlayer

func playLabelChange():
	animation_player.play("targetlabel")


func _on_item_button_button_down():
	pass # Replace with function body.


func _on_save_button_button_down():
	PanelManager.show_Save_panel()
	pass # Replace with function body.
