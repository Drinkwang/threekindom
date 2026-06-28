extends Control
class_name ShopPanel
@onready var detail = $detail
var selectGoods:ShopItem

@onready var back_txt = $backTxt
@onready var hearsay = $HBoxContainer2/xiaodao
@onready var buy_back_button = $backTxt/buyBackButton
@onready var buy_back_button_2 = $backTxt/buyBackButton2
@onready var merchant_buy_button = $backTxt/buyBackButton2/merchantBuyBtn
@onready var self_buy_button = $backTxt/buyBackButton2/selfBuyButton
@onready var self_sell_bg = $selfSellBg
@onready var self_sell_panel = $selfSellPanel
@onready var self_sell_total_label = $selfSellPanel/Content/Summary/TotalLabel
@onready var self_sell_coin_label = $selfSellPanel/Content/Summary/CoinLabel
@onready var self_sell_confirm_button = $selfSellPanel/Content/Buttons/ConfirmButton
@onready var self_sell_rows = {
	InventoryManagerItem.益气丸: {
		"owned": $selfSellPanel/Content/Rows/YiqiRow/OwnedLabel,
		"price": $selfSellPanel/Content/Rows/YiqiRow/PriceLabel,
		"input": $selfSellPanel/Content/Rows/YiqiRow/yiqiInput,
		"minus": $selfSellPanel/Content/Rows/YiqiRow/MinusButton,
		"plus": $selfSellPanel/Content/Rows/YiqiRow/PlusButton,
	},
	InventoryManagerItem.胜战锦囊: {
		"owned": $selfSellPanel/Content/Rows/ShengzhanRow/OwnedLabel,
		"price": $selfSellPanel/Content/Rows/ShengzhanRow/PriceLabel,
		"input": $selfSellPanel/Content/Rows/ShengzhanRow/shengzhanInput,
		"minus": $selfSellPanel/Content/Rows/ShengzhanRow/MinusButton,
		"plus": $selfSellPanel/Content/Rows/ShengzhanRow/PlusButton,
	},
	InventoryManagerItem.诸子百家论集: {
		"owned": $selfSellPanel/Content/Rows/ZhuziRow/OwnedLabel,
		"price": $selfSellPanel/Content/Rows/ZhuziRow/PriceLabel,
		"input": $selfSellPanel/Content/Rows/ZhuziRow/zhuziInput,
		"minus": $selfSellPanel/Content/Rows/ZhuziRow/MinusButton,
		"plus": $selfSellPanel/Content/Rows/ZhuziRow/PlusButton,
	},
	InventoryManagerItem.珍品礼盒: {
		"owned": $selfSellPanel/Content/Rows/ZhenpinRow/OwnedLabel,
		"price": $selfSellPanel/Content/Rows/ZhenpinRow/PriceLabel,
		"input": $selfSellPanel/Content/Rows/ZhenpinRow/zhenpinInput,
		"minus": $selfSellPanel/Content/Rows/ZhenpinRow/MinusButton,
		"plus": $selfSellPanel/Content/Rows/ZhenpinRow/PlusButton,
	},
}

var useItems
const SELF_SELL_LIMIT := 5
const SELF_SELL_BUTTON_ACTIVE := Color(1, 1, 1, 1)
const SELF_SELL_BUTTON_INACTIVE := Color(0.72, 0.72, 0.72, 1)
var self_sell_counts := {}
var self_sell_updating_input := false
# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.shopPanel=self
	var haveNum=InventoryManager.canUseItemNum()
	var canBuy = GameManager.sav.merMustBuy or GameManager.sav.randomIndex % 2 == 0
	var can_merchant_buy = GameManager.sav.isSoldItem==false and haveNum>=1 and canBuy
	var can_self_sell = GameManager.sav.shopSelfSell and GameManager.sav.isSoldItem==false
	self_sell_bg.hide()
	self_sell_panel.hide()
	_reset_self_sell_counts()
	if can_merchant_buy:
		var backNum=randi_range(1,haveNum)
		backNum=min(backNum,5)
		useItems=InventoryManager.costItemRandom(backNum)
		GameManager.SoldItemStr=generate_consumed_string(useItems)
		GameManager.SoldCoin=0
		var shopEnhanceContext=""
		for item_type in useItems:
			if useItems[item_type] > 0:  # 只处理消耗数量大于 0 的道具
		
			
				var properties:Array=InventoryManager.get_item_properties(item_type)
				var item=properties.filter(func(a):return a["name"]=="price")[0]
				var price=int(item["value"])
				var shopEnhance=GameManager.sav.shopEnhance
				var shopEnum=shopEnhance*0.15
				
				if shopEnhance>0:
					shopEnhanceContext=tr("[法令提升了收购价{profit}%]").format({"profit":shopEnhance*15})
				price=floor(price*(0.6+shopEnum))
				GameManager.SoldCoin=GameManager.SoldCoin+price
		GameManager.SoldItemStr=tr("我将以%d金收购你手上的")%GameManager.SoldCoin+" ["+GameManager.SoldItemStr+"]"+shopEnhanceContext
		back_txt.show()
		#
		
	else:
		back_txt.hide()
	if can_merchant_buy or can_self_sell:
		back_txt.show()
		_refresh_sell_buttons(can_merchant_buy, can_self_sell)
	else:
		back_txt.hide()
	
	var haveone=((InventoryManager.get_hidden_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.市井秘闻) )>0)	
	var havetwo=((InventoryManager.get_hidden_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.市井秘闻_续) )>0)
	var havethree=((InventoryManager.get_hidden_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.市井秘闻_终) )>0)	
	if not haveone and GameManager.sav.have_event["completeTask1"]==true and GameManager.sav.have_event["Factionalization"]==false:#没有1 然后特定事件 and haveenvent=false
		hearsay.show()
		hearsay.itemstype=InventoryManagerItem.ItemEnum.市井秘闻	
		hearsay.img=load("res://Asset/items/密谈3.png")
		#hearsay.itemstype=InventoryManagerItem.ItemEnum.市井秘闻_续
		#waitTime
		#if hearsay.alreaysold.visible
		hearsay.itemContext="1"
	elif !havetwo and GameManager.sav.have_event["Factionalization"]==true and GameManager.sav.have_event["庆功宴是否举办"]==false:#拥有市井1 没有2 然后特定事件
		hearsay.show()	
		hearsay.itemstype=InventoryManagerItem.ItemEnum.市井秘闻_续
		hearsay.img=load("res://Asset/items/密谈2.png")
		hearsay.itemContext="2"
	elif !havethree and GameManager.sav.have_event["袁术首次击败"]==true:#拥有市井2 没有3 然后特定事件
		hearsay.show()
		hearsay.itemstype=InventoryManagerItem.ItemEnum.市井秘闻_终	
		hearsay.img=load("res://Asset/items/密谈1.png")
		hearsay.itemContext="3"
	else:
		hearsay.hide()	
	#pass # Replace with function body.
	hearsay.refreshSold()
@export var dialogue_resource:DialogueResource


func generate_consumed_string(consumed: Dictionary) -> String:
	var result = []
	for item_type in consumed:
		if consumed[item_type] > 0:  # 只处理消耗数量大于 0 的道具
			var item_name = tr(InventoryManager.get_item_db(item_type).name)
			result.append((tr("%s")+"x%d") % [item_name, consumed[item_type]])
	#
	## 用逗号连接所有描述
	return "，".join(result)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
var price:int
@onready var buy_button = $buyButton

func initData():
	detail.text=tr("点击商品获取详细信息")
	buy_button.disabled=true
	selectGoods=null
	refreshAlreadySoldWeapon()
func refreshPage(_price,_detail):
	buy_button.disabled=false
	price=_price.to_int()
	detail.text=tr(_detail)+"\n\n"+tr("当前商品价格:{price}").format({"price":price})
	# selectGoods.itemstype#通过这个获取价格
	pass
	
func refreshAlreadySoldTxt(index):
	buy_button.disabled=true
	if index==1:
		detail.text=tr("当前武器你已经持有了，无需再购买")
	elif index==2:
		detail.text=tr("这个饰品你已经持有了，无需再购买")
	else:
		detail.text=tr("这个秘闻你已经知道了，请改日再来吧")

func _get_selected_hearsay_id() -> int:
	if selectGoods==null:
		return -1
	if selectGoods==hearsay and selectGoods.itemContext.is_valid_int():
		return selectGoods.itemContext.to_int()
	if selectGoods.itemstype==InventoryManagerItem.ItemEnum.市井秘闻:
		return 1
	if selectGoods.itemstype==InventoryManagerItem.ItemEnum.市井秘闻_续:
		return 2
	if selectGoods.itemstype==InventoryManagerItem.ItemEnum.市井秘闻_终:
		return 3
	return -1

func _sync_hearsay_item_type(hearsay_id:int):
	if hearsay_id==1:
		selectGoods.itemstype=InventoryManagerItem.ItemEnum.市井秘闻
	elif hearsay_id==2:
		selectGoods.itemstype=InventoryManagerItem.ItemEnum.市井秘闻_续
	elif hearsay_id==3:
		selectGoods.itemstype=InventoryManagerItem.ItemEnum.市井秘闻_终

func _start_hearsay_story(hearsay_id:int):
	GameManager.hearsayBeforeNode=SceneManager.roomNode.Shop
	GameManager.restFadeScene=SceneManager.GOVERNMENT_BUILDING
	SoundManager.stop_music()
	GameManager.hearsayID=hearsay_id
	GameManager.backhearsayID=hearsay_id

	if hearsay_id==1:
		GameManager.restLabel=tr("你在徐州商人花钱买到一则秘闻。陶谦已逝，刘备新掌徐州，城中却暗潮汹涌。近日，陈登与糜竺密会厅堂，窃窃私语，似在筹谋未来。市井耳目偷听二人低语，揭开权臣心机一角，细闻之下，耐人寻味……")
	elif hearsay_id==2:
		GameManager.restLabel=tr("你在徐州商人重金购得一则秘闻。刘备新主徐州，粮荒民怨未平，陈登与糜竺却针锋相对。昨夜，二人争执后各归私邸，似有异样。市井探子窃闻两人低语，令人心惊……")
	elif hearsay_id==3:
		GameManager.restLabel=tr("你于徐州商人重金购得一则秘闻。时值196年，刘备新主徐州，袁术兵临城下，城中暗流汹涌。昨夜，陈登独坐议事厅，灯下沉吟；糜竺踱步府邸庭院，月下低吟。市井耳目窃闻二人心声，权谋隐志，令人暗叹……")
	GameManager._rest(false)
#var befunc		
func _on_buy_button_down():
	var costhp=0
	if GameManager.sav.gameDifficulty!=1:
	#简单难度 不扣体力，普通难度扣10 困难扣20
	#立法 简单扣2点 普通扣3点，困难扣4点
		
		if GameManager.sav.gameDifficulty==2:
			costhp=10
		elif GameManager.sav.gameDifficulty==3:
			costhp=20
		if(await GameManager.isTried(costhp)):
			return 		
	if(GameManager.sav.coin>=(price as int) and selectGoods!=null):
		SoundManager.play_sound(sounds.buysellsound)
		if GameManager.sav.gameDifficulty!=1:
			GameManager.costHp(costhp)
		var hearsay_id=_get_selected_hearsay_id()
		if hearsay_id>0:
			_sync_hearsay_item_type(hearsay_id)
		selectGoods.getItem()
		GameManager.sav.coin=GameManager.sav.coin-price
		if hearsay_id>0:
			_start_hearsay_story(hearsay_id)
			selectGoods=null
			price=0
			hearsay.refreshSold()
			hearsay.hide()
			return
		
		selectGoods=null
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"欢迎光临")
		price=0
		refreshAlreadySoldWeapon()
	else:
		selectGoods=null
		price=0
		detail.text=tr("你买不起物品")
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"小本生意，请谅解")
		print("你买不起物品")
	pass # Replace with function body.


func refreshAlreadySoldWeapon():
	$HBoxContainer/Control1.refreshSold()
	$HBoxContainer/Control2.refreshSold()
	$HBoxContainer/Control3.refreshSold()
	$HBoxContainer/Control4.refreshSold()
	$HBoxContainer/Control5.refreshSold()
func _on_texture_button_2_button_down():
	GameManager.currenceScene.res_panel.position.x=1404
	GameManager.currenceScene.res_panel.position.y=611
	GameManager.currenceScene.res_panel.scale=Vector2(1,1)
	self.hide()
	if GameManager.sav.have_event["boss战开始"]==true and GameManager.sav.caobaocardgame==4:
		GameManager.currenceScene.enterBlackMerchant()

func settleAfter():
	
	#if selectGoods.isspecial():
	detail.text=tr("点击商品获取详细信息")
	buy_button.disabled=true
	selectGoods=null
	refreshAlreadySoldWeapon()

func _on_Sold_button_down():
	
	#if(await GameManager.isTried(costhp)):
		#return 		
	#GameManager._engerge.startPreviewHp(costhp)	
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"是否售出商品")

#var costhp=15
func confireSold():
	
	GameManager.sav.coin=GameManager.sav.coin+int(GameManager.SoldCoin)
	GameManager.sav.isSoldItem = true
	for item_type in useItems:
			if useItems[item_type] > 0:  # 只处理消耗数量大于 0 的道具
		
				InventoryManager._remove_item(GameManager.inventoryPackege,item_type,useItems[item_type])
	useItems=[]
	AchievementManager.set_achievement("NEW_ACHIEVEMENT_1_7")
	back_txt.text="当前商人没有需要从你手中收购商品的需要，请改日再来！"
	buy_back_button.disabled=true
	merchant_buy_button.hide()
	self_buy_button.hide()
	self_sell_bg.hide()
	self_sell_panel.hide()

func _refresh_sell_buttons(can_merchant_buy:bool, can_self_sell:bool):
	if GameManager.sav.shopSelfSell:
		buy_back_button.hide()
		buy_back_button_2.show()
		merchant_buy_button.disabled = !can_merchant_buy
		self_buy_button.disabled = !can_self_sell
	else:
		buy_back_button.show()
		buy_back_button_2.hide()
		buy_back_button.disabled = !can_merchant_buy

func _reset_self_sell_counts():
	self_sell_counts = {
		InventoryManagerItem.益气丸: 0,
		InventoryManagerItem.胜战锦囊: 0,
		InventoryManagerItem.诸子百家论集: 0,
		InventoryManagerItem.珍品礼盒: 0,
	}

func _get_self_sell_owned(item_type:String) -> int:
	return InventoryManager.inventory_item_quantity(GameManager.inventoryPackege, item_type)

func _has_self_sell_items() -> bool:
	for item_type in self_sell_counts.keys():
		if _get_self_sell_owned(item_type) > 0:
			return true
	return false

func _get_self_sell_price(item_type:String) -> int:
	var properties:Array=InventoryManager.get_item_properties(item_type)
	var price_items=properties.filter(func(a):return a["name"]=="price")
	if price_items.is_empty():
		return 0
	var price=int(price_items[0]["value"])
	var shop_enhance=GameManager.sav.shopEnhance
	return floor(price * (0.6 + shop_enhance * 0.15))

func _get_self_sell_total_count() -> int:
	var total=0
	for item_type in self_sell_counts.keys():
		total += int(self_sell_counts[item_type])
	return total

func _get_self_sell_total_coin() -> int:
	var total=0
	for item_type in self_sell_counts.keys():
		total += _get_self_sell_price(item_type) * int(self_sell_counts[item_type])
	return total

func _change_self_sell_quantity(item_type:String, delta:int):
	if delta > 0 and _get_self_sell_total_count() >= SELF_SELL_LIMIT:
		return
	_set_self_sell_count(item_type, int(self_sell_counts[item_type]) + delta)

func _set_self_sell_count(item_type:String, new_count:int):
	var current_count=int(self_sell_counts[item_type])
	var total_without_item=_get_self_sell_total_count() - current_count
	var max_count=maxi(0, min(_get_self_sell_owned(item_type), SELF_SELL_LIMIT - total_without_item))
	self_sell_counts[item_type]=clampi(new_count, 0, max_count)
	_refresh_self_sell_panel()

func _refresh_self_sell_panel():
	self_sell_updating_input = true
	for item_type in self_sell_rows.keys():
		var row=self_sell_rows[item_type]
		var owned=_get_self_sell_owned(item_type)
		var count=int(self_sell_counts[item_type])
		var can_minus=count>0
		var can_plus=owned>0 and _get_self_sell_total_count()<SELF_SELL_LIMIT and count<owned
		row["owned"].text=tr("持有:%d") % owned
		row["price"].text=tr("单价:%d") % _get_self_sell_price(item_type)
		row["input"].text=str(count)
		row["minus"].modulate=SELF_SELL_BUTTON_ACTIVE if can_minus else SELF_SELL_BUTTON_INACTIVE
		row["plus"].modulate=SELF_SELL_BUTTON_ACTIVE if can_plus else SELF_SELL_BUTTON_INACTIVE
	self_sell_updating_input = false
	self_sell_total_label.text=tr("合计:%d/%d") % [_get_self_sell_total_count(), SELF_SELL_LIMIT]
	self_sell_coin_label.text=tr("可得:%d金") % _get_self_sell_total_coin()
	self_sell_confirm_button.modulate=SELF_SELL_BUTTON_ACTIVE if _get_self_sell_total_count() > 0 else SELF_SELL_BUTTON_INACTIVE

func _on_self_buy_button_down():
	if GameManager.sav.isSoldItem:
		detail.text=tr("今日已经售卖过商品，请改日再来")
		return
	_reset_self_sell_counts()
	if !_has_self_sell_items():
		detail.text=tr("没有可售卖商品")
		return
	_refresh_self_sell_panel()
	self_sell_bg.show()
	self_sell_panel.show()

func _on_self_sell_cancel_button_down():
	self_sell_bg.hide()
	self_sell_panel.hide()

func _on_self_sell_confirm_button_down():
	var total_count=_get_self_sell_total_count()
	if total_count<=0:
		return
	GameManager.SoldCoin = _get_self_sell_total_coin()
	GameManager.SoldItemStr = tr("我将以%d金收购你手上的")%GameManager.SoldCoin+" ["+generate_consumed_string(self_sell_counts)+"]"
	useItems = self_sell_counts.duplicate()
	
	shopEnhanceContext=tr("[法令提升了收购价{profit}%]").format({"profit":shopEnhance*15})
	self_sell_bg.hide()
	self_sell_panel.hide()
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"售出成功")

func _filter_self_sell_input_text(text:String) -> int:
	var valid_text=""
	for char in text:
		if char.is_valid_int():
			valid_text += char
	if valid_text.length()==0:
		return 0
	return int(valid_text)

func _on_self_sell_input_text_changed(item_type:String, text:String):
	if self_sell_updating_input:
		return
	_set_self_sell_count(item_type, _filter_self_sell_input_text(text))

func _on_yiqi_minus_button_down():
	_change_self_sell_quantity(InventoryManagerItem.益气丸, -1)

func _on_yiqi_plus_button_down():
	_change_self_sell_quantity(InventoryManagerItem.益气丸, 1)

func _on_yiqi_input_text_changed(new_text:String):
	_on_self_sell_input_text_changed(InventoryManagerItem.益气丸, new_text)

func _on_shengzhan_minus_button_down():
	_change_self_sell_quantity(InventoryManagerItem.胜战锦囊, -1)

func _on_shengzhan_plus_button_down():
	_change_self_sell_quantity(InventoryManagerItem.胜战锦囊, 1)

func _on_shengzhan_input_text_changed(new_text:String):
	_on_self_sell_input_text_changed(InventoryManagerItem.胜战锦囊, new_text)

func _on_zhuzi_minus_button_down():
	_change_self_sell_quantity(InventoryManagerItem.诸子百家论集, -1)

func _on_zhuzi_plus_button_down():
	_change_self_sell_quantity(InventoryManagerItem.诸子百家论集, 1)

func _on_zhuzi_input_text_changed(new_text:String):
	_on_self_sell_input_text_changed(InventoryManagerItem.诸子百家论集, new_text)

func _on_zhenpin_minus_button_down():
	_change_self_sell_quantity(InventoryManagerItem.珍品礼盒, -1)

func _on_zhenpin_plus_button_down():
	_change_self_sell_quantity(InventoryManagerItem.珍品礼盒, 1)

func _on_zhenpin_input_text_changed(new_text:String):
	_on_self_sell_input_text_changed(InventoryManagerItem.珍品礼盒, new_text)
	


func _on_buy_button_focus_entered() -> void:
	pass
	#if buy_button.disabled==false:
		#if GameManager.haveMirror():
			#GameManager._engerge.startPreviewHp(costhp)


func _on_buy_button_focus_exited() -> void:
	if buy_button.disabled==false:
		GameManager._engerge.stopPreviewHP()
