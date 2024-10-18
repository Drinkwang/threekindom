@tool
class_name  ShopItem
extends Control
#商品信息
var _inventoryManager
const InventoryManagerName = "InventoryManager"
@export var autosave: bool = true
#var to_inventory: String 

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
		
#const questManagerName = "QuestManager"		
# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().get_root().has_node(InventoryManagerName):
		_inventoryManager = get_tree().get_root().get_node(InventoryManagerName)
	context.texture=img
	#if get_tree().get_root().has_node(questManagerName):
	#	questManager = get_tree().get_root().get_node(questManagerName)
@export var quantity=1;
var itemname
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

	var to_inventory= InventoryManagerItem.item_by_enum(itemstype)
	var remainder = _inventoryManager.add_item(to_inventory, itemname, quantity, autosave)
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
		GameManager.shopPanel.selectGoods=self;
		itemname= InventoryManagerItem.item_by_enum(itemstype)
		var properties:Array=_inventoryManager.get_item_properties(itemname)
		var item=properties.filter(func(a):return a["name"]=="price")[0]
		var price=item["value"]
		item=properties.filter(func(a):return a["name"]=="detail")[0]
		var detail=item["value"]
		GameManager.shopPanel.refreshPage(price,detail)#价格和介绍
	#pass # Replace with function body.
