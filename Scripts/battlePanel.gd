
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
@onready var guild_8 = $"pointGroup/8"


@onready var sliderlabel_1 = $sliderlabel1
@onready var sliderlabel_2 = $sliderlabel2
@onready var title = $PanelContainer/orderPanel/VBoxContainer/Label2

@onready var select_detail = $PanelContainer/orderPanel/VBoxContainer/selectDetail

var costhp=30
# Called when the node enters the scene tree for the first time.
func _ready():
	_refreshSlider()
	_refreshGeneral()
	SignalManager.endReward.connect(endBattle)
	battle_circle.isBoot=false
	initTask()
	changeLanguage()
	pass # Replace with function body.
const NOT_JAM_UI_CONDENSED_16 = preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")
func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="ja":
		pass
	elif currencelanguage=="ru":
		sliderlabel_1.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		sliderlabel_2.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		#task_label.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		select_detail.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		title.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
	else:
		pass
#可能会删除
func initData():
	pass		
func endBattle():
	battle_circle.selectgeneral=null
	soild_slider.value=0
	coin_slider.value=0
	_refreshSlider()
	initTask()
	_refreshGeneral()
	#刷新界面
	pass


func _refreshGeneral():
	control_1.updateContext(0)
	control_2.updateContext(1)	
	control_3.updateContext(2)	
	if GameManager.sav.UseGeneral.size()>0:
		for ele in GameManager.sav.UseGeneral:
			var index=GameManager.generals.values().find(ele)
			var finde:SoilderItem=self.find_child("Control_"+str(index+1)) as SoilderItem
			finde.Use()
		

#
#将任务给创建出来
#将当前石头剪刀布 和战力给创建出来

@onready var lauchBtn = $PanelContainer/orderPanel/VBoxContainer/HBoxContainer/Button

func _refreshSlider():
	if GameManager.sav.labor_force<0:
		soild_slider.editable=false
	else:
		soild_slider.editable=true
	if GameManager.sav.coin<0:
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
	
	var currence= GameManager.sav.battleTasks[battle_circle.taskIndex]
	var context=tr("任务条件：")
	var index=1;
	var taskcontext=""
	var targetValue
	for task in currence.task:
		targetValue=task.value
		if task.res=="coin":
			var after=str(targetValue)+"目标值)"
			if task.symbol==GameManager.opcost.greater:
				taskcontext="\n"+str(index)+tr(".工程战:")+tr("(资金超过{targetValue})").format({"targetValue": targetValue})
				pass
			elif task.symbol==GameManager.opcost.equal:
				taskcontext="\n"+str(index)+tr(".特种战:")+tr("(资金等于{targetValue})").format({"targetValue": targetValue})
				pass
			elif task.symbol==GameManager.opcost.less:
				taskcontext="\n"+str(index)+tr(".游击战:")+tr("(资金小于{targetValue} 但大于{targetValue2})").format({"targetValue": targetValue,"targetValue2":int(floor(targetValue*2/3))})
				pass
		pass
		if task.res=="human":
			if task.symbol==GameManager.opcost.greater:
				taskcontext="\n"+str(index)+tr(".遭遇战:")+tr("(兵力超过{targetValue})").format({"targetValue": targetValue})
			elif task.symbol==GameManager.opcost.equal:
				taskcontext="\n"+str(index)+tr(".奇兵任务:")+tr("(兵力等于{targetValue})").format({"targetValue": targetValue})
			elif task.symbol==GameManager.opcost.less:
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
	#print (GameManager.labor_force)
	costsoild=(GameManager.sav.labor_force*value/100)
	soild_num.set_text(str(costsoild))  #报错没有找到 先屏蔽，后续开启
	if(battle_circle.selectgeneral):
		_changeProgress()


func _on_coin_slider_value_changed(value):
	if battle_circle.isBoot==true:
		return
	costcoin=(GameManager.sav.coin*value/100)
	coin_num.text=str(costcoin)
	if(battle_circle.selectgeneral):
		_changeProgress()


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
		
		battle_circle.selectgeneral= GameManager.generals[control_3.repImg]
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
		battle_circle.selectgeneral= GameManager.generals[control_2.repImg]
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
		battle_circle.selectgeneral= GameManager.generals[control_1.repImg]
		battle_circle._juideCompeleteTask()	 
		_refreshSlider()




#出征按钮
func _on_button_button_down():
	if await GameManager.isTried(costhp):
		return 
	if battle_circle.isBoot==false:
		SoundManager.play_sound(sounds.ZHUANPAN)
		battle_circle.lauchProgress(costhp)



	
	pass # Replace with function body.
@export var dialogue_resource:DialogueResource
#推出按钮，同时调用结束
func _on_exit_button_button_down():
	self.hide()
	SoundManager.play_sound(sounds.declinesound)
	#大人
	if GameManager.sav.day==3:
		if GameManager.hp<=10:
			if GameManager.sav.have_event["firstBattleEnd"]==false:
				GameManager.sav.have_event["firstBattleEnd"]=true
				DialogueManager.show_example_dialogue_balloon(dialogue_resource,"军事行动结束")
	 # Replace with function body.
