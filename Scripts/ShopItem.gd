@tool
class_name  ShopItem
extends Control
#商品信息

const InventoryManagerName = "InventoryManager"
@export var autosave: bool = true
@export var to_inventory: String 

@onready var context = $frame/context
@onready var alreaysold = $frame/Alreaysold

@export var img:Texture2D:
	
	get:
		return img
	set(value):
		img=value
		if context!=null:
			context.texture=img
			#context.gre
		#if texture_rect!=null:
		#	texture_rect.texture=img
		
#	return {
#		"items": gained_items,
#		"money": money,
#		"population": population
#	}		
@onready var item_context = $frame/itemContext

@export var itemContext:String:
	get:
		return itemContext
	set(value):
		itemContext=value
		if itemContext.length()>0:
			if item_context!=null:
				item_context.show()
				item_context.text=value
		else:
			item_context.hide()
func set_Data(key,value):
	var itemname= InventoryManagerItem.item_by_enum(key)
	quantity=value
	txt_quantity.text=var_to_str(value)
	txt_quantity.show()
	var db:InventoryItem=InventoryManager.get_item_db(itemname)
	context.texture=load(db.icon)
	self.tooltip_text=db.name
	
	#var itemname= InventoryManagerItem.item_by_enum(key)
	var remainder = InventoryManager.add_item(GameManager.inventoryPackege, itemname, quantity, false)

	
const COIN = preload("res://Asset/coin.png")
const LABOR = preload("res://Asset/labor.png")	
func set_Money(_num):
	context.texture=COIN
	self.tooltip_text="金钱"
	txt_quantity.show()
	txt_quantity.text=var_to_str(_num)
@onready var txt_quantity = $frame/Quantity

func set_Labor(_num):
	context.texture=LABOR
	self.tooltip_text="人口"
	txt_quantity.show()
	txt_quantity.text=var_to_str(_num)
	
#const questManagerName = "QuestManager"		
# Called when the node enters the scene tree for the first time.
func _ready():
	
#	if get_tree().get_root().has_node(InventoryManagerName):
#		_inventoryManager = get_tree().get_root().get_node(InventoryManagerName)
	if isShop==false:
		return
	context.texture=img
	
	var itemname= InventoryManagerItem.item_by_enum(itemstype)
	var db:InventoryItem=InventoryManager.get_item_db(itemname)

	self.tooltip_text=db.name
	if isShop==true:
		refreshSold()
	#if get_tree().get_root().has_node(questManagerName):
	#	questManager = get_tree().get_root().get_node(questManagerName)

func refreshSold():
	var havedec=(itemstype==InventoryManagerItem.ItemEnum.洞察之镜 or itemstype==InventoryManagerItem.ItemEnum.獬豸圣像)
	var havesecret=(itemstype==InventoryManagerItem.ItemEnum.市井秘闻 or itemstype==InventoryManagerItem.ItemEnum.市井秘闻_续 or itemstype==InventoryManagerItem.ItemEnum.市井秘闻_终)
	var havewea=(itemstype==InventoryManagerItem.ItemEnum.雌雄双股剑 or itemstype==InventoryManagerItem.ItemEnum.青龙偃月刀 or itemstype==InventoryManagerItem.ItemEnum.丈八蛇矛)
	if havedec or havesecret or havewea: 
		
		var itemname= InventoryManagerItem.item_by_enum(itemstype)
		var _c=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,itemname)
		if _c>0:
			alreaysold.show()
		else:
			alreaysold.hide()

@export var quantity=1;
@export var isShop:bool=true
@export var itemstype:InventoryManagerItem.ItemEnum:
	
	get:
		return itemstype
	set(value):
		itemstype=value
		#itemname= InventoryManagerItem.item_by_enum(itemstype)
		#print(itemname)
		#context.texture=_inventoryManager.get_inventory_db(itemname).icon
#通过枚举获取值 并且将值传给txt
func getItem():
	print(to_inventory)
	var itemname= InventoryManagerItem.item_by_enum(itemstype)
	var remainder = InventoryManager.add_item(to_inventory, itemname, quantity, false)
	#if remove_collected and remainder == 0:
		#queue_free()
		#if questManager and questManager.is_quest_started():
		#	var quest = questManager.started_quest()
		#	var task = questManager.get_task_and_update_quest_state(quest, item_put, quantity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gui_input(event):
	
	if event is InputEventMouseButton and event.button_index==1:
		if isShop==false or GameManager.shopPanel==null:
			return;
		GameManager.shopPanel.selectGoods=self;
		var itemname= InventoryManagerItem.item_by_enum(itemstype)
		var properties:Array=InventoryManager.get_item_properties(itemname)
		var item=properties.filter(func(a):return a["name"]=="price")[0]
		var price=item["value"]
		item=properties.filter(func(a):return a["name"]=="detail")[0]
		var detail=item["value"]
		
		var index=0
		var havedec=(itemstype==InventoryManagerItem.ItemEnum.洞察之镜 or itemstype==InventoryManagerItem.ItemEnum.獬豸圣像)
		var havesecret=(itemstype==InventoryManagerItem.ItemEnum.市井秘闻 or itemstype==InventoryManagerItem.ItemEnum.市井秘闻_续 or itemstype==InventoryManagerItem.ItemEnum.市井秘闻_终)
		var havewea=(itemstype==InventoryManagerItem.ItemEnum.雌雄双股剑 or itemstype==InventoryManagerItem.ItemEnum.青龙偃月刀 or itemstype==InventoryManagerItem.ItemEnum.丈八蛇矛)
		if havedec==true:
			index=2
		elif  havesecret==true:
			index=3
		elif havewea==true:
			index=1
		if alreaysold.visible==true:
			GameManager.shopPanel.refreshAlreadySoldTxt(index)
			return
		#如果是三把武器，判断玩家是否有，如果有，则调用无法购买已售出的文本
		GameManager.shopPanel.refreshPage(price,detail)#价格和介绍
	#pass # Replace with function body.
