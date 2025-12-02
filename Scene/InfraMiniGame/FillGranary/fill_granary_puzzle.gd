extends Control

var grandNum:int=100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initGranary() # Replace with function body.
	_initTrack()
	initTargetAndHourse()
#简单初始3 复杂初始5
#10 12 15
#1 2 3 随机
#概率生成

#300 500 800
#200 400 700
#150 300 600
@onready var granarys: Node2D = $granarys
@onready var hourses: Node2D = $hourses
@onready var fill_grannary_horse_1: Node2D = $hourses/FillGrannaryHorse1
@onready var fill_grannary_horse_5: Node2D = $hourses/FillGrannaryHorse5

@onready var granary_house_1: Node2D = $granarys/GranaryHouse1
@onready var granary_house_5: Node2D = $granarys/GranaryHouse5



var granarysArr:Array
var horseArr:Array
func initGranary():
	granarysArr=granarys.get_children()
	horseArr=hourses.get_children()
	if GameManager.selectPuzzleDiffcult==SceneManager.selectPuzzleDiffcult.easy:
		fill_grannary_horse_1.hide()
		fill_grannary_horse_5.hide()
		granary_house_1.hide()
		granary_house_5.hide()
		granarysArr.erase(fill_grannary_horse_1)
		granarysArr.erase(fill_grannary_horse_5)
		horseArr.erase(fill_grannary_horse_1)
		horseArr.erase(fill_grannary_horse_5)
	for i in range(0,granarys.size()):
		granarysArr[i].initData(i+1)
		#houseArr[i].initData(i+1)
		horseArr[i].area_2d.input_event.connect(_on_piece_input_event.bind(horseArr[i]))
	#for granary in granarys:
		#pass
		
var selecthourse=null
func _on_piece_input_event(viewport: Node, event: InputEvent, shape_idx: int, hourse):
	#print("haveClickEvent")
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#try_move_piece(piece)#选中图块，跟手，tick阶段判断拼图和场上块接近么接近，发挥效果，并拼上
		if selecthourse!=null:
			selecthourse.stop_flash()
		hourses.start_flash()
		selecthourse=hourse
@onready var color_rect_5: ColorRect = $tracks/ColorRect5
@onready var color_rect_6: ColorRect = $tracks/ColorRect6
@onready var reside_car_label: Label = $resideCar
@onready var currence_value_label: Label = $currenceValue
@onready var target_num_label: Label = $TargetNum


func selectGrannary(select):
	selecthourse.stop_flash()
	selecthourse.selectGrannary(select)
		
func _initTrack():
	if GameManager.selectPuzzleDiffcult==SceneManager.selectPuzzleDiffcult.easy:
		color_rect_5.hide()
		color_rect_6.hide()
	else:
		color_rect_5.show()
		color_rect_6.show()		
		

	#for granary in granarys:
		#pass	
		
var resideHorse=-1
var targetValue=100
var resideValue=0


#简单初始3 复杂初始5
#10 12 15
#1 2 3 随机
#概率生成

#300 500 800
#200 400 700
#150 300 600


func initTargetAndHourse():
	if GameManager.sav.selectPuzzleDiffcult==SceneManager.puzzlediffucult.easy:
		resideHorse=10
		resideValue=300
		targetValue=200
	elif GameManager.sav.selectPuzzleDiffcult==SceneManager.puzzlediffucult.middle:
		resideHorse=12
		resideValue=500
		targetValue=400
	elif GameManager.sav.selectPuzzleDiffcult==SceneManager.puzzlediffucult.high:
		resideHorse=15
		targetValue=700
		resideValue=800
	pass

func _distrutionGrand(value):
	resideValue+=0
	currence_value_label.text=tr("当前粮食：{_num}").format({"_num":resideValue})
	#更新当前粮食

#异步一下
func updatehourse():
		if resideHorse>0:
			pass
		else:
			pass
			#游戏结束


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
