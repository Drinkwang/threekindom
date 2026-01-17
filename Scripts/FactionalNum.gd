extends PanelContainer
class_name factionalname
@onready var progress_bar = $MarginContainer/HBoxContainer/VBoxContainer/ProgressBar
@onready var label:Label = $MarginContainer/HBoxContainer/VBoxContainer/Label
var itemData
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
		DialogueManager.show_example_dialogue_balloon(sys,"警告叛乱风险")
	elif (supportValue<80 and itemData.index==cldata.factionIndex.lvbu and itemData.isAlertRisk==false):	
		itemData.isAlertRisk=true
		DialogueManager.show_example_dialogue_balloon(sys,"吕布风险")	
	if itemData.isSuppressed==true:
		timer.start()
	else:
		timer.stop()
		
		
	var font_size = label.get_theme_font_size("font_size")	
	var text_width = label.get_theme_font("font").get_string_size(label.text,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size).x
	if GameManager.maxResPanelX<=text_width:
		GameManager.maxResPanelX=text_width

		
	
@onready var timer = $Timer


func refreshSameX():
	label.custom_minimum_size.x=GameManager.maxResPanelX


func _on_timer_timeout():
	if itemData.isSuppressed==true:
		itemData.ChangeSupport(-1)
	#itemData # Replace with function body.
