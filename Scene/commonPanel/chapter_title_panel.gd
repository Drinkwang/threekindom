extends CanvasLayer
class_name ChapterTitlePanel

signal closed

@onready var _root: Control = $Root
@onready var _bar: ColorRect = $Root/Bar
@onready var _chapter_label: Label = $Root/Bar/Content/VBoxContainer/ChapterLabel
@onready var _title_label: Label = $Root/Bar/Content/VBoxContainer/TitleLabel

var _data: Dictionary = {}
var _started := false


func setup(data: Dictionary) -> void:
	_data = data
	if is_inside_tree():
		_apply_data()


func _ready() -> void:
	layer = 128
	_apply_data()
	play()


func _apply_data() -> void:
	_chapter_label.text = tr(_data.get("chapter", ""))
	_title_label.text = tr(_data.get("title", ""))
	_fit_text_for_locale()


func _fit_text_for_locale() -> void:
	var locale := TranslationServer.get_locale()
	var chapter_size := 26
	var title_size := 50
	if locale == "ru" or locale == "en":
		chapter_size = 20
		title_size = 38
	elif locale == "ja":
		chapter_size = 22
		title_size = 40
	_chapter_label.add_theme_font_size_override("font_size", chapter_size)
	_title_label.add_theme_font_size_override("font_size", title_size)


func play() -> void:
	if _started:
		return
	_started = true
	var total_time: float = max(0.5, _data.get("duration", 2.6))
	var fade_time: float = min(0.45, total_time * 0.25)
	var hold_time: float = max(0.0, total_time - fade_time * 2.0)
	_bar.modulate = Color(1, 1, 1, 0)
	_root.position.y = -18

	var fade_in := create_tween()
	fade_in.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	fade_in.parallel().tween_property(_bar, "modulate:a", 1.0, fade_time)
	fade_in.parallel().tween_property(_root, "position:y", 0.0, fade_time)
	await fade_in.finished

	await get_tree().create_timer(hold_time).timeout

	var fade_out := create_tween()
	fade_out.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	fade_out.parallel().tween_property(_bar, "modulate:a", 0.0, fade_time)
	fade_out.parallel().tween_property(_root, "position:y", -18.0, fade_time)
	await fade_out.finished

	closed.emit()
	queue_free()
