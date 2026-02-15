extends Control


@onready var close_button: TextureButton =$closeButton

# Called when the node enters the scene tree for the first time.
func _ready():
	initLanguage()
	SignalManager.changeLanguage.connect(initLanguage)
	close_button.scale=Vector2(NORMAL_SCALE, NORMAL_SCALE)
	_setup_button_hover(close_button)
	close_button.pressed.connect(_ondeleteSave)
	update_close_button_position()
const HOVER_SCALE: float = 0.45
const NORMAL_SCALE: float = 0.4
const HOVER_DURATION: float = 0.15
@export var index=-1

func _ondeleteSave():
	save_panel.deleteData=self
	save_panel.showDialogueDelete()
	

@onready var panel_container: PanelContainer = $PanelContainer

func update_close_button_position() -> void:
	pass
	# 获取 PanelContainer 在其自身坐标系内的大小
	## 明确使用 Control 类型的 rect_size
	#var panel_size: Vector2 = (panel_container as Control).rect_size
	#
	#var offset: Vector2 = Vector2(-10, 10)
	#var button_pos: Vector2 = Vector2(panel_size.x, 0) + offset
	#
	#close_button.rect_position = button_pos
	
@onready var color_rect: ColorRect = $ColorRect
	
	
func confiredelete():
	var path="user://save_data{index}.tres".format({"index":index+1})

	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)

		save_panel.savs[index] = null
		color_rect.hide()
		close_button.hide()
		nodate.show()
		label.hide()
		print("存档 {index} 已删除".format({"index": index + 1}))	

func _setup_button_hover(button: TextureButton) -> void:
	button.mouse_entered.connect(_on_button_hover.bind(button))
	button.mouse_exited.connect(_on_button_unhover.bind(button))



func _on_button_hover(button: TextureButton) -> void:
	# 更新pivot以防尺寸变化
	#button.pivot_offset = button.size / 2

	# 创建缩放动画
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	#tween.tween_property(button, "scale", Vector2(HOVER_SCALE, HOVER_SCALE), HOVER_DURATION)

	# 增加亮度
	tween.parallel().tween_property(button, "modulate", Color(1.2, 1.2, 1.2, 1.0), HOVER_DURATION)

func _on_button_unhover(button: TextureButton) -> void:
	# 恢复原始大小
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	#tween.tween_property(button, "scale", Vector2(NORMAL_SCALE, NORMAL_SCALE), HOVER_DURATION)

	# 恢复正常亮度
	tween.parallel().tween_property(button, "modulate", Color(1.0, 1.0, 1.0, 1.0), HOVER_DURATION)

	
@onready var nodate = $nodate
	
const NOT_JAM_UI_CONDENSED_16 = preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")
	
const BAKUDAI_BOLD = preload("res://Asset/Font/Bakudai-Bold.ttf")
func initLanguage():
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="ja":
		#nodate.add_theme_font_size_override("font",42)
		nodate.add_theme_font_override("font",BAKUDAI_BOLD)
		label.add_theme_font_override("font",BAKUDAI_BOLD)
		label.add_theme_constant_override("line_spacing",0)
	elif currencelanguage=="ru":
		label.add_theme_constant_override("line_spacing",-5)
		nodate.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		label.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		nodate.add_theme_font_size_override("font_size",50)
	else:
		label.add_theme_constant_override("line_spacing",0)
		nodate.add_theme_font_size_override("font_size",72)
		nodate.add_theme_font_override("font",BAKUDAI_BOLD)
		label.add_theme_font_override("font",BAKUDAI_BOLD)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
@onready var label = $Label


func refresh(sav:saveData):
	nodate.hide()
	label.show()
	close_button.show()
	color_rect.show()
	#GameManager.sav.current_datetime
	var formatStr=tr("savefiledata")
	if sav.autoSave == true:
		formatStr=("({auto})").format({"auto":tr("自动存档")})+"\n"+formatStr

	label.text=formatStr.format({"current_datetime":sav.current_datetime,"day":sav.day,"coin":sav.coin,"heart":sav.people_surrport,"people":sav.labor_force})
	
@onready var save_panel: savePanel = $"../../.."

	
func delete():
	nodate.show()
	label.hide()
	close_button.hide()
	color_rect.hide()
	
