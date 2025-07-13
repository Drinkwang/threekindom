extends Control
class_name propertyPanel
@onready var coin_num = $PanelContainer/MarginContainer/GridContainer/coinNum
@onready var heart_num = $PanelContainer/MarginContainer/GridContainer/heartNum
@onready var labor_num = $PanelContainer/MarginContainer/GridContainer/laborNum
@onready var dd222test = $PanelContainer/MarginContainer/GridContainer/TextureRect
@onready var coin = $coin
@onready var labor = $labor
@onready var heart = $heart

var showValue:bool=true
# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager._propertyPanel=self
	TooltipManager.register_tooltip(coin,"玩家持有的金钱数量(可购买道具)")
	TooltipManager.register_tooltip(labor,"玩家拥有空闲人口(可转换为士兵)")
	TooltipManager.register_tooltip(heart,"玩家当前百姓的支持度(<=0时游戏失败)")
	#dd222test
	pass # Replace with function body.

@onready var color_rect = $PanelContainer/MarginContainer2/ColorRect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(showValue==true):

		coin_num.text=var_to_str(GameManager.sav.coin)
		heart_num.text=var_to_str(GameManager.sav.people_surrport)
		labor_num.text=var_to_str(GameManager.sav.labor_force)
		color_rect.color.a=0.314+0.686*((100-GameManager.sav.people_surrport)/100.0)

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
	await 0.8
	
	
	if coinGet>0:
		GameManager.sav.coin=GameManager.sav.coin+coinGet
	elif coinGet<0:
		GameManager.sav.coin=GameManager.sav.coin-coinGet

	if heartGet>0:
		GameManager.sav.people_surrport=GameManager.sav.people_surrport+heartGet
	elif heartGet<0:
		GameManager.sav.people_surrport=GameManager.sav.people_surrport-heartGet

		
	if peopleGet>0:
		GameManager.sav.labor_force=GameManager.sav.labor_force+peopleGet
	elif peopleGet<0:
		GameManager.sav.labor_force=GameManager.sav.labor_force-peopleGet


	coin_num.text=var_to_str(GameManager.sav.coin)	
	heart_num.text=var_to_str(GameManager.sav.people_surrport)
	labor_num.text=var_to_str(GameManager.sav.labor_force)	
#var people_surrport #群众支持度 数值
#var  coin #金钱 数值
#var labor_force #劳动力 可以当作军队进行使用 劳动力转换成军队需要消耗值 骑兵 步兵 弓兵
