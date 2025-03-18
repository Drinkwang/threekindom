@tool
class_name  ShopItem
extends Control
#商品信息
var _inventoryManager:InventoryManager
const InventoryManagerName = "InventoryManager"
@export var autosave: bool = true
@export var to_inventory: String 

@onready var context = $frame/context

@export var img:Texture2D:
	
	get:
		return img
	set(value):
		img=value
		if context!=null:
			context.texture=img
		#if texture_rect!=null:
		#	texture_rect.texture=img
		
#	return {
#		"items": gained_items,
#		"money": money,
#		"population": population
#	}		
func set_Data(key,value):
	var itemname= InventoryManagerItem.item_by_enum(key)
	quantity=value
	txt_quantity.text=var_to_str(value)
	txt_quantity.show()
	var db:InventoryItem=_inventoryManager.get_item_db(itemname)
	context.texture=load(db.icon)
	self.tooltip_text=db.name
	
	#var itemname= InventoryManagerItem.item_by_enum(key)
	var remainder = _inventoryManager.add_item(GameManager.inventoryPackege, itemname, quantity, false)

	
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

	if get_tree().get_root().has_node(InventoryManagerName):
		_inventoryManager = get_tree().get_root().get_node(InventoryManagerName)
	if isShop==false:
		return
	context.texture=img
	
	var itemname= InventoryManagerItem.item_by_enum(itemstype)
	var db:InventoryItem=_inventoryManager.get_item_db(itemname)

	self.tooltip_text=db.name
	#if get_tree().get_root().has_node(questManagerName):
	#	questManager = get_tree().get_root().get_node(questManagerName)
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
	var remainder = _inventoryManager.add_item(to_inventory, itemname, quantity, false)
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
		if isShop==false:
			return;
		GameManager.shopPanel.selectGoods=self;
		var itemname= InventoryManagerItem.item_by_enum(itemstype)
		var properties:Array=_inventoryManager.get_item_properties(itemname)
		var item=properties.filter(func(a):return a["name"]=="price")[0]
		var price=item["value"]
		item=properties.filter(func(a):return a["name"]=="detail")[0]
		var detail=item["value"]
		GameManager.shopPanel.refreshPage(price,detail)#价格和介绍
	#pass # Replace with function body.
