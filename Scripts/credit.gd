class_name credit
extends Node2D

const __CREDIT__ = preload("res://Asset/other/常规credit曲子.MP3")
@onready var zhugeliang: clickBlock = $"诸葛亮"

const badaoxian = preload("res://Asset/other/霸道线曲子.mp3")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.currenceScene=self
	initData()
	#if GameManager.sav.endPath==GameManager.endPath.xiaopei:
	#GameManager.sav.endPath=GameManager.endPath.xuzhou
	if GameManager.sav.endPath==GameManager.endPath.xuzhou:
		SoundManager.play_music(badaoxian)
	else:
		SoundManager.play_music(__CREDIT__)
	SoundManager.set_music_volume(1)

	if GameManager.sav.endPath==GameManager.endPath.xuzhou:

		credit_animation.play("credit_2")
	else:
		credit_animation.play("credit")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



@onready var animation_player: AnimationPlayer = $"ColorRect/中文logo/AnimationPlayer"

@onready var back_animation_player: AnimationPlayer = $"ColorRect/AnimationPlayer"

#开端可以了。剩下就是播bgm
#开始credit
func initData():
	await get_tree().create_timer(1.5).timeout
	var _endfunc=func(name):
		await get_tree().create_timer(3).timeout
		back_animation_player.play("colorRect")
		#back_animation_player.play("new_animation", -1) 

	animation_player.animation_finished.connect(_endfunc)	
		
	animation_player.play("new_animation")
@onready var bgfade: AnimationPlayer = $"内饰/bgfade"

@onready var credit_animation: AnimationPlayer = $creditAnimation

@onready var caocao: Node2D = $"曹操老"
@onready var guojia: Node2D = $"郭嘉"


func fade():
	bgfade.play("fadein")
	await get_tree().create_timer(1).timeout
	bgfade.play("fadeout")

const final = preload("res://Asset/bgm/会议室.wav")


func eggFunc():
	if GameManager.sav.endPath==GameManager.endPath.xiaopei:
		PanelManager.Fade_Blank(Color.BLACK,1,PanelManager.fadeType.fadeOut)
		SoundManager.play_ambient_sound(final)
		DialogueManager.show_example_dialogue_balloon(GameManager.sys,"彩蛋剧情")
	elif GameManager.sav.endPath==GameManager.endPath.xuzhou:
		PanelManager.Fade_Blank(Color.BLACK,1,PanelManager.fadeType.fadeOut)
		SoundManager.play_ambient_sound(final)
		DialogueManager.show_example_dialogue_balloon(GameManager.sys,"霸道线彩蛋剧情")

	else:
		settleGame()

@onready var finalBG: ColorRect = $CanvasLayer/final

@onready var what_final: Label = $CanvasLayer/final/whatFinal
@onready var detial: Label = $CanvasLayer/final/detial
@onready var score_tooltip_area: ColorRect = $CanvasLayer/final/scoreTooltipArea
@onready var rank_tooltip_area: ColorRect = $CanvasLayer/final/rankTooltipArea





#完成所有怪谈支线，
#将解锁霸道结局线索。


#打破历史桎梏，驯服所有怪谈支线，
#你以霸主之姿，叩响复兴汉室的大门。


@onready var settle_bg: TextureRect = $CanvasLayer/final/settleBg

const Badao_end = preload("res://Asset/end1.png")
const normal_end = preload("res://Asset/end2.png")
func settleGame():
	if GameManager.sav.day<10:
		_on_button_button_down()
	var finaldec=""
	
	if GameManager.sav.endPath!=GameManager.endPath.none:
		if GameManager.sav.endPath==GameManager.endPath.xiaopei:
			settle_bg.texture=normal_end
			what_final.text=tr("【恭喜你，通关正史结局】")
			finaldec=tr("集齐全部怪谈支线，\n即可解锁霸道结局前置线索。")
			
			#finaldec=tr("完成所有怪谈支线，\n将解锁霸道结局线索。")
		if GameManager.sav.endPath==GameManager.endPath.xuzhou:
			settle_bg.texture=Badao_end
			what_final.text=tr("【恭喜你，通关霸道结局】")
			finaldec=tr("打破历史桎梏，驯服所有怪谈支线，\n你以霸主之姿，叩响复兴汉室的大门。")
		
		finaldec=finaldec+"\n"+"【通关解锁快捷键功能：长按Ctrl可跳过全部对话。】"
		var diffucultLevel=GameManager.sav.gameDifficulty	
		var diffSrc=GameManager.get_difficulty_data(diffucultLevel)
		
		
		var line1=tr("游玩难度：{difficult}").format({"difficult":tr(diffSrc.type)+"（"+tr(diffSrc.name)+"）"})
		var line2=tr("游戏旬数：{day}").format({"day":GameManager.sav.day})
		var line3=tr("探索进度：{process}%").format({"process":GameManager.get_exploration_percent()})
		var line4=tr("累计得分：{score}").format({"score":GameManager.get_total_score()})
		var line5=tr("综合评级：{rank}").format({"rank":GameManager.get_score_rank()})
		detial.text=line1+"\n"+line2+"\n"+line3+"\n"+line4+"\n"+line5+"\n"+finaldec
		TooltipManager.register_tooltip(score_tooltip_area, _get_score_tooltip_text())
		TooltipManager.register_tooltip(rank_tooltip_area, _get_rank_tooltip_text())
	else:
		what_final.hide()
		detial.text="恭喜你通关试玩版，请期待正式游戏"
	
	finalBG.show()
	#修改finalBG


func _get_score_tooltip_text() -> String:
	var delay_text = "-" + str(GameManager.get_day_penalty())
	return tr("本局总评由治政、积蓄与功绩合计：") + "\n\n" \
		+ tr("基业底分：{score}").format({"score":GameManager.get_base_score()}) + "\n" \
		+ tr("钱粮积蓄：{score}").format({"score":GameManager.get_coin_score()}) + "\n" \
		+ tr("民力储备：{score}").format({"score":GameManager.get_labor_score()}) + "\n" \
		+ tr("民心安定：{score}").format({"score":GameManager.get_people_score()}) + "\n" \
		+ tr("府库道具：{score}").format({"score":GameManager.get_item_score()}) + "\n" \
		+ tr("探索功绩：{score}").format({"score":GameManager.get_exploration_score()}) + "\n" \
		+ tr("法令余裕：{score}").format({"score":GameManager.get_law_point_score()}) + "\n" \
		+ tr("迟滞惩罚：{score}").format({"score":delay_text}) + "\n\n" \
		+ tr("65旬后拖延将逐步扣分，旬数越久，惩罚越重。")


func _get_rank_tooltip_text() -> String:
	return tr("综合评级按最终得分判定：") + "\n\n" \
		+ tr("S+：9800+") + "\n" \
		+ tr("S ：8700-9799") + "\n" \
		+ tr("A ：7600-8699") + "\n" \
		+ tr("A-：6600-7599") + "\n" \
		+ tr("B ：5500-6599") + "\n" \
		+ tr("B-：5500 以下")

#ESC按钮，待开发
func _on_button_button_down() -> void:
	SoundManager.stop_all_ambient_sounds()
	GameManager.sav.endPath=GameManager.endPath.none
	SoundManager.set_music_volume(GameManager._setting.music_volume)
	GameManager.ReturnMenu()

var paused_animation_time 
#= animation_player.current_animation_position

@onready var control_sub: Control = $CanvasLayer/Control

func pauseCredit():
	SoundManager.pause_music()
	credit_animation.pause()
	control_sub.pause_subtitle()
	paused_animation_time = credit_animation.current_animation_position
func continusCredit():
	SoundManager.resume_music()
	
	control_sub.resume_subtitle()
	if GameManager.sav.endPath==GameManager.endPath.xuzhou:
		credit_animation.play("credit_2", paused_animation_time)
	else:
		credit_animation.play("credit", paused_animation_time)
	
