extends Control

@onready var coin_num = $PanelContainer/MarginContainer/GridContainer/coinNum
@onready var heart_num = $PanelContainer/MarginContainer/GridContainer/heartNum
@onready var labor_num = $PanelContainer/MarginContainer/GridContainer/laborNum

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	coin_num.text=var_to_str(GameManager.coin)
	heart_num.text=var_to_str(GameManager.people_surrport)
	labor_num.text=var_to_str(GameManager.labor_force)
	pass


#var people_surrport #群众支持度 数值
#var  coin #金钱 数值
#var labor_force #劳动力 可以当作军队进行使用 劳动力转换成军队需要消耗值 骑兵 步兵 弓兵
