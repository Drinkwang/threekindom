extends Control
@export var arrs:Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.playDemand.connect(initData)
	changeLanguage()
	SignalManager.changeLanguage.connect(changeLanguage)
	if GameManager.sav.have_event["Factionalization"]==true:
		swap_controls()
@onready var label_2: Label = $Label2




func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	
	if currencelanguage=="ru":
		label_2.add_theme_font_size_override("font_size",32)
	else:
		if currencelanguage=="en":
			label_2.add_theme_font_size_override("font_size",32)
		elif currencelanguage=="ja":
			label_2.add_theme_font_size_override("font_size",32)
		else:
			label_2.add_theme_font_size_override("font_size",55)
			
	var contextstr=""
	if GameManager.sav.allocationDay==1:
		contextstr=tr("俸给筹备期")
		#弹出不同的教程
	elif GameManager.sav.allocationDay==2:
		contextstr=tr("月例派发期")
	elif GameManager.sav.allocationDay==3:
		contextstr=tr("延发清缴日")
					
	label_2.text=tr("月例配给管理面板")+"【"+ contextstr+"】"
	

func swap_controls():
	# 1. 通过名称找到两个目标控件
	var hbox=$HBoxContainer2
	var control3 = $HBoxContainer2/Control3
	var control2 =$HBoxContainer2/Control2
	
	# 2. 安全校验：确保两个节点都存在
	if not control3 or not control2:
		push_error("Control3 或 Control2 不存在，无法交换位置！")
		return
	
	# 3. 获取两个节点在容器中的当前索引
	var index3 = hbox.get_child_index(control3)
	var index2 = hbox.get_child_index(control2)
	
	# 4. 交换两个节点的位置
	hbox.move_child(control3, index2)
	hbox.move_child(control2, index3)

func initData():
	var contextstr=""
	if GameManager.sav.allocationDay==1:
		contextstr=tr("俸给筹备期")
		#弹出不同的教程
	elif GameManager.sav.allocationDay==2:
		contextstr=tr("月例派发期")
	elif GameManager.sav.allocationDay==3:
		contextstr=tr("延发清缴日")
		
	#休整闲暇期

	label_2.text=tr("月例配给管理面板")+"【"+ contextstr+"】"
	for i in range(0,4):
		
		arrs[i].show()
		arrs[i].initData()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_button_down() -> void:
	self.hide()
