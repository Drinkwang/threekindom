extends Node2D
class_name board_game
@export var selectCard:boardCard
@export var cardArr:Array 
@export var GraveyardArr:Array
@export var destroyArr:Array

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
	turn_num=0
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

@onready var heart_group: HBoxContainer = $CanvasLayer/heartGroup

@onready var turn_num_Txt: Label = $CanvasLayer/turnNum
@export var turn_num=0
@onready var min_group: GridContainer = $CanvasLayer/Node/minGroup
@onready var shi_group: GridContainer = $CanvasLayer/Node/shiGroup
@onready var shang_group: GridContainer = $CanvasLayer/Node/shangGroup
@onready var bin_group: GridContainer = $CanvasLayer/Node/binGroup
@export var hp=3:
	get:
		return hp
	set(value):
		if(value>hp):

			for i in range(0,value-1):
				var tempheart:TextureRect=heart_group.get_child(i)
				if tempheart.visible:
					tempheart.show()
					tempheart.material.set_shader_parameter("progress",0)
		hp=value
		#这里如果value>hp 将大于的部分恢复原样
		
		if hp>=0 and hp<3:
			var tempheart:TextureRect=heart_group.get_child(hp)
			var tween = create_tween()
			tween.tween_property(tempheart.material, "shader_parameter/progress", 1.0, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
			tween.tween_callback(on_tween_finished.bind(tempheart))  # 播放完成后调用函数
func on_tween_finished(a):
	a.hide()
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
	
	if bepunishI==null and bepusnishJ==null:
		punishFade("")
		return
	
	
	bepunishI.animation_player.play("fade")
	bepusnishJ.animation_player.play("fade")
	var tween =create_tween()
	# 为 rect1 的 tint_color 参数设置动画，从白色到红色，持续 2 秒
	tween.tween_property(bepunishI.nine_patch_rect.material, "shader_parameter/burn_progress", 1, 1)
	tween.tween_property(bepunishI.img.material, "shader_parameter/burn_progress", 1, 1)
	tween.tween_property(bepusnishJ.nine_patch_rect.material, "shader_parameter/burn_progress", 1, 1)
	tween.tween_property(bepusnishJ.img.material, "shader_parameter/burn_progress", 1, 1)
	punishStage=false
	

		
	bepusnishJ.animation_player.animation_finished.connect(punishFade)	
	#也可以放成回调

	
func punishFade(anim_name: StringName):
	if bepunishI!=null:
		bepunishI.queue_free()
	if 	bepusnishJ!=null:
		bepusnishJ.queue_free()
	if groupPunishTyp==groupType.min:
		checkCardStage(groupType.shi)
	elif groupPunishTyp==groupType.shi:
		checkCardStage(groupType.shang)
	elif groupPunishTyp==groupType.shang:
		checkCardStage(groupType.bin)
	elif groupPunishTyp==groupType.bin:
		groupPunishTyp=groupType.none
		end_button.show()
		await enterNewPhase(phaseName.useCard)		
	
	
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



#打n把

@export var _issole:bool=false
func startGame(cardnum,issole):
	score=0
	hp=3
	_issole=issole
	drawOne(true)	

	for i in range(0,cardnum):
		drawOne(true)
		if issole==false:
			drawOne(false)	
	#进入新阶段来判断
	await enterNewPhase(phaseName.drawCard)
	
@onready var reside_num: Label = $CanvasLayer/resideNum
@onready var detail_img: Sprite2D = $CanvasLayer/detailTxt/img

func turnGoto():
	turn_num+=1
	turn_num_Txt.text="回合数：{s}".format({"s":5-turn_num})


func enterNewPhase(stage:phaseName):
	
	if stage!=phaseName.punish:
		_phaseName=stage
	if _phaseName==phaseName.drawCard and stage!=phaseName.punish:
		#如果是玩家
		#turnGoto()
		await checkCardStart()
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
				await enterNewPhase(phaseName.useCard)
			elif _phaseName==phaseName.checkEnd:
				groupPunishTyp=groupType.none
				await enterNewPhase(phaseName.endturn)
	elif _phaseName==phaseName.useCard:
		#end_button.disabled=false
		playerStage=2
		detail_txt.text="出牌阶段，请使用你的卡牌"
		detail_img.texture=null
		board_panel.hide()
		end_button.text=tr("回合结束")
		reside_num.show()
		end_button.show()
		pass
	elif _phaseName==phaseName.checkEnd:
		checkCardStage(groupType.min)	
	elif _phaseName==phaseName.endturn:
		detail_txt.text="结束阶段，请等待信会和开始"
		await 2
		
		await checkCardStart()
						
func drawOne(isplayer,index=-1):
	var cardone=BOARD_CARD.instantiate()
	if isplayer==true:

		myhand.add_child(cardone)
		cardone.holdType=cardHoldType.player
	else:
		enemyhand.add_child(cardone)
		cardone.holdType=cardHoldType.enemy
	if index>0:
		var newcardArr=cardArr.filter(func(a):return floor(a/13)==index-1)
		var i=randi_range(0,newcardArr.size()-1)
		var carddate=newcardArr[i]
		cardone._value=carddate
		var j=cardArr.find(carddate)

		cardArr[j]=cardArr[cardsize]


		cardArr[cardsize]=carddate
		cardsize-=1
	else:
		var i=randi_range(0,cardsize)
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
	await 0.2
	#for i in range(0,1):
	#	drawOne(true)
	#	if _issole==false:
	#		drawOne(false)
	turnGoto()
	await enterNewPhase(phaseName.checkStart)
@onready var end_button: Button = $CanvasLayer/Button

#判断所有子物体
#如果有2个子物体相同，则进入惩罚阶段，
#二个卡牌放大，然后要求支付卡牌，
#如果没支付则受到伤害，
#惩罚阶段结束后跳到下一个check阶段，直到check结束
@onready var punishimg: Sprite2D = $CanvasLayer/detailTxt/img

var groupPunishTyp=groupType.none
var groupPunishTyp2=groupType.none


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
							punishimg.texture=_zhanli
						elif _groupType==groupType.shang:
							punishimg.texture=_coin
						elif _groupType==groupType.bin:
							punishimg.texture=_soilder
					#定义一个惩罚cardType，然后赋值非空
						end_button.text=tr("拒付惩罚")
						detail_txt.text="请支付你所需的惩罚："
						punishStage=true
						end_button.show()
						cangoto=false
						enterPunishStage(i,j)
						break;
					elif _phaseName==phaseName.checkEnd:
						groupPunishTyp=_groupType
						punishStage=false
						enterRewardStage(i,j)
						cangoto=false
						break;
		if cangoto==false:
			break
	if cangoto==true:
		groupPunishTyp=_groupType
							
		await enterNewPhase(phaseName.punish)

			
#支付n张
#根据group
@onready var endpos: NinePatchRect = $CanvasLayer/NinePatchRect2
@onready var score_txt: Label = $CanvasLayer/Label2
@export var score=0




#进入结束检查阶段标注 并执行完结束检查阶段
func enterRewardStage(i:boardCard,j:boardCard):

	i.animation_player_reward.play("reward")
	j.animation_player_reward.play("reward")
	print("进入奖励阶段次数1"+var_to_str(groupPunishTyp))
	var tween = create_tween()
	var tween2 = create_tween()

	#根据墓地判断牌
	tween.tween_property(i, "global_position", score_txt.global_position, 1)	
	tween2.tween_property(j, "global_position", score_txt.global_position, 1)	

	
	var tempfunc=func(anim_name,i_node, j_node):
		GraveyardArr.append(i._value)
		GraveyardArr.append(j._value)
		changeScore(i_node)
		changeScore(j_node)
		

		
		drawOne(true,groupPunishTyp)
		#奖励消除卡牌
	
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
			await enterNewPhase(phaseName.endturn)
	i.animation_player_reward.animation_finished.connect(tempfunc.bind(i,j))	
	


@onready var detail_txt: Label = $CanvasLayer/detailTxt
var bepunishI:boardCard
var bepusnishJ:boardCard



func changeScore(i:boardCard):
		#提存
	var reside=floor(i._value/13)

	var have=GraveyardArr.any(func(a):return a/13==reside)
	if have:
		score+=10
	else:
		score+=5
	score_txt.text="玩家得分：{s}".format({"s":score})


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
	
	if _phaseName==phaseName.punish or _phaseName==phaseName.checkStart:
		#插入一个代替阶段,如果无法插入
		#先支付一张红桃
		#如果没有红桃则扣hp-1
		if haveHeart() and groupPunishTyp!=groupType.min and groupPunishTyp2!=groupType.min:
			end_button.text=tr("拒付民心惩罚")
			detail_txt.text=tr("请支付你所需的民心：")
			groupPunishTyp2=groupType.min
			#groupPunishTyp=groupType.min
			punishimg.texture=_heart
			punishStage=true
			end_button.show()
			if bepunishI!=null:
				bepunishI.queue_free()
			if bepusnishJ!=null:
				bepusnishJ.queue_free()

			enterPunishStage()
			return
		else:
			hp-=1
			groupPunishTyp2=groupType.none
			if hp<=0:
				pass
		if bepunishI!=null:
			bepunishI.queue_free()
		if bepusnishJ!=null:
			bepusnishJ.queue_free()		
		punishFade("")
		
	elif _phaseName==phaseName.useCard:
		end_button.hide()
		await enterNewPhase(phaseName.checkEnd)
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
