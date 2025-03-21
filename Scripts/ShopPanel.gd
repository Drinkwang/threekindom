extends Control
class_name ShopPanel
@onready var detail = $detail
var selectGoods:ShopItem
# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.shopPanel=self
	#pass # Replace with function body.

@export var dialogue_resource:DialogueResource

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
var price:int
@onready var buy_button = $buyButton

func initData():
	detail.text="点击商品获取详细信息"
	buy_button.disabled=true
	selectGoods=null
	refreshAlreadySoldWeapon()
func refreshPage(_price,_detail):
	buy_button.disabled=false
	price=_price.to_int()
	detail.text=_detail+"\n\n"+"当前商品价格:{price}".format({"price":price})
	# selectGoods.itemstype#通过这个获取价格
	pass
	
func refreshAlreadySoldTxt():
	buy_button.disabled=true
	detail.text="当前武器你已经持有了，无需再购买"
func _on_buy_button_down():
	if(GameManager.sav.coin>=(price as int) and selectGoods!=null):
		SoundManager.play_sound(sounds.buysellsound)
		selectGoods.getItem()
		GameManager.sav.coin=GameManager.sav.coin-price
		selectGoods=null
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"欢迎光临")
		price=0
		refreshAlreadySoldWeapon()
	else:
		selectGoods=null
		price=0
		detail.text="你买不起物品"
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"小本生意，请谅解")
		print("你买不起物品")
	pass # Replace with function body.


func refreshAlreadySoldWeapon():
	$HBoxContainer/Control1.refreshSold()
	$HBoxContainer/Control2.refreshSold()
	$HBoxContainer/Control3.refreshSold()
func _on_texture_button_2_button_down():
	self.hide()
