extends Control
class_name propertyPanel
#@onready var coin_num = $PanelContainer/MarginContainer/GridContainer/coinNum
#@onready var heart_num = $PanelContainer/MarginContainer/GridContainer/heartNum
#@onready var labor_num = $PanelContainer/MarginContainer/GridContainer/laborNum
#@onready var dd222test = $PanelContainer/MarginContainer/GridContainer/TextureRect



@onready var coin_num = $MarginContainer/GridContainer/coinNum
@onready var heart_num = $MarginContainer/GridContainer/heartNum
@onready var labor_num = $MarginContainer/GridContainer/laborNum
@onready var dd222test = $MarginContainer/GridContainer/TextureRect
@onready var _coin = $coin
@onready var _labor = $labor
@onready var _heart = $heart

var showValue:bool=true

const RESOURCE_POPUP_DURATION := 0.78
const RESOURCE_POPUP_RISE_DISTANCE := 42.0
const RESOURCE_POPUP_FONT_SIZE := 58
const RESOURCE_COUNTER_DURATION := 0.48
var _resource_value_tweens: Dictionary = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	coin_num.text = "%07d" % GameManager.sav.coin
	heart_num.text = "%07d" % GameManager.sav.people_surrport
	labor_num.text = "%07d" % GameManager.sav.labor_force
	#visible=true
	GameManager._propertyPanel=self
	TooltipManager.register_tooltip(_coin,tr("钱：持有的钱数量(可购买道具、军事行动的资金)"))
	TooltipManager.register_tooltip(_labor,tr("民力：拥有空闲民力(可转换为士兵)"))
	TooltipManager.register_tooltip(_heart,tr("民心：当前百姓的支持度(<=0时游戏失败)"))
	#dd222test
	pass # Replace with function body.

@onready var color_rect = $MarginContainer2/ColorRect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(showValue==true):
		if not _resource_value_tweens.has("coin"):
			coin_num.text = "%07d" % GameManager.sav.coin
		heart_num.text = "%07d" % GameManager.sav.people_surrport
		if not _resource_value_tweens.has("labor"):
			labor_num.text = "%07d" % GameManager.sav.labor_force
		#coin_num.text=var_to_str(GameManager.sav.coin)
		#heart_num.text=var_to_str(GameManager.sav.people_surrport)
		#labor_num.text=var_to_str(GameManager.sav.labor_force)
		color_rect.color.a=0.314+0.686*((100-GameManager.sav.people_surrport)/100.0)

func GetValue(coinGet,heartGet,peopleGet):


	
	
	GameManager.sav.coin=GameManager.sav.coin+coinGet
	
	GameManager.sav.people_surrport=GameManager.sav.people_surrport+heartGet

		

	GameManager.sav.labor_force=GameManager.sav.labor_force+peopleGet

	coin_num.text = "%07d" % GameManager.sav.coin
	heart_num.text = "%07d" % GameManager.sav.people_surrport
	labor_num.text = "%07d" % GameManager.sav.labor_force
	

# Resource changes float over their icon without blocking dialogue or input.
func show_resource_change(resource_type: String, change: int) -> void:
	if change == 0:
		return
	var parent: Control = _coin if resource_type == "coin" else _labor
	# Only gains use the celebratory counter roll; costs update immediately.
	if change > 0:
		_start_resource_counter(resource_type)
	var popup := Label.new()
	popup.text = "%+d" % change
	popup.mouse_filter = Control.MOUSE_FILTER_IGNORE
	popup.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	popup.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	popup.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	popup.add_theme_font_override("font", coin_num.get_theme_font("font"))
	popup.add_theme_font_size_override("font_size", RESOURCE_POPUP_FONT_SIZE)
	popup.add_theme_color_override("font_color", _resource_popup_color(resource_type, change))
	popup.add_theme_color_override("font_outline_color", Color(0.12, 0.06, 0.02, 1.0))
	popup.add_theme_constant_override("outline_size", 6)
	popup.z_index = 10
	popup.position.y = 18.0
	popup.scale = Vector2(0.45, 0.45)
	parent.add_child(popup)

	var motion_tween := popup.create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	motion_tween.tween_property(popup, "position:y", -RESOURCE_POPUP_RISE_DISTANCE, RESOURCE_POPUP_DURATION)
	motion_tween.parallel().tween_property(popup, "modulate:a", 0.0, RESOURCE_POPUP_DURATION)
	motion_tween.tween_callback(popup.queue_free)
	var punch_tween := popup.create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	punch_tween.tween_property(popup, "scale", Vector2(1.22, 1.22), 0.16)
	punch_tween.set_trans(Tween.TRANS_QUAD).tween_property(popup, "scale", Vector2.ONE, 0.18)


func _start_resource_counter(resource_type: String) -> void:
	var label: Label = coin_num if resource_type == "coin" else labor_num
	var target: int = GameManager.sav.coin if resource_type == "coin" else GameManager.sav.labor_force
	var current := label.text.to_int()
	if _resource_value_tweens.has(resource_type):
		var previous_tween: Tween = _resource_value_tweens[resource_type]
		if is_instance_valid(previous_tween):
			previous_tween.kill()
	var counter_tween := create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	_resource_value_tweens[resource_type] = counter_tween
	counter_tween.tween_method(_set_resource_counter.bind(label), current, target, RESOURCE_COUNTER_DURATION)
	counter_tween.tween_callback(_finish_resource_counter.bind(resource_type, label, target))

	label.pivot_offset = label.size * 0.5
	label.scale = Vector2(0.82, 0.82)
	var label_punch := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	label_punch.tween_property(label, "scale", Vector2(1.14, 1.14), 0.14)
	label_punch.set_trans(Tween.TRANS_QUAD).tween_property(label, "scale", Vector2.ONE, 0.18)


func _set_resource_counter(value: float, label: Label) -> void:
	label.text = "%07d" % roundi(value)


func _finish_resource_counter(resource_type: String, label: Label, target: int) -> void:
	label.text = "%07d" % target
	_resource_value_tweens.erase(resource_type)


func _resource_popup_color(resource_type: String, change: int) -> Color:
	if change < 0:
		return Color("ff6b6b")
	return Color("ffd166") if resource_type == "coin" else Color("6ee7b7")

#var people_surrport #群众支持度 数值
#var  coin #钱 数值
#var labor_force #民力 可以当作军队进行使用 民力转换成军队需要消耗值 骑兵 步兵 弓兵
