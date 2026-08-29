extends CanvasLayer

const GAME_OVER_MESSAGE := "民心尽失，徐州陷于暴乱，游戏结束。"

@onready var title: RichTextLabel = $Control/ColorRectdont/title2


func _ready() -> void:
	changeLanguage()


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED and is_node_ready():
		changeLanguage()


func changeLanguage() -> void:
	title.text = "[center][tornado]\n%s[/tornado][/center]" % TranslationServer.translate(GAME_OVER_MESSAGE)
