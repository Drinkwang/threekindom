
extends Control
class_name battlePanel
@onready var battle_circle:DiskInBattle = $battleCircle

@onready var soild_num = $soildNum
@onready var coin_num = $coinNum



@onready var coin_slider = $coinSlider
@onready var soild_slider = $soildSlider
@onready var control_3 = $Control_3
@onready var control_2 = $Control_2
@onready var control_1 = $Control_1

@onready var point_group = $pointGroup

@onready var guild_1 = $"pointGroup/1"
@onready var guild_2 = $"pointGroup/2"
@onready var guild_3 = $"pointGroup/3"
@onready var rect_1: ColorRect = $sliderRect
@onready var rect_2: ColorRect = $fengxianRect
@onready var rect_3: ColorRect = $currenceRect
@onready var rect_4: ColorRect = $nextRect


#@onready var guild_4 = $"pointGroup/4"
#@onready var guild_5 = $"pointGroup/5"
#@onready var guild_6 = $"pointGroup/6"
#@onready var guild_7 = $"pointGroup/7"
#@onready var guild_8 = $"pointGroup/8"

@onready var panel_container: PanelContainer = $PanelContainer

@onready var sliderlabel_1 = $sliderlabel1
@onready var sliderlabel_2 = $sliderlabel2
@onready var title = $PanelContainer/orderPanel/VBoxContainer/Label2

@onready var select_detail = $PanelContainer/orderPanel/VBoxContainer/selectDetail
const SELECT_DETAIL_SIZE := Vector2(0, 150)
const SELECT_DETAIL_FONT_SIZE := 28
const USE_ITEM_BUTTON_SIZE := Vector2(500, 82)
const USE_ITEM_CHECK_BOX_RECT := Rect2(454, 23, 36, 36)
const USE_ITEM_LABEL_RECT := Rect2(-370, -14, 356, 64)
const USE_ITEM_LABEL_FONT_SIZE := 17
const TASK_LABEL_RECT := Rect2(1041, 768, 469, 168)
const TASK_LABEL_FONT_SIZE := 28

const DEFAULT_COST_HP := 30
const BOSS_COST_HP := 0

const GENERAL_SELECTED_OFFSET := Vector2(0, -8)
const GENERAL_SELECTED_SCALE := 1.055
const FX_GOLD := Color(1.0, 0.78, 0.22, 1.0)
const FX_BLUE := Color(0.22, 0.72, 1.0, 1.0)
const FX_ORANGE := Color(1.0, 0.42, 0.12, 1.0)
const FX_RED := Color(0.95, 0.10, 0.08, 1.0)

var _general_base_visuals:Dictionary = {}
var _general_move_tweens:Dictionary = {}
var _general_glow_tweens:Dictionary = {}
var _battle_fx_layer:Control
var _battle_fx_overlay:ColorRect

var costhp=DEFAULT_COST_HP
# Called when the node enters the scene tree for the first time.
func _ready():
	_setup_battle_feedback()
	_refreshSlider()
	_refreshGeneral()
	initTask()
	SignalManager.endReward.connect(endBattle)
	battle_circle.isBoot=false

	changeLanguage()

	SignalManager.changeLanguage.connect(changeLanguage)			
	
	SignalManager.initBattle.connect(refreshData)
	visibility_changed.connect(_on_battle_pane_visibility_changed)

func _setup_battle_feedback():
	for general in _get_general_cards():
		_general_base_visuals[general] = {
			"position": general.position,
			"scale": general.scale,
			"rotation": general.rotation,
			"pivot_offset": general.pivot_offset,
			"self_modulate": general.self_modulate
		}
		var glow := Panel.new()
		glow.name = "BattleSelectionGlow"
		glow.position = Vector2(16, 18)
		glow.size = Vector2(282, 280)
		glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
		glow.z_index = 20
		var glow_style := StyleBoxFlat.new()
		glow_style.bg_color = Color(1.0, 0.68, 0.15, 0.035)
		glow_style.border_color = FX_GOLD
		glow_style.set_border_width_all(5)
		glow_style.set_corner_radius_all(12)
		glow.add_theme_stylebox_override("panel", glow_style)
		glow.modulate.a = 0.0
		general.add_child(glow)

	_battle_fx_layer = Control.new()
	_battle_fx_layer.name = "BattleResultFx"
	_battle_fx_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_battle_fx_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_battle_fx_layer.z_index = 100
	add_child(_battle_fx_layer)

	_battle_fx_overlay = ColorRect.new()
	_battle_fx_overlay.name = "ImpactOverlay"
	_battle_fx_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_battle_fx_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_battle_fx_overlay.color = Color(1, 1, 1, 0)
	_battle_fx_layer.add_child(_battle_fx_overlay)

func _get_general_cards() -> Array:
	return [control_1, control_2, control_3]

func _get_selected_general_card() -> SoilderItem:
	match selectIndex:
		1:
			return control_1
		2:
			return control_2
		3:
			return control_3
	return null

func _kill_general_feedback_tweens(general:Control):
	if _general_move_tweens.has(general):
		var move_tween = _general_move_tweens[general]
		if move_tween != null and move_tween.is_valid():
			move_tween.kill()
		_general_move_tweens.erase(general)
	if _general_glow_tweens.has(general):
		var glow_tween = _general_glow_tweens[general]
		if glow_tween != null and glow_tween.is_valid():
			glow_tween.kill()
		_general_glow_tweens.erase(general)

func _set_pivot_preserving_layout(control:Control, new_pivot:Vector2):
	if control.pivot_offset.is_equal_approx(new_pivot):
		return
	# Control 的屏幕原点包含 (1 - scale) * pivot_offset。
	# 切换枢轴时反向补偿 position，保证屏幕位置一像素也不跳。
	var old_pivot := control.pivot_offset
	control.position += (Vector2.ONE - control.scale) * (old_pivot - new_pivot)
	control.pivot_offset = new_pivot

func _general_effect_pivot(general:SoilderItem) -> Vector2:
	return general.head.position + general.head.size * 0.5

func _reset_general_feedback(animate:bool=false):
	for general in _get_general_cards():
		if not _general_base_visuals.has(general):
			continue
		_kill_general_feedback_tweens(general)
		var base:Dictionary = _general_base_visuals[general]
		var glow:Panel = general.get_node_or_null("BattleSelectionGlow")
		if glow != null:
			glow.modulate.a = 0.0
		if animate:
			_set_pivot_preserving_layout(general, base.pivot_offset)
			var tween := create_tween().set_parallel(true)
			tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			tween.tween_property(general, "position", base.position, 0.14)
			tween.tween_property(general, "scale", base.scale, 0.14)
			tween.tween_property(general, "rotation", base.rotation, 0.14)
			tween.tween_property(general, "self_modulate", base.self_modulate, 0.14)
			_general_move_tweens[general] = tween
		else:
			general.pivot_offset = base.pivot_offset
			general.position = base.position
			general.scale = base.scale
			general.rotation = base.rotation
			general.self_modulate = base.self_modulate

func _clear_general_selection():
	_reset_general_feedback(false)
	selectIndex = null
	for general in _get_general_cards():
		general.check_box.button_pressed = false
	if battle_circle != null:
		battle_circle.selectgeneral = null

func _animate_general_selected(index:int):
	_reset_general_feedback(true)
	var general:SoilderItem = _get_selected_general_card()
	if general == null or not _general_base_visuals.has(general):
		return
	_kill_general_feedback_tweens(general)
	var base:Dictionary = _general_base_visuals[general]
	var effect_pivot := _general_effect_pivot(general)
	_set_pivot_preserving_layout(general, effect_pivot)
	var centered_base_position:Vector2 = base.position + (Vector2.ONE - base.scale) * (base.pivot_offset - effect_pivot)
	var tween := create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(general, "position", centered_base_position + GENERAL_SELECTED_OFFSET, 0.2)
	tween.tween_property(general, "scale", base.scale * GENERAL_SELECTED_SCALE, 0.2)
	tween.tween_property(general, "self_modulate", Color(1.08, 1.03, 0.88, 1.0), 0.2)
	_general_move_tweens[general] = tween

	var glow:Panel = general.get_node_or_null("BattleSelectionGlow")
	if glow != null:
		glow.modulate.a = 0.25
		var glow_tween := create_tween().set_loops()
		glow_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		glow_tween.tween_property(glow, "modulate:a", 0.95, 0.42)
		glow_tween.tween_property(glow, "modulate:a", 0.28, 0.58)
		_general_glow_tweens[general] = glow_tween

func play_launch_feedback():
	var general:SoilderItem = _get_selected_general_card()
	if general == null:
		return
	_kill_general_feedback_tweens(general)
	var start_position := general.position
	var start_scale := general.scale
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(general, "scale", start_scale * Vector2(1.06, 0.92), 0.09)
	tween.parallel().tween_property(general, "position", start_position + Vector2(0, 5), 0.09)
	tween.tween_property(general, "scale", start_scale * Vector2(0.98, 1.04), 0.11)
	tween.parallel().tween_property(general, "position", start_position + Vector2(0, -3), 0.11)
	tween.tween_property(general, "scale", start_scale, 0.14)
	tween.parallel().tween_property(general, "position", start_position, 0.14)
	_general_move_tweens[general] = tween

func _risk_level(end) -> int:
	match end:
		"小风险":
			return 1
		"中风险":
			return 2
		"高风险":
			return 3
	return 0

func _fx_local_center(control:Control) -> Vector2:
	var global_center := control.get_global_rect().get_center()
	return _battle_fx_layer.get_global_transform_with_canvas().affine_inverse() * global_center

func _create_attack_streak(from:Vector2, to:Vector2, color:Color, width:float=10.0):
	var line := Line2D.new()
	line.name = "AttackStreak"
	line.points = PackedVector2Array([from, from.lerp(to, 0.35), to])
	line.width = width
	line.default_color = color
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.modulate.a = 0.0
	_battle_fx_layer.add_child(line)
	var tween := create_tween()
	tween.tween_property(line, "modulate:a", 1.0, 0.045)
	tween.tween_property(line, "width", width * 0.35, 0.12)
	tween.parallel().tween_property(line, "modulate:a", 0.0, 0.12)
	tween.tween_callback(line.queue_free)

func _create_impact_burst(center:Vector2, color:Color, intensity:float=1.0):
	var burst := Node2D.new()
	burst.name = "ImpactBurst"
	burst.position = center
	burst.scale = Vector2(0.25, 0.25)
	_battle_fx_layer.add_child(burst)
	# 特效使用独立随机源，不能推进战斗结算所使用的全局随机序列。
	var fx_rng := RandomNumberGenerator.new()
	fx_rng.seed = Time.get_ticks_usec() + int(center.x * 31.0 + center.y * 17.0)
	for i in range(12):
		var angle := TAU * float(i) / 12.0 + fx_rng.randf_range(-0.11, 0.11)
		var direction := Vector2.RIGHT.rotated(angle)
		var ray := Line2D.new()
		ray.points = PackedVector2Array([direction * 12.0, direction * fx_rng.randf_range(34.0, 62.0) * intensity])
		ray.width = fx_rng.randf_range(2.5, 5.5) * intensity
		ray.default_color = color
		ray.begin_cap_mode = Line2D.LINE_CAP_ROUND
		ray.end_cap_mode = Line2D.LINE_CAP_ROUND
		burst.add_child(ray)
	var ring := Line2D.new()
	var points := PackedVector2Array()
	for i in range(33):
		var angle := TAU * float(i) / 32.0
		points.append(Vector2.RIGHT.rotated(angle) * 25.0)
	ring.points = points
	ring.width = 4.0 * intensity
	ring.default_color = color
	burst.add_child(ring)
	var tween := create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(burst, "scale", Vector2.ONE * (1.25 + intensity * 0.18), 0.28)
	tween.tween_property(burst, "modulate:a", 0.0, 0.32).set_delay(0.08)
	tween.chain().tween_callback(burst.queue_free)

func _flash_battle_overlay(color:Color, alpha:float, duration:float=0.22):
	_battle_fx_overlay.color = Color(color.r, color.g, color.b, 0.0)
	var tween := create_tween()
	tween.tween_property(_battle_fx_overlay, "color:a", alpha, 0.045)
	tween.tween_property(_battle_fx_overlay, "color:a", 0.0, duration)

func _pulse_battle_circle(end, is_success:bool):
	var sector_index := _risk_level(end)
	if sector_index >= 0 and sector_index < 4:
		var sector:TextureProgressBar = battle_circle.datas[sector_index]
		var sector_color := sector.modulate
		var sector_tween := create_tween()
		sector_tween.tween_property(sector, "modulate", Color(1.8, 1.35, 0.55, 1.0), 0.08)
		sector_tween.tween_property(sector, "modulate", sector_color, 0.28)
	if is_success:
		var success_sector:TextureProgressBar = battle_circle.datas[4]
		var success_color := success_sector.modulate
		var success_tween := create_tween()
		success_tween.tween_property(success_sector, "modulate", Color(0.55, 1.45, 2.0, 1.0), 0.08)
		success_tween.tween_property(success_sector, "modulate", success_color, 0.32)
	var circle_center := _fx_local_center(battle_circle.datas[0])
	_create_impact_burst(circle_center, FX_BLUE if is_success else FX_RED, 0.75)

func _play_selected_slash():
	if selectIndex == null:
		return
	var anisprite:Sprite2D = self["ani_" + var_to_str(selectIndex)]
	if anisprite == null:
		return
	var ani:AnimationPlayer = anisprite.get_child(0)
	anisprite.show()
	ani.stop()
	ani.play("slash")
	ani.animation_finished.connect(func(_anim_name:StringName): anisprite.hide(), CONNECT_ONE_SHOT)

func _animate_enemy_hit(intensity:float):
	var target:SoilderItem = battle_circle.enemy
	var original_pivot:Vector2 = target.pivot_offset
	var effect_pivot:Vector2 = target.head.position + target.head.size * 0.5
	_set_pivot_preserving_layout(target, effect_pivot)
	var base_position := target.position
	var base_scale := target.scale
	var base_rotation := target.rotation
	var base_modulate := target.self_modulate
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(target, "position", base_position + Vector2(-9, 1) * intensity, 0.055)
	tween.parallel().tween_property(target, "scale", base_scale * Vector2(0.92, 1.07), 0.055)
	tween.parallel().tween_property(target, "self_modulate", Color(2.2, 2.2, 2.2, 1.0), 0.045)
	tween.tween_property(target, "position", base_position + Vector2(13, -2) * intensity, 0.07)
	tween.parallel().tween_property(target, "rotation", 0.025 * intensity, 0.07)
	tween.parallel().tween_property(target, "self_modulate", Color(1.35, 0.42, 0.32, 1.0), 0.07)
	for offset in [Vector2(-7, 2), Vector2(5, -1), Vector2(-3, 0)]:
		tween.tween_property(target, "position", base_position + offset * intensity, 0.045)
	tween.tween_property(target, "position", base_position, 0.14)
	tween.parallel().tween_property(target, "scale", base_scale, 0.14)
	tween.parallel().tween_property(target, "rotation", base_rotation, 0.14)
	tween.parallel().tween_property(target, "self_modulate", base_modulate, 0.14)
	tween.tween_callback(func(): _set_pivot_preserving_layout(target, original_pivot))

func _animate_enemy_counter_cue(direction:Vector2):
	var target:SoilderItem = battle_circle.enemy
	var original_pivot:Vector2 = target.pivot_offset
	var effect_pivot:Vector2 = target.head.position + target.head.size * 0.5
	_set_pivot_preserving_layout(target, effect_pivot)
	var base_position := target.position
	var base_scale := target.scale
	var base_modulate := target.self_modulate
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(target, "scale", base_scale * Vector2(0.94, 1.06), 0.1)
	tween.parallel().tween_property(target, "self_modulate", Color(1.45, 0.35, 0.28, 1.0), 0.1)
	tween.tween_property(target, "position", base_position + direction * 12.0, 0.1)
	tween.parallel().tween_property(target, "scale", base_scale * 1.04, 0.1)
	tween.tween_property(target, "position", base_position, 0.16)
	tween.parallel().tween_property(target, "scale", base_scale, 0.16)
	tween.parallel().tween_property(target, "self_modulate", base_modulate, 0.16)
	tween.tween_callback(func(): _set_pivot_preserving_layout(target, original_pivot))

func _animate_general_victory(general:SoilderItem, risk:int):
	var start_position := general.position
	var start_scale := general.scale
	var tint := FX_GOLD if risk < 2 else FX_ORANGE
	var shake := 1.5 + risk * 1.8
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(general, "position", start_position + Vector2(0, -9), 0.1)
	tween.parallel().tween_property(general, "scale", start_scale * 1.045, 0.1)
	tween.parallel().tween_property(general, "self_modulate", Color(1.25, 1.12, 0.72, 1.0), 0.1)
	if risk >= 2:
		for direction in [-1.0, 1.0, -0.55, 0.35]:
			tween.tween_property(general, "position:x", start_position.x + shake * direction, 0.035)
	tween.tween_property(general, "position", start_position, 0.16)
	tween.parallel().tween_property(general, "scale", start_scale, 0.16)
	tween.parallel().tween_property(general, "self_modulate", Color(tint.r, tint.g, tint.b, 1.0), 0.08)
	tween.tween_property(general, "self_modulate", Color(1.08, 1.03, 0.88, 1.0), 0.16)
	_general_move_tweens[general] = tween

func _animate_general_hit(general:SoilderItem, risk:int):
	var start_position := general.position
	var start_scale := general.scale
	var intensity := 1.0 + risk * 0.18
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(general, "position", start_position + Vector2(10, 3) * intensity, 0.055)
	tween.parallel().tween_property(general, "scale", start_scale * Vector2(0.94, 1.04), 0.055)
	tween.parallel().tween_property(general, "self_modulate", Color(2.0, 0.34, 0.28, 1.0), 0.055)
	for offset in [Vector2(-8, -1), Vector2(6, 1), Vector2(-4, 0), Vector2(2, 0)]:
		tween.tween_property(general, "position", start_position + offset * intensity, 0.045)
	tween.tween_property(general, "position", start_position, 0.18)
	tween.parallel().tween_property(general, "scale", start_scale, 0.18)
	tween.parallel().tween_property(general, "self_modulate", Color(1.08, 1.03, 0.88, 1.0), 0.18)
	_general_move_tweens[general] = tween

func play_battle_result_feedback(end, is_success:bool):
	var general:SoilderItem = _get_selected_general_card()
	if general == null or _battle_fx_layer == null:
		return
	_kill_general_feedback_tweens(general)
	var glow:Panel = general.get_node_or_null("BattleSelectionGlow")
	if glow != null:
		glow.modulate.a = 0.8
	var risk := _risk_level(end)
	var circle_center := _fx_local_center(battle_circle.datas[0])
	var enemy_center := _fx_local_center(battle_circle.enemy.head)
	var general_center := _fx_local_center(general.head)
	_pulse_battle_circle(end, is_success)

	if is_success:
		_play_selected_slash()
		_create_attack_streak(general_center, circle_center, Color(FX_GOLD, 0.72), 5.0)
		await get_tree().create_timer(0.16).timeout
		_create_attack_streak(circle_center, enemy_center, Color(FX_BLUE, 0.95), 13.0 + risk * 1.5)
		_create_impact_burst(enemy_center, FX_GOLD if risk < 2 else FX_ORANGE, 1.0 + risk * 0.12)
		_flash_battle_overlay(FX_GOLD, 0.11 + risk * 0.018, 0.2)
		#SoundManager.play_sound(sounds.SWORD_PANG)
		_animate_enemy_hit(1.0 + risk * 0.12)
		_animate_general_victory(general, risk)
		await get_tree().create_timer(0.66).timeout
	else:
		var counter_direction := (_fx_local_center(general.head) - enemy_center).normalized()
		_animate_enemy_counter_cue(counter_direction)
		_flash_battle_overlay(FX_RED, 0.08, 0.16)
		await get_tree().create_timer(0.18).timeout
		_create_attack_streak(enemy_center, general_center, Color(FX_RED, 0.96), 12.0 + risk * 1.8)
		_create_impact_burst(general_center, FX_RED, 0.95 + risk * 0.14)
		_flash_battle_overlay(FX_RED, 0.13 + risk * 0.025, 0.24)
		#SoundManager.play_sound(sounds.SWORD_PANG)
		_animate_general_hit(general, risk)
		await get_tree().create_timer(0.62).timeout

	if is_instance_valid(general):
		_animate_general_selected(selectIndex)

func _on_battle_pane_visibility_changed():
	if not visible and not _general_base_visuals.is_empty():
		_reset_general_feedback(false)
		if _battle_fx_overlay != null:
			_battle_fx_overlay.color.a = 0.0
	

const NOT_JAM_UI_CONDENSED_16 = preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")

func refreshData():
	_clear_general_selection()
	if _mode==SceneManager.bossMode.none:
		costhp=DEFAULT_COST_HP
	
	_refreshSlider()
	_refreshGeneral()
	initTask()	
	battle_circle.refreshPage()
	
	

func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	_apply_battle_layout()

	#if currencelanguage=="ru":
		#sliderlabel_1.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		#sliderlabel_2.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		#select_detail.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		#title.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
	#else:
		#sliderlabel_1.remove_theme_font_override("font")
		#sliderlabel_2.remove_theme_font_override("font")
		#select_detail.remove_theme_font_override("font")
		#title.remove_theme_font_override("font")
#可能会删除
	if GameManager.sav.battleEnhance!=0:
		var battleEnhance=GameManager.sav.battleEnhance
		var EnhanceContext=tr("[法令提升了战利品收益{profit}%]").format({"profit":battleEnhance*25})
		TooltipManager.register_tooltip(lauchBtn,EnhanceContext)
		
		
		

	var _item_db=InventoryManager.get_item_db(InventoryManagerItem.胜战锦囊)
	var properties:Array=_item_db.properties

		
	var detail=properties.filter(func(a):return a["name"]=="detail")[0]
	#var _context
	#if tr(detail["value"]).length()>0:
					
	#	_context=tr(_item_db.name)+":"+tr(detail["value"])

					

					
	await get_tree().process_frame
	if GameManager.currenceScene!=null:
		GameManager.currenceScene.refreshBattlePanePos()

func _apply_battle_layout():
	select_detail.custom_minimum_size = SELECT_DETAIL_SIZE
	select_detail.add_theme_font_size_override("font_size", SELECT_DETAIL_FONT_SIZE)
	select_detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	#select_detail.clip_text = true

	useItemPanel.custom_minimum_size = USE_ITEM_BUTTON_SIZE
	check_box.position = USE_ITEM_CHECK_BOX_RECT.position
	check_box.size = USE_ITEM_CHECK_BOX_RECT.size
	label.position = USE_ITEM_LABEL_RECT.position
	label.size = USE_ITEM_LABEL_RECT.size
	label.add_theme_font_size_override("font_size", USE_ITEM_LABEL_FONT_SIZE)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.clip_text = true

	task_label.position = TASK_LABEL_RECT.position
	task_label.size = TASK_LABEL_RECT.size
	task_label.add_theme_font_size_override("font_size", TASK_LABEL_FONT_SIZE)
	task_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	task_label.clip_text = true

		
func initData():
	battle_circle.refreshPage()
	if GameManager._setting.showMilitartInput==true:
		line_edit_coin.show()
		line_edit_soilder.show()
	else:
		line_edit_coin.hide()
		line_edit_soilder.hide()				
func endBattle():
	if self.visible==false:
		return
	_clear_general_selection()
	soild_slider.value=0
	coin_slider.value=0
	_refreshSlider()
	initTask()
	_refreshGeneral()
	#刷新界面
	var bossMode=scenemanager.bossMode
	if battle_circle.taskIndex==2:
		if _mode==bossMode.tao:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"真相揭露_陶谦")
		elif  _mode==bossMode.mi:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"真相揭露_血姬")
		elif _mode==bossMode.huang:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"真相揭露_镇魂龙")
	elif battle_circle.taskIndex==0:
		battle_circle.taskIndex=-1
		var wincount=battle_circle.getWinCount()
		if wincount>=3:
			if _mode==bossMode.tao:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗胜利_陶谦")
			elif  _mode==bossMode.mi:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗胜利_血姬")
			elif _mode==bossMode.huang:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗胜利_镇魂龙")
			elif _mode==bossMode.zhenren:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗胜利_真人")	
		else:
			if _mode==bossMode.tao:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗失败_陶谦")
			elif  _mode==bossMode.mi:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗失败_血姬")
			elif  _mode==bossMode.huang:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗失败_镇魂龙")		
@onready var useItemPanel = $PanelContainer/orderPanel/VBoxContainer/HBoxContainer2/TextureButton
@onready var label = $PanelContainer/orderPanel/VBoxContainer/HBoxContainer2/TextureButton/CheckBox/Label


@onready var check_box: CheckBox = $PanelContainer/orderPanel/VBoxContainer/HBoxContainer2/TextureButton/CheckBox


func refreshUseItemPanel():
	var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.胜战锦囊)

	if num>0:
		useItemPanel.show()
		

		var context=tr("_battleUseItem").format({"_num":num})
		
		if InventoryManager.has_item(InventoryManagerItem.迷魂木筒):
			context = context.replace("40", "50") 
		label.text=context
		if GameManager.sav.useItemInBattle:
			check_box.button_pressed=true
	else:
	
		useItemPanel.hide()
		GameManager.sav.useItemInBattle=false

	

func _refreshGeneral():
	refreshUseItemPanel()
	control_1.updateContext(0)
	control_2.updateContext(1)	
	control_3.updateContext(2)	
	if GameManager.sav.UseGeneral.size()>0:
		for ele in GameManager.sav.UseGeneral:
			#var index=GameManager.sav.generals.values().find(ele)
			#var value=GameManager.sav.generals.values().filter(func(a):a.name==ele.name)[0]
			var key=GameManager.sav.generals.find_key(ele)
			#改成不一定是index,index是乱序的
			for i in range(1,4):
				var soider:SoilderItem=self.find_child("Control_"+str(i))
				if soider.repImg==key:
					soider.Use()
					break
			#var finde:SoilderItem=self.find_child("Control_"+str(index+1)) as SoilderItem
			#finde.Use()
	else:
		for i in range(1,4):
			var soider:SoilderItem=self.find_child("Control_"+str(i))

			soider.alreadyUse=false	
			soider.updateContext(i-1)

#
#将任务给创建出来
#将当前石头剪刀布 和战力给创建出来

@onready var lauchBtn = $PanelContainer/orderPanel/VBoxContainer/HBoxContainer/Button

func _refreshSlider():
	
	
	soild_slider.max_value=GameManager.sav.labor_force
	coin_slider.max_value=GameManager.sav.coin
	if GameManager.sav.labor_force<0 or _mode==SceneManager.bossMode.mi:
		soild_slider.editable=false

	else:
		soild_slider.editable=true
	if GameManager.sav.coin<0 or _mode==SceneManager.bossMode.tao: 
		coin_slider.editable=false
	else:
		coin_slider.editable=true
	if battle_circle.selectgeneral==null:
		lauchBtn.disabled=true
		soild_slider.editable=false
		coin_slider.editable=false	
	else:
		lauchBtn.disabled=false	
@onready var task_label = $TaskLabel

func initTask():
	refreshTask(false)

func refreshTask(checkSlider:bool=true):
	if battle_circle.taskIndex<0 or GameManager.sav.battleTasks==null or GameManager.sav.battleTasks.size()<=0:
		return

	var levels=1

	if battle_circle.selectgeneral!=null:
		var generalLevel=battle_circle.selectgeneral.level
		var generalName=battle_circle.selectgeneral.name
		var isBloodBattle=GameManager.sav.have_event["战斗袁术血战模式"]==true and GameManager.sav.have_event["血战袁术完成"]==false
		var hasWeapon=false
		if generalName=="关羽":
			hasWeapon=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.青龙偃月刀)>0
		elif generalName=="张飞":
			if isBloodBattle:
				generalLevel=10
				hasWeapon=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.雌雄双股剑)>0
			else:
				hasWeapon=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.丈八蛇矛)>0
		elif generalName=="无名":
			hasWeapon=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.龙胆亮银枪)>0

		levels=1.0889-(0.0889*generalLevel)
		if hasWeapon:
			levels=levels*0.7

	var currence= GameManager.sav.battleTasks[battle_circle.taskIndex]
	var context=tr("战术目标：")
	var index=1;
	var taskcontext=""
	var targetValue
	var haveRes:int
	var minValue:int
	var isCompleted:bool
	var bossMode=scenemanager.bossMode

	for task in currence.task:
		targetValue=floor(task.value*levels)
		isCompleted=false
		var taskAdded=false

		# ——— 资金类任务 ———
		if task.res=="coin" and _mode!=bossMode.tao:
			taskcontext="\n"+str(index)
			haveRes=costcoin
			minValue=int(floor(targetValue*2/3))
			taskAdded=true

			if task.symbol==GameManager.opcost.greater:
				isCompleted=haveRes>targetValue
				if _mode==bossMode.mi:
					taskcontext+=tr(".血金祭坛:")+tr("(资金超过{targetValue})").format({"targetValue": targetValue})
				else:
					taskcontext+=tr(".工程战:")+tr("(资金超过{targetValue})").format({"targetValue": targetValue})
			elif task.symbol==GameManager.opcost.equal:
				isCompleted=haveRes==targetValue
				if _mode==bossMode.mi:
					taskcontext+=tr(".血金秘术:")+tr("(资金等于{targetValue})").format({"targetValue": targetValue})
				else:
					taskcontext+=tr(".特种战:")+tr("(资金等于{targetValue})").format({"targetValue": targetValue})
			elif task.symbol==GameManager.opcost.less:
				isCompleted=haveRes<targetValue and haveRes>minValue
				if _mode==bossMode.mi:
					taskcontext+=tr(".商贾幻影:")+tr("(资金小于{targetValue} 但大于{targetValue2})").format({"targetValue": targetValue,"targetValue2":minValue})
				else:
					taskcontext+=tr(".游击战:")+tr("(资金小于{targetValue} 但大于{targetValue2})").format({"targetValue": targetValue,"targetValue2":minValue})

		# ——— 兵力类任务 ———
		if task.res=="human" and _mode!=bossMode.mi:
			taskcontext="\n"+str(index)
			haveRes=costsoild
			minValue=int(floor(targetValue*3/5))
			taskAdded=true

			if task.symbol==GameManager.opcost.greater:
				isCompleted=haveRes>targetValue
				if _mode==bossMode.tao:
					taskcontext+=tr(".尸皇怒吼:")+tr("(兵力超过{targetValue})").format({"targetValue": targetValue})
				else:
					taskcontext+=tr(".遭遇战:")+tr("(兵力超过{targetValue})").format({"targetValue": targetValue})
			elif task.symbol==GameManager.opcost.equal:
				isCompleted=haveRes==targetValue
				if _mode==bossMode.tao:
					taskcontext+=tr(".怨魂诡阵:")+tr("(兵力等于{targetValue})").format({"targetValue": targetValue})
				else:
					taskcontext+=tr(".奇兵任务:")+tr("(兵力等于{targetValue})").format({"targetValue": targetValue})
			elif task.symbol==GameManager.opcost.less:
				isCompleted=haveRes<targetValue and haveRes>minValue
				if _mode==bossMode.tao:
					taskcontext+=tr(".冥界壁垒:")+tr("(兵力小于{targetValue} 但大于{targetValue2})").format({"targetValue": targetValue,"targetValue2":minValue})
				else:
					taskcontext+=tr(".防守战:")+tr("(兵力小于{targetValue} 但大于{targetValue2})").format({"targetValue": targetValue,"targetValue2":minValue})

		if not taskAdded:
			continue
		# 标记已达成
		if checkSlider and isCompleted:
			taskcontext+=tr("【已达成，伤亡降低】")

		context+=taskcontext
		index+=1

	if currence.task.size()==0:
		task_label.text=context+tr("无")
	elif index==1:
		task_label.text=context+tr("无")
	else:
		task_label.text=context
	if TooltipManager and TooltipManager.has_method("register_tooltip"):
		TooltipManager.register_tooltip(task_label,tr("武将等级与专属武器，可降低战术目标物资损耗"))
		_apply_battle_layout()

func _fit_task_label_height():
		pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
var _cursor_in_rect:bool=false

func _process(_delta):
	if self.visible==true:
		var mouse_pos = get_global_mouse_position()
		var rect = Rect2(373, 504, 596, 104)
		if rect.has_point(mouse_pos):
			if not _cursor_in_rect:
				_cursor_in_rect=true
				GameManager.restore_system_cursor()
		else:
			if _cursor_in_rect:
				_cursor_in_rect=false
				GameManager.apply_game_cursor()


func _changeProgress():

	battle_circle._processSuccussCircle(costcoin,costsoild)
	pass

var costcoin:int
var costsoild:int

func _soilderNum_changed(value):
	if battle_circle.isBoot==true:
		return

	#costsoild=(GameManager.sav.labor_force*value/100)
	costsoild=value

	soild_num.set_text(str(costsoild))  #报错没有找到 先屏蔽，后续开启
	if(battle_circle.selectgeneral):
		_changeProgress()
		refreshTask(true)


func _on_coin_slider_value_changed(value):
	if battle_circle.isBoot==true:
		return
	#costcoin=(GameManager.sav.coin*value/100)
	costcoin=value
	coin_num.text=str(costcoin)
	if GameManager.sav.extraBattleTaskEnum!=SceneManager.etraTaskType.none:
		battle_circle.refreshTempHideBattleTask()
	if(battle_circle.selectgeneral):
		_changeProgress()
		refreshTask(true)

var selectIndex
#BOOT结算完后将对应的general转换成use 然后同时也结算
#{"name": "关羽", "level": 1, "max_level": 10, "randominit": -1}
func _on_control_3_gui_input(event):

	if battle_circle.isBoot==true||control_3.canSelect==false||control_3.alreadyUse==true or(GameManager.sav.have_event["无名之死"]==true and GameManager.sav.have_event["夏侯偷马"]==false):
		return	
	
	if(event is InputEventMouseButton and event.button_index==1 or istour==true):	
		SoundManager.play_sound(sounds.CLICKHERO)		
		control_3.check_box.button_pressed=true
		control_2.check_box.button_pressed=false
		control_1.check_box.button_pressed=false
		selectIndex=3
		_animate_general_selected(selectIndex)
		battle_circle.selectgeneral= GameManager.sav.generals[control_3.repImg]
		battle_circle._juideCompeleteTask()
		_refreshSlider()
		previewHpdone()
		refreshTask(true)
	#取消其它的选中状态
	#给当前标记为选中
	#将选中将领具体信息发送给disk	
	pass # Replace with function body.


func _on_control_2_gui_input(event):

	if battle_circle.isBoot==true||control_2.canSelect==false||control_2.alreadyUse==true:
		return	
	if(event is InputEventMouseButton and event.button_index==1 or istour==true):	
		SoundManager.play_sound(sounds.CLICKHERO)
		control_1.check_box.button_pressed=false
		control_2.check_box.button_pressed=true
		control_3.check_box.button_pressed=false
		selectIndex=2
		_animate_general_selected(selectIndex)
		battle_circle.selectgeneral= GameManager.sav.generals[control_2.repImg]
		battle_circle._juideCompeleteTask() 
		_refreshSlider()
		previewHpdone()
		refreshTask(true)
var istour=false
func _on_control_1_gui_input(event):

	if battle_circle.isBoot==true||control_1.canSelect==false||control_1.alreadyUse==true or (GameManager.sav.have_event["关羽求援期间"]==true and GameManager.sav.have_event["关羽求援结束"]==false):
		return
	if(event is InputEventMouseButton and event.button_index==1 or istour==true):		
		SoundManager.play_sound(sounds.CLICKHERO)		
		control_3.check_box.button_pressed=false
		control_2.check_box.button_pressed=false
		control_1.check_box.button_pressed=true
		selectIndex=1
		_animate_general_selected(selectIndex)
		battle_circle.selectgeneral= GameManager.sav.generals[control_1.repImg]
		battle_circle._juideCompeleteTask()	 
		_refreshSlider()
		previewHpdone()
		refreshTask(true)
func previewHpdone():
	if GameManager.haveMirror():
		GameManager._engerge.startPreviewHp(costhp)

@onready var ani_1 = $ani_1
@onready var ani_2 = $ani_2
@onready var ani_3 = $ani_3

#出征按钮
func _on_button_button_down():
	if GameManager.currenceScene.battle_pane._mode==SceneManager.bossMode.none:
		if await GameManager.isTried(costhp) or \
		(GameManager.sav.have_event["无名之死"]==true and GameManager.sav.have_event["夏侯偷马"]==false and selectIndex==3) or\
		(GameManager.sav.have_event["关羽求援期间"]==true and GameManager.sav.have_event["关羽求援结束"]==false and selectIndex==1):
			return 
	if battle_circle.isBoot==false:
		
		SoundManager.play_sound(sounds.ZHUANPAN)
		play_launch_feedback()
		battle_circle.lauchProgress(costhp)
		lauchBtn.disabled=true
		
	pass # Replace with function body.
@export var dialogue_resource:DialogueResource
#推出按钮，同时调用结束
func _on_exit_button_button_down():
	GameManager._engerge.stopPreviewHP()
	_clear_general_selection()
	self.hide()
	GameManager.currenceScene.res_panel.position.x=1403
	GameManager.currenceScene.res_panel.position.y=622
	GameManager.currenceScene.res_panel.scale=Vector2(1,1)
	GameManager.currenceScene.refreshData()
	SoundManager.play_sound(sounds.declinesound)
	#大人
	if GameManager.sav.day==3:
		if GameManager.sav.hp<=10:
			if GameManager.sav.have_event["firstBattleEnd"]==false:
				GameManager.sav.have_event["firstBattleEnd"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"军事行动结束")
				GameManager.sav.destination="自宅"	
	 # Replace with function body.


var buffSize=0
func _on_Usecheck_box_toggled(toggled_on):

	GameManager.sav.useItemInBattle=toggled_on
	
	buffSize=5;
	_changeProgress()
	#接下来的代码，改变胜率，让胜率的东西往前一丢丢

@onready var ban_2_coin = $ban2
@onready var ban_1_soilder = $ban1

@export var _mode:SceneManager.bossMode=SceneManager.bossMode.none
func refreshHead():
	battle_circle.changeHeadInMainTask()

func enterBattleMi():
	_mode=SceneManager.bossMode.mi
	costhp=BOSS_COST_HP
	close_btn.hide()
	ban_1_soilder.show()
	battle_circle.taskIndex=0
	soild_slider.editable=false
	#soild_slider.enan;
	battle_circle.enemyName="糜贞"
	point_group.hide()
	var cha=load("res://Asset/人物/mizhen_battle.png")
	
	for  data in GameManager.sav.battleTasks.values():
		data.task=[]	
	battle_circle.changeHead(cha)
	initTask()
@onready var close_btn = $TextureButton

func enterBattleTao():
	
	
	point_group.hide()
	close_btn.hide()
	_mode=SceneManager.bossMode.tao
	costhp=BOSS_COST_HP
	ban_2_coin.show()
	coin_slider.editable=false	
	var cha=load("res://Asset/人物/尸皇.png")
	battle_circle.enemyName="陶谦"
	battle_circle.changeHead(cha)
	battle_circle.taskIndex=0
	initTask()
func enterBattleHuang():
	
	_refreshSlider()
	_refreshGeneral()
	initTask()	
	point_group.hide()
	battle_circle.enemyName="骨龙"
	close_btn.hide()
	_mode=SceneManager.bossMode.huang
	costhp=BOSS_COST_HP
	var cha=load("res://Asset/人物/骨龙最终.png")
	
	battle_circle.changeHead(cha)	
	#禁用任务
	for  data in GameManager.sav.battleTasks.values():
		data.task=[]
	#GameManager.sav.battleTasks.task=[]#clear()
	battle_circle.taskIndex=0
	initTask()


func sideQuestReturnG(iswin):
	GameManager.bossmode=SceneManager.bossMode.mi
	GameManager.bossmoderesult=iswin
	SceneManager.changeScene(SceneManager.roomNode.GOVERNMENT_BUILDING,2)
	
func sideQuestReturnT(iswin):
	GameManager.bossmode=SceneManager.bossMode.tao
	GameManager.bossmoderesult=iswin
	SceneManager.changeScene(SceneManager.roomNode.BOULEUTERION,2)


func sideQuestReturnD(iswin):
	GameManager.bossmode=SceneManager.bossMode.huang
	GameManager.bossmoderesult=iswin
	SceneManager.changeScene(SceneManager.roomNode.DRILL_GROUND,2)

@onready var line_edit_coin = $coinSlider/LineEdit
@onready var line_edit_soilder = $soildSlider/LineEdit



func _on_coinBlock_button_down():
	if battle_circle.selectgeneral!=null and GameManager.sav.coin!=0:
		line_edit_coin.show()


func _on_soilderBlock_button_down():
	if battle_circle.selectgeneral!=null and GameManager.sav.labor_force!=0:
		line_edit_soilder.show()


func enterBattleZhenRen():
	useItemPanel.hide()
	close_btn.hide()
	_mode=SceneManager.bossMode.zhenren
	costhp=BOSS_COST_HP
	point_group.hide()
	for i in range(0,3):
		var datas=GameManager.sav.battleTasks.values()
		var data=datas[i]
		data.task=[]
		data.index=i+299
	refreshData()
	battle_circle.taskIndex=0
	battle_circle.enemyName="修道真人"
	const cha = preload("res://Asset/人物/真人.png")
	battle_circle.changeHead(cha)	
	#禁用任务
	#GameManager.sav.battleTasks.clear()

	#for  data in GameManager.sav.battleTasks.values():
		#data.task=[]
		
		#GameManager.sav.battleTasks[taskIndex]
		
	GameManager.secretBattleSav=GameManager.sav.currenceTask
	#GameManager.sav.currenceTask=200
	initTask()


func changeHead(cha):
	battle_circle.changeHead(cha)	





func _on_texture_button_pressed() -> void:
	check_box.button_pressed = not check_box.button_pressed
#	_on_Usecheck_box_toggled(!check_box.toggle_mode)
