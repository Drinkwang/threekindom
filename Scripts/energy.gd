extends Control
class_name energe
@onready var progress_bar = $TextureProgressBar

# Called when th$TextureProgressBare node enters the scene tree for the first time.
func _ready():
	GameManager._engerge=self
	changerate(GameManager.sav.hp)
	changeTargetLabel()


func changeTargetLabel():
	if(GameManager.sav.targetTxt==null || GameManager.sav.targetTxt.length()==0):
		if GameManager.sav.TargetDestination!=null and GameManager.sav.TargetDestination.length()>0:
			target_label.text=GameManager.sav.TargetDestination
	

@onready var rateLabel=$TextureProgressBar/Label
func _process(delta):
	if(GameManager.sav.targetTxt!=null and GameManager.sav.targetTxt.length()>0):
		showTargetLabel()
func changerate(rate):
	progress_bar.value=rate
	rateLabel.text=var_to_str(rate)+"%"

@onready var target_label = $TargetLabel

func showTargetLabel():
	var targetValue=GameManager.sav.targetValue
	#获取当前值的枚举类型，根据枚举类型获取对应资源数值，并把资源数值填写进下面的函数
	var currenceValue=GameManager.getTaskCurrenceValue()
	# target，currence
	
	if currenceValue>=targetValue:
		if(GameManager.sav.TargetDestination=="rest"):
			target_label.text=tr("任务已完成，休息进入下一天推进剧情")
		elif GameManager.sav.TargetDestination=="自宅":
			target_label.text=tr("任务已完成，请返回自宅触发下一阶段剧情")
		elif GameManager.sav.TargetDestination=="府邸":
			target_label.text=tr("任务已完成，请前往府邸触发下一阶段剧情")
		elif GameManager.sav.TargetDestination=="议事厅":
			target_label.text=tr("任务已完成，请前往议事厅触发下一阶段剧情")
		elif GameManager.sav.TargetDestination=="演武场":
			target_label.text=tr("任务已完成，请前往演武场触发下一阶段剧情")
		elif GameManager.sav.TargetDestination=="大儒辩经":
			target_label.text=tr("任务已完成，请前往城外和大儒辩经触发下一阶段剧情")
		else:
			target_label.text=GameManager.sav.TargetDestination	
	else:
		target_label.text=GameManager.sav.targetTxt.format({"target":targetValue,"currence":currenceValue})
	for law in GameManager.sav.courtingLaws:

		var cd
		if law=="本土派"||law=="士族派":
			cd=GameManager.sav.xuzhouCD
		elif law=="豪族派":
			cd=GameManager.sav.haozuCD
		elif law=="外地派":
			cd=GameManager.sav.danyangCD
		
		if(cd>0):	
			target_label.text=target_label.text+"\n"
			var context=tr("%s指定《%s》，7天内通过，还剩%d天！")%[law,GameManager.sav.courtingLaws[law],cd]
			target_label.text=target_label.text+context
	#target_label.text=target_label.text+
@onready var animation_player = $TargetLabel/AnimationPlayer

func playLabelChange():
	animation_player.play("targetlabel")

@onready var inventory_any = $TargetLabel/InventoryAny

func _on_item_button_button_down():
	if inventory_any.visible:
		inventory_any.hide()
	else:
		inventory_any.show()


func _on_save_button_button_down():
	PanelManager.show_Save_panel()
	pass # Replace with function body.
