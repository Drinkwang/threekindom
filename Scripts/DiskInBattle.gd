extends Control
class_name DiskInBattle
@export var datas:Array[TextureProgressBar]
@onready var selectHero=$"../"

@onready var control = $".."
const jiandao = preload("res://Asset/other/剪刀.png")
const bu = preload("res://Asset/other/布.png")
const shitou = preload("res://Asset/other/石头.png")
const Success=preload("res://.godot/imported/Success.svg-af58d452c13e928b2a282a117f5e080e.ctex")
const fail=preload("res://Asset/other/0_red.png")

@onready var point_1 = $POINT1
@onready var point_2 = $POINT2
@onready var point_3 = $POINT3
@onready var point_4 = $POINT4

#var battleCircle=[
#	{"name":"无风险","initPos":0,"radian":90},
# Called when the node enters the scene tree for the first time.
var selectgeneral
#ne
func _endReward():
	
	pass
	#print(点击完毕)
	#点击通过
	#判断是否完成任务
	#$PointerScifiB.hide()

@onready var enemy = $enemy

func _normalize_angle(angle: float) -> float:
	return fposmod(angle, 360.0)

func _is_angle_in_sector(angle: float, lower: float, upper: float) -> bool:
	if lower < upper:
		return angle >= lower and angle < upper
	return angle >= lower or angle < upper

func _refreshBattleTypePreview():
	if GameManager.sav.battleTasks==null or GameManager.sav.battleTasks.size()==0:
		return
	var size = GameManager.sav.battleTasks.size()
	#var current = taskIndex
	#if current < 0 or current >= size:
	#	current = 0
	for i in range(1, 4):
		var idx = (i - 1) % size
		var sd = GameManager.sav.battleTasks[idx].sdType
		_initBattleTypePng(i, sd)
var enemyName=""
func changeHeadInMainTask():
	
	const CANGXI_2 = preload("res://Asset/人物/cangxi2.png")
	const CANGXI = preload("res://Asset/人物/cangxi.png")
	const HUANGJIN_3 = preload("res://Asset/人物/huangjin3.png")
	const ZANGBA = preload("res://Asset/人物/zangba.png")
	const ma = preload("res://Asset/人物/马儿.png")
	const jiling = preload("res://Asset/人物/纪灵.png")
	const lvbujiling = preload("res://Asset/人物/吕布纪灵.png")
	const lvbu = preload("res://Asset/人物/吕布.png")
	
	if GameManager.sav.have_event["battleTaiShan"]==true and GameManager.sav.have_event["昌豨求饶"]==false:
		enemyName="昌豨"
		changeHead(CANGXI)
	elif GameManager.sav.endPath==GameManager.endPath.xuzhou:
		enemyName="纪灵/吕布"		
		changeHead(lvbujiling)

		#吕布和袁术各一半
	elif GameManager.sav.have_event["昌豨求饶"]==true and GameManager.sav.have_event["臧霸首战"]==false:
		enemyName="昌豨"	
		changeHead(CANGXI)
	elif  GameManager.sav.have_event["臧霸首战"]==true and GameManager.sav.have_event["completebattleTaiShan"]==false:
		enemyName="臧霸"			
		changeHead(ZANGBA)
	elif GameManager.sav.have_event["夏侯偷马"]==false and GameManager.sav.have_event["战斗袁术开始"]==true:
		enemyName="纪灵"	
		changeHead(jiling)
	elif GameManager.sav.have_event["吕布之怒"]==false and GameManager.sav.have_event["夏侯偷马"]==true and GameManager.sav.endPath==GameManager.endPath.xiaopei:
		enemyName="吕布的马"	
		changeHead(ma)
	elif GameManager.sav.have_event["吕布之怒"]==true:
		enemyName="吕布"	
		changeHead(lvbu)
		
	else:
		enemyName="黄巾流寇"	
		changeHead(HUANGJIN_3)	
		
		
#"臧霸首战之前":false,#泰山诸将1
#	"昌豨求饶":false,#泰山诸将2
#	"臧霸首战":false,#泰山诸将3
#	"昌豨求饶2":false,#泰山诸将3
	#最后是黄巾

func _ready():
	changeHeadInMainTask()
	SignalManager.changeLanguage.connect(changeLanguage)		
	SignalManager.endReward.connect(_endReward)
	taskIndex=getTaskIndex()
	if GameManager.sav.battleTasks==null or GameManager.sav.battleTasks.size()==0:
		return 
	_initBattleTypePng(0, GameManager.sav.battleTasks[taskIndex].sdType)
	_refreshBattleTypePreview()
	#初始化其中一个，然后随机获取一个 初始化按照gamemanager数据来
	var btdatas=GameManager.battleCircle
	for i in range(0,4):
		var btdata=btdatas[i]
		datas[i].radial_initial_angle=btdata.initPos
		datas[i].radial_fill_degrees=btdata.radian
		self["point_"+str(i+1)].radial_initial_angle=btdata.initPos
		
	#初始化玩家坐标系
	datas[4].radial_initial_angle=btdatas[4].initPos
	datas[4].radial_fill_degrees=btdatas[4].radian
	refreshHideBattleTask()
	changeLanguage()
	refreshPage()
	Txtcount.text=str(GameManager.sav.completeTask)+"/"+str(GameManager.sav.currenceTask-GameManager.sav.completeTask)+"/"+str(GameManager.sav.currenceTask)
const NOT_JAM_UI_CONDENSED_16 = preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")
const LEGEND_FONT_DEFAULT = preload("res://Asset/Font/1_sim.ttf")
const LEGEND_FONT_RU = preload("res://Asset/Font/1_blod.ttf")
#const LEGEND_NORMAL_RECT := Rect2(-100.0, 1.0, 20.0, 76.0)
#const LEGEND_VICTORY_KIT_RECT := Rect2(-110.0, -14.0, 20.0, 96.0)
func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="ru":
		_set_legend_style(LEGEND_FONT_RU, 14)
	else:
		_set_legend_style(LEGEND_FONT_RU, -1)
	if GameManager.sav.isInformation==false:
		TooltipManager.register_tooltip(se_task_hbox,tr("奇策触发：满足特定条件，解锁隐藏行动"))	
	else:
		var context="条件揭示：\n"+ tr(GameManager.sav.extranewDetail)
		TooltipManager.register_tooltip(se_task_hbox,context)	
func _set_legend_style(font:Font, font_size:int):
	for legend_item in $VBoxContainer.get_children():
		var legend_label = legend_item.get_node_or_null("Label")
		if legend_label == null:
			continue
		legend_label.add_theme_font_override("font", font)
		if font_size > 0:
			legend_label.add_theme_font_size_override("font_size", font_size)
		else:
			legend_label.remove_theme_font_size_override("font_size")



var taskIndex:int=0

var taskComplete=0
@onready var buff_txt = $buffTxt
	
func _juideCompeleteTask():
	#用100减去安全区的值
	#
	taskComplete=0
	var rewardMax=360-GameManager.battleCircle[0].radian
	#所有风险区的变化最后都会改成无风险值变大
	var generalLevel
	if(selectgeneral!=null):
		generalLevel=selectgeneral.level
	else:
		generalLevel=0
	var mustHave	
	if  GameManager.sav.gameDifficulty==3:
		mustHave=rewardMax*(generalLevel+10)/34
	else:
		mustHave=rewardMax*(generalLevel+10)/32     #+generalLevel*rewardMax/20
	#var mustHave=rewardMax/2
	var targetGet=0
	var is_mi_boss=GameManager.currenceScene!=null and GameManager.currenceScene.battle_pane._mode==SceneManager.bossMode.mi
	var mi_risk_task_complete=false
	#print("befoer"+str(targetGet))
	#等级 （reward/100）*mustrewad
	var btdatas
	var tasks
	if GameManager.sav.battleTasks.size()>0:
		btdatas=GameManager.sav.battleTasks[taskIndex]
		tasks=btdatas.task
	else:
		btdatas=null
		tasks=[]
	
	var haveRes
	var levels=1
	#generalLevel=selectgeneral.level
	if generalLevel!=null and selectgeneral!=null:
		
		var generalName=selectgeneral.name
		var isBloodBattle=GameManager.sav.have_event["战斗袁术血战模式"]==true and GameManager.sav.have_event["血战袁术完成"]==false
		var hasWeapon=false
		if generalName=="关羽":
			hasWeapon=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.青龙偃月刀)>0
		elif generalName=="张飞":
			if isBloodBattle:
				hasWeapon=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.雌雄双股剑)>0
				generalLevel=10
			else:
				hasWeapon=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.丈八蛇矛)>0
		elif generalName=="无名":
			hasWeapon=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.龙胆亮银枪)>0
			if GameManager.sav.have_event["夏侯偷马"]==true:
				generalLevel=10
		levels=GameManager.get_battle_task_requirement_multiplier(generalLevel, hasWeapon)
		
	for task in tasks:
		var value=floor(task.value*levels)
		var minValue
		if task.res=="coin":
			haveRes=curCoin	
			minValue=int(floor(value*2/3))
		else:
			haveRes=curSoilder		
			minValue=int(floor(value*3/5))
		var sybol=task.symbol
		var iscomplete=false
		if sybol==GameManager.opcost.greater:
			if(haveRes>value):
				iscomplete=true
		elif sybol==GameManager.opcost.less:
			if(haveRes<value and haveRes>minValue):
				iscomplete=true
		elif sybol==GameManager.opcost.equal:
			if(haveRes==value):
				iscomplete=true
		if iscomplete==true:
			if is_mi_boss:
				mi_risk_task_complete=true
			else:
				targetGet=targetGet+ ((task.reward/100.0)*mustHave)
			taskComplete=taskComplete+1

 	

	# 	{"name": "赵云", "level": 1, "max_level": 10, "randominit": -1}
# 判断选择武将的石头剪刀布
#首先获取选择的武将
	#btdatas.sdType
	var type = GameManager.sav.generals.find_key(selectgeneral)
	
	if (btdatas.sdType==GameManager.RspEnum.SCISSORS&&type==GameManager.RspEnum.PAPER) or\
	(btdatas.sdType==GameManager.RspEnum.PAPER&&type==GameManager.RspEnum.ROCK) or\
	(btdatas.sdType==GameManager.RspEnum.ROCK&&type==GameManager.RspEnum.SCISSORS):
		#print("失败"+str(btdatas.reward))
		targetGet=targetGet-((btdatas.reward/100.0)*mustHave)
		 #玩家失败 暂时不扣 免得有bug
	elif btdatas.sdType==type:
		#print("平局")
		pass
		 #平局
	else: 
		targetGet=targetGet+  ((btdatas.reward/100.0)*mustHave)
		taskComplete=taskComplete+1
		#print("获胜")
		#玩家获胜
			
	pass

		
	#可加入每次完成任务，成功率提升10%
	#当玩家的值大于basevalue时，每提升10% 会有5%的提升 上部封顶 但是最多玩家将会获得100%的和平区域 也就是最多为rewardMax
	var levelup= int(floor(curCoin /(btdatas.index)))*2+int(floor(curSoilder/(btdatas.index)))*10+(generalLevel)
	
	var buff_lines:Array[String]=[]
	if GameManager.sav.useItemInBattle==true:
		var itemup=1.4
		if  InventoryManager.has_item(InventoryManagerItem.迷魂木筒):
			itemup=1.5
			buff_lines.append(tr("道具加持+{bonus}%").format({"bonus":50})) #未来要注销
		else:
			buff_lines.append(tr("道具加持+{bonus}%").format({"bonus":40})) #未来要注销
		levelup=levelup*itemup

		#if InventoryManager.has_item()
	var haveWeaponNum=0
	var haveWeaponName=""
	var weaponRate=0
	if selectgeneral==null:
		return 
	if selectgeneral.name=="关羽":
		haveWeaponNum=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.青龙偃月刀)
		haveWeaponName="青龙偃月刀"
		weaponRate=0.08
		if GameManager.sav.isWeaponLevelUP:
			weaponRate=0.18
		#有无青龙偃月刀
		#道具加持xxx
		#显示文本xxx
		pass
	elif selectgeneral.name=="张飞":
		var isBloodBattle=GameManager.sav.have_event["战斗袁术血战模式"]==true and GameManager.sav.have_event["血战袁术完成"]==false
		if not isBloodBattle:
			haveWeaponNum=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.丈八蛇矛)
			haveWeaponName="丈八蛇矛"
			weaponRate=0.06
			if GameManager.sav.isWeaponLevelUP:
				weaponRate=0.16
	elif selectgeneral.name=="无名" and GameManager.sav.have_event["无名之死"]==false:
		#有无龙胆银月枪
		#道具加持xxx
		haveWeaponNum=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.龙胆亮银枪)
		haveWeaponName="龙胆亮银枪"
		weaponRate=0.1
		if GameManager.sav.isWeaponLevelUP:
			weaponRate=0.2

	if haveWeaponNum>0:
		levelup=levelup*(1+weaponRate)
		var weapon_buff_key="{weapon}+{bonus}%【法令已强化】" if GameManager.sav.isWeaponLevelUP else "{weapon}+{bonus}%"
		buff_lines.append(tr(weapon_buff_key).format({
			"weapon":tr(haveWeaponName),
			"bonus":int(round(weaponRate*100))
		}))
		
	if InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.雌雄双股剑)>0:
		buff_lines.append(tr("{weapon}+{bonus}%").format({"weapon":tr("雌雄双股剑"),"bonus":1}))
		levelup=levelup*(1.01)
	#商城系统如果购买了武器，则取消这件装备继续卖出
	#判断选中的武将1 有无装备
	#判断选中的武将2 有无装备
	#判断选中的武将3 有无装备
	if is_mi_boss and mi_risk_task_complete:
		levelup+=GameManager.MI_BOSS_RISK_WIN_RATE_BONUS_PERCENT
		#buff_lines.append(tr("风险行动胜率+{bonus}%").format({"bonus":GameManager.MI_BOSS_RISK_WIN_RATE_BONUS_PERCENT}))
	buff_txt.text="\n".join(buff_lines)
	buff_txt.visible=not buff_lines.is_empty()
	var success_degrees = min(max(levelup * 3.6, 0), 360)
	GameManager.battleCircle[4].radian = success_degrees
	#targetGet=targetGet+levelup
	#if(targetGet>rewardMax):
	#	targetGet=rewardMax
	#看情况开启注释代码
	#封顶
	#当玩家的coin值大于basevalue 每提升10% 会有3%提升
	#print("after"+str(targetGet))
	_changeCircle(targetGet)
		
	pass # Replace with function body.

var curCoin=0
var curSoilder=0

func _processSuccussCircle(coin,soilder):
	curCoin=coin
	curSoilder=soilder
	_juideCompeleteTask()
	pass
	

var battleCircleClone:Array;


func _changeCircle(rewardGet):
	#获取的reward去由高到底转换
	

	battleCircleClone=GameManager.battleCircle.duplicate(true)
	for data in battleCircleClone:
		data.initPos = _normalize_angle(data.initPos)
	
	battleCircleClone[4].radian = clamp(battleCircleClone[4].radian, 0, 360)
	# {"name":"无风险","initPos":0,"radian":90,"index":0},#
	#{"name":"小风险","initPos":0,"radian":90,"index":1},#
	#{"name":"中风险","initPos":0,"radian":90,"index":2},#
	#{"name":"高风险","initPos":0,"radian":90,"index":3},#
	#{"name":"成功率","initPos":-1,"radian":60,"index":4}
	var cost=rewardGet
	
	if(battleCircleClone[0].radian+rewardGet<0):
		rewardGet=0-battleCircleClone[0].radian

	
	for i in range(3,0,-1):
		
		if(cost>battleCircleClone[i].radian):	
			cost=cost-battleCircleClone[i].radian
			battleCircleClone[i].radian=0
			#修复二边初始角度
			
		else:
			battleCircleClone[i].radian=battleCircleClone[i].radian-cost
			cost=0;
			break;	
			
	
	#这玩意不能改动，有二个方法
	battleCircleClone[0].radian=battleCircleClone[0].radian+rewardGet
	
	
	

	#从起始initindex开始围绕一圈
	var initindex=battleCircleClone[0].index
	var nextInitIndex
	
	var calradian=0
	#下面逻辑会导致旋转图出现混乱，并且没有做保护措施
	if battleCircleClone[0].radian>0:
		calradian=battleCircleClone[0].radian
	if calradian<0:
		calradian=0
	if(initindex+1>3):
		nextInitIndex=0
	else:
		nextInitIndex=initindex+1
	while(nextInitIndex!=initindex):
		var e
		for i in range(battleCircleClone.size()):
			if battleCircleClone[i].index==nextInitIndex:
				e=battleCircleClone[i]
				break
		#有bug待修复

		#此处不能用加法
		e.initPos = _normalize_angle(battleCircleClone[0].initPos - calradian)
		if e.radian>0:
			calradian=calradian+e.radian
		
		if(nextInitIndex+1>3):
			nextInitIndex=0
		else:
			nextInitIndex=nextInitIndex+1
		
	var success_rate: float = clamp(battleCircleClone[4].radian, 0, 360) / 360.0

# 2. 转换为百分比并保留0位小数（如0.8 → 80%）
	var success_rate_percent: int = min(int(success_rate * 100 + 0.5), 100)

# 3. 拼接成目标文本格式（假设文本节点名为 "SuccessRateText"）
	
	#if canchange==true:
	suss_label.text =tr("胜率:%d%%") % success_rate_percent	

	refresh()



	
func refresh():
	
	for i in range(0,4):
		var btdata=battleCircleClone[i]
		datas[i].radial_initial_angle=btdata.initPos
		datas[i].radial_fill_degrees=btdata.radian
		self["point_"+str(i+1)].radial_initial_angle=btdata.initPos
		
	#初始化玩家坐标系
	datas[4].radial_initial_angle=battleCircleClone[4].initPos
	datas[4].radial_fill_degrees=battleCircleClone[4].radian
	#玩家坐标只会受到二个影响 一个是coin 一个是soilder
	

var isBoot:bool=false
var _extraTaskCountedThisRound:bool=false
var _active_general = null

func changeHead(value):
	enemy.headImg=value
	TooltipManager.register_tooltip(enemy.head,tr(enemyName)+"\n"+tr(GameManager.enemyDesc[enemyName]))

func lauchProgress(hp) -> bool:
	if isBoot or selectgeneral == null:
		return false
	_active_general=selectgeneral
	_extraTaskCountedThisRound=false
	isBoot=true
	suss_label.text=""
	_hp=hp
	_on_SpinButton_pressed()
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.



# 定义转盘的半径和奖品数量
const RADIUS = 200
const PRIZE_COUNT =5

# 定义转盘的中心点
const CENTER = Vector2(0, 0)

# 定义旋转动画的持续时间
const ROTATION_DURATION = 5

var stop_angle

var _hp
func _on_SpinButton_pressed():
	# 开始旋转动画
	$PointerScifiB.show()
	var tween = get_tree().create_tween()
	#add_child(tween)
	#tween.interpolate_property(self, "rotation_degrees", 360 * ROTATION_DURATION, ROTATION_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.start()
	stop_angle = randf_range(0, 360)
	#current_state=battleStete.all
	#switchStete()
	for data in battleCircleClone:
		if data.radian > 0:
			data.initPos = _normalize_angle(data.initPos)

	tween.tween_property($PointerScifiB, "rotation_degrees", 360 * ROTATION_DURATION + stop_angle, 2)


	tween.tween_callback(_on_Tween_tween_all_completed)
	
	
# 在旋转动画开始之前生成一个随机角度


# 实例化四张石头剪刀布图片
func _initBattleTypePng(index,type):
	if(type==GameManager.RspEnum.PAPER):
		find_child("ColorRect_"+str(index)).get_child(0).texture=bu
	elif type== GameManager.RspEnum.ROCK:
		find_child("ColorRect_"+str(index)).get_child(0).texture=shitou
	else:
		find_child("ColorRect_"+str(index)).get_child(0).texture=jiandao
	#this["ColorRect_0"].hidden()$ColorRect_0
	pass


func _on_Tween_tween_all_completed():
	await get_tree().create_timer(0.1).timeout   # 建议等一小会儿再取最终角度，更稳
	$PointerScifiB.rotation_degrees = _normalize_angle(stop_angle)
	var real_angle = _normalize_angle(stop_angle - 45) #减去图片偏差的45度
	var issuccess = false
	var selectPart = null
	for data in battleCircleClone:
		if data.radian > 0:
			var lowerValue = _normalize_angle(data.initPos - data.radian)
			var upperValue = _normalize_angle(data.initPos)
			if _is_angle_in_sector(real_angle, lowerValue, upperValue):
				if data.name == "成功率":
					issuccess = true
				elif selectPart == null:
					selectPart = data.name
	if GameManager.currenceScene.battle_pane._mode == SceneManager.bossMode.none:
		GameManager.sav.hp = GameManager.sav.hp - _hp
	await control.play_battle_result_feedback(selectPart, issuccess)
	settleGame(selectPart, issuccess, _active_general)
	_active_general=null
	#将风险值和成功率一起输入
	#print(real_angle)
	isBoot=false
	#check_button.show()
	# 计算停止位置
	
	#
		#{"name":"无风险","initPos":0,"radian":90,"index":0},
	#{"name":"小风险","initPos":0,"radian":90,"index":1},
	#{"name":"中风险","initPos":0,"radian":90,"index":2},
	#{"name":"高风险","initPos":0,"radian":90,"index":3},
	#{"name":"成功率


var buffMultiple=1
var finalScore
const yanwuchang = preload("res://dialogues/演武场.dialogue")

func settleGame(end,issuccess,general):
	if general == null:
		push_error("Battle settlement blocked because no general was captured at launch")
		return
	var _wasUsingItem = GameManager.sav.useItemInBattle
	#扣除消耗 只会消耗士兵
	#无风险 无扣除
	#小风险 扣除10-20%
	#中风险 扣除30-40%
	#高风险 扣除50-100%
	#如果道具用完，则改成不用道具
	
	#暂时迁移过来一个，另外二个保留在下面，防止有啥bug
	if GameManager.sav.useItemInBattle==true:
		InventoryManager._remove_item(GameManager.inventoryPackege,InventoryManagerItem.胜战锦囊,1)
		var resideCount=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.胜战锦囊)
		if InventoryManager.has_item(InventoryManagerItem.迷魂木筒):
			AchievementManager.set_achievement("NEW_ACHIEVEMENT_1_2")
		if resideCount<=0:
			GameManager.sav.useItemInBattle=false
			GameManager.currenceScene.battle_pane.check_box.toggle_mode=false

	var cost=10000
	var percentage=0
	if end =="无风险":
		cost=0
		percentage=0
	elif end=="小风险":
		percentage=randi_range(10,30)
		pass
	elif end=="中风险":
		percentage=randi_range(30,70)
		pass
	elif end=="高风险":
		percentage=randi_range(70,100)
		pass
	if cost!=0:
		cost= int(floor(curSoilder*percentage)/100)
	#删除cost
	GameManager.sav.coin=GameManager.sav.coin-curCoin
	GameManager.sav.labor_force=GameManager.sav.labor_force-cost

	var _rewardPanel:rewardPanel=PanelManager.new_reward()
	_rewardPanel.coinCost=curCoin
	var sussusss= battleCircleClone[4]
	print(GameManager.sav.useItemInBattle)
	_rewardPanel.soilderCost=cost
	if GameManager.sav.targetResType==GameManager.ResType.stayFight and GameManager.currenceScene.battle_pane._mode==SceneManager.bossMode.none:
			GameManager.sav.currenceValue=GameManager.sav.currenceValue+1
			
			#if GameManager.sav.currenceValue==22:
			#	DialogueManager.show_example_dialogue_balloon(yanwuchang,"破解克苏鲁")	#这个会被拦截，如果触发了这个就不能触发失去民心，或者把这个丢到battle里
	if issuccess==true:
		GameManager.sav.battleResults[taskIndex]=GameManager.BattleResult.win
		print("你win了")
		if GameManager.sav.targetResType==GameManager.ResType.battle and GameManager.currenceScene.battle_pane._mode==SceneManager.bossMode.none:
			GameManager.sav.currenceValue=GameManager.sav.currenceValue+1
			
			

			
		#判断胜利积分
		var enemyPower=GameManager.sav.battleTasks[taskIndex].index*50
		
		
		finalScore=GameManager.calculate_points(enemyPower,taskComplete, percentage/100,general.level,buffMultiple)
		finalScore=finalScore*(0.6+(GameManager.sav.battleEnhance*0.25))
		if GameManager.sav.have_event["吕布之怒"]==false and GameManager.sav.have_event["夏侯偷马"]==true and GameManager.sav.endPath==GameManager.endPath.xiaopei:
			finalScore=finalScore*1.5
		if GameManager.sav.have_event["战斗袁术血战模式"]==true and GameManager.sav.have_event["血战袁术完成"]==false:
			finalScore=finalScore*0.3
		var items=GameManager.ScoreToItem(finalScore)
		if GameManager.sav.have_event["吕布之怒"]==false and GameManager.sav.have_event["夏侯偷马"]==true and GameManager.sav.endPath==GameManager.endPath.xiaopei:
			_rewardPanel.showRewardMa(items)
		else:
			_rewardPanel.showReward(items)
		#一旦完成target的数量，就令其获胜，来到府邸进行下一步操作
		GameManager.sav.completeTask=GameManager.sav.completeTask+1
		
		GameManager.sav.ctLoseBattle=0
		if GameManager.sav.ctLoseBattleRate>0:
			GameManager.sav.ctLoseBattleRate=GameManager.sav.ctLoseBattleRate-1
		
	else:
		
		
		GameManager.sav.battleResults[taskIndex]=GameManager.BattleResult.fail
		print("你输了")
		if GameManager.currenceScene.battle_pane._mode==SceneManager.bossMode.zhenren:
			
			
			var clickAfter=func():
				$"..".hide()
			
				DialogueManager.show_example_dialogue_balloon(yanwuchang,"战斗失败_真人")	
			SignalManager.endReward.connect(clickAfter)
			#GameManager.bossmoderesult=false


		_rewardPanel.fail()
		judgeLoseSentiment()

	GameManager.improveFinalPhase(2 if issuccess else 1, true)
	# === 统一额外任务计数 ===
	if not _extraTaskCountedThisRound and GameManager.currenceScene.battle_pane._mode == SceneManager.bossMode.none:
		var _counted = false
		match GameManager.sav.extraBattleTaskEnum:
			SceneManager.etraTaskType.useItem:
				if _wasUsingItem:
					GameManager.sav.extraCureenTaskCNum += 1
					_counted = true
			SceneManager.etraTaskType.costMoney:
				GameManager.sav.extraCureenTaskCNum += _rewardPanel.coinCost
				_counted = true
			SceneManager.etraTaskType.dontLoseGame:
				if sussusss.radian >= 360:
					GameManager.sav.extraCureenTaskCNum += 1
					_counted = true
			SceneManager.etraTaskType.loseGame:
				if not issuccess:
					GameManager.sav.extraCureenTaskCNum += 1
					_counted = true
		if _counted:
			_extraTaskCountedThisRound = true
			refreshHideBattleTask()

	#bug 开始修改这里的问题
	curCoin=0
	curSoilder=0

	GameManager.sav.currenceTask=GameManager.sav.currenceTask+1
	
	GameManager.sav.UseGeneral.push_front(general)
	taskIndex=taskIndex+1
	
	if(taskIndex>=3):
		GameManager.initBattleCircle()
		taskIndex=0
	Txtcount.text=str(GameManager.sav.completeTask)+"/"+str(GameManager.sav.currenceTask-GameManager.sav.completeTask)+"/"+str(GameManager.sav.currenceTask)
	refreshPage()

func getWinCount()->int:
	var win_count = GameManager.sav.battleResults.count(GameManager.BattleResult.win)
	return win_count


func judgeLoseSentiment():
	var loseNum=GameManager.sav.currenceTask-GameManager.sav.completeTask
	var allNum=GameManager.sav.currenceTask
	
	GameManager.sav.ctLoseBattle+=1	
	GameManager.sav.ctLoseBattleRate=GameManager.sav.ctLoseBattleRate+1	
	if(loseNum)>=10 and (loseNum)>allNum/2 and GameManager.sav.have_event["军事行动大败"]==false and GameManager.currenceScene.battle_pane._mode==SceneManager.bossMode.none:
		#需要加入事件 有且仅能触发一次
		
		
		GameManager.sav.have_event["军事行动大败"]=true
		if GameManager.sav.gameDifficulty==1:
			GameManager.resideValue=15
		elif GameManager.sav.gameDifficulty==2:
			GameManager.resideValue=20
		elif GameManager.sav.gameDifficulty==3:
			GameManager.resideValue=25
		
		if GameManager.sav.have_event["战斗袁术血战模式"]==true and GameManager.sav.have_event["血战袁术完成"]==false:
			DialogueManager.show_example_dialogue_balloon(yanwuchang,"血战大败")
		else:
			DialogueManager.show_example_dialogue_balloon(yanwuchang,"大败")	
		#return
		#pass#大败 可以在sav加入一次
	elif loseNum>=8 and loseNum>allNum/2 and GameManager.sav.have_event["军事行动大败提示"]==false and GameManager.currenceScene.battle_pane._mode==SceneManager.bossMode.none:
		#需要加入事件 有且仅能触发一次
		GameManager.sav.have_event["军事行动大败提示"]=true
		if GameManager.sav.have_event["战斗袁术血战模式"]==true and GameManager.sav.have_event["血战袁术完成"]==false:
			DialogueManager.show_example_dialogue_balloon(yanwuchang,"血战大败提示")
		else:
			DialogueManager.show_example_dialogue_balloon(yanwuchang,"大败提示")	
	

	

	elif GameManager.sav.ctLoseBattle>=3 and GameManager.currenceScene.battle_pane._mode==SceneManager.bossMode.none:
		

		if GameManager.sav.gameDifficulty==1:
			GameManager.resideValue=10
		elif GameManager.sav.gameDifficulty==2:
			GameManager.resideValue=15
		elif GameManager.sav.gameDifficulty==3:
			GameManager.resideValue=15
		
		if GameManager.sav.have_event["战斗袁术血战模式"]==true and GameManager.sav.have_event["血战袁术完成"]==false:
			DialogueManager.show_example_dialogue_balloon(yanwuchang,"血战连续多次败北")
		else:
			DialogueManager.show_example_dialogue_balloon(yanwuchang,"连续多次败北")	
		#连续多日怠惰
	elif GameManager.currenceScene.battle_pane._mode==SceneManager.bossMode.none:
		
		if GameManager.sav.gameDifficulty==1:
			GameManager.resideValue=5
		elif GameManager.sav.gameDifficulty==2:
			GameManager.resideValue=10
		elif GameManager.sav.gameDifficulty==3:
			GameManager.resideValue=10

		var lazyRan=0.1*GameManager.sav.ctLoseBattleRate
		var random_value = randf()  # 生成0.0到1.0的随机数
		if random_value <= lazyRan:
			if GameManager.sav.have_event["战斗袁术血战模式"]==true and GameManager.sav.have_event["血战袁术完成"]==false:
				DialogueManager.show_example_dialogue_balloon(yanwuchang,"血战一次败北引发民愤")
			else:
				DialogueManager.show_example_dialogue_balloon(yanwuchang,"一次败北引发民愤")
				#怠惰概率 1次 10% 	
		
	#后面加入一些判断胜利次数的
	
@onready var Txtcount = $count


func refreshPage():
	var index
	if taskIndex==-1:
		index=0
	else:
		index=taskIndex
	
	enemy.namelv=tr("(当前战力:{targetValue})").format({"targetValue": GameManager.sav.battleTasks[index].index*50}) 
	#可以刷新头像和技能 包括点击项
	
	var btresult= GameManager.BattleResult

	var sd=GameManager.sav.battleTasks[index].sdType
	_initBattleTypePng(0,sd)
	_refreshBattleTypePreview()

	var txt
	for i in range(0,GameManager.sav.battleResults.size()):
		var _ColorRect=find_child("ColorRect_"+str(i+1))
		var tag:TextureRect=_ColorRect.get_node("tag")
	
		if(GameManager.sav.battleResults[i]==btresult.win):
			txt=Success
		elif (GameManager.sav.battleResults[i]==btresult.fail):
			txt=fail
		elif (GameManager.sav.battleResults[i]==btresult.none):
			tag.hide()
			continue
		tag.show()
	
		tag.texture=txt
	
		pass
	#将下面的结果和石头剪刀布都进行修改
	# 显示结果
#定义一个枚举，然后显示当前win还是false
#得保存
func getTaskIndex():
	var index=0
	var btresult= GameManager.BattleResult
	for i in range(0,GameManager.sav.battleResults.size()):
		var _ColorRect=find_child("ColorRect_"+str(i+1))
	
	

		if (GameManager.sav.battleResults[i]!=btresult.none):
			index+=1
	if index>2:
		index=0		
	return index		
	
@onready var battlepanel: battlePanel = $".."


@onready var se_task_hbox: HBoxContainer = $taskHbox


func refreshHideBattleTask():
	if GameManager.sav.extraBattleTaskEnum==SceneManager.etraTaskType.none or battlepanel._mode!=SceneManager.bossMode.none:
		se_task_hbox.hide()
	else:
		se_task_hbox.show()
		for i in range(0,3):
			var ic:TextureRect=se_task_hbox.get_child(i)
			var number_map = {1: 3, 2: 2, 3: 1}  # 定义替换规则
			if(GameManager.sav.extraCureenTaskCNum>=float(GameManager.sav.extraBattleTaskTargetNum)/float(number_map[i+1])):
				if GameManager.sav.extraBattleTaskEnum==SceneManager.etraTaskType.costMoney or GameManager.sav.extraBattleTaskEnum==SceneManager.etraTaskType.loseGame or GameManager.sav.extraBattleTaskEnum==SceneManager.etraTaskType.useItem:
					ic.modulate=Color.GREEN
				elif GameManager.sav.extraBattleTaskEnum==SceneManager.etraTaskType.dontLoseGame:
					ic.modulate=Color.RED
			else:
				ic.modulate=Color.WHITE
		pass
		
		
func refreshTempHideBattleTask():
	if GameManager.sav.extraBattleTaskEnum==SceneManager.etraTaskType.none or battlepanel._mode!=SceneManager.bossMode.none:
		se_task_hbox.hide()
	else:
		se_task_hbox.show()
		for i in range(0,3):
			var ic:TextureRect=se_task_hbox.get_child(i)
			var number_map = {1: 3, 2: 2, 3: 1}  # 定义替换规则
			if(GameManager.sav.extraCureenTaskCNum>=float(GameManager.sav.extraBattleTaskTargetNum)/float(number_map[i+1])):
				if GameManager.sav.extraBattleTaskEnum==SceneManager.etraTaskType.costMoney or GameManager.sav.extraBattleTaskEnum==SceneManager.etraTaskType.loseGame or GameManager.sav.extraBattleTaskEnum==SceneManager.etraTaskType.useItem:
					ic.modulate=Color.GREEN
				elif GameManager.sav.extraBattleTaskEnum==SceneManager.etraTaskType.dontLoseGame:
					ic.modulate=Color.RED
			else:
				
				
				if(GameManager.sav.extraCureenTaskCNum+GameManager.currenceScene.battle_pane.costcoin>=float(GameManager.sav.extraBattleTaskTargetNum)/float(number_map[i+1])):
					if GameManager.sav.extraBattleTaskEnum==SceneManager.etraTaskType.costMoney or GameManager.sav.extraBattleTaskEnum==SceneManager.etraTaskType.loseGame:
						if(ic.modulate!=Color.YELLOW):
							ic.modulate=Color.YELLOW
							#叮
				else:
					ic.modulate=Color.WHITE
		pass				
#var current_state:battleStete=battleStete.all

#func _on_Switch_button_down() -> void:
	#if isBoot==true:
		#return
		#
	#var state_list: Array = battleStete.values()
	## 找到当前状态的索引
	#var current_index: int = state_list.find(current_state)
	#
	## 计算下一个索引（最后一个索引则回到0）
	#var next_index: int = (current_index + 1) % state_list.size()
	## 更新当前状态
	#current_state = state_list[next_index]
	#switchStete()
	# 可选：打印当前状态，方便调试
	#print("当前切换状态：", battleStete.keys()[next_index])
#@onready var state_label: Label = $stateLabel


@onready var rect_no: ColorRect = $"VBoxContainer/无风险"
@onready var rect_low: ColorRect = $"VBoxContainer/低风险"
@onready var rect_low2: ColorRect = $"VBoxContainer/低风险2"
@onready var rect_low3: ColorRect = $"VBoxContainer/低风险3"
@onready var rect_suss: ColorRect = $"VBoxContainer/成功率"
@onready var suss_label: Label = $sussLabel

@onready var background_player: TextureProgressBar = $"background-player"


#var canchange=false
#func switchStete():
	#
	## 这里可以添加切换状态后的逻辑（比如更新扇形图显示）
	#match current_state:
		#battleStete.all:
			#canchange=false
			#
			## 显示全维度战情图的逻辑
			#datas[0].show()
			#datas[1].show()
			#datas[2].show()
			#datas[3].show()
			#datas[4].show()
			##background_player.show()
			#rect_suss.show()
			#rect_no.show()
			#rect_low.show()
			#rect_low2.show()
			#rect_low3.show()			
			#suss_label.text=tr("战情全图")
			#point_1.show()
			#point_2.show()
			#point_3.show()
			#point_4.show()
			##suss_label.hide()
		#battleStete.victory:
			#canchange=true
			## 显示成功率图的逻辑
			#rect_suss.show()
			##suss_label.show()
			#background_player.show()
			#rect_no.hide()
			#rect_low.hide()
			#rect_low2.hide()
			#rect_low3.hide()
			#datas[0].hide()
			#datas[1].hide()
			#datas[2].hide()
			#datas[3].hide()
			#point_1.hide()
			#point_2.hide()
			#point_3.hide()
			#point_4.hide()			
			#
			#datas[4].show()
			#
			#suss_label.text=tr("征战胜算图")
		#battleStete.damage:
			#canchange=false
			## 显示伤亡率图的逻辑
			#rect_suss.hide()
			#datas[0].show()
			#datas[1].show()
			#datas[2].show()
			#datas[3].show()
			#datas[4].hide()			
			#background_player.hide()
			#rect_no.show()
			#rect_low.show()
			#rect_low2.show()
			#rect_low3.show()		
			#
			#point_1.show()
			#point_2.show()
			#point_3.show()
			#point_4.show()			
			#suss_label.text=tr("折损态势图")

enum battleStete{
	all,
	victory,
	damage
}
