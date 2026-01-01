extends Resource
class_name SettingsResource

# 存储的分辨率（字符串格式，如 "1920x1080"）
@export var resolution: String = "1920x1080"
# 全屏状态
@export var fullscreen: bool = true

@export var isAutoSave: bool = true

# 音乐音量（线性值，0 到 1）
@export var music_volume: float = 0.5
# 游戏音量（线性值，0 到 1）
@export var sfx_volume: float = 1

# 人物音量
@export var people_volume:float=1
@export var bgs_volume:float=1
@export var peopleVlan:String="none"
# 选中的语言
@export var language: String = ""
