extends Control
class_name ShopPanel
@onready var detail = $detail
var selectGoods:ShopItem

@onready var back_txt = $backTxt

var useItems
# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.shopPanel=self
	var haveNum=InventoryManager.canUseItemNum()
	if GameManager.sav.isSoldItem==false and haveNum>=3:
		var backNum=randi_range(3,haveNum)
		useItems=InventoryManager.costItemRandom(backNum)
		GameManager.SoldItemStr=generate_consumed_string(useItems)
		GameManager.SoldCoin=0
		for item_type in useItems:
			if useItems[item_type] > 0:  # 只处理消耗数量大于 0 的道具
		
			
				var properties:Array=InventoryManager.get_item_properties(item_type)
				var item=properties.filter(func(a):return a["name"]=="price")[0]
				var price=int(item["value"])
				price=floor(price*0.6)
				GameManager.SoldCoin=GameManager.SoldCoin+price
		GameManager.SoldItemStr=tr("我将以%d金收购你手上的")%GameManager.SoldCoin+GameManager.SoldItemStr
		back_txt.show()
		#
	else:
		back_txt.hide()
	#pass # Replace with function body.

@export var dialogue_resource:DialogueResource


func generate_consumed_string(consumed: Dictionary) -> String:
	var result = []
	for item_type in consumed:
		if consumed[item_type] > 0:  # 只处理消耗数量大于 0 的道具
			var item_name = InventoryManager.get_item_db(item_type).name
			result.append(tr("%s%d个") % [item_name, consumed[item_type]])
	#
	## 用逗号连接所有描述
	return "，".join(result)
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


func _on_Sold_button_down():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"是否售出商品")

@onready var buy_back_button = $backTxt/buyBackButton

func confireSold():
	GameManager.sav.coin+int(GameManager.SoldCoin)
	GameManager.sav.isSoldItem=true
	for item_type in useItems:
			if useItems[item_type] > 0:  # 只处理消耗数量大于 0 的道具
		
				InventoryManager._remove_item(GameManager.inventoryPackege,item_type,useItems[item_type])
	useItems=[]
	back_txt.text="当前商人没有需要从你手中收购商品的需要，请改日再来！"
	buy_back_button.disabled=true
	
