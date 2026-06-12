extends PanelContainer
class_name factionalname
@onready var progress_bar = $MarginContainer/HBoxContainer/VBoxContainer/ProgressBar
@onready var label:Label = $MarginContainer/HBoxContainer/VBoxContainer/Label
var itemData:cldata
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.changeLanguage.connect(changeLanguage)
	changeLanguage()

	pass # Replace with function body.



@onready var v_box_container: VBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer


func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()

	if currencelanguage=="ru":

		label.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))

	else:
		label.remove_theme_font_override("font")
	refreshData()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	pass

func init(item:cldata):
	itemData=item
	refreshData()

const sys = preload("res://dialogues/系统.dialogue")
func refreshData():
	if itemData==null:
		return
	var statusTxt=""
	var supportValue=itemData._support_rate
	label .text=tr(itemData._name)+tr("-支持度：")
	progress_bar.value=itemData._support_rate
	if itemData.isSuppressed==true:
		var sb = StyleBoxFlat.new()
		progress_bar.add_theme_stylebox_override("fill", sb)

		sb.bg_color = Color.GRAY

	elif itemData.index==cldata.factionIndex.weidipai:
		var sb = StyleBoxFlat.new()
		progress_bar.add_theme_stylebox_override("fill", sb)
		if supportValue>=60:
			sb.bg_color = Color.RED
		else:
			sb.bg_color=Color.DARK_RED
	elif itemData.index==cldata.factionIndex.bentupai:
		var sb = StyleBoxFlat.new()
		progress_bar.add_theme_stylebox_override("fill", sb)
		if supportValue>=60:
			sb.bg_color = Color.GREEN
		else:
			sb.bg_color = Color.DARK_GREEN
	elif itemData.index==cldata.factionIndex.haozupai:
		var sb = StyleBoxFlat.new()
		progress_bar.add_theme_stylebox_override("fill", sb)
		if supportValue>=60:
			sb.bg_color = Color.BLUE
		else:
			sb.bg_color = Color.DARK_BLUE
			#if itemData.isAlertRisk==false:
	elif itemData.index==cldata.factionIndex.lvbu:
		var sb = StyleBoxFlat.new()
		progress_bar.add_theme_stylebox_override("fill", sb)
		if supportValue>=60:
			sb.bg_color = Color.GRAY
		else:
			sb.bg_color = Color.DARK_GRAY
			#if itemData.isAlertRisk==false:
	if(supportValue<60 and itemData.index!=cldata.factionIndex.lvbu and itemData.isAlertRisk==false and DialogueManager.dialogBegin==false):#必须没有其它对话
		itemData.isAlertRisk=true
		GameManager.resideValue=itemData._name
		#必须在第一时间调用，错过了不该调用
		#DialogueManager.show_example_dialogue_balloon(sys,"警告叛乱风险")
	elif (supportValue<80 and itemData.index==cldata.factionIndex.lvbu and itemData.isAlertRisk==false):
		itemData.isAlertRisk=true
		#DialogueManager.show_example_dialogue_balloon(sys,"吕布风险")
	if itemData.isSuppressed==true:
		if timer.is_stopped():
			timer.start()
		statusTxt=tr("【状态：已镇压,派系正受严密监控。因积怨难平，好感度持续衰减，须施以恩赏方可平息。】")
	else:
		timer.stop()
	if itemData.supressNum>=3:
		statusTxt=tr("【状态：彻底收服,派系已被完全驯化。因畏服权威，好感度永久锁定，不再受任何影响。】")

	var font_size = label.get_theme_font_size("font_size")
	var text_width = label.get_theme_font("font").get_string_size(label.text,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size).x
	if GameManager.maxResPanelX<=text_width:
		GameManager.maxResPanelX=text_width

	TooltipManager.register_tooltip(self,itemData.detail+statusTxt)
	#【状态：镇压中，当前派系会不断消耗好感度，直到玩家采取讨好当前派系的手段】
	#【状态：已臣服，当前派系受到玩家多次镇压，已再无反抗之心，好感度将不再发生变化】

@onready var timer = $Timer


func refreshSameX():
	label.custom_minimum_size.x=GameManager.maxResPanelX


func _on_timer_timeout():
	if itemData.isSuppressed==true:
		if itemData.supressNum>=3:
			timer.stop()
			return
		# 直接修改好感度，不走 ChangeSupport 级联链
		#（避免触发 changeFloor → initPaixiFloor → changeSupport → _processList 误杀其他派系的 timer）
		var new_val = max(0, itemData._support_rate - 1)
		if new_val == itemData._support_rate:
			return
		itemData._support_rate = new_val
		# 完整重算派系人数分布（与 initPaixiFloor 一致，但不触发 changeSupport）
		var total = itemData._num_all
		itemData._num_op = int(total * (100 - new_val) / 100.0 + 0.5)
		# 法律效果修正
		var lawIndex = GameManager.getIndexByFractionIndex(itemData.index)
		if lawIndex != GameManager.sav.curLawNum1 and GameManager.sav.curLawNum1 != -1:
			var lawOp = ((GameManager.sav.curLawNum2 - 1) * 10.0 / 100.0) * (total - itemData._num_op)
			itemData._num_op += int(lawOp)
		var maxRt = max(0, total - itemData._num_op)
		var initRt = randf_range(0, min(itemData._num_op * 2.0, maxRt))
		if itemData._num_rt > initRt:
			initRt = min(itemData._num_rt, maxRt)
		if GameManager.sav.curLawNum1 < 0:
			initRt = 0
		itemData._num_rt = int(initRt)
		itemData._num_sp = max(0, total - itemData._num_op - itemData._num_rt)
		# 更新自己的 UI
		progress_bar.value = new_val
		# 只发 UI 刷新信号（不会触发 _processList 销毁节点）
		SignalManager.changeFraction.emit()
