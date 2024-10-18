extends Control

@onready var coin_num = $PanelContainer/MarginContainer/GridContainer/coinNum
@onready var heart_num = $PanelContainer/MarginContainer/GridContainer/heartNum
@onready var labor_num = $PanelContainer/MarginContainer/GridContainer/laborNum

var showValue:bool
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(showValue==true):
		coin_num.text=var_to_str(GameManager.sav.coin)
		heart_num.text=var_to_str(GameManager.sav.people_surrport)
		labor_num.text=var_to_str(GameManager.sav.labor_force)
	

func GetValue(coinGet,heartGet,peopleGet):
	if coinGet>0:
		coin_num.text=var_to_str(GameManager.sav.coin)+"+"+var_to_str(coinGet)
	elif coinGet<0:
		coin_num.text=var_to_str(GameManager.sav.coin)+"-"+var_to_str(coinGet)
	else:
		coin_num.text=var_to_str(GameManager.sav.coin)
	
	if heartGet>0:
		heart_num.text=var_to_str(GameManager.sav.people_surrport)+"+"+var_to_str(heartGet)
	elif heartGet<0:
		heart_num.text=var_to_str(GameManager.sav.people_surrport)+"-"+var_to_str(heartGet)
	else:
		heart_num.text=var_to_str(GameManager.sav.people_surrport)
		
	if peopleGet>0:
		labor_num.text=var_to_str(GameManager.sav.labor_force)+"+"+var_to_str(peopleGet)
	elif peopleGet<0:
		labor_num.text=var_to_str(GameManager.sav.labor_force)+"-"+var_to_str(peopleGet)
	else:
		labor_num.text=var_to_str(GameManager.sav.labor_force)	
	

#var people_surrport #群众支持度 数值
#var  coin #金钱 数值
#var labor_force #劳动力 可以当作军队进行使用 劳动力转换成军队需要消耗值 骑兵 步兵 弓兵
