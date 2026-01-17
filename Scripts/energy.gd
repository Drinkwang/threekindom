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


	var iscompleteTask=false    
	if  currenceValue is Array:
		if currenceValue[0]>=GameManager.sav.targetValue and currenceValue[1]>=3:
			iscompleteTask=true
	else:
		if currenceValue>=GameManager.sav.targetValue:
			iscompleteTask=true
				
	if iscompleteTask:
		if(GameManager.sav.TargetDestination=="rest"):
			target_label.text=tr("任务已完成，休息进入下一天推进剧情")
		elif GameManager.sav.TargetDestination=="自宅":
			target_label.text=tr("任务已完成，请返回自宅触发下一阶段剧情")
		elif GameManager.sav.TargetDestination=="府邸":
			if GameManager.sav.targetResType==GameManager.ResType.govern and not GameManager.dontHaveDominance():

				target_label.text=tr("主线已毕，霸道镇压尚未达成。\n可继续镇压派系，亦可返回府邸交付任务。")
			else:
				target_label.text=tr("任务已完成，请前往府邸触发下一阶段剧情")
		elif GameManager.sav.TargetDestination=="议事厅":
			target_label.text=tr("任务已完成，请前往议事厅触发下一阶段剧情")
		elif GameManager.sav.TargetDestination=="演武场":
			target_label.text=tr("任务已完成，请前往演武场触发下一阶段剧情")
		elif GameManager.sav.TargetDestination=="大儒辩经":
			target_label.text=tr("任务已完成，请前往城外和大儒辩经触发下一阶段剧情")
		else:
			target_label.text=tr(GameManager.sav.TargetDestination)	
	else:
		
		if  currenceValue is Array:
			if currenceValue[1]<3:
				target_label.text=tr(GameManager.sav.targetTxt).format({"target":targetValue,"currence1":currenceValue[0],"currence2":currenceValue[1]})
			else:
				var strContext=tr("基建已完成，请征集民夫完成后前往府邸触发下一阶段剧情")	
				strContext+=tr("征集民夫数量：{currence1}/{target}").format({"target":targetValue,"currence1":currenceValue[0]})
				target_label.text=strContext
		else:
			target_label.text=tr(GameManager.sav.targetTxt).format({"target":targetValue,"currence":currenceValue})
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
			var context=tr("%s指定《%s》，7天内通过，还剩%d天！")%[tr(law),GameManager.sav.courtingLaws[law],cd]
			target_label.text=target_label.text+context
	#target_label.text=target_label.text+
@onready var animation_player = $TargetLabel/AnimationPlayer
@onready var auto_label = $AutoLabel
@onready var auto_player = $AutoLabel/AutoPlayer

@onready var autotimer = $AutoLabel/Timer

func showAutoSaveANI():
	auto_label.show()
	auto_player.play("AUTO")

func endAutoSave():
	autotimer.timeout.connect(hideAutoSaveANI)
	autotimer.start()		
func hideAutoSaveANI():
	auto_label.hide()
	auto_player.play("RESET")
func playLabelChange():
	animation_player.play("targetlabel")

@onready var inventory_any = $TargetLabel/InventoryAny

func _on_item_button_button_down():
	if GameManager.CanClickUI==false:
		return
	if inventory_any.visible:
		inventory_any.hide()
	else:
		inventory_any.show()

const sys = preload("res://dialogues/系统.dialogue")
func _on_save_button_button_down():
	
	if GameManager.CanClickUI==false:
		return
	#DialogueManager.show_example_dialogue_balloon(sys,"当前功能demo不开放")
	PanelManager.show_Save_panel()
	#demo注释


func _on_click_hero_button_down():
	GameManager.openSetting()

@onready var label: Label = $Label

func _on_timer_timeout() -> void:
	pass
	#if GameManager.sav.remaining_seconds >= 0:
	#	GameManager.sav.remaining_seconds -= 1
	#	_update_label()
func _update_label() -> void:
	if not label:
		return
	var m := GameManager.sav.remaining_seconds / 60
	var s := GameManager.sav.remaining_seconds % 60
	label.text = "剩余试玩时间 %02d:%02d" % [m, s]
