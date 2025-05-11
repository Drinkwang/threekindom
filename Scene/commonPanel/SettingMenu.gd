extends CanvasLayer
class_name SettingMenu
@onready var resolution_option: OptionButton =$VBoxContainer/resolotionCon/OptionButton

@onready var fullscreen_check: CheckBox=$VBoxContainer/fullsysCon/CheckBox

@onready var music_slider: HSlider = $VBoxContainer/musicCon/HSlider2

@onready var sfx_slider: HSlider =  $VBoxContainer/sfxCon/HSlider

@onready var option_button = $VBoxContainer/lanSysCon/OptionButton2

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
	var aspect_ratios = {
		"16:9": 16.0 / 9.0,  # 1.777
		"16:10": 16.0 / 10.0, # 1.6
		"14:9": 14.0 / 9.0    # 1.555
	}
	
	# 最小宽度和步长
	var min_width = 640
	var width_step = 128  # 每次增加 128
	
	# 动态生成分辨率
	var generated_resolutions: Array[Vector2i] = []
	for aspect_name in aspect_ratios:
		var ratio = aspect_ratios[aspect_name]
		var width = min_width
		while width <= max_width:
			var height = int(width / ratio)
			if height <= max_height:
				generated_resolutions.append(Vector2i(width, height))
			width += width_step
	
	# 添加常见分辨率（手动补充）
	var common_resolutions = [
		Vector2i(1366, 768),
		Vector2i(1400, 900),
		Vector2i(1440, 900),
		Vector2i(1680, 1050),
		Vector2i(2560, 1440)  # 2K
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
		
		fullscreen_check.toggle_mode=true	
		music_slider.value=1
		sfx_slider.value=1
		GameManager._setting=SettingsResource.new()
		GameManager._setting.language=system_locale
		GameManager._setting.resolution=resolutions[current_resolution_index]
	else:

		system_locale=GameManager._setting.language #= OS.get_locale_language()
		current_resolution_index=find_closest_resolution(max_width, max_height)
		music_slider.value=GameManager._setting.music_volume
		sfx_slider.value=GameManager._setting.sfx_volume
		fullscreen_check.toggle_mode=GameManager._setting.fullscreen
	resolution_option.select(current_resolution_index)
	apply_resolution(current_resolution_index)
	TranslationServer.set_locale(system_locale)
	# 连接信号
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, true)
	#如果设置存了别的
	var lan
	if system_locale=="zh_HK" or system_locale=="zh_TW":
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

# 应用分辨率
func apply_resolution(index: int):
	var res = resolutions[index].split("x")
	var width = int(res[0])
	var height = int(res[1])
	DisplayServer.window_set_size(Vector2i(width, height))
	# 居中窗口
	var screen_size = DisplayServer.screen_get_size()
	var window_pos = (screen_size - Vector2i(width, height)) / 2
	DisplayServer.window_set_position(window_pos)
	return resolutions[index]	


# 分辨率选择变化
func _on_resolution_selected(index: int):
	current_resolution_index = index
	var saveResolution=apply_resolution(index)
	GameManager._setting.resolution=saveResolution

	#if not GameManager._setting.fullscreen:
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)  # Ensure windowed mode
	#
	
# 全屏模式切换
func _on_fullscreen_toggled(toggled: bool):
	if toggled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		apply_resolution(current_resolution_index)
		
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	GameManager._setting.fullscreen=toggled
# 确认按钮

# 恢复默认按钮
func _on_reset_pressed():
	# 重置为显示器推荐分辨率
	var screen_size = DisplayServer.screen_get_size()
	current_resolution_index = find_closest_resolution(screen_size.x, screen_size.y)
	resolution_option.select(current_resolution_index)
	apply_resolution(current_resolution_index)
	fullscreen_check.button_pressed = false
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

# 音量滑块（示例）
func _on_music_slider_value_changed(value: float):
	SoundManager.set_sound_volume(value)
	GameManager._setting.music_volume=value

func _on_sfx_slider_value_changed(value: float):
	SoundManager.set_music_volume(value)
	GameManager._setting.sfx_volume=value

func _on_button_button_down():
	#保存
	ResourceSaver.save(GameManager._setting,"user://save_data_setting.tres")
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
		$"VBoxContainer/lanSysCon/语言系统".add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		$"VBoxContainer/resolotionCon/分辨率".add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		$"VBoxContainer/fullsysCon/是否全屏".add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		$"VBoxContainer/musicCon/音乐音量".add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		$"VBoxContainer/sfxCon/音效音量".add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))

		v_box_container.position.x=681-150
	else:
		$"VBoxContainer/lanSysCon/语言系统".remove_theme_font_override("font")
		$"VBoxContainer/resolotionCon/分辨率".remove_theme_font_override("font")
		$"VBoxContainer/fullsysCon/是否全屏".remove_theme_font_override("font")
		$"VBoxContainer/musicCon/音乐音量".remove_theme_font_override("font")
		$"VBoxContainer/sfxCon/音效音量".remove_theme_font_override("font")
		v_box_container.position.x=681	
		
