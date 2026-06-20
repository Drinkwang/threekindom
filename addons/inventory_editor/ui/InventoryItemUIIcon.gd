# Example implementation for inventory item icon to demonstrate functionality of InventoryEditor : MIT License
# @author Vladimir Petrenko
@tool
extends TextureRect

const InventoryManagerName = "InventoryManager"
var _inventoryManager

var _item
var _item_db: InventoryItem

@export var inventory: String # inventory_uuid
@export var type: String # type_uuid
@export var index: int = -1
@export var show_quantity: bool = true

@onready var _quantity_ui = $Quantity as Label

func set_inventory_manager(inv_uuid, manager) -> void:
	inventory = inv_uuid
	_inventoryManager = manager
	_init_connections()
	_update_item()

func _ready() -> void:
	if get_tree().get_root().has_node(InventoryManagerName):
		_inventoryManager = get_tree().get_root().get_node(InventoryManagerName)
		_init_connections()
		_update_item()

func _init_connections() -> void:
	if _inventoryManager:
		if not _inventoryManager.inventory_changed.is_connected(_on_inventory_changed):
			_inventoryManager.inventory_changed.connect(_on_inventory_changed)

func _on_inventory_changed(inv_uuid: String) -> void:
	if inventory == inv_uuid:
		_update_item()

func _update_item() -> void:
	if show_quantity:
		_quantity_ui.show()
	else:
		_quantity_ui.hide()

	if _inventoryManager and index >= 0:
		var items = _inventoryManager.get_inventory_items(inventory)
		if items and index < items.size():
			_item = items[index]
			if items[index].has("item_uuid"):
				_item_db = _inventoryManager.get_item_db(items[index].item_uuid)


				if _item.item_uuid==InventoryManagerItem.市井秘闻 or _item.item_uuid==InventoryManagerItem.市井秘闻_终 or _item.item_uuid==InventoryManagerItem.市井秘闻_续:
					_item = null
					_item_db = null
					texture = null
					_quantity_ui.text = "0"
					return

				if _item_db != null and _item_db.icon != null:
					texture = load(_item_db.icon)
				if _item.quantity:
					_quantity_ui.text = str(_item.quantity)
					var properties:Array=_item_db.properties


					var detail=properties.filter(func(a):return a["name"]=="detail")[0]
					var _context
					if tr(detail["value"]).length()>0:

						_context=tr(_item_db.name)+":"+tr(detail["value"])
					else:
						_context=tr(_item_db.name)+":"+"?"

					#var stock_info = ""
					#if _item_db.uuid == InventoryManagerItem.胜战锦囊 or _item_db.uuid == InventoryManagerItem.益气丸 or _item_db.uuid == InventoryManagerItem.诸子百家论集 or _item_db.uuid == InventoryManagerItem.珍品礼盒:
					#	stock_info = "\n(" + tr("最大携带数量：") + str(_item_db.stacksize) + ")"

					#done
					if _item_db.uuid == InventoryManagerItem.益气丸 and InventoryManager.has_item(InventoryManagerItem.饥蛊骨签):
						_context = _context.replace("40", "60")
						TooltipManager.register_tooltip(self,_context+tr("【已强化】"))


					elif _item_db.uuid == InventoryManagerItem.胜战锦囊 and InventoryManager.has_item(InventoryManagerItem.迷魂木筒):
						_context = _context.replace("40", "50")
						TooltipManager.register_tooltip(self,_context+tr("【已强化】"))

					#done
					elif _item_db.uuid == InventoryManagerItem.诸子百家论集 and InventoryManager.has_item(InventoryManagerItem.礼记笺疏):
						TooltipManager.register_tooltip(self,_context+tr("【已强化】"))
					#done
					elif _item_db.uuid == InventoryManagerItem.珍品礼盒 and InventoryManager.has_item(InventoryManagerItem.黄麻药囊):
						_context = _context.replace("15", "30")
						TooltipManager.register_tooltip(self,_context+tr("【已强化】"))

					elif(_item_db.type_uuid=="947b1cbf-7c4f-4eaa-8853-058ef1784615"):

						TooltipManager.register_tooltip(self,_context+tr("【已装备】"))
					else:
						TooltipManager.register_tooltip(self,_context)
				else:
					TooltipManager.unregister_tooltip(self)
					_item = null
					_item_db = null
					texture = null
					_quantity_ui.text = "0"

func _get_drag_data(position: Vector2):
	var drag_texture = TextureRect.new()
	drag_texture.ignore_texture_size = true
	drag_texture.size = Vector2(size)
	drag_texture.texture = texture

	var preview = Control.new()
	preview.add_child(drag_texture)
	drag_texture.position = -0.5 * drag_texture.size
	# https://godotengine.org/qa/30298/drag_preview-get-hide-under-canvaslayer
	set_drag_preview(preview)

	var data = {
		"type": "InventoryItem",
		"inventory": inventory,
		"index": index,
		"item": _item,
		"item_db": _item_db
	}
	return data

func _can_drop_data(position: Vector2, data) -> bool:
	if data.has("type") and data["type"] == "InventoryItem":
		if type == null:
			return true
		else:
			return type == data["item_db"].type_uuid
	return false

func _drop_data(position: Vector2, data) -> void:
	if _inventoryManager and data.has("index"):
		_inventoryManager.move_item(data["inventory"], data["index"], inventory, index)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.double_click:
		if _item_db is InventoryRecipe:
			if _inventoryManager.is_craft_possible(inventory, _item_db.uuid):
				_inventoryManager.craft_item(inventory, _item_db.uuid)
		#print("aaaa i be doubleclick  使用道具"+_item_db.name)

		if 	InventoryManagerItem.益气丸==_item_db.uuid:

			InventoryManager._remove_item(GameManager.inventoryPackege,InventoryManagerItem.益气丸,1)
			#GameManager.triedPanelDone.emit()
			if GameManager.sav.hp>60:
				GameManager.recoverHp(100-GameManager.sav.hp)
			else:
				if InventoryManager.has_item(InventoryManagerItem.饥蛊骨签):
					GameManager.recoverHp(50)
				else:
					GameManager.recoverHp(40)

			SoundManager.play_sound(sounds.tunyan)
