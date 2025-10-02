extends Control
class_name propertyPanel
#@onready var coin_num = $PanelContainer/MarginContainer/GridContainer/coinNum
#@onready var heart_num = $PanelContainer/MarginContainer/GridContainer/heartNum
#@onready var labor_num = $PanelContainer/MarginContainer/GridContainer/laborNum
#@onready var dd222test = $PanelContainer/MarginContainer/GridContainer/TextureRect



@onready var coin_num = $MarginContainer/GridContainer/coinNum
@onready var heart_num = $MarginContainer/GridContainer/heartNum
@onready var labor_num = $MarginContainer/GridContainer/laborNum
@onready var dd222test = $MarginContainer/GridContainer/TextureRect
@onready var _coin = $coin
@onready var _labor = $labor
@onready var _heart = $heart

var showValue:bool=true
# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager._propertyPanel=self
	TooltipManager.register_tooltip(_coin,tr("金币：持有的金钱数量(可购买道具)"))
	TooltipManager.register_tooltip(_labor,tr("人口：拥有空闲人口(可转换为士兵)"))
	TooltipManager.register_tooltip(_heart,tr("民心：当前百姓的支持度(<=0时游戏失败)"))
	#dd222test
	pass # Replace with function body.

@onready var color_rect = $MarginContainer2/ColorRect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(showValue==true):
		coin_num.text = "%07d" % GameManager.sav.coin
		heart_num.text = "%07d" % GameManager.sav.people_surrport
		labor_num.text = "%07d" % GameManager.sav.labor_force
		#coin_num.text=var_to_str(GameManager.sav.coin)
		#heart_num.text=var_to_str(GameManager.sav.people_surrport)
		#labor_num.text=var_to_str(GameManager.sav.labor_force)
		color_rect.color.a=0.314+0.686*((100-GameManager.sav.people_surrport)/100.0)

func GetValue(coinGet,heartGet,peopleGet):


	
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

	coin_num.text = "%07d" % GameManager.sav.coin
	heart_num.text = "%07d" % GameManager.sav.people_surrport
	labor_num.text = "%07d" % GameManager.sav.labor_force
	
#var people_surrport #群众支持度 数值
#var  coin #金钱 数值
#var labor_force #劳动力 可以当作军队进行使用 劳动力转换成军队需要消耗值 骑兵 步兵 弓兵
