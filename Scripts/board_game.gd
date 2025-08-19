extends Node2D
class_name board_game
@export var selectCard:boardCard
@export var cardArr:Array 
var cardsize
@export var rects:Array[Node2D]
const BOARD_CARD = preload("res://Scene/prefab/boardCard.tscn")

@onready var board_panel: Panel = $CanvasLayer/boardPanel
var turnAllnum=5


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
	await startGame(3,true)
#点击，然后创造线，松手取消线$CanvasLayer/Border
@onready var mouseline: Line2D = $CanvasLayer/mouseline
@onready var myhand: HBoxContainer = $CanvasLayer/myhand
@onready var enemyhand: HBoxContainer = $CanvasLayer/enemyhand



@onready var min_group: GridContainer = $CanvasLayer/Node/minGroup
@onready var shi_group: GridContainer = $CanvasLayer/Node/shiGroup
@onready var shang_group: GridContainer = $CanvasLayer/Node/shangGroup
@onready var bin_group: GridContainer = $CanvasLayer/Node/binGroup
@export var hp=3

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

	groudObj.add_child(cardone)
	cardone._value=value
	if selectCard!=null:
		selectCard.queue_free()
		playerStage-=1
		if playerStage<=0:
			pass
			#end_button.disabled=true
		reside_num.text=tr("剩余步数：{s}").format({"s":playerStage})
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
	var tween =create_tween()
	# 为 rect1 的 tint_color 参数设置动画，从白色到红色，持续 2 秒
	tween.tween_property(bepunishI.nine_patch_rect.material, "shader_parameter/burn_progress", 1, 1)
	tween.tween_property(bepunishI.img.material, "shader_parameter/burn_progress", 1, 1)
	tween.tween_property(bepusnishJ.nine_patch_rect.material, "shader_parameter/burn_progress", 1, 1)
	tween.tween_property(bepusnishJ.img.material, "shader_parameter/burn_progress", 1, 1)
	punishStage=false
	
	var tempfunc=func(anim_name: StringName):
		bepunishI.queue_free()
		bepusnishJ.queue_free()
		if groupPunishTyp==groupType.min:
			checkCardStage(groupType.shi)
		elif groupPunishTyp==groupType.shi:
			checkCardStage(groupType.shang)
		elif groupPunishTyp==groupType.shang:
			checkCardStage(groupType.bin)
		elif groupPunishTyp==groupType.bin:
			groupPunishTyp=groupType.none
			enterNewPhase(phaseName.useCard)
	#切换下一个check，如果没有则进入下一个阶段
		
	bepusnishJ.animation_player.animation_finished.connect(tempfunc)	
	#也可以放成回调

	
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





@export var _issole:bool=false
func startGame(cardnum,issole):
	#
	hp=3
	_issole=issole
	for i in range(0,cardnum):
		drawOne(true)
		if issole==false:
			drawOne(false)	
	#进入新阶段来判断
	await enterNewPhase(phaseName.drawCard)
	
@onready var reside_num: Label = $CanvasLayer/resideNum
@onready var detail_img: Sprite2D = $CanvasLayer/detailTxt/img


func enterNewPhase(stage:phaseName):
	if stage!=phaseName.punish:
		_phaseName=stage
	if _phaseName==phaseName.drawCard and stage!=phaseName.punish:
		checkCardStart()
	elif _phaseName==phaseName.checkStart and stage!=phaseName.punish:
		checkCardStage(groupType.min)	
	elif stage==phaseName.punish:
		if groupPunishTyp==groupType.min:
			checkCardStage(groupType.shi)
		elif groupPunishTyp==groupType.shi:
			checkCardStage(groupType.shang)
		elif groupPunishTyp==groupType.shang:
			checkCardStage(groupType.bin)
		elif groupPunishTyp==groupType.bin:
			if  _phaseName==phaseName.checkStart:
				groupPunishTyp=groupType.none
				enterNewPhase(phaseName.useCard)
			elif _phaseName==phaseName.checkEnd:
				groupPunishTyp=groupType.none
				enterNewPhase(phaseName.endturn)
	elif _phaseName==phaseName.useCard:
		#end_button.disabled=false
		playerStage=2
		detail_txt.text="出牌阶段，请使用你的卡牌"
		detail_img.texture=null
		board_panel.hide()
		end_button.text=tr("回合结束")
		reside_num.show()
		pass
	elif _phaseName==phaseName.checkEnd:
		checkCardStage(groupType.min)	
	elif _phaseName==phaseName.endturn:
		print("进入结束阶段")
						
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

#支付一张
func checkCardStart():
	await 0.2
	insertCardRandom(groupType.min)
	insertCardRandom(groupType.shi)
	insertCardRandom(groupType.shang)
	insertCardRandom(groupType.bin)
	
	#for i in range(0,1):
	#	drawOne(true)
	#	if _issole==false:
	#		drawOne(false)
	enterNewPhase(phaseName.checkStart)
@onready var end_button: Button = $CanvasLayer/Button

#判断所有子物体
#如果有2个子物体相同，则进入惩罚阶段，
#二个卡牌放大，然后要求支付卡牌，
#如果没支付则受到伤害，
#惩罚阶段结束后跳到下一个check阶段，直到check结束
@onready var punishimg: Sprite2D = $CanvasLayer/detailTxt/img

var groupPunishTyp=groupType.none


@export var _phaseName:phaseName=phaseName.checkStart

#判断之前阶段和尾部阶段
func checkCardStage(_groupType):
	bepunishI=null
	bepusnishJ=null

	var groudObj:GridContainer
	if _groupType==groupType.min:
		groudObj=min_group
		board_panel.position=Vector2(516,267)
	elif _groupType==groupType.shi:
		groudObj=shi_group
		board_panel.position=Vector2(747,267)
	elif _groupType==groupType.shang:
		groudObj=shang_group
		board_panel.position=Vector2(975,267)
	elif _groupType==groupType.bin:
		groudObj=bin_group
		board_panel.position=Vector2(1206,267)
	var groupchild=groudObj.get_children()
	var cangoto=true
	for i:boardCard in groupchild:
		for j:boardCard in groupchild:
			if i!=j and i!=null and j!=null:
				var residei:int=floori((i._value)/13)
				var residej:int=floori((j._value)/13)
				if residei==residej:
					
					
					if _phaseName==phaseName.checkStart:
						groupPunishTyp=_groupType
					
						if _groupType==groupType.min:
							punishimg.texture=_heart
						elif _groupType==groupType.shi:
							punishimg.textur=_zhanli
						elif _groupType==groupType.shang:
							punishimg.textur=_coin
						elif _groupType==groupType.bin:
							punishimg.textur=_soilder
					#定义一个惩罚cardType，然后赋值非空
						end_button.text=tr("支付惩罚")
						#end_button.text=tr("支付民心惩罚")
						#enterPunishStage()
						punishStage=true
						end_button.show()
						cangoto=false
						enterPunishStage(i,j)
					elif _phaseName==phaseName.checkEnd:
						enterRewardStage(i,j)
						cangoto=false
	if cangoto==true:
		groupPunishTyp=_groupType
							
		enterNewPhase(phaseName.punish)				
#支付n张
#根据group
@onready var endpos: NinePatchRect = $CanvasLayer/NinePatchRect2
@onready var score_txt: Label = $CanvasLayer/Label2


#进入结束检查阶段标注 并执行完结束检查阶段
func enterRewardStage(i:boardCard,j:boardCard):
	i.animation_player_reward.play("reward")
	j.animation_player_reward.play("reward")
	
	var tween = create_tween()

	tween.tween_property(i, "global_position", score_txt.global_position, 1)	
	tween.tween_property(j, "global_position", score_txt.global_position, 1)	

	
	var tempfunc=func(anim_name,i_node, j_node):
		#print("helloworld")
		i_node.queue_free()
		j_node.queue_free()
		if groupPunishTyp==groupType.min:
			checkCardStage(groupType.shi)
		elif groupPunishTyp==groupType.shi:
			checkCardStage(groupType.shang)
		elif groupPunishTyp==groupType.shang:
			checkCardStage(groupType.bin)
		elif groupPunishTyp==groupType.bin:
			groupPunishTyp=groupType.none
			enterNewPhase(phaseName.endturn)
	i.animation_player_reward.animation_finished.connect(tempfunc.bind(i,j))	
	


@onready var detail_txt: Label = $CanvasLayer/detailTxt
var bepunishI:boardCard
var bepusnishJ:boardCard





#进入惩罚阶段标注
func enterPunishStage(i=null,j=null):
	detail_txt.show()
	board_panel.show()
	#pn=phaseName.punish
	if i!=null:
		i._color_rect.show()
		i.scale=Vector2(i.originScale.x*1.2,i.originScale.y*1.2)
		bepunishI=i		
	if j!=null:	
		j._color_rect.show()

		j.scale=Vector2(j.originScale.x*1.2,j.originScale.y*1.2)


		bepusnishJ=j

	
#不知道有啥用的，可以删
#func checkCardEnd():
	#pn=phaseName.checkStart


	
	
func insertCardRandom(group:groupType):
	#
	var i=randi_range(0,cardsize)
		#cardArr.
	var carddate=cardArr[i]
	insertCard(group,carddate)
		

	cardArr[i]=cardArr[cardsize]
		
		#var temp=cardArr[cardsize]
	cardArr[cardsize]=carddate
	cardsize-=1	
	
var punishStage=false
#判断是什么阶段，如果是	
func phaseEnd():
	
	if _phaseName==phaseName.punish:
		#插入一个代替阶段,如果无法插入
		#先支付一张红桃
		#如果没有红桃则扣hp-1
		if haveHeart():
			end_button.text=tr("支付民心惩罚")
			groupPunishTyp=groupType.min
			punishimg.texture=_heart
			punishStage=true
			end_button.show()

			enterPunishStage()
		else:
			hp-=1
			if hp<=0:
				pass#gameover
		SettlePunish()
		
	elif _phaseName==phaseName.useCard:
		end_button.hide()
		enterNewPhase(phaseName.checkEnd)
	#每个下面发一张牌
	pass

func haveHeart():
	var cards=myhand.get_children()
	for card:boardCard in cards:
		var kvalue=card._value
		var reside:int=floori((kvalue)%13)
		var devisor:int=floori((kvalue)/13)
		if devisor==0:
			return true
	return false

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

enum phaseName{
	none,
	drawCard,
	checkStart,
	punish,
	useCard,
	checkEnd,
	endturn
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
