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
	var canBuy = GameManager.sav.merMustBuy or GameManager.sav.randomIndex % 2 == 0
	if GameManager.sav.isSoldItem==false and haveNum>=1 and canBuy:
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

@onready var buy_back_button = $backTxt/buyBackButton
#var costhp=15
func confireSold():
	
	GameManager.sav.coin=GameManager.sav.coin+int(GameManager.SoldCoin)
	GameManager.sav.isSoldItem=true
	for item_type in useItems:
			if useItems[item_type] > 0:  # 只处理消耗数量大于 0 的道具
		
				InventoryManager._remove_item(GameManager.inventoryPackege,item_type,useItems[item_type])
	useItems=[]
	AchievementManager.set_achievement("NEW_ACHIEVEMENT_1_7")
	back_txt.text="当前商人没有需要从你手中收购商品的需要，请改日再来！"
	buy_back_button.disabled=true
	


func _on_buy_button_focus_entered() -> void:
	pass
	#if buy_button.disabled==false:
		#if GameManager.haveMirror():
			#GameManager._engerge.startPreviewHp(costhp)


func _on_buy_button_focus_exited() -> void:
	if buy_button.disabled==false:
		GameManager._engerge.stopPreviewHP()
