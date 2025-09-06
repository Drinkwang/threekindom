extends Node2D
class_name board_game
@export var selectCard:boardCard
@export var cardArr:Array 
@export var GraveyardArr:Array
@export var enemyGraArr:Array
@export var destroyArr:Array

var cardsize
@export var rects:Array[Node2D]
const BOARD_CARD = preload("res://Scene/prefab/boardCard.tscn")

@onready var board_panel: Panel = $CanvasLayer/boardPanel
var turnAllnum=5


var playerStage=4
var enemyStage=4

@onready var lose_label: Label = $CanvasLayer/LoseRect/Label


func loseGame(_str:String=""):
	
	if _str.length()>0:
		lose_label.text=_str	
		
	lose_rect.show()
	SoundManager.play_sound(sounds.BAD_BATTLE)

@onready var animation_player_BLINK: AnimationPlayer = $CanvasLayer/blinkRect/AnimationPlayer



@onready var win_label: Label = $CanvasLayer/winRect/Label


func winGame(_str:String=""):
	if _str.length()>0:
		win_label.text=_str
	blink_rect.show()
	animation_player_BLINK.play("win")
	var finishfunc=func(aniname):
		blink_rect.hide()
	animation_player_BLINK.animation_finished.connect(finishfunc)
	#曹豹 商人初级 中级 士族 高级 
	#最后的开发，音效的加入
	#0 小试牛刀开启 1小试牛刀通过 2 对局试炼开启 3对局试验通过 4 诡秘怪谈开启 5诡秘怪谈通过
	
	if GameManager._boardMode==boardType.boardMode.new:
		pass
		
	
	win_rect.show()
	SoundManager.play_sound(sounds.GOOD_THING)

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
	readyInGameData()
	changeHoldEnegyPanel()
	#await startGame(4,false)
	


func readyInGameData():
	if GameManager.sav.have_event["卡牌新手教程"]==false and GameManager._boardMode==boardType.boardMode.new:
		GameManager.sav.have_event["卡牌新手教程"]=true
		enterNtutorial()
	elif GameManager.sav.have_event["卡牌中级教程"]==false and GameManager._boardMode==boardType.boardMode.middle:
		GameManager.sav.have_event["卡牌中级教程"]=true
		enterMtutorial()
	elif GameManager.sav.have_event["卡牌高级教程"]==false and GameManager._boardMode==boardType.boardMode.high:
		GameManager.sav.have_event["卡牌高级教程"]=true
		enterHtutorial()		
	else:
		enterGame()


func enterGame():
	#根据model和character修改东西
	var issole=true
	if GameManager._boardMode==boardType.boardMode.new:
		issole=true
	else:
		issole=false
		
		
	if GameManager._boardMode==boardType.boardMode.high:
		issecretGame=true
	else:
		issecretGame=false
	var cardNum=5
	
	
	if GameManager.selectBoardCharacter==boardType.boardCharacter.caobao:
		
		cardNum=5
	elif GameManager.selectBoardCharacter==boardType.boardCharacter.mizhu:
		
		cardNum=4
	elif GameManager.selectBoardCharacter==boardType.boardCharacter.chenden:
		
		cardNum=3
	
	startGame(cardNum,issole)

func showdetail(str:String,grouptype):

	detail_txt.show()
	punishimg.show()
	detail_txt.text=tr(str)
	if grouptype==groupType.min:
		punishimg.texture=_heart
	elif grouptype==groupType.shi:
		punishimg.texture=_zhanli
	elif grouptype==groupType.shang:
		punishimg.texture=_coin
	elif grouptype==groupType.bin:
		punishimg.texture=_soilder
	else:
		punishimg.texture=null

	
	
#每次放卡牌进行一次检测阶段，结束后依然返回出牌阶段，将每次最多使用卡牌改为4张
	
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
		if hp<=0:
			loseGame()
			
			
@export var enemy_hp=3:	
	get:
		return enemy_hp
	set(value):
		if(value>enemy_hp):

			for i in range(0,value-1):
				var tempheart:TextureRect=heart_group_enemy.get_child(i)
				if tempheart.visible:
					tempheart.show()
					tempheart.material.set_shader_parameter("progress",0)
		enemy_hp=value
		#这里如果value>hp 将大于的部分恢复原样
		
		if enemy_hp>=0 and enemy_hp<3:
			var tempheart:TextureRect=heart_group_enemy.get_child(enemy_hp)
			var tween = create_tween()
			tween.tween_property(tempheart.material, "shader_parameter/progress", 1.0, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
			tween.tween_callback(on_tween_finished.bind(tempheart))  # 播放完成后调用函数
		if enemy_hp<=0:
			winGame()	
	
		

func on_tween_finished(a):
	a.hide()
const _coin = preload("res://Asset/ui/钱财.png")
const _heart = preload("res://Asset/ui/人心.png")
const _soilder = preload("res://Asset/ui/兵力.png")
const _zhanli = preload("res://Asset/ui/战力.png")


@onready var win_rect: ColorRect = $CanvasLayer/winRect

@onready var blink_rect: TextureRect = $CanvasLayer/blinkRect

@onready var lose_rect: ColorRect = $CanvasLayer/LoseRect

func isLightUpEnergPanel(isshow):
	if isshow==false:
		rich_text_label_hold_enegy_panel.text="玩家:\n[color=#ffffff88]♥♠♣♦[/color]\n敌人:\n[color=#ffffff88]♥♠♣♦[/color]"
	else:
		rich_text_label_hold_enegy_panel.text="玩家:\n♥♠♣♦\n敌人:\n[color=#ffffff88]♥♠♣♦[/color]"


func changeHoldEnegyPanel():
	#从墓地区便利
	pass
	var context=tr("玩家")+":\n"
	if engergeHold(groupType.min):
		context+="♥"
	else:
		context+="[color=#ffffff88]♥[/color]"
	if engergeHold(groupType.shi):
		context+="♠"
	else:
		context+="[color=#ffffff88]♠[/color]"
	if engergeHold(groupType.shang):
		context+="♣"
	else:
		context+="[color=#ffffff88]♣[/color]"
	if engergeHold(groupType.bin):
		context+="♦"
	else:
		context+="[color=#ffffff88]♦[/color]"		
	context+="\n"
		
	context+=tr("敌人")+":\n"
	
	if engergeHold(groupType.min,false):
		context+="♥"
	else:
		context+="[color=#ffffff88]♥[/color]"
	if engergeHold(groupType.shi,false):
		context+="♠"
	else:
		context+="[color=#ffffff88]♠[/color]"
	if engergeHold(groupType.shang,false):
		context+="♣"
	else:
		context+="[color=#ffffff88]♣[/color]"
	if engergeHold(groupType.bin,false):
		context+="♦"
	else:
		context+="[color=#ffffff88]♦[/color]"					
	
	
	rich_text_label_hold_enegy_panel.text=context
	#
#获得一张诡秘卡
#红桃Q 陶谦 血姬
#方片Q 骨龙  尸皇
#梅花Q 血姬  骨龙
#黑桃Q 商人

var hasSecretCard=[true,true,true,true]
var secretPanel
func showSecretCard():
	if secretPanel==null:
		secretPanel=PanelManager.new_SecretCardView()
		secretPanel.initSecretCard(hasSecretCard)
	else:
		secretPanel.show()

func getSecretCard(cardId,isplayer=true):
	var cardone=BOARD_CARD.instantiate()
	if isplayer==true:
		playerEngergyHold.clear()
		myhand.add_child(cardone)
		cardone.holdType=cardHoldType.player
	else:
		enemyEngergyHold.clear()
		enemyhand.add_child(cardone)
		cardone.holdType=cardHoldType.enemy	
	#获得不同的
	cardone._value=(cardId-1)*13+11 #获得q，然后我们的下一部操作是把
	hasSecretCard[cardId-1]=false
	changeHoldEnegyPanel()
#这个最好是发动移到显眼处，然后有个动画
func useSecretCard(index):
	pass

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
		reside_num.text=tr("剩余步数：{s}").format({"s":playerStage})
	
	if  _phaseName==phaseName.useCard:
		await get_tree().create_timer(0.2).timeout
		settleOneGroup(groudObj)
	
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
	punishStage=false
	if bepunishI==null and bepusnishJ==null:
		punishFade("")
		heart_color.hide()
		return
	
	
	bepunishI.animation_player.play("fade")
	bepusnishJ.animation_player.play("fade")
	var tween =create_tween()
	# 为 rect1 的 tint_color 参数设置动画，从白色到红色，持续 2 秒
	tween.tween_property(bepunishI.nine_patch_rect.material, "shader_parameter/burn_progress", 1, 1)
	tween.tween_property(bepunishI.img.material, "shader_parameter/burn_progress", 1, 1)
	tween.tween_property(bepusnishJ.nine_patch_rect.material, "shader_parameter/burn_progress", 1, 1)
	tween.tween_property(bepusnishJ.img.material, "shader_parameter/burn_progress", 1, 1)
	
	
	

	

		
	bepusnishJ.animation_player.animation_finished.connect(punishFade)	
	#也可以放成回调

	
func punishFade(anim_name: StringName):
	
	
	

	if 	bepunishI==null and bepusnishJ==null:
		groupPunishTyp=groupType.none
		await get_tree().create_timer(1).timeout
		await enterNewPhase(phaseName.useCard)			
		
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
		if isPlayerTurn==true:
			end_button.show()
		await get_tree().create_timer(1).timeout
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
			if _phaseName==phaseName.useCard and isPlayerTurn==true:
				detail_txt.text=tr("必须靠近出现感叹号才能使用卡牌")
	#参考我炒的代码
	
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		isstop=true
	
		if isstop==true:
			stopClick()


@onready var heart_group_enemy: HBoxContainer = $CanvasLayer/heartGroup_enemy

#打n把
#集齐四种花色时，每回合开始可以利用四种花色换取一张功能牌
# 少20分
# 弃掉对面一牌 战士
# 自己抽1牌  商人
# 恢复一点体力 士族

@export var _issole:bool=false
func startGame(cardnum,issole):
	score=0
	hp=3
	enemy_hp=3
	_issole=issole
	if _issole==false:
		enemy_score_txt.show()
		heart_group_enemy.show()
		enemyhand.show()
		detail_h_box_container.position=Vector2(627,162)
	else:
		detail_h_box_container.position=Vector2(627,11)		
		enemy_score_txt.hide()
		heart_group_enemy.hide()
		enemyhand.hide()
	if issecretGame==true:
		hold_enegy_panel.show()
	else:
		hold_enegy_panel.hide()	
	for i in range(0,cardnum):
		drawOne(true)
		if issole==false:
			drawOne(false)	
	#进入新阶段来判断
	await enterNewPhase(phaseName.drawCard)
	
@onready var reside_num: Label = $CanvasLayer/resideNum

@onready var detail_h_box_container: HBoxContainer = $CanvasLayer/HBoxContainer




#规则三打开 不过默认也收集花色
@onready var hold_enegy_panel: Panel = $HoldEnegyPanel
@onready var rich_text_label_hold_enegy_panel: RichTextLabel = $HoldEnegyPanel/RichTextLabel_HoldEnegyPanel


func turnGoto():
	if turn_num<5:
		turn_num+=1
		turn_num_Txt.text="回合数：{s}/5".format({"s":turn_num})
	else:
		#
		if _issole==true:
			winGame()
		else:
			if score>enemyscore:
				winGame(tr("你的积分大于对手\n你赢了"))
			elif score==enemyscore:
				winGame()
			else:
				loseGame(tr("你的积分小于对手\n你输了"))

@export var isPlayerTurn:bool=true
func enterNewPhase(stage:phaseName):
	
	if stage!=phaseName.punish:
		_phaseName=stage
	if _phaseName==phaseName.drawCard and stage!=phaseName.punish:
		#如果是玩家
		#turnGoto()
		await checkCardStart()
	elif _phaseName==phaseName.checkStart and stage!=phaseName.punish:
		checkCardStage(groupType.min)#check 才是punish  我们只需要ai使用check 和use	
	elif stage==phaseName.punish:
		#进入punish并不是punish 而是跳转
		if groupPunishTyp==groupType.min:
			checkCardStage(groupType.shi)
		elif groupPunishTyp==groupType.shi:
			checkCardStage(groupType.shang)
		elif groupPunishTyp==groupType.shang:
			checkCardStage(groupType.bin)
		elif groupPunishTyp==groupType.bin:
			if  _phaseName==phaseName.checkStart:
				groupPunishTyp=groupType.none
				await get_tree().create_timer(0.2).timeout
				await enterNewPhase(phaseName.useCard)
			elif _phaseName==phaseName.checkEnd:
				groupPunishTyp=groupType.none
				await enterNewPhase(phaseName.endturn)
	elif _phaseName==phaseName.useCard:
		if isPlayerTurn==true:
			playerStage=4
			detail_txt.text=tr("出牌阶段，请使用你的卡牌")
			punishimg.texture=null
			board_panel.hide()
			end_button.text=tr("回合结束")
			reside_num.show()
			end_button.show()
		else:
			detail_txt.text=tr("敌人出牌阶段，正在使用卡牌")
			punishimg.texture=null
			enemyStage=4
			AIUseCard()
	elif _phaseName==phaseName.checkEnd:
		checkCardStage(groupType.min)	
	elif _phaseName==phaseName.endturn:
		detail_txt.text="结束阶段，请等待新回合开始"
		punishimg.texture=null
		SoundManager.play_sound(sounds.COLLECT_SMALL_JEWEL_1)
		await get_tree().create_timer(1.5).timeout
		if _issole==false:
			isPlayerTurn=!isPlayerTurn
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
	SoundManager.play_sound(sounds.DRAWCARD)
	if _issole==false:
		drawOne(isPlayerTurn)
		pass
	await get_tree().create_timer(0.1).timeout
	insertCardRandom(groupType.min)
	await get_tree().create_timer(0.1).timeout
	insertCardRandom(groupType.shi)
	await get_tree().create_timer(0.1).timeout
	insertCardRandom(groupType.shang)
	await get_tree().create_timer(0.1).timeout
	insertCardRandom(groupType.bin)

	#for i in range(0,1):
	#	drawOne(true)
	#	if _issole==false:
	#		drawOne(false)
	if isPlayerTurn==true:
		turnGoto()
	await enterNewPhase(phaseName.checkStart)
@onready var end_button: Button = $CanvasLayer/Button

#判断所有子物体
#如果有2个子物体相同，则进入惩罚阶段，
#二个卡牌放大，然后要求支付卡牌，
#如果没支付则受到伤害，
#惩罚阶段结束后跳到下一个check阶段，直到check结束
@onready var punishimg:TextureRect = $CanvasLayer/HBoxContainer/img

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
	var rewardArr=[]
	#编排出来，统一hide，然后加入rewardarr，最后统一释放
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
					
						if isPlayerTurn==true:
							SoundManager.play_sound(sounds.deniedsound)
							end_button.text=tr("拒付惩罚")
							detail_txt.text="请支付你所需的惩罚："
							punishStage=true
							end_button.show()
							cangoto=false
							enterPunishStage(i,j)
						else:
							groupPunishTyp=_groupType
							punishStage=false
							detail_txt.text="敌人支付惩罚中："
							await get_tree().create_timer(2)
							#支付完了后 应该把状态清空
							await AIDiscardCard(i,j)
							cangoto=false
							
							#随机丢一个
							#进入下一个阶段
							pass
						break;
					elif _phaseName==phaseName.checkEnd:
						groupPunishTyp=_groupType
						punishStage=false
						cangoto=false
						await enterRewardStage(i,j)
						break;
						
						
						#await get_tree().create_timer(0.5)
						


			
		if cangoto==false:
			break
			

				
	if cangoto==true:
		groupPunishTyp=_groupType
							
		await enterNewPhase(phaseName.punish)


#玩家受伤动画
#玩家支付代价动画
#修改4步，以及打出牌就能获得奖励
#润滑ai行为和动画

@onready var heart_color: ColorRect = $CanvasLayer/heartColor
@onready var damage_color: ColorRect = $CanvasLayer/damageColor



func AIDiscardCard(i,j):
	
	
	#
	var _value=i._value
	bepusnishJ=j
	bepunishI=i
	var index=floor(_value/13)
	await get_tree().create_timer(2)
	payRandomPunish(index+1)	


func payRandomPunish(_grouptype:groupType):
	var isPay=false
	var index=_grouptype-1
	var arrs: Array[boardCard] = []
	var _minnum=suitNum(groupType.min)
	for child in enemyhand.get_children():
		if child is boardCard:
			var bevalue=floor(child._value/13)
			if bevalue==index:# or bevalue==0:
				arrs.append(child)
	var can_pay = false
	#groupPunishTyp=_grouptype
	if arrs.size()>0:
		var _havesuitnum=haveSuitNum(false)
		var _suitNum=suitNum(_grouptype)

		if _grouptype==groupType.min:
			var percent=100
			if enemy_hp>=2:
				if _suitNum==1:
					percent-=50
				elif _suitNum==2:
					percent-=40
				elif _suitNum==3:
					percent-=30
				elif _suitNum==4:
					percent-=20
				if _havesuitnum<=2:
					percent-=10	
				
			#if hp>=2 and _suitNum<=1 and  _havesuitnum<=2:
			#	percent=50
			#else:
			#	percent=100
			isPay=chance(percent)

		else:
			var percent=100
			
			if enemy_hp+_minnum>=2:
				if _suitNum==1:
					percent-=25
				elif _suitNum==2:
					percent-=20
				elif _suitNum==3:
					percent-=15
				elif _suitNum==4:
					percent-=5
				if _havesuitnum<=2:
					percent-=5	
			isPay=chance(percent)
	else:
		isPay=false
		
	if isPay==true:



		#加入没清空的状态
		var cancost=arrs.size()-1
		var constindex=randi_range(0,cancost)
		var discard=arrs[constindex]
		discard.queue_free()
		if bepusnishJ!=null and bepusnishJ!=null:
			SettlePunish()
		else:
			punishFade("")
	else:
		if _grouptype!=groupType.min:
			if _minnum>0:
				#groupPunishTyp2=groupType.min 暂时没发现意义，但不能用type1 以免被卡流程
				print("拿民代替")
				payRandomPunish(groupType.min)
			else:
				enemy_hp-=1
				SettlePunish()
				#punishFade("")
		else:
			enemy_hp-=1
			SettlePunish()
			#punishFade("")

		
	#判断有无支付，支付了放true，没支付放false

#在ai使用卡牌会优先确保能量槽位未满

#使用卡牌丢卡牌概率
func chance(percent: float) -> bool:
	randomize()  # 每次调用设置不同种子
	return randf() * 100 <= percent
	
func haveSuitNum(isplayer: bool) -> int:
	var hand
	if isplayer==true:
		hand=myhand
	else:
		hand=enemyhand

	var arrs: Array[boardCard] = []
	for child in hand.get_children():
		if child is boardCard:
			if child is boardCard:
				var bearr=floor(child._value/13)
				if not bearr in arrs:
					arrs.append(bearr)
	return 	arrs.size()

func suitNum(_groupType:groupType) -> int:
	var _value=_groupType

	var arrs: Array[boardCard] = []
	for child in enemyhand.get_children():
		if child is boardCard:
			if floor(child._value/13)==_value-1:
				arrs.append(child)
	return 	arrs.size()
	
#使用secretcard报错
#使用红心替代报错  优先解决
	
@onready var canvas_layer: CanvasLayer = $CanvasLayer

	
func AIUseCard():
	#var demandGroup=[1,2,3,4]
#
	#demandGroup.sort_custom(
		#func(a,b):
			#if a==1:
				#return false
			#elif b==1:
				#return true
			#if suitNum(a)>suitNum(b):
				#return true
			#else:
				#return false
	#)
	#var groudObj:GridContainer	
	#for _group in demandGroup:
		#if _group==groupType.min:
			#groudObj=min_group
		#elif _group==groupType.shi:
			#groudObj=shi_group
	#
		#elif _group==groupType.shang:
			#groudObj=shang_group
#
		#elif _group==groupType.bin:
			#groudObj=bin_group
#
	#var stuckcards=groudObj.get_children()
	#for stuckcard in stuckcards:
		#pass #如果别的能用 有50%放弃		
	#
	#
	var bestScore=0	
	var bestIndex=-1
	var alreadyUse=[]
	#把ai用的牌和消除的牌全部记录一遍，不会重复计入
	#while enemyStage>0:
	for _group in range(1,5):
		var getscore=calculateStuckScore(_group)
			
		if bestScore<getscore:
			print("currence"+var_to_str(bestScore)+",bestindex"+var_to_str(_group))
			bestScore=getscore
			bestIndex=_group
	  #在bestIndex使用卡牌	
	if 	bestIndex!=-1:
		#忽略12，待开发
		AIUseCardInStuck(bestIndex,alreadyUse)
		enemyStage-=1;
		return

	else:
		print("it is problem")
		enemyStage=0
	if enemyStage<=0:
	#进入下一个阶段
		phaseEnd()
		
func AIUseCardInStuck(bestIndex,alreadyUse:Array):
	var groupobj=getGroupObj(bestIndex)
	#能凑齐，加分
	var useCard=false
	var cards=groupobj.get_children()
	var handCard=enemyhand.get_children()
		
	for hand_card in handCard:
		if hand_card is boardCard:
			for stack_card in cards:
				if stack_card is boardCard:
					if floor(hand_card._value%13)==11 or floor(hand_card._value/13) == floor(stack_card._value/13) and not alreadyUse.has(stack_card) and not alreadyUse.has(hand_card):
						useCard=true
						alreadyUse.append(stack_card)
						alreadyUse.append(hand_card)
						var tween=create_tween()
						hand_card.reparent(canvas_layer)	
						hand_card.holdType=cardHoldType.stack
						hand_card.back_rect.hide()
						tween.tween_property(hand_card, "global_position", groupobj.global_position, 1)
						#tween.tween_property(tempheart.material, "shader_parameter/progress", 1.0, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
						var movefinish=func(_hand_card,groupobj):
							if _hand_card!=null:
								_hand_card.reparent(groupobj)
								await settleOneGroup(groupobj)
								#调用结算函数	
							pass
						tween.tween_callback(movefinish.bind(hand_card,groupobj))  # 播放完成后调用函数
						#实际用牌逻辑 将handcard打入到groupobj
						break
			if useCard==true:
				break

func settleOneGroup(_groupobj:GridContainer):
	var groupobj=_groupobj.get_children()
	var isbreak
	for i:boardCard in groupobj:
		for j:boardCard in groupobj:
			if i!=j and i!=null and j!=null:
				var residei:int=floori((i._value)/13)
				var residej:int=floori((j._value)/13)

				if residei==residej:

		
					punishStage=false
					isbreak=true
					await enterRewardStage(i,j)
					break
		if isbreak==true:
			break	
			



		if isbreak==true:
			break								
	excuteSecret(groupobj)					
						#await get_tree().create_timer(0.5)

			

func excuteSecret(groupobj:Array):
	for secretCard:boardCard in groupobj:
		var _secretValue=secretCard._value
		var _secretsuit=floor(secretCard._value/13)+1
		var _secretReside=floor(secretCard._value%13)
		if _secretReside==11:
			var tween=create_tween()
			secretCard.reparent(canvas_layer)	
			secretCard.holdType=cardHoldType.stack
			secretCard.back_rect.hide()
			tween.tween_property(secretCard, "global_position", Vector2(844,396), 1)

			var movefinish=func(_hand_card,groupobj,_secretsuit):
				if _hand_card!=null:
					if _secretsuit==1:
						if isPlayerTurn:
							hp+=1
							detail_txt.text=tr("你发动了血姬卡，恢复一点体力")
						else:
							enemy_hp+=1
							detail_txt.text=tr("敌人发动血姬卡，恢复一点体力")
					elif _secretsuit==2:
						if isPlayerTurn:
							var cards=enemyhand.get_children()
							var _index=randi_range(0,cards.size()-1)
							cards[_index].queue_free()
							detail_txt.text=tr("你发动了骨龙卡，弃掉对手一张卡")
							#拆一张牌
							pass
						else:
							var cards=myhand.get_children()
							var _index=randi_range(0,cards.size()-1)
							detail_txt.text=tr("敌人发动了骨龙卡，弃掉你一张卡")
							cards[_index].queue_free()
					elif _secretsuit==3:
						if isPlayerTurn:
							drawOne(true)
							detail_txt.text=tr("你发动尸皇卡，抽一张卡")
						else:
							drawOne(false)
							detail_txt.text=tr("敌人发动尸皇卡，抽一张卡")
					elif _secretsuit==4:
						if isPlayerTurn:
							
							detail_txt.text=tr("你发动黑商卡，对手失去20分")
							enemyscore-=20
							enemy_score_txt.text="敌人得分：{s}".format({"s":enemyscore})		

						else:
							#扣积分
							detail_txt.text=tr("敌人发动黑商卡，你失去20分")
							score-=20
							score_txt.text="玩家得分：{s}".format({"s":score})
					await get_tree().create_timer(2)
					_hand_card.queue_free()

			#groupobj.any(func(a):return a._value%13==11)					#调用结算函数	
			if secretCard!=null and groupobj!=null and _secretsuit>0:
				tween.tween_callback(movefinish.bind(secretCard,groupobj,_secretsuit))  # 播放完成后调用函数
				
		else:
			pass
		#secretCard#移动到中间		

	if isPlayerTurn==false:
		await get_tree().create_timer(0.2).timeout
		if enemyStage>0:
			AIUseCard()	#这个我可能感觉ai可能也会需要
		else:
			phaseEnd()


#还差敌人发动secret的逻辑，以及把上面的逻辑加特效

func getGroupObj(_group)->GridContainer:
	var groudObj
	if _group==groupType.min:
		groudObj=min_group
	elif _group==groupType.shi:
		groudObj=shi_group
	elif _group==groupType.shang:
		groudObj=shang_group

	elif _group==groupType.bin:
		groudObj=bin_group
	
	return groudObj
		
func calculateStuckScore(stuck:groupType):
	var _score=0
	var canscore=false
	var groupobj=getGroupObj(stuck)
	#能凑齐，加分

	var cards=groupobj.get_children()
	var handCard=enemyhand.get_children()
		
	for hand_card in handCard:
		if hand_card is boardCard:
			for stack_card in cards:
				if stack_card is boardCard:
					if floor(hand_card._value/13) == floor(stack_card._value/13) or (floor(hand_card._value%13)==11 and floor(hand_card._value/13) != floor(stack_card._value/13)):
						canscore= true
						break
			if canscore==true:
				break

	
	if canscore==true:
		_score+=10
		var cardValues=[]
		
		calculateStuckScoreInLoop(stuck,cardValues)
		_score+=(cardValues.size()*10)
		if stuck==1:
			_score+=20
		#如果里面不存在这个元素 则可以
		#cardValues.append(calculateStuckScoreInLoop(stuck))
		
		#
	#能凑齐并且得到的东西能在其它堆凑齐 加加分
	#是红桃 加分
	return _score
	

func calculateStuckScoreInLoop(suitColor,cardValues:Array):	
	#用卡牌便利四个堆，如果有，且cards没有，则获取堆，并把该卡加入cards 并继续调用calculateStuckStuck
	for g in range(1,5):
		var groupobj=getGroupObj(g)
		var cards=groupobj.get_children()
		
		for card in cards:
			if card is boardCard:
				if floor(card._value/13)+1==suitColor and not cardValues.has(card._value):
					cardValues.append(card._value)
					calculateStuckScoreInLoop(g,cardValues)

#根据group
@onready var endpos: NinePatchRect = $CanvasLayer/NinePatchRect2
@onready var score_txt: Label = $CanvasLayer/Label2
@onready var enemy_score_txt: Label = $CanvasLayer/enemyScore



@export var score=0

@export var enemyscore=0

var playerEngergyHold=[]
var enemyEngergyHold=[]


var issecretGame=true

#进入结束检查阶段标注 并执行完结束检查阶段
func enterRewardStage(i:boardCard,j:boardCard):
		
		
	i.animation_player_reward.play("reward")
	j.animation_player_reward.play("reward")
	#print("进入奖励阶段次数1"+var_to_str(groupPunishTyp))
	var tween = create_tween()
	var tween2 = create_tween()

	var desposition
	if isPlayerTurn==true:
		desposition=score_txt.global_position
	else:
		desposition=enemy_score_txt.global_position
	#根据墓地判断牌
	tween.tween_property(i, "global_position", desposition, 1)	
	tween2.tween_property(j, "global_position", desposition, 1)	

	
	var tempfunc=func(anim_name,i_node, j_node):
				
		var gettype:groupType
		var parent_type=i_node.get_parent()
		if parent_type==min_group:
			gettype=groupType.min
		elif parent_type==shi_group:
			gettype=groupType.shi
		elif parent_type==shang_group:
			gettype=groupType.shang		
		elif parent_type==bin_group:
			gettype=groupType.bin				
		var index=i._value/13	
		
		if isPlayerTurn==true:
			GraveyardArr.append(i._value)
			GraveyardArr.append(j._value)
			
			if 	!playerEngergyHold.has(index+1):
				playerEngergyHold.append(index+1)

		else:
			enemyGraArr.append(i._value)
			enemyGraArr.append(j._value)
			if 	!enemyEngergyHold.has(index+1):
				enemyEngergyHold.append(index+1)
				if enemyEngergyHold.size()>=4 and hasSecretCard.has(true) and issecretGame==true:
					var indexRandom=randi_range(1,4)
					getSecretCard(indexRandom,false)	
					hasSecretCard[indexRandom-1]=false
					#播放一个动画，拿到某张诡异卡


		changeScore(i_node)
		changeScore(j_node)
		
		SoundManager.play_sound(sounds.MATCH_STRIKING)
		
		#var parent
		drawOne(isPlayerTurn,gettype)
		#奖励消除卡牌
	
		#print("helloworld")
		i_node.queue_free()
		j_node.queue_free()
		await get_tree().create_timer(0.5).timeout
		if playerEngergyHold.size()>=4 and hasSecretCard.has(true) and _issole==false and issecretGame==true:
			showSecretCard()#非单人模式才能触发
			SoundManager.play_sound(sounds.HUI_1)
		if _phaseName==phaseName.checkEnd:
			if groupPunishTyp==groupType.min:
				checkCardStage(groupType.shi)
			elif groupPunishTyp==groupType.shi:
				checkCardStage(groupType.shang)
			elif groupPunishTyp==groupType.shang:
				checkCardStage(groupType.bin)
			elif groupPunishTyp==groupType.bin:
				groupPunishTyp=groupType.none
				await enterNewPhase(phaseName.endturn)
		elif _phaseName==phaseName.useCard:
			if isPlayerTurn==false:
				await get_tree().create_timer(0.2).timeout
				if enemyStage>0:
					AIUseCard()	#这个我可能感觉ai可能也会需要
				else:
					phaseEnd()
	i.animation_player_reward.animation_finished.connect(tempfunc.bind(i,j))	



@onready var detail_txt: Label = $CanvasLayer/HBoxContainer/detailTxt
var bepunishI:boardCard
var bepusnishJ:boardCard


func engergeHold(reside,isplayer=true):
	var have
	if isplayer==true:
		have=playerEngergyHold.any(func(a):return a==(reside))	
	else:
		have=enemyEngergyHold.any(func(a):return a==(reside))	
	return have


#代替红桃没有结束
#如果没有惩罚 没有结束

#从墓地改成能量区，目前废弃墓地设定
func graveyardHave(reside,isplayer=true):
	var have
	if isplayer==true:
		have=GraveyardArr.any(func(a):return a/13==(reside-1))	
	else:
		have=enemyGraArr.any(func(a):return a/13==(reside-1))	
	return have

func changeScore(i:boardCard):
		#提存
	var reside=floor(i._value/13)

	var have
	
	if isPlayerTurn:
		have=GraveyardArr.any(func(a):return a/13==reside)
	
	
		if have:
	
			score+=10
		else:
			score+=5
		score_txt.text="玩家得分：{s}".format({"s":score})
	else:
		have=enemyGraArr.any(func(a):return a/13==reside)
	
	
		if have:
	
			enemyscore+=10
		else:
			enemyscore+=5
		
		enemy_score_txt.text="敌人得分：{s}".format({"s":enemyscore})		
	changeHoldEnegyPanel()		
		

#进入惩罚阶段标注
func enterPunishStage(i=null,j=null):
	detail_txt.show()
	board_panel.show()
	if i!=null and j!=null:
		board_panel.modulate=Color.WHITE
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
			end_button.text=tr("拒付失去体力")
			detail_txt.text=tr("是否支付民心替代惩罚：")
			if isPlayerTurn==true:
				#然后还要过度强度
				var hearttween = get_tree().create_tween()
				heart_color.material.set_shader_parameter("vignette_intensity", 0)
				heart_color.show()
				hearttween.tween_method(
					func(value): heart_color.material.set_shader_parameter("vignette_intensity", value),
					0.0, # Start value
					1.0, # End value
					1 # Duration in seconds
				)	
		
			board_panel.modulate=Color.RED
			groupPunishTyp2=groupType.min
			#groupPunishTyp=groupType.min
			punishimg.texture=_heart
			punishStage=true
			if isPlayerTurn==true:
				end_button.show()
			if bepunishI!=null:
				bepunishI.queue_free()
			if bepusnishJ!=null:
				bepusnishJ.queue_free()

			enterPunishStage()
			return
		else:
			SoundManager.play_sound(sounds.SWORD_PANG)
			
			
			var hptween = create_tween()

			heart_color.hide()
			damage_color.material.set_shader_parameter("vignette_intensity", 0)
			damage_color.show()
			hptween.tween_method(
				func(value): damage_color.material.set_shader_parameter("vignette_intensity", value),
				0.0, # Start value
				1.0, # End value
				0.5 # Duration in seconds
			)				
			hptween.tween_method(
				func(value): damage_color.material.set_shader_parameter("vignette_intensity", value),
				1, # Start value
				0, # End value
				0.5 # Duration in seconds
			)				
			hptween.tween_callback(func(): damage_color.hide())	
			
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
		if isPlayerTurn==true:
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

const dialogue_resource = preload("res://dialogues/桌游.dialogue")
func enterNtutorial():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"欢迎进入初级")
	
func enterMtutorial():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"欢迎进入中级")

func enterHtutorial():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"欢迎进入高级")

@onready var point_group: Control = $CanvasLayer/pointGroup


@onready var guild_1: Node2D = $"CanvasLayer/pointGroup/1"
@onready var guild_2: Node2D = $"CanvasLayer/pointGroup/2"
@onready var guild_3: Node2D = $"CanvasLayer/pointGroup/3"
@onready var guild_4: Node2D = $"CanvasLayer/pointGroup/4"
@onready var guild_5: Node2D = $"CanvasLayer/pointGroup/5"
@onready var guild_6: Node2D = $"CanvasLayer/pointGroup/6"

@onready var guild_7: Node2D = $"CanvasLayer/pointGroup/7"

@onready var guild_8: Node2D = $"CanvasLayer/pointGroup/8"




func showtutorial(num,isshow):

	if(num<9):
		if isshow:
			self["guild_"+str(num)].show()
		else:
			self["guild_"+str(num)].hide()
