extends Node2D

const ARVOSTUS = preload("res://Asset/bgm/4- Arvostus.mp3")
func _ready():
	SoundManager.play_music(ARVOSTUS)
	

func _on_exit_button_down():
	get_tree().quit()
	pass # Replace with function body.

#需要修改，此处应该是hero剪辑欸
#@onready var policyPanel = $"政务面板"
@onready var control = $Control

func _on_begin_button_down():
	SoundManager.play_sound(sounds.confiresound)

	control.show()
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
