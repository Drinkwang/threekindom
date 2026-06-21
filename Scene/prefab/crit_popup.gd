extends CanvasLayer
class_name CritPopup

const SUIT_COLORS := {
	0: { "bg": Color("#CC2233"), "border": Color("#FFD700"), "icon_color": Color("#FFD700"), "icon": "♥" },
	1: { "bg": Color("#3A2A5A"), "border": Color("#AAAAAA"), "icon_color": Color("#CCAAFF"), "icon": "♠" },
	2: { "bg": Color("#C17A00"), "border": Color("#FFDD44"), "icon_color": Color("#FFDD44"), "icon": "♣" },
	3: { "bg": Color("#1A5588"), "border": Color("#88CCFF"), "icon_color": Color("#88CCFF"), "icon": "♦" },
}

const SUIT_NAMES := ["红桃", "黑桃", "梅花", "方片"]

var _panel: Panel
var _title_label: Label
var _icon_label: Label
var _suit_label: Label
var _desc_label: Label


func _enter_tree() -> void:
	layer = 10
	_build_ui()


func _build_ui() -> void:
	var cc := CenterContainer.new()
	cc.set_anchors_preset(Control.PRESET_FULL_RECT)
	cc.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(cc)

	_panel = Panel.new()
	_panel.custom_minimum_size = Vector2(620, 200)
	_panel.size_flags_horizontal = Control.SIZE_EXPAND
	_panel.size_flags_vertical = Control.SIZE_EXPAND
	_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cc.add_child(_panel)

	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override("separation", 2)
	_panel.add_child(vbox)

	# 顶行：标题 + 图标 + 名称
	var hbox := HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 12)
	hbox.custom_minimum_size = Vector2(0, 80)
	vbox.add_child(hbox)

	_title_label = Label.new()
	_title_label.add_theme_font_size_override("font_size", 44)
	_title_label.add_theme_constant_override("outline_size", 3)
	_title_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.6))
	_title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hbox.add_child(_title_label)

	_icon_label = Label.new()
	_icon_label.add_theme_font_size_override("font_size", 52)
	_icon_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hbox.add_child(_icon_label)

	_suit_label = Label.new()
	_suit_label.add_theme_font_size_override("font_size", 36)
	_suit_label.add_theme_constant_override("outline_size", 2)
	_suit_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.4))
	_suit_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hbox.add_child(_suit_label)

	# 分隔线
	var sep := HSeparator.new()
	sep.modulate = Color(1, 1, 1, 0.3)
	vbox.add_child(sep)

	# 效果描述（加大字号，放在一个带内边距的容器里）
	var desc_container := MarginContainer.new()
	desc_container.add_theme_constant_override("margin_top", 6)
	desc_container.add_theme_constant_override("margin_bottom", 6)
	desc_container.add_theme_constant_override("margin_left", 20)
	desc_container.add_theme_constant_override("margin_right", 20)
	desc_container.custom_minimum_size = Vector2(0, 60)
	vbox.add_child(desc_container)

	_desc_label = Label.new()
	_desc_label.add_theme_font_size_override("font_size", 30)
	_desc_label.add_theme_constant_override("outline_size", 1)
	_desc_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.3))
	_desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_desc_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_container.add_child(_desc_label)


# ==================== 暴击 ====================

func play(suit_index: int, desc: String = "") -> void:
	var c = SUIT_COLORS[suit_index]

	var style := StyleBoxFlat.new()
	style.bg_color = c["bg"]
	style.set_corner_radius_all(12)
	style.set_border_width_all(3)
	style.border_color = c["border"]
	style.shadow_size = 10
	style.shadow_color = Color(0, 0, 0, 0.6)
	_panel.add_theme_stylebox_override("panel", style)

	_title_label.text = tr("暴击！")
	_title_label.add_theme_color_override("font_color", Color.WHITE)

	_icon_label.text = c["icon"]
	_icon_label.add_theme_color_override("font_color", c["icon_color"])

	_suit_label.text = SUIT_NAMES[suit_index]
	_suit_label.add_theme_color_override("font_color", Color.WHITE)

	_desc_label.text = desc
	_desc_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.95))

	_play_tween()


# ==================== 动画 ====================

func _play_tween() -> void:
	_panel.scale = Vector2(2.2, 2.2)
	_panel.modulate = Color(1, 1, 1, 0)

	var tw := create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tw.tween_property(_panel, "scale", Vector2(1.0, 1.0), 0.28)
	tw.parallel().tween_property(_panel, "modulate", Color(1, 1, 1, 1), 0.18)
	tw.tween_interval(0.7)
	tw.tween_property(_panel, "modulate", Color(1, 1, 1, 0), 0.25).set_trans(Tween.TRANS_SINE)
	tw.tween_callback(queue_free)
