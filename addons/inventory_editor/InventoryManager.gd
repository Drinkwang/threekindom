# Service to manage game inventories and items
# Please add this script to Project -> Project Settings -> AutoLoad
# to use this manager as singleton
# @author Vladimir Petrenko
@tool
extends Node

signal inventory_changed(inventory_uuid)

var _db = InventoryData.new()#判断问题所在 装备放在非装备背包
var player

var _path_to_type = "user://inventory.tres"


func ready(db: InventoryData) -> void:
	_db = db
	_init_db()

func _ready() -> void:
	_db.init_data()
	load_data()

func _init_db() -> void:
	if not _db.inventory_stacks_changed.is_connected(_on_inventory_stacks_changed):
		_db.inventory_stacks_changed.connect(_on_inventory_stacks_changed)

func _on_inventory_stacks_changed(inventory) -> void:
	emit_signal("inventory_changed", inventory.uuid)

func load_data() -> void:
	pass
	#if FileAccess.file_exists(_path_to_type):
	#	var loaded_data = load(_path_to_type)
	#	if loaded_data:
	#		GameManager.sav._data.inventories = loaded_data.inventories

func save() -> void:
	pass
	#var state = ResourceSaver.save(GameManager.sav._data, _path_to_type)
	#if state != OK:
	#	printerr("Can't save inventories data")

func reset_data() -> void:
	GameManager.sav._data.reset()
	save()

func get_inventory_by_name_items(inventory_name: String) -> Array:
	var inventory = _db.get_inventory_by_name(inventory_name)
	return get_inventory_items(inventory.uuid)

func get_inventory_items(inventory_uuid: String) -> Array:
	var items = []
	if GameManager.sav==null:
		return items
	if GameManager.sav._data.inventories.has(inventory_uuid):
		items = GameManager.sav._data.inventories[inventory_uuid]
	return items

func clear_inventory_by_name(inventory_name: String) -> void:
	var inventory = _db.get_inventory_by_name(inventory_name)
	clear_inventory(inventory.uuid)

func clear_inventory(inventory_uuid: String) -> void:
	var items
	if GameManager.sav._data.inventories.has(inventory_uuid):
		items = GameManager.sav._data.inventories[inventory_uuid]
		for index in range(items.size()):
			items[index] = {}
		emit_signal("inventory_changed", inventory_uuid)

func add_item_by_name(inventory_name: String, item_name: String, quantity: int = 1) -> int:
	var inventory = _db.get_inventory_by_name(inventory_name)
	var item = _db.get_inventory_by_name(item_name)
	return add_item(inventory.uuid, item.uuid, quantity)

func add_item(inventory_uuid: String, item_uuid: String, quantity: int = 1, do_save = true) -> int:
	if(quantity < 0):
		printerr("Can't add negative number of items")
	var remainder = 0 
	if(quantity < 0):
		printerr("Can't add negative number of items")
		return remainder
	var db_inventory = _db.get_inventory_by_uuid(inventory_uuid)
	var db_item = _db.get_item_by_uuid(item_uuid)
	if not db_item:
		printerr("Can't find item in itemlist")
		return remainder
	var is_hidden_item=false
	if item_uuid==InventoryManagerItem.市井秘闻||item_uuid==InventoryManagerItem.市井秘闻_终||item_uuid==InventoryManagerItem.市井秘闻_续:
		is_hidden_item=true
		
	if is_hidden_item:
		return _add_hidden_item(inventory_uuid, item_uuid, quantity, save)
	if not GameManager.sav._data.inventories.has(inventory_uuid):
		create_inventory(inventory_uuid)
	_add_item_with_quantity(db_inventory, db_item, quantity)
	if do_save:
		save()
	emit_signal("inventory_changed", inventory_uuid)
	return remainder



func get_hidden_item_quantity(inventory_uuid: String, item_uuid: String) -> int:
	var hidden_key = "_hidden_" + inventory_uuid
	if not GameManager.sav._data.inventories.has(hidden_key):
		return 0
	
	for hidden_item in GameManager.sav._data.inventories[hidden_key]:
		if hidden_item.item_uuid == item_uuid:
			return hidden_item.quantity
	return 0

func _add_hidden_item(inventory_uuid: String, item_uuid: String, quantity: int, save) -> int:
	# 使用特殊的隐藏存储键
	var hidden_key = "_hidden_" + inventory_uuid
	if not GameManager.sav._data.inventories.has(hidden_key):
		GameManager.sav._data.inventories[hidden_key] = []
	
	var hidden_items = GameManager.sav._data.inventories[hidden_key]
	
	# 查找是否已存在该隐藏物品
	var item = null
	for hidden_item in hidden_items:
		if hidden_item.item_uuid == item_uuid:
			item = hidden_item
			break
	
	if item:
		item.quantity += quantity
	else:
		hidden_items.append({"item_uuid": item_uuid, "quantity": quantity})
	
	if save:
		save()
	
	# 隐藏物品不触发UI更新信号，但可以触发内部逻辑
	return 0  # 隐藏物品不需要处理remainder

func create_inventory(inventory_uuid:String) -> void:
	var inventory_db = get_inventory_db(inventory_uuid) as InventoryInventory
	var stacks = []
	for index in range(inventory_db.stacks):
		stacks.append({})
	GameManager.sav._data.inventories[inventory_uuid] = stacks

func _add_item_with_quantity(db_inventory: InventoryInventory, db_item: InventoryItem, quantity: int = 1) -> int:
	var stacks_with_item_indexes = _stacks_with_item_indexes(db_inventory.uuid, db_item.uuid)
	for stack_index in stacks_with_item_indexes:
		var space = db_item.stacksize - GameManager.sav._data.inventories[db_inventory.uuid][stack_index].quantity
		if space >= quantity:
			GameManager.sav._data.inventories[db_inventory.uuid][stack_index].quantity = GameManager.sav._data.inventories[db_inventory.uuid][stack_index].quantity + quantity
			quantity = 0
		else:
			GameManager.sav._data.inventories[db_inventory.uuid][stack_index].quantity = db_item.stacksize
			quantity = quantity - space
	var stacks_empty_indexes = _stacks_empty_indexes(db_inventory)
	if quantity > 0 and stacks_with_item_indexes.size() < db_item.stacks and stacks_empty_indexes.size() > 0:
		GameManager.sav._data.inventories[db_inventory.uuid][stacks_empty_indexes[0]]= {"item_uuid": db_item.uuid, "quantity": 0}
		quantity = _add_item_with_quantity(db_inventory, db_item, quantity)
	return quantity

func _stacks_with_item_indexes(inventory_uuid: String, db_item_uuid: String) -> Array:
	if not GameManager.sav._data.inventories.has(inventory_uuid):
		return []
	var stacks = GameManager.sav._data.inventories[inventory_uuid]
	var stacks_indexes: Array = []
	for index in range(stacks.size()):
		if stacks[index].has("item_uuid") and stacks[index].item_uuid == db_item_uuid:
			stacks_indexes.append(index)
	return stacks_indexes

func _stacks_empty_indexes(db_inventory: InventoryInventory) -> Array:
	var stacks = GameManager.sav._data.inventories[db_inventory.uuid]
	var stacks_indexes: Array = []
	for index in range(stacks.size()):
		if stacks[index].is_empty():
			stacks_indexes.append(index)
	return stacks_indexes

func get_item_properties_by_name(item_name: String) -> Array:
	return _db.get_item_by_name(item_name).properties

func get_item_properties(item_uuid: String) -> Array:
	return _db.get_item_by_uuid(item_uuid).properties

func get_item_db(item_uuid: String) -> InventoryItem:
	return _db.get_item_by_uuid(item_uuid)

func get_type_db(type_uuid: String) -> InventoryType:
	return _db.get_type_by_uuid(type_uuid)

func get_inventory_db(inventory_uuid: String) -> InventoryInventory:
	return _db.get_inventory_by_uuid(inventory_uuid)

func remove_item_by_name(inventory_name: String, item_name: String, quantity: int = 1) -> void:
	var inventory = _db.get_inventory_by_name(inventory_name)
	var item = _db.get_inventory_by_name(item_name)
	remove_item(inventory.uuid, item.uuid, quantity)

func remove_item(inventory_uuid: String, item_uuid: String, quantity: int = 1, do_save = true) -> int:
	if(quantity < 0):
		printerr("Can't remove negative number of items")
	_remove_item(inventory_uuid, item_uuid, quantity)
	if do_save:
		save()
	emit_signal("inventory_changed", inventory_uuid)
	return quantity

func remove_all_items(inventory_uuid: String, item_uuid: String, do_save = true) -> int:
	var quantity = inventory_item_quantity(inventory_uuid, item_uuid)
	_remove_item(inventory_uuid, item_uuid, quantity)
	if do_save:
		save()
	emit_signal("inventory_changed", inventory_uuid)
	return quantity

func _remove_item(inventory_uuid: String, item_uuid: String, quantity: int) -> int:
	var stacks_with_item_indexes = _stacks_with_item_indexes(inventory_uuid, item_uuid)
	if stacks_with_item_indexes.size() <= 0:
		return 0
	var index = stacks_with_item_indexes[stacks_with_item_indexes.size() - 1]
	var stack_quantity = GameManager.sav._data.inventories[inventory_uuid][index].quantity
	if stack_quantity > quantity:
		GameManager.sav._data.inventories[inventory_uuid][index].quantity = GameManager.sav._data.inventories[inventory_uuid][index].quantity - quantity
		quantity = 0
		#emit_signal("inventory_changed", inventory_uuid)
	else:
		quantity = quantity - GameManager.sav._data.inventories[inventory_uuid][index].quantity
		GameManager.sav._data.inventories[inventory_uuid][index] = {}
	if stacks_with_item_indexes.size() > 0 and quantity > 0:
		remove_item(inventory_uuid, item_uuid, quantity)
	emit_signal("inventory_changed", inventory_uuid)	
	return quantity

func move_item_by_names(inventory_name_from: String, from_index: int, inventory_name_to: String, to_index: int) -> void:
	var inventory_from = _db.get_inventory_by_name(inventory_name_from)
	var inventory_to = _db.get_inventory_by_name(inventory_name_to)
	move_item(inventory_from.uuid, from_index, inventory_to.uuid, to_index)

func move_item(inventory_uuid_from: String, from_index: int, inventory_uuid_to: String, to_index: int) -> void:
	if not GameManager.sav._data.inventories.has(inventory_uuid_to):
		create_inventory(inventory_uuid_to)
	if GameManager.sav._data.inventories.has(inventory_uuid_from) and GameManager.sav._data.inventories.has(inventory_uuid_to):
		if inventory_uuid_from == inventory_uuid_to:
			_move_in_same_inventory(inventory_uuid_from, from_index, to_index)
		else:
			_move_to_other_inventory(inventory_uuid_from, from_index, inventory_uuid_to, to_index)

func _move_in_same_inventory(inventory_uuid: String, from_index: int, to_index: int) -> void:
		var items = GameManager.sav._data.inventories[inventory_uuid]
		var from = items[from_index]
		var to = items[to_index]
		items[to_index] = from
		items[from_index] = to
		emit_signal("inventory_changed", inventory_uuid)

func _move_to_other_inventory(inventory_uuid_from: String, from_index: int, inventory_uuid_to: String, to_index: int) -> void:
	var items_from = GameManager.sav._data.inventories[inventory_uuid_from]
	var items_to = GameManager.sav._data.inventories[inventory_uuid_to]
	var item_from = items_from[from_index]
	var item_to = items_to[to_index]

	if items_to[to_index].has("item_uuid"):
		items_to[to_index] = item_from
		items_from[from_index] = item_to
	else:
		items_to[to_index] = item_from
		items_from[from_index] = {}
	emit_signal("inventory_changed", inventory_uuid_from)
	emit_signal("inventory_changed", inventory_uuid_to)

func inventory_has_item_by_name(inventory_name: String, item_name: String) -> bool:
	return inventory_item_quantity_by_name(inventory_name, item_name) > 0

func inventory_has_item(inventory_uuid: String, item_uuid: String) -> bool:
	return inventory_item_quantity(inventory_uuid, item_uuid) > 0

func inventory_item_quantity_by_name(inventory_name: String, item_name: String) -> int:
	var inventory = _db.get_inventory_by_name(inventory_name)
	var item = _db.get_inventory_by_name(item_name)
	return inventory_item_quantity(inventory.uuid, item.uuid)

func inventory_item_quantity(inventory_uuid: String, item_uuid: String) -> int:
	
	if item_uuid==InventoryManagerItem.市井秘闻||item_uuid==InventoryManagerItem.市井秘闻_终||item_uuid==InventoryManagerItem.市井秘闻_续:
		return get_hidden_item_quantity(inventory_uuid,item_uuid)
	var quantity = 0
	
	if GameManager.sav!=null and GameManager.sav._data.inventories.has(inventory_uuid):
		var items = GameManager.sav._data.inventories[inventory_uuid]
		var item
		for index in range(items.size()):
			if items[index].has("item_uuid") and items[index].item_uuid == item_uuid:
				item = items[index]
				break
		if item and item.quantity:
			quantity = item.quantity
	return quantity

func has_item_by_name(item_name: String) -> bool:
	var item = _db.get_inventory_by_name(item_name)
	return has_item_quantity(item.uuid) > 0

func has_item(item_uuid: String) -> bool:
	return has_item_quantity(item_uuid) > 0

func has_item_quantity_by_name(item_name: String) -> int:
	var item = _db.get_inventory_by_name(item_name)
	return has_item_quantity(item.uuid)

func has_item_quantity(item_uuid: String) -> int:
	var quantity = 0
	for items in GameManager.sav._data.inventories.values():
		var item
		for index in range(items.size()):
			if items[index].has("item_uuid") and items[index].item_uuid == item_uuid:
				item = items[index]
				break
		if item and item.quantity:
			quantity = item.quantity
	return quantity

func is_craft_possible(inventory_uuid, recipe_uuid) -> bool:
	var recipe_db = get_item_db(recipe_uuid)
	for ingridient in recipe_db.ingredients:
		if ingridient.quantity > inventory_item_quantity(inventory_uuid, ingridient.uuid):
			return false
	return true

func craft_item(inventory_uuid, recipe_uuid) -> void:
	var recipe_db = get_item_db(recipe_uuid)
	for ingridient in recipe_db.ingredients:
		remove_item(inventory_uuid, ingridient.uuid, ingridient.quantity, false)
	if inventory_has_item(inventory_uuid, recipe_db.item):
		add_item(inventory_uuid, recipe_db.item, 1, false)
		remove_item(inventory_uuid, recipe_db.uuid, 1)
	elif inventory_item_quantity(inventory_uuid, recipe_db.uuid) > 0:
		remove_item(inventory_uuid, recipe_db.uuid, 1, false)
		add_item(inventory_uuid, recipe_db.item, 1)
	else:
		var index = remove_item(inventory_uuid, recipe_db.uuid, 1)
		GameManager.sav._data.inventories[inventory_uuid][index] = {"item_uuid": recipe_db.item, "quantity": 1}
	emit_signal("inventory_changed", inventory_uuid)

func canUseItemNum():
	var num1=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.益气丸)
	var num2=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.胜战锦囊)
	var num3=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.诸子百家论集)
	var num4=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.珍品礼盒)
	return num1+num2+num3+num4

func costItemRandom(_cost):
	var items=[
		{"type": InventoryManagerItem.益气丸, "count": InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.益气丸)},
		{"type": InventoryManagerItem.胜战锦囊, "count": InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.胜战锦囊)},
		{"type": InventoryManagerItem.诸子百家论集, "count": InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.诸子百家论集)},
		{"type": InventoryManagerItem.珍品礼盒, "count": InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.珍品礼盒)}
	]
	var cost=_cost
	

	var consumed = {
		InventoryManagerItem.益气丸: 0,
		InventoryManagerItem.胜战锦囊: 0,
		InventoryManagerItem.诸子百家论集: 0,
		InventoryManagerItem.珍品礼盒: 0
	}
	while  cost>0:
		var available_items = items.filter(func(item): return item.count > 0)
		var random_item = available_items[randi() % available_items.size()]
		random_item.count -= 1
		consumed[random_item.type] += 1

		cost=cost-1;		
	return consumed
