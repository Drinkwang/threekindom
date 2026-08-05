

extends Control
class_name policyPanel
@export var index=0
@onready var button = $PanelContainer/orderPanel/VBoxContainer/HBoxContainer/Button
@onready var tab_bar = $TabBar
@onready var point_label = $lawPanel/PointLabel
@onready var law_label = $lawPanel/DetailPanel/Label2
@onready var exp_len = $PanelContainer/orderPanel2/VBoxContainer/expLen
@onready var tourPoint: Node2D = $Node2D
@onready var policy_panel_container: PanelContainer = $PanelContainer

const LAW_TAB_INDEX := 1
const POLICY_DETAIL_BASE_FONT_SIZE := 31
const POLICY_PANEL_BASE_OFFSET_BOTTOM := 411.0

@export_range(10.0, 20.0, 1.0) var policy_detail_bottom_spacing := 15.0
@export_range(10, 31, 1) var policy_detail_min_font_size := 18
@export_range(0.0, 250.0, 1.0) var policy_panel_max_extra_height := 124.0
@export_range(10.0, 40.0, 1.0) var policy_panel_viewport_bottom_margin := 20.0

var _policy_detail_fit_generation := 0

var tab_bar_emphasis_panel: Panel
var tab_bar_emphasis_tween: Tween
var tab_bar_emphasis_tab_index := LAW_TAB_INDEX
var tab_bar_emphasis_showing := false


func showTourPoint():
	tourPoint.show()
	$"Node2D/5Yellow/AnimationPlayer".play("YELLOWGUILD")
	showLawTabEmphasis()

func showLawTabEmphasis():
	showTabBarEmphasis(LAW_TAB_INDEX)

func showTabBarEmphasis(tab_index := LAW_TAB_INDEX):
	tab_bar_emphasis_tab_index = tab_index
	tab_bar_emphasis_showing = true
	_ensureTabBarEmphasisPanel()
	_refreshTabBarEmphasis()
	call_deferred("_refreshTabBarEmphasis")
	tab_bar_emphasis_panel.show()
	tab_bar_emphasis_panel.modulate.a = 1.0
	if tab_bar_emphasis_tween != null:
		tab_bar_emphasis_tween.kill()
	tab_bar_emphasis_tween = create_tween()
	tab_bar_emphasis_tween.set_loops()
	tab_bar_emphasis_tween.tween_property(tab_bar_emphasis_panel, "modulate:a", 0.25, 0.45).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tab_bar_emphasis_tween.tween_property(tab_bar_emphasis_panel, "modulate:a", 1.0, 0.45).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func hideLawTabEmphasis():
	hideTabBarEmphasis()

func hideTabBarEmphasis():
	tab_bar_emphasis_showing = false
	if tab_bar_emphasis_tween != null:
		tab_bar_emphasis_tween.kill()
		tab_bar_emphasis_tween = null
	if tab_bar_emphasis_panel != null and is_instance_valid(tab_bar_emphasis_panel):
		tab_bar_emphasis_panel.hide()
		tab_bar_emphasis_panel.modulate.a = 1.0

func _ensureTabBarEmphasisPanel():
	if tab_bar_emphasis_panel != null and is_instance_valid(tab_bar_emphasis_panel):
		return
	tab_bar_emphasis_panel = Panel.new()
	tab_bar_emphasis_panel.name = "TabBarEmphasis"
	tab_bar_emphasis_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tab_bar_emphasis_panel.visible = false
	tab_bar_emphasis_panel.z_index = 10
	var stylebox := StyleBoxFlat.new()
	stylebox.bg_color = Color(1.0, 0.78, 0.22, 0.08)
	stylebox.border_color = Color(1.0, 0.78, 0.22, 1.0)
	stylebox.set_border_width_all(4)
	stylebox.set_corner_radius_all(8)
	tab_bar_emphasis_panel.add_theme_stylebox_override("panel", stylebox)
	add_child(tab_bar_emphasis_panel)

func _refreshTabBarEmphasis():
	if tab_bar_emphasis_panel == null or not is_instance_valid(tab_bar_emphasis_panel):
		return
	if tab_bar_emphasis_showing == false:
		return
	var highlight_rect := _getTabBarEmphasisRect(tab_bar_emphasis_tab_index)
	tab_bar_emphasis_panel.position = highlight_rect.position
	tab_bar_emphasis_panel.size = highlight_rect.size

func _getTabBarEmphasisRect(tab_index:int) -> Rect2:
	var padding := Vector2(6, 6)
	var tab_rect := Rect2()
	if tab_bar.has_method("get_tab_rect"):
		tab_rect = tab_bar.get_tab_rect(tab_index)
	else:
		var tab_count = max(tab_bar.get_tab_count(), 1)
		tab_rect = Rect2(Vector2(tab_bar.size.x / tab_count * tab_index, 0), Vector2(tab_bar.size.x / tab_count, tab_bar.size.y))
	return Rect2(tab_bar.position + tab_rect.position - padding, tab_rect.size + padding * 2.0)

var costhp=35
#@onready var button = $PanelContainer/orderPanel/VBoxContainer/HBoxContainer/Button
@onready var detail_panel = $lawPanel/DetailPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.changeLanguage.connect(changeLanguage)
	if not visibility_changed.is_connected(_on_policy_panel_visibility_changed):
		visibility_changed.connect(_on_policy_panel_visibility_changed)
	#if not resized.is_connected(_queue_policy_detail_font_fit):
		#resized.connect(_queue_policy_detail_font_fit)
	if GameManager.sav.hp<costhp:
	
		button.disabled=true
		
		pass
		
	pass
	#initControls()
	#changeLanguage()
	#_queue_policy_detail_font_fit()
	 # Replace with function body.


func initControls():
	_reset_policy_selection()

	var group=GameManager.getPolicyGroup()
		#GameManager.currenceScene.selectPolicy(self["control_"+index].data)
		#DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"xxx")
		#判断自己的逻辑
	#应该是第二天
	if group==-1 and GameManager.sav.policyExcute==false and GameManager.sav.day>=5:
		group=4
	if group==-1:
		currence_no_policy.show()
		$PanelContainer/orderPanel/VBoxContainer.hide()
	else:
		$PanelContainer/orderPanel/VBoxContainer.show()
		currence_no_policy.hide()
		GameManager.currenceScene._initGroup(group)
		control_1.initDataByGroup(1,group)
		control_2.initDataByGroup(2,group)
		control_3.initDataByGroup(3,group)

var expLenWidth=1240		

@onready var ConfireButton = $lawPanel/DetailPanel/Button

func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	
	if currencelanguage=="ru":
		expLenWidth=1325
		tourPoint.position.x=-130
		currence_no_policy.add_theme_font_size_override("font_size",45)
		ConfireButton.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		tab_bar.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		#label.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		law_label.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))	
		#currence_no_policy.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))	
	else:
		if currencelanguage=="en":
			tourPoint.position.x=-405
		elif currencelanguage=="ja":
			tourPoint.position.x=-250
		else:
			tourPoint.position.x=-344
		currence_no_policy.add_theme_font_size_override("font_size",66)
		expLenWidth=1240
		ConfireButton.remove_theme_font_override("font")
		tab_bar.remove_theme_font_override("font")
		#label.remove_theme_font_override("font")
		law_label.remove_theme_font_override("font")
		#currence_no_policy.remove_theme_font_override("font")
	#point_label.text=tr("点数:%s")%GameManager.sav.Merit_points
	refreshLawPoint()
	_refreshCurrentDescription()
	_queue_policy_detail_font_fit()
	
	if GameManager.sav.gameDifficulty==1:
		TooltipManager.register_tooltip(ConfireButton,tr("立法收益仅在表决通过后生效。本难度下，仅点亮立法节点会扣除受损派系支持度，法案通过不再重复扣除。"))
	else:
		TooltipManager.register_tooltip(ConfireButton,tr("立法的好处仅表决通过后获得；点亮节点、立法通过均会扣除受损派系支持度。"))

func _refreshCurrentDescription():
	if selectLawPoint!=null:
		law_label.text=_getLocalizedLawDetail(selectLawPoint)
		changeexp_len()
	elif GameManager.sav.curLawName.length()>0:
		law_label.text=tr("当前【%s】法案已被立项，请先在议事厅通过该法案，才能立项其他法律。") % tr(GameManager.sav.curLawName)
		changeexp_len()
	elif index>=1 and index<=3:
		var selected_item:policyItem=get("control_%d"%index)
		label.text=tr(selected_item.context)+":"+selected_item.detail
		canHideBlockShow()

func _getLocalizedLawDetail(value:lawpoint)->String:
	var context:String="{bg}({Txt})".format({"bg":tr(value.IncomeBg),"Txt":tr(value.IncomeTxt)})
	if "[danyang]" in context:
		context=context.replace("[danyang]",tr("丹阳派"))
	if "[shizu]" in context:
		context=context.replace("[shizu]",tr("士族派") if GameManager.sav.have_event["Factionalization"] else tr("本土派"))
	if "[haozu]" in context:
		context=context.replace("[haozu]",tr("豪族派") if GameManager.sav.have_event["Factionalization"] else tr("本土派"))
	return context
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _initData():
	#_on_control_1_gui_input()
	if GameManager.sav.have_event["firstLawExecute"]==false and GameManager.sav.day<5:
		$TextureButton.hide()
	else:
		$TextureButton.show()
	if GameManager.sav.curLawName.length()>0:
		show_current_law_pending_message()
		#var label_height = 81
		#var label_line_count = law_label.get_line_count()  # 获取行数（可选）
		#var padding = 20  # 可根据需要调整
		#var new_size = Vector2(detail_panel.custom_minimum_size.x, label_height +label_line_count* padding)
		#exp_len.custom_minimum_size=Vector2(expLenWidth,new_size.y-81)

		#detail_panel.custom_minimum_size = new_size
	
	refreshLawPoint()
	
# This is the default text while a bill awaits approval. Read-only law nodes may temporarily replace it.
func show_current_law_pending_message() -> void:
	selectLawPoint = null
	ConfireButton.disabled = true
	law_label.text = tr("当前【%s】法案已被立项，请先在议事厅通过该法案，才能立项其他法律。") % tr(GameManager.sav.curLawName)
	if is_instance_valid(GameManager._engerge):
		GameManager._engerge.stopPreviewHP()
	changeexp_len()

func changeexp_len():

	var label_height = 81
	var label_line_count = law_label.get_line_count()  # 获取行数（可选）
	var padding = 20  # 可根据需要调整
	var new_size = Vector2(1295+expLenWidth-1240, label_height +label_line_count* padding)
	exp_len.custom_minimum_size=Vector2(expLenWidth,new_size.y-81)
		# 应用到 Panel
	detail_panel.custom_minimum_size = new_size
func refreshLawPoint():
	#if tab==0:
	#	return 
	get_tree().call_group("lawpoints","_initData")
	if GameManager.sav.curLawName.length()>0 or GameManager.sav.curLawNum1!=-1 or GameManager.sav.curLawNum2!=-1:
		ConfireButton.disabled=true
	else:
		ConfireButton.disabled=false
	point_label.text=tr("点数:%s")%GameManager.sav.Merit_points
	#+"\n"+"上限:{x}/{max}".format({"x":GameManager.LawNum(),"max":GameManager.maxLawNum})
	var tabcontext=" {x}/{max}".format({"x":GameManager.LawNum(),"max":GameManager.maxLawNum})
	tab_bar.set_tab_title(1,tr("法律法规")+tabcontext)
@onready var LawPanelBoard = $PanelContainer/orderPanel2


func _on_tab_bar_tab_changed(tab):
	tourPoint.hide()
	hideLawTabEmphasis()
	if tab==0:
		$lawPanel.hide()
		LawPanelBoard.hide()
		$PanelContainer/orderPanel.show()
		_queue_policy_detail_font_fit()
	else:
		policy_panel_container.offset_bottom = POLICY_PANEL_BASE_OFFSET_BOTTOM
		$lawPanel.show()
		LawPanelBoard.show()
		changeexp_len()
		$PanelContainer/orderPanel.hide()
		if GameManager.sav.have_event["firstTabLaw"]==false:
			GameManager.sav.have_event["firstTabLaw"]=true
			DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"第一次指定法律")
		#判断剧情是否触发，如果没触发触发剧情
	#pass # Replace with function body.
	previewCostView()
	_initData()

@onready var control_1 = $PanelContainer/orderPanel/VBoxContainer/orderVbox/Control_1
@onready var control_2 = $PanelContainer/orderPanel/VBoxContainer/orderVbox/Control_2
@onready var control_3 = $PanelContainer/orderPanel/VBoxContainer/orderVbox/Control_3

@onready var label = $PanelContainer/orderPanel/VBoxContainer/Label

func _on_control_1_gui_input(event):
	

	if control_1.canclick==false:
		return
	if(event is InputEventMouseButton and event.button_index==1):
		index=1
		
		button.disabled=false
		SoundManager.play_sound(sounds.CLICKHERO)
		control_1.check_box.button_pressed=true
		control_2.check_box.button_pressed=false
		control_3.check_box.button_pressed=false
		label.text=tr(control_1.context)+":"+tr(control_1.detail)
		canHideBlockShow()

func _on_control_2_gui_input(event):
	

	if control_2.canclick==false:
		return
	if(event is InputEventMouseButton and event.button_index==1):	
		index=2		
		button.disabled=false
		SoundManager.play_sound(sounds.CLICKHERO)
		control_1.check_box.button_pressed=false
		control_2.check_box.button_pressed=true
		control_3.check_box.button_pressed=false
		label.text=tr(control_2.context)+":"+tr(control_2.detail)	
		canHideBlockShow()
@onready var can_hide_block = $PanelContainer/orderPanel/VBoxContainer/canHideBlock


func previewCostView():
	if GameManager.haveMirror()==false:
		return
	if tab_bar.current_tab==0:
		if index!=0:
			GameManager._engerge.startPreviewHp(costhp)
		else:
			GameManager._engerge.stopPreviewHP()
	elif tab_bar.current_tab==1:
		if selectLawPoint!=null:
			GameManager._engerge.startPreviewHp(costhp)
		else:
			GameManager._engerge.stopPreviewHP()		

func _on_control_3_gui_input(event):
	

	if control_3.canclick==false:
		return
	if(event is InputEventMouseButton and event.button_index==1):
		SoundManager.play_sound(sounds.CLICKHERO)
		index=3
		button.disabled=false
		
		control_1.check_box.button_pressed=false
		control_2.check_box.button_pressed=false
		control_3.check_box.button_pressed=true
		label.text=tr(control_3.context)+":"+tr(control_3.detail)	
		canHideBlockShow()
		
func canHideBlockShow():		
	label.add_theme_font_size_override("font_size", POLICY_DETAIL_BASE_FONT_SIZE)
	var lines = _get_policy_detail_line_count(POLICY_DETAIL_BASE_FONT_SIZE)
	if lines >= 5:
		can_hide_block.hide()
	else:
		can_hide_block.show()	
	_queue_policy_detail_font_fit()
	previewCostView()	

func _reset_policy_selection() -> void:
	index = 0
	button.disabled = true
	control_1.check_box.button_pressed = false
	control_2.check_box.button_pressed = false
	control_3.check_box.button_pressed = false
	label.text = tr("请点击政策获取施政的详细信息")
	label.add_theme_font_size_override("font_size", POLICY_DETAIL_BASE_FONT_SIZE)
	can_hide_block.show()
	policy_panel_container.offset_bottom = POLICY_PANEL_BASE_OFFSET_BOTTOM
	_queue_policy_detail_font_fit()

func _queue_policy_detail_font_fit() -> void:
	if not is_node_ready():
		return
	_policy_detail_fit_generation += 1
	_fit_policy_detail_font(_policy_detail_fit_generation)
	#call_deferred("_fit_policy_detail_font", _policy_detail_fit_generation)

func _on_policy_panel_visibility_changed() -> void:
	await get_tree().process_frame
	changeLanguage()

func _fit_policy_detail_font(generation: int) -> void:
	if generation != _policy_detail_fit_generation or not is_visible_in_tree():
		return
	#if _is_fitting_policy_detail:
		#call_deferred("_fit_policy_detail_font", generation)
		#return


	label.add_theme_font_size_override("font_size", POLICY_DETAIL_BASE_FONT_SIZE)
	var required_height: float = _measure_policy_detail_height(POLICY_DETAIL_BASE_FONT_SIZE)
	var base_available_height: float = _get_policy_detail_base_available_height()
	var allowed_extra_height: float = _get_policy_panel_allowed_extra_height()
	var extra_height: float = clampf(required_height - base_available_height, 0.0, allowed_extra_height)
	var available_height: float = base_available_height + extra_height
	var font_size: int = POLICY_DETAIL_BASE_FONT_SIZE
	while font_size > policy_detail_min_font_size:
		if _measure_policy_detail_height(font_size) <= available_height:
			break
		font_size -= 1

	label.add_theme_font_size_override("font_size", font_size)
	policy_panel_container.offset_bottom = POLICY_PANEL_BASE_OFFSET_BOTTOM + extra_height
	await get_tree().process_frame
	if generation != _policy_detail_fit_generation or tab_bar.current_tab != 0:
		policy_panel_container.offset_bottom = POLICY_PANEL_BASE_OFFSET_BOTTOM

		return

	var viewport_limit: float = get_viewport().get_visible_rect().end.y - policy_panel_viewport_bottom_margin
	while font_size > policy_detail_min_font_size and _get_policy_panel_actual_bottom() > viewport_limit:
		font_size -= 1
		label.add_theme_font_size_override("font_size", font_size)
		await get_tree().process_frame
		if generation != _policy_detail_fit_generation or tab_bar.current_tab != 0:
			policy_panel_container.offset_bottom = POLICY_PANEL_BASE_OFFSET_BOTTOM

			return

	label.add_theme_font_size_override("font_size", font_size)


func _get_policy_panel_allowed_extra_height() -> float:
	var parent_control: Control = policy_panel_container.get_parent_control()
	var intended_top: float = policy_panel_container.global_position.y
	if parent_control != null:
		intended_top = parent_control.global_position.y \
			+ parent_control.size.y * policy_panel_container.anchor_top \
			+ policy_panel_container.offset_top
	var base_height: float = POLICY_PANEL_BASE_OFFSET_BOTTOM - policy_panel_container.offset_top
	var viewport_bottom: float = get_viewport().get_visible_rect().end.y
	var viewport_room: float = viewport_bottom - policy_panel_viewport_bottom_margin - intended_top - base_height
	return clampf(viewport_room, 0.0, policy_panel_max_extra_height)

func _get_policy_detail_base_available_height() -> float:
	var vbox: VBoxContainer = label.get_parent()
	var button_row: HBoxContainer = button.get_parent()
	var reserved_height: float = button_row.get_combined_minimum_size().y
	if can_hide_block.visible:
		reserved_height += can_hide_block.get_combined_minimum_size().y
	var separation: int = vbox.get_theme_constant("separation")
	var visible_rows_after_label: int = 1 + int(can_hide_block.visible)
	reserved_height += separation * visible_rows_after_label
	var base_height: float = POLICY_PANEL_BASE_OFFSET_BOTTOM - policy_panel_container.offset_top
	var label_top_in_panel: float = label.global_position.y - policy_panel_container.global_position.y
	return maxf(1.0, base_height - label_top_in_panel - reserved_height - policy_detail_bottom_spacing)

func _get_policy_panel_actual_bottom() -> float:
	return policy_panel_container.global_position.y + policy_panel_container.size.y

func _measure_policy_detail_height(font_size: int) -> float:
	var font: Font = label.get_theme_font("font")
	if font == null:
		return 0.0
	var text_height: float = font.get_multiline_string_size(
		label.text,
		label.horizontal_alignment,
		label.size.x,
		font_size,
		-1,
		TextServer.BREAK_MANDATORY | TextServer.BREAK_WORD_BOUND | TextServer.BREAK_ADAPTIVE
	).y
	var line_height: float = font.get_height(font_size)
	var line_count := maxi(1, ceili(text_height / line_height))
	return text_height + max(0, line_count - 1) * label.get_theme_constant("line_spacing")

func _get_policy_detail_line_count(font_size: int) -> int:
	var font: Font = label.get_theme_font("font")
	if font == null or label.size.x <= 0.0:
		return label.get_line_count()
	var text_height: float = font.get_multiline_string_size(
		label.text,
		label.horizontal_alignment,
		label.size.x,
		font_size,
		-1,
		TextServer.BREAK_MANDATORY | TextServer.BREAK_WORD_BOUND | TextServer.BREAK_ADAPTIVE
	).y
	return maxi(1, ceili(text_height / font.get_height(font_size)))
func bancontrol(_index,status):
	#get("ban%d"%index)=boolvalue
	#set("ban%d"%index,boolvalue)
	#var value=get("ban%d"%index)
	var item= get("control_%d"%_index) as policyItem
	item.setStatus(status)


func _disableAll():
	control_1.canclick=false
	control_2.canclick=false
	control_3.canclick=false

func _on_button_button_down():

	if await GameManager.isTried(costhp) or index==0:
		return
	
	SoundManager.play_sound(sounds.SFX_FAST_UI_CLICK_MECHANICAL_03_WAV)
	#var context="story"+index
	#根据选项判断影响，并同时让施政选项不再显示
	#get_tree().get_root().get_node("")

	GameManager.currenceScene.selectPolicy(self["control_"+var_to_str(index)].data,costhp)
	#每个上中下上册都有一个结构体，这边事后根据结构体对应id判断不同id点击施政的确切影响
	pass # Replace with function body.

var selectLawPoint:lawpoint
func preLaw(value:lawpoint):
	# Enacted laws are read-only: their effect is always viewable, even while another bill is pending.
	if value.isUnlock == false and await GameManager.isTried(costhp):
		return
	ConfireButton.show()
	selectLawPoint=value
	
	var context:String=_getLocalizedLawDetail(value)
	#if value.detail
	
	law_label.text=context
	
	ConfireButton.disabled=false
	if value.lawpoins.size()>0:
		if value.lawpoins.any(func(value):return value.isUnlock==true)==false:# and !GameManager.haveMirror():
			ConfireButton.disabled=true		
	if value.isUnlock==true:
		ConfireButton.disabled=true	
	if ConfireButton.disabled==false:
		previewCostView()
	changeexp_len()
	#var label_height = 81
	#var label_line_count = law_label.get_line_count()  # 获取行数（可选）
	#var padding = 20  # 可根据需要调整
	#var new_size = Vector2(detail_panel.custom_minimum_size.x, label_height +label_line_count* padding)
	
	# 应用到 Panel
	#detail_panel.custom_minimum_size = new_size
	
	#exp_len.custom_minimum_size=Vector2(expLenWidth,new_size.y-81)
	#detail_panel.size=new_size
	pass

func excuteLaw(value:lawpoint):

	if value==null:
		return
		
	if GameManager.sav.have_event["法律健全"]==false and GameManager.LawNum()>=GameManager.maxLawNum:
		DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"法律已满")
		return 
	#GameManager.hp=GameManager.hp-costhp
	if(GameManager.sav.Merit_points<GameManager.GET_COST_LAW_POINT()):
		DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"你的政策点不够")	
		return
	if await GameManager.isTried(costhp):
		return	
	if GameManager.sav.gameDifficulty!=1:
		GameManager.resideValue4=tr("【当前难度下，法案影响派系时，提案与通过都会扣对应派系支持度。】")
	else:
		GameManager.resideValue4=""
	if selectLawPoint!=null:
		DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"确认法律")
	else:
		DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"当前没有法律可执行")

func agreelaw():
	if await GameManager.isTried(costhp):
		return
	GameManager.sav.RewardLaw=tr(selectLawPoint.IncomeTxt)

	GameManager.sav.curLawName=selectLawPoint.context
	GameManager.sav.curLawNum1=selectLawPoint.num1
	GameManager.sav.curLawNum2=selectLawPoint.num2
	SignalManager.changeSupport.emit()
	#num1\num2
	# int index	
	#当前【民田开垦】法案已被立项，请先在议会厅通过该法案，才能立项其他法律。	
	GameManager.sav.hp=GameManager.sav.hp-costhp
	GameManager.sav.Merit_points=GameManager.sav.Merit_points-GameManager.GET_COST_LAW_POINT()
	selectLawPoint.isUnlock=true
	selectLawPoint._initData()

	GameManager.refreshPaixis()
	GameManager.sav.laws[selectLawPoint.num1].append(selectLawPoint.num2)
	
	#判断法律是否为即将达成的，如果是，则让其完成，获得好感度和目标
	#if GameManager.sav.gameDifficulty!=1:
	GameManager.preCostPaixi()
	#GameManager.haveLaw=true
	SoundManager.play_sound(sounds.confiresound)
	if GameManager.sav.have_event["firstLawExecute"]==false:
		GameManager.sav.have_event["firstLawExecute"]=true
		
		DialogueManager.show_example_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"第一次指定法律完成")
	#第一次执行完 执行额外操作
	#后续法律生效写在这里
	#if selectLawPoint.context=="":
	#	pass
	#elif selectLawPoint.context=="":
	#	pass
	if GameManager.sav.endPath!=GameManager.endPath.none:
		GameManager.improveFinalPhase()
	_initData()
enum itemStatus{ban,select,normal}

func arrangeDone():
	_on_exit_button_button_down()
	#$"../.."._initData()
	
func _on_law_confire_button_down():
	if selectLawPoint.isUnlock==true:
		return
	excuteLaw(selectLawPoint)
	pass # Replace with function body.

@onready var law_panel = $lawPanel

func getPolicyName(lawIndex,policyIndex)->String:
	
	
	
	var lawPoint:lawpoint=law_panel.get_node("Control"+var_to_str(lawIndex+1)+"-"+var_to_str(policyIndex))
	return tr(lawPoint.context)

@onready var currence_no_policy = $PanelContainer/orderPanel/currenceNoPolicy

func _on_exit_button_button_down():
	SoundManager.play_sound(sounds.declinesound)
	GameManager._engerge.stopPreviewHP()
	self.hide()
	#GameManager.currenceScene.peoples.show()
	
	pass # Replace with function body.
