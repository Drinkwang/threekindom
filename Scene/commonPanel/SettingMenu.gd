extends CanvasLayer
class_name SettingMenu
@onready var resolution_option: OptionButton =$VBoxContainer/resolotionCon/OptionButton

@onready var fullscreen_check: CheckBox=$VBoxContainer/fullsysCon/CheckBox
@onready var AutoSavecheck = $VBoxContainer/isAutoSave/CheckBox

@onready var music_slider: HSlider = $VBoxContainer/musicCon/HSlider2

@onready var sfx_slider: HSlider =  $VBoxContainer/sfxCon/HSlider

@onready var people_slider: HSlider = $VBoxContainer/peopleCon/HSlider

@onready var bgs_slider: HSlider = $VBoxContainer/bgsCon/HSlider

@onready var option_button = $VBoxContainer/lanSysCon/OptionButton2
@onready var lansound_option_button: OptionButton = $VBoxContainer/lanSysCon2/lansoundOptionButton
@onready var open_save_button: Button = $"VBoxContainer/isAutoSave/是否自动存档/Button"
@onready var open_save_txt: Label = $"VBoxContainer/isAutoSave/是否自动存档"

# 当前分辨率索引
var current_resolution_index: int = 0
# 分辨率列表
var resolutions: Array[String] = []

func _ready():
	# 获取显示器分辨率（这里假设 2K：2560x1440）
	var screen_size = DisplayServer.screen_get_size()
	var max_width = screen_size.x
	var max_height = screen_size.y
	
	# 定义常见宽高比
	var generated_resolutions: Array[Vector2i] = []
	var common_resolutions = [
		Vector2i(1280, 720),
		Vector2i(1366, 768),
		Vector2i(1600, 900),
		Vector2i(1920, 1080),
		Vector2i(1440, 900),
		Vector2i(1680, 1050),
		Vector2i(2560, 1440),
		Vector2i(3840, 2160)
	]
	for res in common_resolutions:
		if res.x <= max_width and res.y <= max_height:
			generated_resolutions.append(res)
	
	# 去重并排序
	generated_resolutions = remove_duplicates(generated_resolutions)
	generated_resolutions.sort_custom(func(a, b): return a.x * a.y < b.x * b.y)
	resolutions=[]
	# 转换为字符串并添加到列表
	for res in generated_resolutions:
		resolutions.append("%dx%d" % [res.x, res.y])
	
	# 填充下拉菜单
	for res in resolutions:
		resolution_option.add_item(res)
	
	
	
	var system_locale #= OS.get_locale_language()
	
	
	
	if GameManager._setting==null:
	# 默认选择最接近显示器分辨率的选项
		system_locale= OS.get_locale_language()
		current_resolution_index = find_closest_resolution(max_width, max_height)
		
		fullscreen_check.button_pressed=true
		music_slider.value=0.25
		sfx_slider.value=1
		people_slider.value=1
		bgs_slider.value=0.5
		AutoSavecheck.button_pressed=true
		GameManager._setting=SettingsResource.new()
		GameManager._setting.language=system_locale
		GameManager._setting.resolution=resolutions[current_resolution_index]
		_sync_people_voice_option()
	else:
	
		system_locale=GameManager._setting.language #= OS.get_locale_language()
		if GameManager._setting.fullscreen:
			current_resolution_index=find_closest_resolution(max_width, max_height)
		else:
			find_res(GameManager._setting.resolution)
			if current_resolution_index < 0:
				current_resolution_index = find_closest_resolution(max_width, max_height)
		music_slider.value=GameManager._setting.music_volume
		sfx_slider.value=GameManager._setting.sfx_volume
		people_slider.value=GameManager._setting.people_volume
		bgs_slider.value=GameManager._setting.bgs_volume
		# 保底：确保音量被应用到 AudioServer（防止 _load_settings() 未被调用的情况）
		SoundManager.set_music_volume(GameManager._setting.music_volume)
		SoundManager.set_sound_volume(GameManager._setting.sfx_volume)
		SoundManager.set_ambient_sound_volume(GameManager._setting.bgs_volume)
		SoundManager.set_sound_ui_volume(GameManager._setting.people_volume)
		fullscreen_check.button_pressed=GameManager._setting.fullscreen
		AutoSavecheck.button_pressed=GameManager._setting.isAutoSave
	_sync_people_voice_option()
	resolution_option.select(current_resolution_index)
	# 延迟应用分辨率，避免在 _ready() 中立即改窗口大小导致 UI 异常
	call_deferred("apply_resolution", current_resolution_index)
	TranslationServer.set_locale(system_locale)
	# 连接信号（弹出菜单 index_pressed 比 item_selected 更可靠）
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, true)
	resolution_option.get_popup().index_pressed.connect(_on_resolution_selected)
	#如果设置存了别的
	var lan
	if system_locale=="zh_HK" or system_locale=="zh_TW" or system_locale=="lzh":
		option_button.select(1)
		_on_option_button_item_selected(1)
	elif system_locale=="zh":
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

# 去重函数
func remove_duplicates(res_list: Array[Vector2i]) -> Array[Vector2i]:
	var unique_res: Array[Vector2i] = []
	var seen = {}
	for res in res_list:
		var key = str(res.x) + "x" + str(res.y)
		if not seen.has(key):
			seen[key] = true
			unique_res.append(res)
	return unique_res

# 找到最接近显示器分辨率的选项
func find_closest_resolution(max_width: int, max_height: int) -> int:
	var closest_index = 0
	var smallest_diff = 99999999
	
	for i in range(resolutions.size()):
		var res = resolutions[i].split("x")
		var width = int(res[0])
		var height = int(res[1])
		var diff = abs(max_width - width) + abs(max_height - height)
		if diff < smallest_diff:
			smallest_diff = diff
			closest_index = i
	
	return closest_index

func find_res(resolution):
	var index=resolutions.find(resolution)
	current_resolution_index=index
	#apply_resolution(index)

# 应用分辨率
func apply_resolution(index: int):
	if index < 0 or index >= resolutions.size():
		return ""
	if fullscreen_check.button_pressed:
		return resolutions[index]
	var res = resolutions[index].split("x")
	var width = int(res[0])
	var height = int(res[1])
	
	
	var current_screen_idx = DisplayServer.window_get_current_screen()
	
	# 2. 获取该屏幕的实际尺寸
	var screen_size = DisplayServer.screen_get_size(current_screen_idx)
	var screen_pos = DisplayServer.screen_get_position(current_screen_idx)
	
	DisplayServer.window_set_size(Vector2i(width, height))
	# 居中窗口
	#var screen_size = DisplayServer.screen_get_size()
	var window_pos = screen_pos + (screen_size - Vector2i(width, height)) / 2
	
	#防止超出屏幕边界
	window_pos.x = max(window_pos.x, screen_pos.x)
	window_pos.y = max(window_pos.y, screen_pos.y)
	# 确保位置不超过屏幕边界（防止右下侧出屏）
	window_pos.x = min(window_pos.x, screen_pos.x + screen_size.x - width)
	window_pos.y = min(window_pos.y, screen_pos.y + screen_size.y - height)
		
	
	
	DisplayServer.window_set_position(window_pos,current_screen_idx)
	return resolutions[index]	


# 分辨率选择变化
func _on_resolution_selected(index: int):
	current_resolution_index = index
	GameManager._setting.resolution = resolutions[index]
	# 延迟应用分辨率，避免在 OptionButton 下拉菜单交互时立即改窗口大小导致冲突
	call_deferred("apply_resolution", index)

	#if not GameManager._setting.fullscreen:
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)  # Ensure windowed mode
	#
	
# 全屏模式切换
func _on_fullscreen_toggled(toggled: bool):
	if toggled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		call_deferred("apply_resolution", current_resolution_index)
		
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	GameManager._setting.fullscreen=toggled
# 确认按钮

# 恢复默认按钮
func _on_reset_pressed():
	# 重置为显示器推荐分辨率
	var screen_size = DisplayServer.screen_get_size()
	current_resolution_index = find_closest_resolution(screen_size.x, screen_size.y)
	resolution_option.select(current_resolution_index)
	call_deferred("apply_resolution", current_resolution_index)
	fullscreen_check.button_pressed = false
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

# 音量滑块（示例）
func _on_music_slider_value_changed(value: float):
	SoundManager.set_music_volume(value)
	GameManager._setting.music_volume=value

func _on_sfx_slider_value_changed(value: float):
	SoundManager.set_sound_volume(value)
	GameManager._setting.sfx_volume=value
	
	
	
func _on_bgs_slider_value_changed(value: float):
	SoundManager.set_ambient_sound_volume(value)
	GameManager._setting.bgs_volume=value

func _on_people_slider_value_changed(value: float):
	SoundManager.set_sound_ui_volume(value)
	GameManager._setting.people_volume=value	

func _on_button_button_down():
	#保存
	ResourceSaver.save(GameManager._setting,"user://ysg_data_setting.tres")
	PanelManager.isOpenSetting=false
	self.hide()
	pass # Replace with function body.

#语言切换
func _on_option_button_item_selected(index):
	var lan
	if index==0:
		lan="zh"

	elif index==1:
		lan="lzh"
	
	elif index==2:
		lan="en"
		
	elif index==3:
		lan="ja"
	
	elif index==4:
		lan="ru"
		
	TranslationServer.set_locale(lan)
	GameManager._setting.language=lan
	SignalManager.changeLanguage.emit()
	refreshLanguage(lan)
	
@onready var v_box_container = $VBoxContainer
	
func refreshLanguage(lan):
	if(lan=="ru"):
	#	$"VBoxContainer/lanSysCon/语言系统".add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
	#	$"VBoxContainer/resolotionCon/分辨率".add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
	#	$"VBoxContainer/fullsysCon/是否全屏".add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
	#	$"VBoxContainer/musicCon/音乐音量".add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
	#	$"VBoxContainer/sfxCon/音效音量".add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))

		v_box_container.position.x=681-150
	else:
	#	$"VBoxContainer/lanSysCon/语言系统".remove_theme_font_override("font")
	#	$"VBoxContainer/resolotionCon/分辨率".remove_theme_font_override("font")
	#	$"VBoxContainer/fullsysCon/是否全屏".remove_theme_font_override("font")
	#	$"VBoxContainer/musicCon/音乐音量".remove_theme_font_override("font")
	#	$"VBoxContainer/sfxCon/音效音量".remove_theme_font_override("font")
		v_box_container.position.x=681	
		
	await get_tree().create_timer(0.1).timeout 
	var betweenSaveButtonX=open_save_txt.size.x-216
	open_save_button.position.x=220+betweenSaveButtonX
	
	
	resetButton(open_save_button,5)
	resetButton(confirebutton,5)
	#open_save_button.size.x
	#print(betweenSaveButtonX)

@onready var confirebutton: Button = $confire/Button

func resetButton(button:Button,padding):
	var font = button.get_theme_font("font")
	var font_size = button.get_theme_font_size("font_size")
	var temp_font = font.duplicate()
	#temp_font.size = font_size
	var text_size = temp_font.get_string_size(button.text)
	
	# 2. 设置按钮最小尺寸（文字宽度+左右边距，高度+上下边距）
	button.size.x =text_size.x + padding * 2
	

func _on_IsSave_toggled(toggled_on):
	GameManager._setting.isAutoSave=toggled_on
# 确认按钮


func _on_lansound_option_button_item_selected(index: int) -> void:
	var lan
	if index==0:
		lan="none"

	elif index==1:
		lan="zh"

		
	#TranslationServer.set_locale(lan)
	GameManager._setting.peopleVlan=lan
	#SignalManager.changeLanguage.emit()
	#refreshLanguage(lan)


func _sync_people_voice_option():
	var lan="none"
	if GameManager._setting!=null:
		lan=GameManager._setting.peopleVlan
	if lan=="zh":
		lansound_option_button.select(1)
	else:
		if GameManager._setting!=null:
			GameManager._setting.peopleVlan="none"
		lansound_option_button.select(0)


func _on_openSaveDir_down() -> void:
	var save_dir = ProjectSettings.globalize_path("user://")
	# 调用系统命令打开文件夹
	OS.shell_open(save_dir)
