extends Resource
class_name SettingsResource

const NARRATIVE_MODE_STANDARD := "standard"
const NARRATIVE_MODE_HORROR_FILTERED := "horror_filtered"
const DEFAULT_SCENE_TRANSITION_DURATION := 2.0
const MAX_SCENE_TRANSITION_DURATION := 2.0

# 存储的分辨率（字符串格式，如 "1920x1080"）
@export var resolution: String = "1920x1080"
# 全屏状态
@export var fullscreen: bool = true

@export var isAutoSave: bool = true

# 音乐音量（线性值，0 到 1）
@export var music_volume: float = 0.25
# 游戏音量（线性值，0 到 1）
@export var sfx_volume: float = 1

# 人物音量
@export var people_volume:float=1
@export var bgs_volume:float=0.5
@export var peopleVlan:String="zh"
# 选中的语言
@export var language: String = ""

# 叙事氛围仅控制指定的惊悚演出，不改变剧情或战斗内容。
@export_enum("standard", "horror_filtered") var narrative_atmosphere: String = NARRATIVE_MODE_STANDARD
# 仅替换现有常规 2 秒场景转场；剧情专用的其他时长保持不变。
@export_range(0.5, MAX_SCENE_TRANSITION_DURATION, 0.1) var scene_transition_duration: float = DEFAULT_SCENE_TRANSITION_DURATION

@export var is_clear_overlord_line=false  # 通关霸道线
@export var is_clear_normal_line=false    # 通关常规线
@export var is_clear_prologue=false       # 主动通关小沛序章
@export var enable_rest_remind=false
@export var showMilitartInput=false


func is_horror_filter_enabled() -> bool:
	return narrative_atmosphere==NARRATIVE_MODE_HORROR_FILTERED


func resolve_scene_transition_duration(requested_seconds:float) -> float:
	var safe_requested:=maxf(requested_seconds,0.0)
	if not is_equal_approx(safe_requested,DEFAULT_SCENE_TRANSITION_DURATION):
		return safe_requested
	return clampf(scene_transition_duration,0.5,MAX_SCENE_TRANSITION_DURATION)
