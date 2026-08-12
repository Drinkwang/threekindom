extends CanvasLayer

const GAME_OVER_MESSAGE := "民心尽失，徐州陷于暴乱，游戏结束。"

@onready var title: RichTextLabel = $Control/ColorRectdont/title2


func _ready() -> void:
	SignalManager.changeLanguage.connect(changeLanguage)
	changeLanguage()

func changeLanguage() -> void:
	title.text = "[center][tornado]\n%s[/tornado][/center]" % tr(GAME_OVER_MESSAGE)
