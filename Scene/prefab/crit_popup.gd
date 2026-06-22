extends CanvasLayer
class_name CritPopup

const SUIT_STYLES := {
	0: { "accent": Color("#B23A32"), "accent_soft": Color("#6D2220"), "seal": Color("#2E1614"), "icon": "♥" },
	1: { "accent": Color("#4D455E"), "accent_soft": Color("#24202F"), "seal": Color("#17151F"), "icon": "♠" },
	2: { "accent": Color("#B37A22"), "accent_soft": Color("#5B3A14"), "seal": Color("#2A1E10"), "icon": "♣" },
	3: { "accent": Color("#2D6E7E"), "accent_soft": Color("#183D49"), "seal": Color("#10242D"), "icon": "♦" },
}

const ENEMY_SUIT_STYLES := {
	0: { "accent": Color("#7D2422"), "accent_soft": Color("#341312"), "seal": Color("#1D0C0B"), "icon": "♥" },
	1: { "accent": Color("#302A3E"), "accent_soft": Color("#15131D"), "seal": Color("#0E0C14"), "icon": "♠" },
	2: { "accent": Color("#755019"), "accent_soft": Color("#2C1E0C"), "seal": Color("#181108"), "icon": "♣" },
	3: { "accent": Color("#1D4B57"), "accent_soft": Color("#0D2229"), "seal": Color("#09171C"), "icon": "♦" },
}

const SUIT_NAMES := ["红桃", "黑桃", "梅花", "方片"]

@onready var _popup: Control = %Popup
@onready var _card_bg: NinePatchRect = %CardBg
@onready var _top_accent: ColorRect = %TopAccent
@onready var _bottom_accent: ColorRect = %BottomAccent
@onready var _seal: PanelContainer = %SuitSeal
@onready var _seal_frame: ColorRect = %SealFrame
@onready var _title_label: Label = %TitleLabel
@onready var _icon_label: Label = %IconLabel
@onready var _suit_label: Label = %SuitLabel
@onready var _desc_label: Label = %DescLabel


func _ready() -> void:
	layer = 10
	_popup.pivot_offset = _popup.size * 0.5
	_seal.pivot_offset = _seal.size * 0.5


# ==================== 暴击 ====================

func play(suit_index: int, desc: String = "", is_player: bool = true) -> void:
	if not is_node_ready():
		await ready

	var styles = SUIT_STYLES if is_player else ENEMY_SUIT_STYLES
	var c = styles.get(suit_index, styles[0])
	var accent: Color = c["accent"]
	var accent_soft: Color = c["accent_soft"]
	var seal_inner := Color("#E6C98D") if is_player else Color("#211A18")

	_card_bg.self_modulate = Color(0.92, 0.84, 0.70, 1.0) if is_player else Color(0.58, 0.50, 0.45, 1.0)
	_top_accent.color = accent
	_bottom_accent.color = accent_soft
	_seal_frame.color = seal_inner

	var seal_style := _seal.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	seal_style.bg_color = c["seal"]
	seal_style.border_color = accent
	_seal.add_theme_stylebox_override("panel", seal_style)

	_title_label.text = tr("暴击！") if is_player else tr("敌暴击！")
	_title_label.add_theme_color_override("font_color", Color("#2B1711") if is_player else Color("#F0D8C2"))

	_icon_label.text = c["icon"]
	_icon_label.add_theme_color_override("font_color", accent)

	_suit_label.text = SUIT_NAMES[suit_index] if suit_index >= 0 and suit_index < SUIT_NAMES.size() else ""
	_suit_label.add_theme_color_override("font_color", accent)

	_desc_label.text = desc
	_desc_label.add_theme_color_override("font_color", Color("#2F221B") if is_player else Color("#E4CDC0"))

	_popup.pivot_offset = _popup.size * 0.5
	_seal.pivot_offset = _seal.size * 0.5
	_play_tween()


# ==================== 动画 ====================

func _play_tween() -> void:
	_popup.scale = Vector2(1.26, 0.86)
	_popup.modulate = Color(1, 1, 1, 0)
	_seal.scale = Vector2(0.72, 0.72)
	_seal.rotation_degrees = -8.0

	var tw := create_tween()
	tw.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(_popup, "scale", Vector2.ONE, 0.22)
	tw.parallel().tween_property(_popup, "modulate", Color.WHITE, 0.14)
	tw.parallel().tween_property(_seal, "scale", Vector2.ONE, 0.28)
	tw.parallel().tween_property(_seal, "rotation_degrees", 0.0, 0.28)
	tw.tween_interval(1.55)
	tw.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tw.tween_property(_popup, "modulate", Color(1, 1, 1, 0), 0.22)
	tw.parallel().tween_property(_popup, "position:y", _popup.position.y - 18.0, 0.22)
	tw.tween_callback(queue_free)
