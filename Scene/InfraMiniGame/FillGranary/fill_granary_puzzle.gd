extends Control

var grandNum:int=100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.PuzzleScene=self

#简单初始3 复杂初始5

func initGame():
	self.show()
	win_rect.hide()
	lose_rect.hide()
	initGranary() # Replace with function body.
	_initTrack()
	initTargetAndHourse()
	updatehourse()
	_updateMainContext()
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


var trackNum=5
var granarysArr:Array
var horseArr:Array
func initGranary():
	trackNum=5
	granarysArr=granarys.get_children()
	horseArr=hourses.get_children()
	if GameManager.selectPuzzleDiffcult==SceneManager.puzzlediffucult.easy:
		trackNum=3
		fill_grannary_horse_1.hide()
		fill_grannary_horse_5.hide()
		granary_house_1.hide()
		granary_house_5.hide()
		granarysArr.erase(granary_house_1)
		granarysArr.erase(granary_house_5)
		horseArr.erase(fill_grannary_horse_1)
		horseArr.erase(fill_grannary_horse_5)
	for i in range(0,granarysArr.size()):
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
		hourse.start_flash()
		selecthourse=hourse
@onready var color_rect_5: ColorRect = $tracks/ColorRect5
@onready var color_rect_6: ColorRect = $tracks/ColorRect6



func selectGrannary(select):
	selecthourse.stop_flash()
	selecthourse.selectGrannary(select)
		
func _initTrack():
	if GameManager.selectPuzzleDiffcult==SceneManager.puzzlediffucult.easy:
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


#var current_cart : int = 0

# 改良版：每一辆车都保证有粮食！
func next_cart_load() -> int:
	#current_cart += 1
	
	# 还剩多少辆车没发（包括当前这辆）
	#var carts_left_including_this_one : int = resideHorse #- current_cart + 1
	
	# 关键：每辆车至少保留 1 单位给后面的车
	var guaranteed_for_later : int = resideHorse - 1   # 后面几辆至少各 1
	var safe_max : int = resideValue - guaranteed_for_later       # 这辆车最多能拿多少
	
	var fullest_granary = get_fullest_granary()
	
	safe_max=min(safe_max,fullest_granary)#粮仓最大的取min
	if safe_max <= 0:
		# 理论上不会走到这里，但保险
		return 0
	
	# 你的原始规则：1 ~ 剩余的一半，但不能超过 safe_max
	var half : int = resideValue / 2
	var load : int = randi_range(1, min(half, safe_max))
	
	# 最后一辆车直接拿光
	if resideHorse == 1:
		load = resideValue
	
	resideValue -= load

	return load

#200 400 700
#150 300 600
# 获取最满的粮仓（剩余空间最小的）
func get_fullest_granary() -> int:
	if granarysArr.is_empty():
		return 0
	
	var min_remaining = 0  # 用一个无限大值初始化
	#var fullest_granary = null
	
	for g in granarysArr:
		var remaining = g.maxValue - g.currenceValue
		if remaining > min_remaining:
			min_remaining = remaining
			#fullest_granary = g
	
	return min_remaining

func initTargetAndHourse():
	if GameManager.selectPuzzleDiffcult==SceneManager.puzzlediffucult.easy:
		resideHorse=10
		resideValue=300
		targetValue=150
	elif GameManager.selectPuzzleDiffcult==SceneManager.puzzlediffucult.middle:
		resideHorse=12
		resideValue=500
		targetValue=300
	elif GameManager.selectPuzzleDiffcult==SceneManager.puzzlediffucult.high:
		resideHorse=15
		targetValue=600
		resideValue=800
	target_num_label.text=tr("目标粮食：{allnum}").format({"allnum":targetValue})


#场上的车

var sideTrackCar=[]
#异步一下
func updatehourse():
	if resideHorse>0:
		if sideTrackCar.size()!=0:
			for i in range(0,sideTrackCar.size()):

				horseArr[i].crateHorse(sideTrackCar[i])
				resideHorse-=1
			sideTrackCar.clear()
		else:
		
			for i in range(0,horseArr.size()):
		
				var load=next_cart_load()
				horseArr[i].crateHorse(load)
				resideHorse-=1

		if 	sideTrackCar.size()==0:
			for i in range(0,min(resideHorse,horseArr.size())):
		
				var load=next_cart_load()
				sideTrackCar.append(load)	
		_updateMainContext()		
	else:
		var residevalue=getCurrenceValue()
		if residevalue>=targetValue:
			winGame()
		else:
			loseGame()
@onready var win_rect: ColorRect = $winRect
@onready var blink_rect: TextureRect = $winRect/blinkRect
@onready var blink_animation_player: AnimationPlayer = $winRect/blinkRect/AnimationPlayer

var isVictory=false
#这个等于true 无法操作
func winGame():
	print("拼图完成!")
	isVictory=true
	win_rect.show()
	blink_rect.show()
	blink_animation_player.play("win")
	var finishfunc=func(aniname):
		blink_rect.hide()
	blink_animation_player.animation_finished.connect(finishfunc)	
	

	SoundManager.play_sound(sounds.GOOD_THING)


@onready var lose_rect: ColorRect = $LoseRect


func loseGame():
	lose_rect.show()


func loseGameBtn():
	self.hide()
	DialogueManager.show_dialogue_balloon(GameManager.sys,"基建运粮失败")
@onready var txt_detail: Label = $detail
@onready var reside_car_label: Label = $resideCar
@onready var currence_value_label: Label = $currenceValue
@onready var target_num_label: Label = $TargetNum


func _updateMainContext():
	_updateFillGrannary()
	_updateTxtDetail()
	_update_reside_car_label()

func _update_reside_car_label():
	reside_car_label.text=tr("剩余粮车:{_num}").format({"_num":resideHorse})

func _updateTxtDetail():
	
	if sideTrackCar.size()>0:
		var str_comma = ",".join(sideTrackCar)
		txt_detail.text=tr("接下来运粮车：{s}".format({"s":str_comma}))
	
		txt_detail.text=txt_detail.text+"\n"+tr("游戏提示：请选中左边粮车和未满的粮仓")
	else:
		txt_detail.text=tr("游戏提示：请选中左边粮车和未满的粮仓")
func _updateFillGrannary():
	#获取三个粮仓的粮食合计
	var residevalue=getCurrenceValue()
	currence_value_label.text=tr("当前粮食：{s}").format({"s":var_to_str(residevalue)})
	#更新当前粮食


func getCurrenceValue():
	var residevalue=0
	for i in granarysArr:
		if i.isOverFill==false:
			residevalue+=i.currenceValue
	return 	residevalue

func refreshHorse():
	var isrefresh=true
	for i in range(0,horseArr.size()):
		if horseArr[i].visible==true:
			isrefresh=false
			break
			
	if isrefresh==true:
		updatehourse()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_winAfter_button_down() -> void:
	if GameManager.sav.constructGrain<GameManager.selectPuzzleDiffcult:
		var tc=0
		if GameManager.sav.constructGrain==1:
			tc=10
		elif GameManager.sav.constructGrain==2:
			tc=20
		elif GameManager.sav.constructGrain==3:
			tc=30
		
		if GameManager.selectPuzzleDiffcult==SceneManager.puzzlediffucult.easy:
			GameManager.resideValue=10
		elif GameManager.selectPuzzleDiffcult==SceneManager.puzzlediffucult.middle:
			GameManager.resideValue=20
		elif GameManager.selectPuzzleDiffcult==SceneManager.puzzlediffucult.high:
			GameManager.resideValue=30
		var allDayget=GameManager.resideValue-tc
		GameManager.sav.coin_DayGet+=allDayget
		GameManager.sav.constructTower=GameManager.selectPuzzleDiffcult

	else:
		#无奖励
		GameManager.resideValue=0
	self.hide()
	DialogueManager.show_dialogue_balloon(GameManager.sys,"基建运粮成功")


func _on_giveup_button_down() -> void:
	DialogueManager.show_dialogue_balloon(GameManager.sys,"放弃基建")
