extends Node2D
class_name board_game
@export var selectCard:boardCard
@export var cardArr:Array 
var cardsize
@export var rects:Array[Node2D]
const BOARD_CARD = preload("res://Scene/prefab/boardCard.tscn")

@onready var board_panel: Panel = $CanvasLayer/boardPanel



var playerStage=2
var enemyStage=2
# Called when the node enters the scene tree for the first tim"res://Scene/prefab/boardCard.tscn"e.
func _ready() -> void:
	cardsize=0
	GameManager.currenceScene=self
	cardArr=[]
	for i in range(0,52):
		var reside:int=floori((i)%13)
		if reside>10:
			continue
		else:
			cardsize+=1
			cardArr.push_front(i)
	cardsize-=1
	startGame(3,true)
#点击，然后创造线，松手取消线$CanvasLayer/Border
@onready var mouseline: Line2D = $CanvasLayer/mouseline
@onready var myhand: HBoxContainer = $CanvasLayer/myhand
@onready var enemyhand: HBoxContainer = $CanvasLayer/enemyhand



@onready var min_group: GridContainer = $CanvasLayer/Node/minGroup
@onready var shi_group: GridContainer = $CanvasLayer/Node/shiGroup
@onready var shang_group: GridContainer = $CanvasLayer/Node/shangGroup
@onready var bin_group: GridContainer = $CanvasLayer/Node/binGroup


const _coin = preload("res://Asset/ui/钱财.png")
const _heart = preload("res://Asset/ui/人心.png")
const _soilder = preload("res://Asset/ui/兵力.png")
const _zhanli = preload("res://Asset/ui/战力.png")


func insertCard(group:groupType,value):
	var groudObj
	if group==groupType.min:
		groudObj=min_group
	elif group==groupType.shi:
		groudObj=shi_group
	elif group==groupType.shang:
		groudObj=shang_group
	elif group==groupType.bin:
		groudObj=bin_group
	var cardone=BOARD_CARD.instantiate()
	cardone.holdType=cardHoldType.stack
	cardone._value=value
	groudObj.add_child(cardone)
	
	if selectCard!=null:
		selectCard.queue_free()
	stopClick()
	
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

func SettlePunish():

	bepunishI.animation_player.play("fade")
	bepusnishJ.animation_player.play("fade")
	await 1
	bepunishI.queue_free()
	bepusnishJ.queue_free()
	#切换下一个check，如果没有则进入下一个阶段
	
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
@export var _issole:bool=false
func startGame(cardnum,issole):
	#
	_issole=issole
	for i in range(0,cardnum):
		drawOne(true)
		if issole==false:
			drawOne(false)			
func drawOne(isplayer):
	var cardone=BOARD_CARD.instantiate()
	if isplayer==true:

		myhand.add_child(cardone)
		cardone.holdType=cardHoldType.player
	else:
		enemyhand.add_child(cardone)
		cardone.holdType=cardHoldType.enemy
	var i=randi_range(0,cardsize)
		#cardArr.
	var carddate=cardArr[i]

		
	cardone._value=carddate
	cardArr[i]=cardArr[cardsize]
		
		#var temp=cardArr[cardsize]
	cardArr[cardsize]=carddate
	cardsize-=1
func phaseStart():
	insertCardRandom(groupType.min)
	insertCardRandom(groupType.shi)
	insertCardRandom(groupType.shang)
	insertCardRandom(groupType.bin)
	
	for i in range(0,1):
		drawOne(true)
		if _issole==false:
			drawOne(false)

#支付一张
func checkCardStart():
	
	print(3)
	await 2
	print(2)

#判断所有子物体
#如果有2个子物体相同，则进入惩罚阶段，
#二个卡牌放大，然后要求支付卡牌，
#如果没支付则受到伤害，
#惩罚阶段结束后跳到下一个check阶段，直到check结束
@onready var punishimg: Sprite2D = $CanvasLayer/detailTxt/img

var groupPunishTyp:groupType=groupType.none
func checkCardStage(groupType):
	var groudObj:GridContainer
	if groupType==groupType.min:
		groudObj=min_group
	elif groupType==groupType.shi:
		groudObj=shi_group
	elif groupType==groupType.shang:
		groudObj=shang_group
	elif groupType==groupType.bin:
		groudObj=bin_group
	var groupchild=groudObj.get_children()
	for i:boardCard in groupchild:
		for j:boardCard in groupchild:
			if i!=j:
				var residei:int=floori((i._value)/13)
				var residej:int=floori((j._value)/13)
				if residei==residej:
					groupPunishTyp=groupType
					detail_txt.show()
					if groupType==groupType.min:
						punishimg.texture=_heart
					elif groupType==groupType.shi:
						punishimg.textur=_zhanli
					elif groupType==groupType.shang:
						punishimg.textur=_coin
					elif groupType==groupType.bin:
						punishimg.textur=_soilder
					#定义一个惩罚cardType，然后赋值非空
					await enterPunishStage(i,j)
					break
#支付n张
#根据group

@onready var detail_txt: Label = $CanvasLayer/detailTxt
var bepunishI:boardCard
var bepusnishJ:boardCard

func enterPunishStage(i,j):
	i._color_rect.show()
	j._color_rect.show()
	i.scale=Vector2(i.originScale.x*1.2,i.originScale.y*1.2)
	j.scale=Vector2(j.originScale.x*1.2,j.originScale.y*1.2)
	i.isbePunish=true
	j.isbePunish=true
	bepunishI=i
	bepusnishJ=j
	#二个卡牌变红
	#放大
	

func checkCardEnd():
	pass	
	
func insertCardRandom(group:groupType):
	var i=randi_range(0,cardsize)
		#cardArr.
	var carddate=cardArr[i]
	insertCard(group,carddate)
		

	cardArr[i]=cardArr[cardsize]
		
		#var temp=cardArr[cardsize]
	cardArr[cardsize]=carddate
	cardsize-=1	
	
func phaseEnd():
	#每个下面发一张牌
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var moupos=get_viewport().get_mouse_position()
	if mouseline.visible==true:
		mouseline.set_point_position(1,moupos)	
		border.position=moupos


enum cardHoldType{
	player,
	enemy,
	stack
}


enum groupType{
	none,
	min,
	shi,
	shang,
	bin,
	gt_taoshang,
	gt_mizhen,
	gt_gulong
	
}
