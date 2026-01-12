extends Control
class_name ShopPanel
@onready var detail = $detail
var selectGoods:ShopItem

@onready var back_txt = $backTxt
@onready var hearsay = $HBoxContainer2/xiaodao

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
		GameManager.SoldItemStr=tr("我将以%d金收购你手上的")%GameManager.SoldCoin+" ["+GameManager.SoldItemStr+"]"
		back_txt.show()
		#
		
	else:
		back_txt.hide()
	
	var haveone=((InventoryManager.get_hidden_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.市井秘闻) )>0)	
	var havetwo=((InventoryManager.get_hidden_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.市井秘闻_续) )>0)
	var havethree=((InventoryManager.get_hidden_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.市井秘闻_终) )>0)	
	if not haveone and GameManager.sav.have_event["completeTask1"]==true:#没有1 然后特定事件
		hearsay.show()
		hearsay.itemstype=InventoryManagerItem.ItemEnum.市井秘闻	
		hearsay.img=load("res://Asset/items/密谈3.png")
		#hearsay.itemstype=InventoryManagerItem.ItemEnum.市井秘闻_续
		#waitTime
		#if hearsay.alreaysold.visible
		hearsay.itemContext="1"
	elif haveone and !havetwo and GameManager.sav.have_event["Factionalization"]==true:#拥有市井1 没有2 然后特定事件
		hearsay.show()	
		hearsay.itemstype=InventoryManagerItem.ItemEnum.市井秘闻_续
		hearsay.img=load("res://Asset/items/密谈2.png")
		hearsay.itemContext="2"
	elif havetwo and GameManager.sav.have_event["庆功宴是否举办"]==true:#拥有市井2 没有3 然后特定事件
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
			result.append(tr("%sx%d") % [item_name, consumed[item_type]])
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
#var befunc		
func _on_buy_button_down():
	if(GameManager.sav.coin>=(price as int) and selectGoods!=null):
		SoundManager.play_sound(sounds.buysellsound)
		selectGoods.getItem()
		GameManager.sav.coin=GameManager.sav.coin-price
		if selectGoods.itemstype==InventoryManagerItem.ItemEnum.市井秘闻:
			#展示内部剧情
				GameManager.hearsayBeforeNode=SceneManager.roomNode.Shop
				GameManager.restFadeScene=SceneManager.GOVERNMENT_BUILDING
				SoundManager.stop_music()
				GameManager.hearsayID=1
				GameManager.restLabel=tr("你在徐州商人花钱买到一则秘闻。陶谦已逝，刘备新掌徐州，城中却暗潮汹涌。近日，陈登与糜竺密会厅堂，窃窃私语，似在筹谋未来。市井耳目偷听二人低语，揭开权臣心机一角，细闻之下，耐人寻味……")
				#商人售卖利益 
				GameManager._rest(false)
		elif selectGoods.itemstype==InventoryManagerItem.ItemEnum.市井秘闻_续:
				GameManager.hearsayBeforeNode=SceneManager.roomNode.Shop
				GameManager.restFadeScene=SceneManager.GOVERNMENT_BUILDING
				SoundManager.stop_music()
				GameManager.hearsayID=2
				GameManager.restLabel=tr("你在徐州商人重金购得一则秘闻。刘备新主徐州，粮荒民怨未平，陈登与糜竺却针锋相对。昨夜，二人争执后各归私邸，似有异样。市井探子窃闻两人低语，令人心惊……")
				#商人售卖利益 
				GameManager._rest(false)
		elif selectGoods.itemstype==InventoryManagerItem.ItemEnum.市井秘闻_终:
				GameManager.hearsayBeforeNode=SceneManager.roomNode.Shop
				GameManager.restFadeScene=SceneManager.GOVERNMENT_BUILDING
				SoundManager.stop_music()
				GameManager.hearsayID=3
				GameManager.restLabel=tr("你于徐州商人重金购得一则秘闻。时值196年，刘备新主徐州，袁术兵临城下，城中暗流汹涌。昨夜，陈登独坐议事厅，灯下沉吟；糜竺踱步府邸庭院，月下低吟。市井耳目窃闻二人心声，权谋隐志，令人暗叹……")
				#商人售卖利益 
				GameManager._rest(false)
		
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
func _on_texture_button_2_button_down():
	GameManager.currenceScene.res_panel.position.x=1404
	GameManager.currenceScene.res_panel.position.y=611
	GameManager.currenceScene.res_panel.scale=Vector2(1,1)
	self.hide()
	if GameManager.sav.have_event["boss战开始"]==true and GameManager.sav.caobaocardgame==4:
		GameManager.currenceScene.enterBlackMerchant()

func settleAfter():
	pass#后续可能会修改
	#refreshAlreadySoldTxt
	


func _on_Sold_button_down():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,"是否售出商品")

@onready var buy_back_button = $backTxt/buyBackButton

func confireSold():
	GameManager.sav.coin=GameManager.sav.coin+int(GameManager.SoldCoin)
	GameManager.sav.isSoldItem=true
	for item_type in useItems:
			if useItems[item_type] > 0:  # 只处理消耗数量大于 0 的道具
		
				InventoryManager._remove_item(GameManager.inventoryPackege,item_type,useItems[item_type])
	useItems=[]
	back_txt.text="当前商人没有需要从你手中收购商品的需要，请改日再来！"
	buy_back_button.disabled=true
	
