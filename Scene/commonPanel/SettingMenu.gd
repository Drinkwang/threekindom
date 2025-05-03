extends CanvasLayer
class_name SettingMenu
@onready var resolution_option: OptionButton =$"分辨率/OptionButton"

@onready var fullscreen_check: CheckBox = $"是否全屏/CheckBox"

@onready var music_slider: HSlider =  $"音乐音量/HSlider"

@onready var sfx_slider: HSlider =  $"音效音量/HSlider"

@onready var option_button = $"语言系统/OptionButton"

# 当前分辨率索引
var current_resolution_index: int = 0
# 分辨率列表
var resolutions: Array[String] = []

func _ready():
	
	
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
	
	# 默认选择最接近显示器分辨率的选项
	current_resolution_index = find_closest_resolution(max_width, max_height)
	resolution_option.select(current_resolution_index)
	apply_resolution(current_resolution_index)
	
	# 连接信号
	resolution_option.item_selected.connect(_on_resolution_selected)
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	#$VBoxContainer2/Button.pressed.connect(_on_confirm_pressed)
	#$VBoxContainer2/Button2.pressed.connect(_on_reset_pressed)

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

# 分辨率选择变化
func _on_resolution_selected(index: int):
	current_resolution_index = index
	apply_resolution(index)

# 全屏模式切换
func _on_fullscreen_toggled(toggled: bool):
	if toggled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		apply_resolution(current_resolution_index)

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

func _on_sfx_slider_value_changed(value: float):
	SoundManager.set_music_volume(value)


func _on_button_button_down():
	self.hide()
	pass # Replace with function body.


func _on_option_button_item_selected(index):
	if index==0:
		TranslationServer.set_locale("zh")
	elif index==1:
		TranslationServer.set_locale("lzh")
	elif index==2:
		TranslationServer.set_locale("en")
	elif index==3:
		TranslationServer.set_locale("ja")
	elif index==4:
		TranslationServer.set_locale("ru")

