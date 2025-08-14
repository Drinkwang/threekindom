extends Node2D
@export var selectCard:boardCard
@export var cardArr:Array 
@export var rects:Array[Node2D]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.currenceScene=self
	cardArr=[]
	for i in range(0,52):
		var reside:int=floori((i)%13)
		if i>10:
			continue
		else:
			cardArr.push_front(i)
	pass # Replace with function body.

#点击，然后创造线，松手取消线$CanvasLayer/Border
@onready var mouseline: Line2D = $CanvasLayer/mouseline



var canClick:bool=false
func clickPoint(vec:Vector2):
	
	mouseline.show()
	mouseline.set_point_position(0,vec)

	await 0.1
	canClick=true
	border.show()
func stopClick():
	border.hide()
	selectCard=null
	mouseline.hide()


@onready var border: Sprite2D = $CanvasLayer/Border		
func _input(event: InputEvent) -> void:
	var isstop:bool=true
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# 检查点击位置是否在 LineEdit 外
		for recti in rects:
		
			var rect = recti.get_global_rect()  # 获取 LineEdit 的全局矩形区域
			var mouse_pos = get_global_mouse_position()
			if  rect.has_point(mouse_pos):
				isstop=false
				break
			# 点击在 LineEdit 外，隐藏 LineEdit
		if isstop==true:
			stopClick()
	#参考我炒的代码
	
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		isstop=true
	
		if isstop==true:
			stopClick()
	#if event is InputEventMouseButton:
		#if event.button_index==MOUSE_BUTTON_WHEEL_UP:
			#v_slider.value=v_slider.value+1
		#elif event.button_index==MOUSE_BUTTON_WHEEL_DOWN:
			#v_slider.value=v_slider.value-1
			#pass
func drawOne():
	#获得2个手牌
	pass
	
func phaseEnd():
	#每个下面发一张牌
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var moupos=get_viewport().get_mouse_position()
	if mouseline.visible==true:
		mouseline.set_point_position(1,moupos)	
		border.position=moupos
