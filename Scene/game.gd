extends Node2D
@onready var option_button = $OptionButton
@onready var title = $CanvasLayer/title

const ARVOSTUS = preload("res://Asset/bgm/4- Arvostus.mp3")
func _ready():
	GameManager.sav=saveData.new()
	GameManager.sav.day=0
	GameManager.musicId=0
	SoundManager.play_music(ARVOSTUS)
	var system_locale	
	if GameManager._setting==null or GameManager._setting.language.length()<=0:
		system_locale= OS.get_locale_language()
		#GameManager.initSetting()
	else:
		system_locale=GameManager._setting.language
		

	TranslationServer.set_locale(system_locale)
	if system_locale=="zh_HK" or system_locale=="zh_TW" or system_locale=="lzh":
		#TranslationServer.set_locale("lzh")
		option_button.select(1)
		_on_option_button_item_selected(1)
	elif system_locale=="zh":
		#TranslationServer.set_locale("zh")
		option_button.select(0)
		_on_option_button_item_selected(0)
	elif system_locale=="ja":
		option_button.select(3)
		_on_option_button_item_selected(3)	
	elif system_locale=="ru":
		option_button.select(4)
		_on_option_button_item_selected(4)
	elif system_locale=="en":
		option_button.select(2)			
		_on_option_button_item_selected(2)
		
	initLoadContinus()
	_add_version_label()#debug
	_test_deadline_check()#debug
	if GameManager._setting.is_clear_normal_line or GameManager._setting.is_clear_overlord_line:
		$credit.disabled = false
func initLoadContinus():
	var showContinus=false
	for i in range(1,4):
		var path="user://save_data{index}.tres".format({"index":i})
		if(FileAccess.file_exists(path)):	
			showContinus=true
			break
	if	showContinus==true:
		$continue.disabled=false


func _add_version_label():
	var ver_label = Label.new()
	ver_label.text = "内部测试版本，禁止外传、分享"
	ver_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
	ver_label.add_theme_font_size_override("font_size", 14)
	ver_label.position = Vector2(8, get_viewport().get_visible_rect().size.y - 30)
	ver_label.z_index = 9999
	add_child(ver_label)

func _test_deadline_check():
	var now = Time.get_datetime_dict_from_system()
	var year = now.get("year", 2026)
	var month = now.get("month", 1)
	var day = now.get("day", 1)

	var deadline_ts = Time.get_unix_time_from_datetime_dict({
		"year": year,
		"month": 6,
		"day": 21,
		"hour": 23,
		"minute": 59,
		"second": 59
	})
	var now_ts = Time.get_unix_time_from_datetime_dict({
		"year": year,
		"month": month,
		"day": day,
		"hour": 0,
		"minute": 0,
		"second": 0
	})

	if now_ts <= deadline_ts:
		return

	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.92)
	overlay.size = get_viewport().get_visible_rect().size
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.z_index = 99999
	add_child(overlay)

	var msg = Label.new()
	msg.text = "测试已截止，无法使用，请退出。"
	msg.add_theme_color_override("font_color", Color(1, 0.3, 0.3))
	msg.add_theme_font_size_override("font_size", 32)
	msg.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	msg.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	msg.size = overlay.size
	msg.z_index = 99999
	add_child(msg)

func _on_exit_button_down():
	get_tree().quit()
	pass # Replace with function body.

#需要修改，此处应该是hero剪辑欸
#@onready var policyPanel = $"政务面板"
const sys = preload("res://dialogues/系统.dialogue")
@onready var control = $Control
@onready var readyInitData=null
func _on_begin_button_down():
	
	DialogueManager.show_example_dialogue_balloon(sys,"开始游戏选项")
	
	#SoundManager.play_sound(sounds.confiresound)
	
	
	#SoundManager.play_sound(sounds.COLLECT_SMALL_JEWEL_1)
	#SceneManager.changeScene(SceneManager.roomNode.PRE_SCENE,2)
	
	#不显示初始相关内容	
	#control.show()
	#control._initData()
#policyPanel.show()

func _on_credit_button_down():
	
	DialogueManager.show_example_dialogue_balloon(sys,"credit选项")


func NormalStartGame():
	SoundManager.play_sound(sounds.confiresound)
	
	GameManager.sav.day=1
	SoundManager.play_sound(sounds.COLLECT_SMALL_JEWEL_1)
	SceneManager.changeScene(SceneManager.roomNode.PRE_SCENE,2)
	
	
func JumpStartGame():
	
	DialogueManager.show_example_dialogue_balloon(sys,"小沛内容介绍")

func MainContent():
	SoundManager.stop_music()
	GameManager.SkipPrologue()
	
	SoundManager.play_sound(sounds.confiresound)
	
	
	SoundManager.play_sound(sounds.COLLECT_SMALL_JEWEL_1)
	SceneManager.changeScene(SceneManager.roomNode.GOVERNMENT_BUILDING,2)


func _on_continue_button_down():
	#if GameManager.CanClickUI==false:
	#	return
	#DialogueManager.show_example_dialogue_balloon(sys,"当前功能demo不开放")
	PanelManager.show_Save_panel()


func _on_option_button_item_selected(index):
	var lan=""
	if index==0:
		title.add_theme_font_size_override("normal_font_size",200)  
		lan="zh"
		title.text="[center][rainbow]阴[/rainbow][wave amp=50 frep=100]三国[/wave][rainbow]谋论[/rainbow]-[tornado][color=#ff0000]徐州篇[/color][/tornado][/center]"				

	elif index==1:
		title.add_theme_font_size_override("normal_font_size",200)  
		lan="lzh"
		title.text="[center][rainbow]陰[/rainbow][wave amp=50 frep=100]三國[/wave][rainbow]謀論[/rainbow]-[tornado]徐州篇[/tornado][/center]"				
	
	elif index==2:
		lan="en"
		title.add_theme_font_size_override("normal_font_size",130)
		title.text="[center]The [rainbow]Three Kingdoms[/rainbow] of [wave amp=50 frep=100]Shadows[/wave]:[tornado]Xuzhou[/tornado][/center]"
				
	elif index==3:
		lan="ja"
		title.text="[center][rainbow]陰[/rainbow][wave amp=50 frep=100]三国[/wave][rainbow]謀論[/rainbow]: [tornado]徐州編[/tornado][/center]"
		title.add_theme_font_size_override("normal_font_size",200)  		
	elif index==4:
		lan="ru"
		title.text="[center][tornado]Тёмные [/tornado][wave amp=50 frep=100]интриги [/wave][rainbow]Троецарствия[/rainbow][/center]"			
		title.add_theme_font_size_override("normal_font_size",130)  		
	
	TranslationServer.set_locale(lan)
	if GameManager._setting!=null:
		GameManager._setting.language=lan
		SignalManager.changeLanguage.emit()
		ResourceSaver.save(GameManager._setting,"user://ysg_data_setting.tres")



func _on_continue_mouse_entered():
	SoundManager.play_sound(sounds.hoversound)


func _on_begin_mouse_entered():
	SoundManager.play_sound(sounds.hoversound)


func _on_exit_mouse_entered():
	SoundManager.play_sound(sounds.hoversound)
	pass # Replace with function body.
