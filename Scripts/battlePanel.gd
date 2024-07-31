
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

# Called when the node enters the scene tree for the first time.
func _ready():
	_refreshSlider()

	initTask()
	pass # Replace with function body.


#将任务给创建出来
#将当前石头剪刀布 和战力给创建出来


func _refreshSlider():
	if GameManager.labor_force<0:
		soild_slider.editable=false
	else:
		soild_slider.editable=true
	if GameManager.coin<0:
		coin_slider.editable=false
	else:
		coin_slider.editable=true
	if battle_circle.selectgeneral==null:
		soild_slider.editable=false
		coin_slider.editable=false	

@onready var task_label = $TaskLabel

func initTask():
	
	var currence= GameManager.battleTasks[battle_circle.taskIndex]
	var context="任务条件："
	var index=1;
	var taskcontext=""
	var targetValue
	for task in currence.task:
		targetValue=task.value
		if task.res=="coin":
			var after=str(targetValue)+"目标值)"
			if task.symbol==GameManager.opcost.greater:
				taskcontext="\n"+str(index)+".工程战:"+"(资金超过{targetValue})".format({"targetValue": targetValue})
				pass
			elif task.symbol==GameManager.opcost.equal:
				taskcontext="\n"+str(index)+".特种战:"+"(资金等于{targetValue})".format({"targetValue": targetValue})
				pass
			elif task.symbol==GameManager.opcost.less:
				taskcontext="\n"+str(index)+".游记战:"+"(资金小于{targetValue})".format({"targetValue": targetValue})
				pass
		pass
		if task.res=="human":
			if task.symbol==GameManager.opcost.greater:
				taskcontext="\n"+str(index)+".遭遇战:"+"(兵力超过{targetValue})".format({"targetValue": targetValue})
			elif task.symbol==GameManager.opcost.equal:
				taskcontext="\n"+str(index)+".奇兵任务:"+"(兵力等于{targetValue})".format({"targetValue": targetValue})
			elif task.symbol==GameManager.opcost.less:
				taskcontext="\n"+str(index)+".防守战:"+"(兵力小于{targetValue})".format({"targetValue": targetValue})
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
	print (GameManager.labor_force)
	costsoild=(GameManager.labor_force/100*value)
	
	soild_num.set_text(str(costsoild))  #报错没有找到 先屏蔽，后续开启
	
	_changeProgress()


func _on_coin_slider_value_changed(value):
	if battle_circle.isBoot==true:
		return
	costcoin=(GameManager.coin/100*value)
	coin_num.text=str(costcoin)
	_changeProgress()

#{"name": "关羽", "level": 1, "max_level": 10, "randominit": -1}
func _on_control_1_gui_input(event):
	if battle_circle.isBoot==true:
		return	
	if(event is InputEventMouseButton and event.button_index==1):	
		control_1.check_box.button_pressed=true
		control_2.check_box.button_pressed=false
		control_3.check_box.button_pressed=false
		battle_circle.selectgeneral= GameManager.generals[control_1.repImg]
		battle_circle._juideCompeleteTask()
		_refreshSlider()
	#取消其它的选中状态
	#给当前标记为选中
	#将选中将领具体信息发送给disk	
	pass # Replace with function body.


func _on_control_2_gui_input(event):
	if battle_circle.isBoot==true:
		return	
	if(event is InputEventMouseButton and event.button_index==1):	
		control_1.check_box.button_pressed=false
		control_2.check_box.button_pressed=true
		control_3.check_box.button_pressed=false
		battle_circle.selectgeneral= GameManager.generals[control_2.repImg]
		battle_circle._juideCompeleteTask() 
		_refreshSlider()

func _on_control_3_gui_input(event):
	if battle_circle.isBoot==true:
		return
	if(event is InputEventMouseButton and event.button_index==1):		
		control_1.check_box.button_pressed=false
		control_2.check_box.button_pressed=false
		control_3.check_box.button_pressed=true
		battle_circle.selectgeneral= GameManager.generals[control_3.repImg]
		battle_circle._juideCompeleteTask()	 
		_refreshSlider()




#出征按钮
func _on_button_button_down():
	if battle_circle.isBoot==false:
		battle_circle.lauchProgress()



	
	pass # Replace with function body.
