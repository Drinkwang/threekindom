@tool
extends Window

const json_file = "res://addons/GodotPrivacyPlugin/config.json"

@onready var background = $ColorRect
@onready var panel = $ColorRect/Panel
@onready var label = $ColorRect/Panel/ScrollContainer/Label
@onready var agree_btn = $ColorRect/Panel/Button
@onready var cancel_btn = $ColorRect/Panel/Button2

func _ready():
	background = $ColorRect
	panel = $ColorRect/Panel
	label = $ColorRect/Panel/ScrollContainer/Label
	agree_btn = $ColorRect/Panel/Button
	cancel_btn = $ColorRect/Panel/Button2
	loadPanel()	
func loadJson():
	var file = FileAccess.open(json_file, FileAccess.READ)
	var content = file.get_as_text()
	return JSON.parse_string(content)

func loadText(entity):
	var file = FileAccess.open(entity.textPath, FileAccess.READ)
	var content = file.get_as_text()
	
	$ColorRect/Panel/ScrollContainer/Label.text = content

func loadPanel():
	var entity = loadJson()
	loadText(entity)
	$ColorRect.color = Color(entity.backgroundColor)
	$ColorRect/Panel/ScrollContainer/Label.label_settings.set_font_color(Color(entity.textColor))
	$ColorRect/Panel.get("theme_override_styles/panel").set("bg_color",Color(entity.contentColor))
	$ColorRect/Panel/Button.get("theme_override_styles/normal").set("bg_color",Color(entity.agreeBtn.color))
	$ColorRect/Panel/Button.set("theme_override_colors/font_color",Color(entity.agreeBtn.textColor))
	$ColorRect/Panel/Button2.get("theme_override_styles/normal").set("bg_color",Color(entity.cancelBtn.color))
	$ColorRect/Panel/Button2.set("theme_override_colors/font_color",Color(entity.cancelBtn.textColor))

func _on_close_requested() -> void:
	hide()

func _on_about_to_popup() -> void:
	loadPanel()


func _on_focus_entered() -> void:
	loadPanel()
