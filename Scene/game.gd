extends Node2D
@onready var option_button = $OptionButton
@onready var title = $title

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
		title.add_theme_font_size_override("normal_font_size",200)  
		TranslationServer.set_locale("zh")
		title.text="[center][rainbow]阴[/rainbow][wave amp=50 frep=100]三国[/wave][rainbow]谋论[/rainbow]-[tornado][color=#ff0000]徐州篇[/color][/tornado][/center]"				

	elif index==1:
		title.add_theme_font_size_override("normal_font_size",200)  
		TranslationServer.set_locale("lzh")
		title.text="[center][rainbow]陰[/rainbow][wave amp=50 frep=100]三國[/wave][rainbow]謀論[/rainbow]-[tornado]徐州篇[/tornado][/center]"				
	
	elif index==2:
		TranslationServer.set_locale("en")
		title.add_theme_font_size_override("normal_font_size",130)
		title.text="[center]The [rainbow]Three Kingdoms[/rainbow] of [wave amp=50 frep=100]Shadows[/wave]:[tornado]Xuzhou[/tornado][/center]"
				
	elif index==3:
		TranslationServer.set_locale("ja")
		title.text="[center][rainbow]陰[/rainbow][wave amp=50 frep=100]三国[/wave][rainbow]謀論[/rainbow]: [tornado]徐州編[/tornado][/center]"
		title.add_theme_font_size_override("normal_font_size",200)  		
	elif index==4:
		TranslationServer.set_locale("ru")
		title.text="[center][tornado]Тёмные [/tornado][wave amp=50 frep=100]интриги [/wave][rainbow]Троецарствия[/rainbow][/center]"			
		title.add_theme_font_size_override("normal_font_size",130)  		
	
	pass # Replace with function body.




func _on_continue_mouse_entered():
	SoundManager.play_sound(sounds.hoversound)


func _on_begin_mouse_entered():
	SoundManager.play_sound(sounds.hoversound)


func _on_exit_mouse_entered():
	SoundManager.play_sound(sounds.hoversound)
	pass # Replace with function body.
