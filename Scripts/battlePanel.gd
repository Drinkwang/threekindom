
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
@onready var guild_4 = $"pointGroup/4"
@onready var guild_5 = $"pointGroup/5"
@onready var guild_6 = $"pointGroup/6"
@onready var guild_7 = $"pointGroup/7"
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
func initData():
	battle_circle.refreshPage()
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
		else:
			if _mode==bossMode.tao:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗失败_陶谦")
			elif  _mode==bossMode.mi:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗失败_血姬")
			elif  _mode==bossMode.huang:
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"战斗失败_镇魂龙")		
@onready var useItemPanel = $PanelContainer/orderPanel/VBoxContainer/HBoxContainer2/TextureButton
@onready var label = $PanelContainer/orderPanel/VBoxContainer/HBoxContainer2/TextureButton/CheckBox/Label




func refreshUseItemPanel():
	var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.胜战锦囊)

	if num>0:
		useItemPanel.show()
		label.text=tr("_battleUseItem").format({"_num":num})
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
	if battle_circle.taskIndex<0 or GameManager.sav.battleTasks==null or GameManager.sav.battleTasks.size()<=0:
		return
		

	var currence= GameManager.sav.battleTasks[battle_circle.taskIndex]
	var context=tr("任务条件：")
	var index=1;
	var taskcontext=""
	var targetValue
	var bossMode=scenemanager.bossMode
	for task in currence.task:
		targetValue=task.value
		if task.res=="coin"and _mode!=bossMode.tao:
			var after=str(targetValue)+"目标值)"
			if task.symbol==GameManager.opcost.greater:
				if _mode==bossMode.mi:
					taskcontext="\n"+str(index)+tr(".血金祭坛:")+tr("(资金超过{targetValue})").format({"targetValue": targetValue})
				else:
					taskcontext="\n"+str(index)+tr(".工程战:")+tr("(资金超过{targetValue})").format({"targetValue": targetValue})
			elif task.symbol==GameManager.opcost.equal:
				if _mode==bossMode.mi:
					taskcontext="\n"+str(index)+tr(".血金秘术:")+tr("(资金等于{targetValue})").format({"targetValue": targetValue})
				else:				
					taskcontext="\n"+str(index)+tr(".特种战:")+tr("(资金等于{targetValue})").format({"targetValue": targetValue})
			elif task.symbol==GameManager.opcost.less:
				if _mode==bossMode.mi:
					taskcontext="\n"+str(index)+tr(".商贾幻影:")+tr("(资金小于{targetValue} 但大于{targetValue2})").format({"targetValue": targetValue,"targetValue2":int(floor(targetValue*2/3))})
				else:				
					taskcontext="\n"+str(index)+tr(".游击战:")+tr("(资金小于{targetValue} 但大于{targetValue2})").format({"targetValue": targetValue,"targetValue2":int(floor(targetValue*2/3))})
		pass
		if task.res=="human" and _mode!=bossMode.mi:
			if task.symbol==GameManager.opcost.greater:
				if _mode==bossMode.tao:
					taskcontext="\n"+str(index)+tr(".尸皇怒吼:")+tr("(兵力超过{targetValue})").format({"targetValue": targetValue})
				else:
					taskcontext="\n"+str(index)+tr(".遭遇战:")+tr("(兵力超过{targetValue})").format({"targetValue": targetValue})
			elif task.symbol==GameManager.opcost.equal:
				if _mode==bossMode.tao:
					taskcontext="\n"+str(index)+tr(".怨魂诡阵:")+tr("(兵力等于{targetValue})").format({"targetValue": targetValue})
				else:				
					taskcontext="\n"+str(index)+tr(".奇兵任务:")+tr("(兵力等于{targetValue})").format({"targetValue": targetValue})
			elif task.symbol==GameManager.opcost.less:
				if _mode==bossMode.tao:
					taskcontext="\n"+str(index)+tr(".冥界壁垒:")+tr("(兵力小于{targetValue} 但大于{targetValue2})").format({"targetValue": targetValue,"targetValue2":int(floor(targetValue*3/5))})
				else:				
					taskcontext="\n"+str(index)+tr(".防守战:")+tr("(兵力小于{targetValue} 但大于{targetValue2})").format({"targetValue": targetValue,"targetValue2":int(floor(targetValue*3/5))})
		pass
		context=context+taskcontext
	pass
	task_label.text=context

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


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


func _on_coin_slider_value_changed(value):
	if battle_circle.isBoot==true:
		return
	#costcoin=(GameManager.sav.coin*value/100)
	costcoin=value
	coin_num.text=str(costcoin)
	if(battle_circle.selectgeneral):
		_changeProgress()

var selectIndex
#BOOT结算完后将对应的general转换成use 然后同时也结算
#{"name": "关羽", "level": 1, "max_level": 10, "randominit": -1}
func _on_control_3_gui_input(event):

	if battle_circle.isBoot==true||control_3.canSelect==false||control_3.alreadyUse==true:
		return	
	
	if(event is InputEventMouseButton and event.button_index==1):	
		SoundManager.play_sound(sounds.CLICKHERO)		
		control_3.check_box.button_pressed=true
		control_2.check_box.button_pressed=false
		control_1.check_box.button_pressed=false
		selectIndex=3
		battle_circle.selectgeneral= GameManager.sav.generals[control_3.repImg]
		battle_circle._juideCompeleteTask()
		_refreshSlider()
	#取消其它的选中状态
	#给当前标记为选中
	#将选中将领具体信息发送给disk	
	pass # Replace with function body.


func _on_control_2_gui_input(event):

	if battle_circle.isBoot==true||control_2.canSelect==false||control_2.alreadyUse==true:
		return	
	if(event is InputEventMouseButton and event.button_index==1):	
		SoundManager.play_sound(sounds.CLICKHERO)
		control_1.check_box.button_pressed=false
		control_2.check_box.button_pressed=true
		control_3.check_box.button_pressed=false
		selectIndex=2
		battle_circle.selectgeneral= GameManager.sav.generals[control_2.repImg]
		battle_circle._juideCompeleteTask() 
		_refreshSlider()

func _on_control_1_gui_input(event):

	if battle_circle.isBoot==true||control_1.canSelect==false||control_1.alreadyUse==true:
		return
	if(event is InputEventMouseButton and event.button_index==1):		
		SoundManager.play_sound(sounds.CLICKHERO)		
		control_3.check_box.button_pressed=false
		control_2.check_box.button_pressed=false
		control_1.check_box.button_pressed=true
		selectIndex=1
		battle_circle.selectgeneral= GameManager.sav.generals[control_1.repImg]
		battle_circle._juideCompeleteTask()	 
		_refreshSlider()



@onready var ani_1 = $ani_1
@onready var ani_2 = $ani_2
@onready var ani_3 = $ani_3

#出征按钮
func _on_button_button_down():
	if GameManager.currenceScene.battle_pane._mode==SceneManager.bossMode.none:
		if await GameManager.isTried(costhp):
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
	self.hide()
	GameManager.currenceScene.res_panel.position.x=1529
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


func enterBattleMi():
	_mode=SceneManager.bossMode.mi
	close_btn.hide()
	ban_1_soilder.show()
	
	soild_slider.editable=false
	#soild_slider.enan;
	var cha=load("res://Asset/人物/假糜贞.png")
	battle_circle.changeHead(cha)
	initTask()
@onready var close_btn = $TextureButton

func enterBattleTao():
	close_btn.hide()
	_mode=SceneManager.bossMode.tao
	ban_2_coin.show()
	coin_slider.editable=false	
	var cha=load("res://Asset/人物/尸皇.png")
	
	battle_circle.changeHead(cha)

	initTask()
func enterBattleHuang():
	
	var cha=load("res://Asset/人物/骨龙最终.png")
	
	battle_circle.changeHead(cha)	
	#禁用任务
	GameManager.sav.battleTasks.clear()
	battle_circle.taskIndex=-1
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
