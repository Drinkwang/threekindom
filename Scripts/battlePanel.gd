
extends Control
class_name battlePanel
@onready var battle_circle:DiskInBattle = $battleCircle

@onready var soild_num = $soildNum
@onready var coin_num = $coinNum



@onready var coin_slider = $coinSlider
@onready var soild_slider = $soildSlider
@onready var control_3 = $Control_3
@onready var control_2 = $Control_2
@onready var control_1 = $Control_1

@onready var point_group = $pointGroup

@onready var guild_1 = $"pointGroup/1"
@onready var guild_2 = $"pointGroup/2"
@onready var guild_3 = $"pointGroup/3"
@onready var rect_1: ColorRect = $sliderRect
@onready var rect_2: ColorRect = $fengxianRect
@onready var rect_3: ColorRect = $currenceRect
@onready var rect_4: ColorRect = $nextRect


#@onready var guild_4 = $"pointGroup/4"
#@onready var guild_5 = $"pointGroup/5"
#@onready var guild_6 = $"pointGroup/6"
#@onready var guild_7 = $"pointGroup/7"
#@onready var guild_8 = $"pointGroup/8"


@onready var sliderlabel_1 = $sliderlabel1
@onready var sliderlabel_2 = $sliderlabel2
@onready var title = $PanelContainer/orderPanel/VBoxContainer/Label2

@onready var select_detail = $PanelContainer/orderPanel/VBoxContainer/selectDetail

var costhp=30
# Called when the node enters the scene tree for the first time.
func _ready():
	_refreshSlider()
	_refreshGeneral()
	initTask()
	SignalManager.endReward.connect(endBattle)
	battle_circle.isBoot=false

	changeLanguage()

	SignalManager.changeLanguage.connect(changeLanguage)			
	
	SignalManager.initBattle.connect(refreshData)
	

const NOT_JAM_UI_CONDENSED_16 = preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")

func refreshData():
	
	_refreshSlider()
	_refreshGeneral()
	initTask()	
	battle_circle.refreshPage()
	
	

func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	#if currencelanguage=="ru":
		#sliderlabel_1.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		#sliderlabel_2.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		#select_detail.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		#title.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
	#else:
		#sliderlabel_1.remove_theme_font_override("font")
		#sliderlabel_2.remove_theme_font_override("font")
		#select_detail.remove_theme_font_override("font")
		#title.remove_theme_font_override("font")
#可能会删除
	if GameManager.sav.battleEnhance!=0:
		var battleEnhance=GameManager.sav.battleEnhance
		var EnhanceContext=tr("[法令提升了战利品收益{profit}%]").format({"profit":battleEnhance*15})
		TooltipManager.register_tooltip(lauchBtn,EnhanceContext)
		
		
		

	var _item_db=InventoryManager.get_item_db(InventoryManagerItem.胜战锦囊)
	var properties:Array=_item_db.properties

		
	var detail=properties.filter(func(a):return a["name"]=="detail")[0]
	var _context
	if tr(detail["value"]).length()>0:
					
		_context=tr(_item_db.name)+":"+tr(detail["value"])

					

					
	if InventoryManager.has_item(InventoryManagerItem.迷魂木筒):
		_context = _context.replace("40", "50") 
		_context=_context+tr("【已强化】")
		
	TooltipManager.register_tooltip(useItemPanel,_context)	

		
func initData():
	battle_circle.refreshPage()
	if GameManager._setting.showMilitartInput==true:
		line_edit_coin.show()
		line_edit_soilder.show()
	else:
		line_edit_coin.hide()
		line_edit_soilder.hide()				
func endBattle():
	if self.visible==false:
		return
		
	battle_circle.selectgeneral=null
	soild_slider.value=0
	coin_slider.value=0
	_refreshSlider()
	initTask()
	_refreshGeneral()
	#刷新界面
	var bossMode=scenemanager.bossMode
	if battle_circle.taskIndex==2:
		if _mode==bossMode.tao:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"真相揭露_陶谦")
		elif  _mode==bossMode.mi:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"真相揭露_血姬")
		elif _mode==bossMode.huang:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"真相揭露_镇魂龙")
	elif battle_circle.taskIndex==0:
		battle_circle.taskIndex=-1
		var wincount=battle_circle.getWinCount()
		if wincount>=3:
			if _mode==bossMode.tao:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗胜利_陶谦")
			elif  _mode==bossMode.mi:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗胜利_血姬")
			elif _mode==bossMode.huang:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗胜利_镇魂龙")
			elif _mode==bossMode.zhenren:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗胜利_真人")	
		else:
			if _mode==bossMode.tao:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗失败_陶谦")
			elif  _mode==bossMode.mi:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗失败_血姬")
			elif  _mode==bossMode.huang:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗失败_镇魂龙")		
@onready var useItemPanel = $PanelContainer/orderPanel/VBoxContainer/HBoxContainer2/TextureButton
@onready var label = $PanelContainer/orderPanel/VBoxContainer/HBoxContainer2/TextureButton/CheckBox/Label


@onready var check_box: CheckBox = $PanelContainer/orderPanel/VBoxContainer/HBoxContainer2/TextureButton/CheckBox


func refreshUseItemPanel():
	var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.胜战锦囊)

	if num>0:
		useItemPanel.show()
		var context=tr("_battleUseItem").format({"_num":num})
		
		if InventoryManager.has_item(InventoryManagerItem.益气丸):
			context = context.replace("40", "50") 
		label.text=context
		if GameManager.sav.useItemInBattle:
			check_box.button_pressed=true
	else:
		useItemPanel.hide()
	

func _refreshGeneral():
	refreshUseItemPanel()
	control_1.updateContext(0)
	control_2.updateContext(1)	
	control_3.updateContext(2)	
	if GameManager.sav.UseGeneral.size()>0:
		for ele in GameManager.sav.UseGeneral:
			#var index=GameManager.sav.generals.values().find(ele)
			#var value=GameManager.sav.generals.values().filter(func(a):a.name==ele.name)[0]
			var key=GameManager.sav.generals.find_key(ele)
			#改成不一定是index,index是乱序的
			for i in range(1,4):
				var soider:SoilderItem=self.find_child("Control_"+str(i))
				if soider.repImg==key:
					soider.Use()
					break
			#var finde:SoilderItem=self.find_child("Control_"+str(index+1)) as SoilderItem
			#finde.Use()
	else:
		for i in range(1,4):
			var soider:SoilderItem=self.find_child("Control_"+str(i))

			soider.alreadyUse=false	
			soider.updateContext(i-1)

#
#将任务给创建出来
#将当前石头剪刀布 和战力给创建出来

@onready var lauchBtn = $PanelContainer/orderPanel/VBoxContainer/HBoxContainer/Button

func _refreshSlider():
	
	
	soild_slider.max_value=GameManager.sav.labor_force
	coin_slider.max_value=GameManager.sav.coin
	if GameManager.sav.labor_force<0 or _mode==SceneManager.bossMode.mi:
		soild_slider.editable=false

	else:
		soild_slider.editable=true
	if GameManager.sav.coin<0 or _mode==SceneManager.bossMode.tao: 
		coin_slider.editable=false
	else:
		coin_slider.editable=true
	if battle_circle.selectgeneral==null:
		lauchBtn.disabled=true
		soild_slider.editable=false
		coin_slider.editable=false	
	else:
		lauchBtn.disabled=false	
@onready var task_label = $TaskLabel

func initTask():
	refreshTask(false)

func refreshTask(checkSlider:bool=true):
	if battle_circle.taskIndex<0 or GameManager.sav.battleTasks==null or GameManager.sav.battleTasks.size()<=0:
		return

	var levels=1

	if battle_circle.selectgeneral!=null:
		var generalLevel=battle_circle.selectgeneral.level
		var generalName=battle_circle.selectgeneral.name
		var isBloodBattle=GameManager.sav.have_event["战斗袁术血战模式"]==true and GameManager.sav.have_event["血战袁术完成"]==false
		var hasWeapon=false
		if generalName=="关羽":
			hasWeapon=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.青龙偃月刀)>0
		elif generalName=="张飞":
			if isBloodBattle:
				generalLevel=10
				hasWeapon=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.雌雄双股剑)>0
			else:
				hasWeapon=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.丈八蛇矛)>0
		elif generalName=="无名":
			hasWeapon=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.龙胆亮银枪)>0

		levels=1.0889-(0.0889*generalLevel)
		if hasWeapon:
			levels=levels*0.7

	var currence= GameManager.sav.battleTasks[battle_circle.taskIndex]
	var context=tr("战术目标：")
	var index=1;
	var taskcontext=""
	var targetValue
	var haveRes:int
	var minValue:int
	var isCompleted:bool
	var bossMode=scenemanager.bossMode

	for task in currence.task:
		targetValue=floor(task.value*levels)
		isCompleted=false
		var taskAdded=false

		# ——— 资金类任务 ———
		if task.res=="coin" and _mode!=bossMode.tao:
			taskcontext="\n"+str(index)
			haveRes=costcoin
			minValue=int(floor(targetValue*2/3))
			taskAdded=true

			if task.symbol==GameManager.opcost.greater:
				isCompleted=haveRes>targetValue
				if _mode==bossMode.mi:
					taskcontext+=tr(".血金祭坛:")+tr("(资金超过{targetValue})").format({"targetValue": targetValue})
				else:
					taskcontext+=tr(".工程战:")+tr("(资金超过{targetValue})").format({"targetValue": targetValue})
			elif task.symbol==GameManager.opcost.equal:
				isCompleted=haveRes==targetValue
				if _mode==bossMode.mi:
					taskcontext+=tr(".血金秘术:")+tr("(资金等于{targetValue})").format({"targetValue": targetValue})
				else:
					taskcontext+=tr(".特种战:")+tr("(资金等于{targetValue})").format({"targetValue": targetValue})
			elif task.symbol==GameManager.opcost.less:
				isCompleted=haveRes<targetValue and haveRes>minValue
				if _mode==bossMode.mi:
					taskcontext+=tr(".商贾幻影:")+tr("(资金小于{targetValue} 但大于{targetValue2})").format({"targetValue": targetValue,"targetValue2":minValue})
				else:
					taskcontext+=tr(".游击战:")+tr("(资金小于{targetValue} 但大于{targetValue2})").format({"targetValue": targetValue,"targetValue2":minValue})

		# ——— 兵力类任务 ———
		if task.res=="human" and _mode!=bossMode.mi:
			taskcontext="\n"+str(index)
			haveRes=costsoild
			minValue=int(floor(targetValue*3/5))
			taskAdded=true

			if task.symbol==GameManager.opcost.greater:
				isCompleted=haveRes>targetValue
				if _mode==bossMode.tao:
					taskcontext+=tr(".尸皇怒吼:")+tr("(兵力超过{targetValue})").format({"targetValue": targetValue})
				else:
					taskcontext+=tr(".遭遇战:")+tr("(兵力超过{targetValue})").format({"targetValue": targetValue})
			elif task.symbol==GameManager.opcost.equal:
				isCompleted=haveRes==targetValue
				if _mode==bossMode.tao:
					taskcontext+=tr(".怨魂诡阵:")+tr("(兵力等于{targetValue})").format({"targetValue": targetValue})
				else:
					taskcontext+=tr(".奇兵任务:")+tr("(兵力等于{targetValue})").format({"targetValue": targetValue})
			elif task.symbol==GameManager.opcost.less:
				isCompleted=haveRes<targetValue and haveRes>minValue
				if _mode==bossMode.tao:
					taskcontext+=tr(".冥界壁垒:")+tr("(兵力小于{targetValue} 但大于{targetValue2})").format({"targetValue": targetValue,"targetValue2":minValue})
				else:
					taskcontext+=tr(".防守战:")+tr("(兵力小于{targetValue} 但大于{targetValue2})").format({"targetValue": targetValue,"targetValue2":minValue})

		if not taskAdded:
			continue
		# 标记已达成
		if checkSlider and isCompleted:
			taskcontext+=tr("【已达成，伤亡降低】")

		context+=taskcontext
		index+=1

	if currence.task.size()==0:
		task_label.text=context+tr("无")
	elif index==1:
		task_label.text=context+tr("无")
	else:
		task_label.text=context
	if TooltipManager and TooltipManager.has_method("register_tooltip"):
		TooltipManager.register_tooltip(task_label,tr("武将等级与专属武器，可降低战术目标物资损耗"))
		# 下一帧让 PanelContainer 自适应 TaskLabel 高度
		call_deferred("_fit_task_label_height")

func _fit_task_label_height():
		# TaskLabel 实际渲染高度减去基准144，只增加超出部分
		var extra = max(0, task_label.size.y - 144)
		var spacer = $PanelContainer/orderPanel/VBoxContainer/TaskSpacer
		if spacer:
			spacer.custom_minimum_size.y = extra
		$PanelContainer.offset_bottom = 411 + extra
# Called every frame. 'delta' is the elapsed time since the previous frame.
var _cursor_in_rect:bool=false

func _process(_delta):
	if self.visible==true:
		var mouse_pos = get_global_mouse_position()
		var rect = Rect2(373, 504, 596, 104)
		if rect.has_point(mouse_pos):
			if not _cursor_in_rect:
				_cursor_in_rect=true
				GameManager.restore_system_cursor()
		else:
			if _cursor_in_rect:
				_cursor_in_rect=false
				GameManager.apply_game_cursor()


func _changeProgress():

	battle_circle._processSuccussCircle(costcoin,costsoild)
	pass

var costcoin:int
var costsoild:int

func _soilderNum_changed(value):
	if battle_circle.isBoot==true:
		return

	#costsoild=(GameManager.sav.labor_force*value/100)
	costsoild=value

	soild_num.set_text(str(costsoild))  #报错没有找到 先屏蔽，后续开启
	if(battle_circle.selectgeneral):
		_changeProgress()
		refreshTask(true)


func _on_coin_slider_value_changed(value):
	if battle_circle.isBoot==true:
		return
	#costcoin=(GameManager.sav.coin*value/100)
	costcoin=value
	coin_num.text=str(costcoin)
	if GameManager.sav.extraBattleTaskEnum!=SceneManager.etraTaskType.none:
		battle_circle.refreshTempHideBattleTask()
	if(battle_circle.selectgeneral):
		_changeProgress()
		refreshTask(true)

var selectIndex
#BOOT结算完后将对应的general转换成use 然后同时也结算
#{"name": "关羽", "level": 1, "max_level": 10, "randominit": -1}
func _on_control_3_gui_input(event):

	if battle_circle.isBoot==true||control_3.canSelect==false||control_3.alreadyUse==true or(GameManager.sav.have_event["无名之死"]==true and GameManager.sav.have_event["夏侯偷马"]==false):
		return	
	
	if(event is InputEventMouseButton and event.button_index==1 or istour==true):	
		SoundManager.play_sound(sounds.CLICKHERO)		
		control_3.check_box.button_pressed=true
		control_2.check_box.button_pressed=false
		control_1.check_box.button_pressed=false
		selectIndex=3
		battle_circle.selectgeneral= GameManager.sav.generals[control_3.repImg]
		battle_circle._juideCompeleteTask()
		_refreshSlider()
		previewHpdone()
		refreshTask(true)
	#取消其它的选中状态
	#给当前标记为选中
	#将选中将领具体信息发送给disk	
	pass # Replace with function body.


func _on_control_2_gui_input(event):

	if battle_circle.isBoot==true||control_2.canSelect==false||control_2.alreadyUse==true:
		return	
	if(event is InputEventMouseButton and event.button_index==1 or istour==true):	
		SoundManager.play_sound(sounds.CLICKHERO)
		control_1.check_box.button_pressed=false
		control_2.check_box.button_pressed=true
		control_3.check_box.button_pressed=false
		selectIndex=2
		battle_circle.selectgeneral= GameManager.sav.generals[control_2.repImg]
		battle_circle._juideCompeleteTask() 
		_refreshSlider()
		previewHpdone()
		refreshTask(true)
var istour=false
func _on_control_1_gui_input(event):

	if battle_circle.isBoot==true||control_1.canSelect==false||control_1.alreadyUse==true or (GameManager.sav.have_event["关羽求援期间"]==true and GameManager.sav.have_event["关羽求援结束"]==false):
		return
	if(event is InputEventMouseButton and event.button_index==1 or istour==true):		
		SoundManager.play_sound(sounds.CLICKHERO)		
		control_3.check_box.button_pressed=false
		control_2.check_box.button_pressed=false
		control_1.check_box.button_pressed=true
		selectIndex=1
		battle_circle.selectgeneral= GameManager.sav.generals[control_1.repImg]
		battle_circle._juideCompeleteTask()	 
		_refreshSlider()
		previewHpdone()
		refreshTask(true)
func previewHpdone():
	if GameManager.haveMirror():
		GameManager._engerge.startPreviewHp(costhp)

@onready var ani_1 = $ani_1
@onready var ani_2 = $ani_2
@onready var ani_3 = $ani_3

#出征按钮
func _on_button_button_down():
	if GameManager.currenceScene.battle_pane._mode==SceneManager.bossMode.none:
		if await GameManager.isTried(costhp) or \
		(GameManager.sav.have_event["无名之死"]==true and GameManager.sav.have_event["夏侯偷马"]==false and selectIndex==3) or\
		(GameManager.sav.have_event["关羽求援期间"]==true and GameManager.sav.have_event["关羽求援结束"]==false and selectIndex==1):
			return 
	if battle_circle.isBoot==false:
		
		SoundManager.play_sound(sounds.ZHUANPAN)
		var anisprite:Sprite2D=self["ani_"+var_to_str(selectIndex)]
		
		battle_circle.lauchProgress(costhp)
		lauchBtn.disabled=true

		anisprite.show()
		var ani:AnimationPlayer=anisprite.get_child(0)
		ani.play("slash")
		
		var _func=func(anim_name: StringName):
			ani.stop()
			anisprite.hide()
			print("diaoyong")
		ani.animation_finished.connect(_func)
		
	pass # Replace with function body.
@export var dialogue_resource:DialogueResource
#推出按钮，同时调用结束
func _on_exit_button_button_down():
	GameManager._engerge.stopPreviewHP()
	self.hide()
	GameManager.currenceScene.res_panel.position.x=1403
	GameManager.currenceScene.res_panel.position.y=622
	GameManager.currenceScene.res_panel.scale=Vector2(1,1)
	GameManager.currenceScene.refreshData()
	SoundManager.play_sound(sounds.declinesound)
	#大人
	if GameManager.sav.day==3:
		if GameManager.sav.hp<=10:
			if GameManager.sav.have_event["firstBattleEnd"]==false:
				GameManager.sav.have_event["firstBattleEnd"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"军事行动结束")
				GameManager.sav.destination="自宅"	
	 # Replace with function body.


var buffSize=0
func _on_Usecheck_box_toggled(toggled_on):

	GameManager.sav.useItemInBattle=toggled_on
	buffSize=5;
	_changeProgress()
	#接下来的代码，改变胜率，让胜率的东西往前一丢丢

@onready var ban_2_coin = $ban2
@onready var ban_1_soilder = $ban1

@export var _mode:SceneManager.bossMode=SceneManager.bossMode.none
func refreshHead():
	battle_circle.changeHeadInMainTask()

func enterBattleMi():
	_mode=SceneManager.bossMode.mi
	close_btn.hide()
	ban_1_soilder.show()
	battle_circle.taskIndex=0
	soild_slider.editable=false
	#soild_slider.enan;
	battle_circle.enemyName="糜贞"
	var cha=load("res://Asset/人物/mizhen_battle.png")
	battle_circle.changeHead(cha)
	initTask()
@onready var close_btn = $TextureButton

func enterBattleTao():
	
	
	
	close_btn.hide()
	_mode=SceneManager.bossMode.tao
	ban_2_coin.show()
	coin_slider.editable=false	
	var cha=load("res://Asset/人物/尸皇.png")
	battle_circle.enemyName="陶谦"
	battle_circle.changeHead(cha)
	battle_circle.taskIndex=0
	initTask()
func enterBattleHuang():
	
	_refreshSlider()
	_refreshGeneral()
	initTask()	
	
	battle_circle.enemyName="骨龙"
	close_btn.hide()
	_mode=SceneManager.bossMode.huang
	var cha=load("res://Asset/人物/骨龙最终.png")
	
	battle_circle.changeHead(cha)	
	#禁用任务
	for  data in GameManager.sav.battleTasks.values():
		data.task=[]
	#GameManager.sav.battleTasks.task=[]#clear()
	battle_circle.taskIndex=0
	initTask()


func sideQuestReturnG(iswin):
	GameManager.bossmode=SceneManager.bossMode.mi
	GameManager.bossmoderesult=iswin
	SceneManager.changeScene(SceneManager.roomNode.GOVERNMENT_BUILDING,2)
	
func sideQuestReturnT(iswin):
	GameManager.bossmode=SceneManager.bossMode.tao
	GameManager.bossmoderesult=iswin
	SceneManager.changeScene(SceneManager.roomNode.BOULEUTERION,2)


func sideQuestReturnD(iswin):
	GameManager.bossmode=SceneManager.bossMode.huang
	GameManager.bossmoderesult=iswin
	SceneManager.changeScene(SceneManager.roomNode.DRILL_GROUND,2)

@onready var line_edit_coin = $coinSlider/LineEdit
@onready var line_edit_soilder = $soildSlider/LineEdit



func _on_coinBlock_button_down():
	if battle_circle.selectgeneral!=null and GameManager.sav.coin!=0:
		line_edit_coin.show()


func _on_soilderBlock_button_down():
	if battle_circle.selectgeneral!=null and GameManager.sav.labor_force!=0:
		line_edit_soilder.show()


func enterBattleZhenRen():
	useItemPanel.hide()
	close_btn.hide()
	_mode=SceneManager.bossMode.zhenren
	for i in range(0,3):
		var datas=GameManager.sav.battleTasks.values()
		var data=datas[i]
		data.task=[]
		data.index=i+299
	refreshData()
	battle_circle.taskIndex=0
	battle_circle.enemyName="修道真人"
	const cha = preload("res://Asset/人物/真人.png")
	battle_circle.changeHead(cha)	
	#禁用任务
	#GameManager.sav.battleTasks.clear()

	#for  data in GameManager.sav.battleTasks.values():
		#data.task=[]
		
		#GameManager.sav.battleTasks[taskIndex]
		
	GameManager.secretBattleSav=GameManager.sav.currenceTask
	#GameManager.sav.currenceTask=200
	initTask()


func changeHead(cha):
	battle_circle.changeHead(cha)	
