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
	coin_num.text = "%07d" % GameManager.sav.coin
	heart_num.text = "%07d" % GameManager.sav.people_surrport
	labor_num.text = "%07d" % GameManager.sav.labor_force
	#visible=true
	GameManager._propertyPanel=self
	TooltipManager.register_tooltip(_coin,tr("钱：持有的钱数量(可购买道具、军事行动的资金)"))
	TooltipManager.register_tooltip(_labor,tr("民力：拥有空闲民力(可转换为士兵)"))
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


	
	
	GameManager.sav.coin=GameManager.sav.coin+coinGet
	
	GameManager.sav.people_surrport=GameManager.sav.people_surrport+heartGet

		

	GameManager.sav.labor_force=GameManager.sav.labor_force+peopleGet

	coin_num.text = "%07d" % GameManager.sav.coin
	heart_num.text = "%07d" % GameManager.sav.people_surrport
	labor_num.text = "%07d" % GameManager.sav.labor_force
	
#var people_surrport #群众支持度 数值
#var  coin #钱 数值
#var labor_force #民力 可以当作军队进行使用 民力转换成军队需要消耗值 骑兵 步兵 弓兵
