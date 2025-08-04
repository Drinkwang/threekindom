extends LineEdit
@export var _slider:Slider
#
@onready var control: battlePanel = $"../.."

@export var resType:GameManager.ResType
func _ready():
	# 确保 LineEdit 可接收输入
	editable = true
	connect("text_changed", _on_text_changed)

func _on_text_changed(new_text: String):
	var valid_text = ""
	for char in new_text:
		if char.is_valid_int():  # 检查是否为数字
			valid_text += char
	text = valid_text
	caret_column = valid_text.length()
	if resType==GameManager.ResType.coin:
		if int(valid_text)>=GameManager.sav.coin:
			valid_text=var_to_str(GameManager.sav.coin)
		elif int(valid_text)<0:
			valid_text=var_to_str(0)
			# valid_text
		
	elif resType==GameManager.ResType.people:
		if int(valid_text)>=GameManager.sav.labor_force:
			valid_text=var_to_str(GameManager.sav.labor_force)
		elif int(valid_text)<0:
			valid_text=var_to_str(0)
	_slider.value=int(valid_text)
		#costcoin=(GameManager.sav.coin*value/100)
	#coin_num.text=str(costcoin)
	#if(battle_circle.selectgeneral):
		#_changeProgress()
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# 检查点击位置是否在 LineEdit 外
		var rect = get_global_rect()  # 获取 LineEdit 的全局矩形区域
		var mouse_pos = get_global_mouse_position()
		if not rect.has_point(mouse_pos):
			# 点击在 LineEdit 外，隐藏 LineEdit
			hide()
