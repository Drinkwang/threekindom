extends Node2D
@onready var option_button = $OptionButton

const ARVOSTUS = preload("res://Asset/bgm/4- Arvostus.mp3")
func _ready():
	SoundManager.play_music(ARVOSTUS)
	var system_locale = OS.get_locale_language()
	TranslationServer.set_locale(system_locale)
	if system_locale=="zh_HK" or system_locale=="zh_TW":
		TranslationServer.set_locale("lzh")
		option_button.select(1)
	elif system_locale=="zh":
		option_button.select(0)
	elif system_locale=="ja":
		option_button.select(3)	
	elif system_locale=="ru":
		option_button.select(4)	
	elif system_locale=="en":
		option_button.select(2)			
		
func _on_exit_button_down():
	get_tree().quit()
	pass # Replace with function body.

#需要修改，此处应该是hero剪辑欸
#@onready var policyPanel = $"政务面板"
@onready var control = $Control

func _on_begin_button_down():
	SoundManager.play_sound(sounds.confiresound)
	
	control.show()
	#control._on_v_slider_value_changed(100)
	control._initData()
#policyPanel.show()



func _on_continue_button_down():
	pass # Replace with function body.


func _on_option_button_item_selected(index):
	if index==0:
		TranslationServer.set_locale("zh")
		pass
	elif index==1:
		TranslationServer.set_locale("lzh")
		pass
	elif index==2:
		TranslationServer.set_locale("en")
		
	elif index==3:
		TranslationServer.set_locale("ja")
	elif index==4:
		TranslationServer.set_locale("ru")
	
	pass # Replace with function body.




func _on_continue_mouse_entered():
	SoundManager.play_sound(sounds.hoversound)


func _on_begin_mouse_entered():
	SoundManager.play_sound(sounds.hoversound)


func _on_exit_mouse_entered():
	SoundManager.play_sound(sounds.hoversound)
	pass # Replace with function body.
