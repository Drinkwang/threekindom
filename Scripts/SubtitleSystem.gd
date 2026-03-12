# 继承自Control，作为字幕UI的根节点
extends Control

# ===================== 可视化配置项（在编辑器中直接调整） =====================
# SRT字幕文件路径（必填：确保文件后缀是.srt，不是.txt）
@export var srt_file_path: String = "res://credit_sub.srt"
# 字幕显示位置（0-1为屏幕相对坐标，x=0.5居中，y=0.9靠底部）
@export var subtitle_pos: Vector2 = Vector2(0.5, 0.9)
# 字幕样式
@export var font_size: int = 36               # 字号（适配古风建议36+）
@export var font_color: Color = Color(1, 1, 1)  # 字体颜色（白色）
@export var bg_color: Color = Color(0, 0, 0, 0.4)  # 背景半透明黑
# ==============================================================================

# 内部变量（无需修改）
@export var subtitle_label: Label       # 显示字幕的Label节点
var subtitle_data: Array = []   # 解析后的字幕数据 [{start, end, text}]
var game_start_ts: float = 0.0  # 游戏启动时间戳（秒）
var update_timer: Timer         # 字幕更新计时器

# 暂停功能新增变量
var is_paused: bool = false     # 暂停状态标记
var pause_time: float = 0.0     # 暂停时记录的累计播放时间
var pause_system_ts: float = 0.0 # 暂停时的系统时间戳

# 节点就绪时初始化
func _ready() -> void:
	# 记录游戏启动时间（用于精准计算流逝时间）
	game_start_ts = Time.get_ticks_msec() / 1000.0
	
	# 1. 自动创建字幕Label（无需手动搭建节点）
	_init_subtitle_label()
	
	# 2. 初始化计时器（每0.1秒检查一次字幕，平衡性能和流畅度）
	update_timer = Timer.new()
	update_timer.wait_time = 0.1
	update_timer.timeout.connect(_update_subtitle)
	add_child(update_timer)
	update_timer.start()
	
	# 3. 核心：解析SRT文件
	_parse_srt()

# 初始化字幕Label的样式和位置
func _init_subtitle_label() -> void:
	# 如果没有手动指定Label节点，自动创建
	if not is_instance_valid(subtitle_label):
		subtitle_label = Label.new()
		add_child(subtitle_label)
	
	# 基础设置
	subtitle_label.name = "SubtitleLabel"
	subtitle_label.visible = false  # 初始隐藏
	#subtitle_label.horizontal_alignment = Label.HORIZONTAL_ALIGNMENT_CENTER
	#subtitle_label.vertical_alignment = Label.VERTICAL_ALIGNMENT_CENTER
	
	# 自适应分辨率的锚点（关键：不同屏幕都能显示在底部居中）

	

	subtitle_label.modulate = Color(1,1,1,1)

func _parse_srt() -> void:
	if not FileAccess.file_exists(srt_file_path):
		print("❌ 字幕文件不存在：", srt_file_path)
		print("💡 请确认文件路径正确，且后缀是.srt（不是.txt）")
		return
	
	var file = FileAccess.open(srt_file_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	# ========== 纯GDScript实现：兼容所有换行符 + 分割空行 ==========
	# 步骤1：统一所有换行符为\n（兼容Windows/macOS/Linux）
	content = content.replace("\r\n", "\n").replace("\r", "\n")
	# 步骤2：按单个换行符拆分成行，过滤空行
	var all_lines = content.split("\n")
	var clean_lines = []
	for line in all_lines:
		var trimmed = line.strip_edges()
		if trimmed != "":
			clean_lines.append(trimmed)
	# 步骤3：按字幕块分割（每3行以上为一个块：序号+时间+内容）
	var blocks = []
	var current_block = []
	for line in clean_lines:
		current_block.append(line)
		# 判定字幕块结束：下一行是数字（新序号），且当前块至少3行
		var next_idx = clean_lines.find(line) + 1
		if next_idx>=60:
			continue
		if next_idx < clean_lines.size() and clean_lines[next_idx].to_int() != 0 or clean_lines[next_idx] == "0":
			if current_block.size() >= 3:
				blocks.append(current_block)
				current_block = []
	# 加入最后一个块
	if current_block.size() >= 3:
		blocks.append(current_block)
	# ==============================================================
	
	# 解析每个字幕块
	for block in blocks:
		# 解析时间行（块的第2行，索引1）
		var time_parts = block[1].split(" --> ", true)
		if time_parts.size() != 2:
			continue
		
		# 转换并校验时间
		var start = _time_str_to_sec(time_parts[0])
		var end = _time_str_to_sec(time_parts[1])
		if start == 0 or end == 0 or start >= end:
			print("⚠️ 无效时间范围：", start, " - ", end, "，跳过该字幕块")
			continue
		
		# 拼接字幕内容（块的第3行及以后）
		var text = ""
		for i in range(2, block.size()):
			text += block[i] + "\n"
		text = text.strip_edges()
		
		# 存入数据
		subtitle_data.append({
			"start": start,
			"end": end,
			"text": text
		})
	
	print("✅ 字幕解析完成，共加载 ", subtitle_data.size(), " 条")

# 辅助函数：把SRT时间字符串转成秒（00:00:05,000 → 5.0秒）
func _time_str_to_sec(time_str: String) -> float:
	time_str = time_str.replace(",", ".")  # 兼容逗号/点分隔毫秒
	var parts = time_str.split(":", true)
	if parts.size() != 3:
		return 0.0
	
	var h = parts[0].to_float()
	var m = parts[1].to_float()
	var s = parts[2].to_float()
	return h * 3600 + m * 60 + s

# 实时更新字幕显示
func _update_subtitle() -> void:
	# 如果暂停，直接返回（不更新字幕）
	if is_paused:
		return
	
	# 计算游戏运行的真实时间（扣除启动耗时）
	var current_time = (Time.get_ticks_msec() / 1000.0) - game_start_ts
	var show_text = ""
	
	# 匹配当前时间的字幕
	for sub in subtitle_data:
		if current_time >= sub.start and current_time <= sub.end:
			show_text = sub.text
			break
	
	# 更新显示（空字幕则隐藏）
	subtitle_label.text = show_text
	subtitle_label.visible = show_text != ""

# ===================== 新增：暂停/继续功能 =====================
# 暂停字幕播放
func pause_subtitle() -> void:
	if not is_paused:
		is_paused = true
		# 记录暂停时的累计播放时间
		pause_time = (Time.get_ticks_msec() / 1000.0) - game_start_ts
		pause_system_ts = Time.get_ticks_msec() / 1000.0
		print("📌 字幕已暂停，当前播放时间：", pause_time, "秒")

# 继续字幕播放
func resume_subtitle() -> void:
	if is_paused:
		is_paused = false
		# 计算暂停的时长，修正启动时间戳（让时间继续流逝）
		var pause_duration = (Time.get_ticks_msec() / 1000.0) - pause_system_ts
		game_start_ts += pause_duration
		print("▶️ 字幕已继续，暂停时长：", pause_duration, "秒")
		# 立即更新一次字幕（避免延迟）
		_update_subtitle()

# 切换暂停/继续状态（一键切换）
func toggle_pause() -> void:
	if is_paused:
		resume_subtitle()
	else:
		pause_subtitle()

# ===================== 原有功能保留 =====================
# 可选：手动跳转到指定时间的字幕（场景切换时调用）
func jump_to_time(sec: float) -> void:
	# 处理暂停状态下的跳转
	if is_paused:
		pause_time = sec
		var text = ""
		for sub in subtitle_data:
			if sec >= sub.start and sec <= sub.end:
				text = sub.text
				break
		subtitle_label.text = text
		subtitle_label.visible = text != ""
		print("🔍 暂停状态下跳转到：", sec, "秒，显示字幕：", text)
	else:
		# 非暂停状态下跳转（修改启动时间戳）
		var current_system_time = Time.get_ticks_msec() / 1000.0
		game_start_ts = current_system_time - sec
		_update_subtitle()
		print("🔍 跳转到：", sec, "秒，显示字幕：", subtitle_label.text)
