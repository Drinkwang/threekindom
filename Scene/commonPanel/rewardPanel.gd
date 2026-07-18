
extends CanvasLayer
#extends InventoryUI
class_name rewardPanel
const victoryPng = preload("res://Asset/other/胜利.png")
const failPng = preload("res://Asset/other/骷髅头.png")
const maPng = preload("res://Asset/人物/马儿.png")
const REWARD_FLIGHT_DURATION := 0.32
const REWARD_FLIGHT_STAGGER := 0.025
const REWARD_FLIGHT_SETTLE_DELAY := 0.48
const REWARD_FLIGHT_ICON_SIZE := Vector2(64, 64)
const REWARD_SOUND_SECONDARY_DELAY := 0.10
const REWARD_SOUND_SECONDARY_VOLUME_DB := -4.0
#@onready var title = $Control/PanelContainer/MarginContainer/VBoxContainer/title

@onready var img =$Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/img
@onready var grid = $Control/PanelContainer/MarginContainer/VBoxContainer/Margin/Grid

@export var txt:Texture2D:
	get:
		return txt
	set(value):
		txt=value
		if(img!=null):
			img.texture=txt

@export_multiline var contextEX:String:
	get:
		return contextEX
	set(value): 
		contextEX=value
		if(context!=null):
			context.text=contextEX

@export var titleEX:String:
	get:
		return titleEX
	set(value):
		titleEX=value
		if(title!=null):
			title.text=titleEX
		
@onready var context = $Control/PanelContainer/MarginContainer/VBoxContainer/context2

@onready var title = $Control/PanelContainer/MarginContainer/VBoxContainer/title

var _reward_flight_entries: Array[Dictionary] = []
var _reward_flight_canvas: CanvasLayer
var _pending_item_rewards: Dictionary = {}
var _pending_coin := 0
var _pending_labor := 0
var _pending_hp_limit := 0
var _is_collecting := false
var _rewards_applied := false



# Called when the node enters the scene tree for the first time.
func _ready():
	PanelManager.rewardNode=self
	if(context!=null):
		context.text=contextEX
	if(title!=null):
		title.text=titleEX		
		
	if(txt!=null):
		img.texture=txt
	#hide()
	await get_tree().create_timer(0.25).timeout
	canclick = true	
	
@export var canclick=false	
	
@onready var imgTarget = $"骷髅头"

#@onready var grid = $Control/PanelContainer/MarginContainer/VBoxContainer/Margin/Grid

func showTitileReward(context,item,addAfter=true):
	imgTarget.texture=victoryPng
	self.show()
	var titleContext=context
	if addAfter==true:
		titleContext=titleContext+tr(",获得以下道具:")
	title.text=titleContext	

	_clear_view()
	getItemSound()
	if item.items!=null:
		for key in item.items.keys():
			var _count=item.items[key]
			var item_ui:ShopItem = DaojuItem.instantiate()
			item_ui.isShop=false
			_grid_ui.add_child(item_ui)
			item_ui.set_Data(key,_count)
			_queue_item_reward(key, _count)
			_register_reward_flight(item_ui, "item", _count)
		#获取道具

	#var getMoney=
	if item.money>0:
		var itemMoney_ui:ShopItem = DaojuItem.instantiate()
		itemMoney_ui.isShop=false
		_grid_ui.add_child(itemMoney_ui)
		itemMoney_ui.set_Money(item.money)	
		_register_reward_flight(itemMoney_ui, "coin", item.money)
		_pending_coin += item.money
		#获取钱
		
	if item.population>0:
		var itempop_ui:ShopItem = DaojuItem.instantiate()
		itempop_ui.isShop=false
		_grid_ui.add_child(itempop_ui)
		itempop_ui.set_Labor(item.population)	
		_register_reward_flight(itempop_ui, "labor", item.population)
		#获取民力
		_pending_labor += item.population
	if item.get("hplimit", 0)>0:
		var itemHpLimit_ui:ShopItem = DaojuItem.instantiate()
		itemHpLimit_ui.isShop=false
		_grid_ui.add_child(itemHpLimit_ui)
		itemHpLimit_ui.set_HpLimit(item.hplimit)
		_register_reward_flight(itemHpLimit_ui, "energy", item.hplimit)
		_pending_hp_limit += item.hplimit
	title.text=titleContext

@export var DaojuItem: PackedScene	
@onready var _grid_ui = $Control/PanelContainer/MarginContainer/VBoxContainer/Margin/Grid

func getItemSound():
	#var ranValue=randi_range(1,3)

	SoundManager.play_sound(sounds.GOOD_THING)

func showReward(item):
	imgTarget.texture=victoryPng
	self.show()
	getItemSound()

	var titleContext=""
	if(coinCost>0 and soilderCost>0):
		titleContext=tr(sucuussContext)+tr(TxtbothCost).format({"coin":str(coinCost),"soilder":str(soilderCost)})
		pass
	elif coinCost>0 and soilderCost==0:
		titleContext=tr(sucuussContext)+tr(TxtcoinCost).format({"coin":str(coinCost)})
	elif coinCost==0 and soilderCost>0:
		titleContext=tr(sucuussContext)+tr(TxtSoiderCost).format({"soilder":str(soilderCost)})
	elif coinCost==0 and soilderCost==0:
		titleContext=tr(sucuussContext)+tr(TxtNoCost)
	var goumaStr=""
	if GameManager.sav.have_event["吕布之怒"]==false and GameManager.sav.have_event["夏侯偷马"]==true and GameManager.sav.endPath==GameManager.endPath.xiaopei:
		goumaStr=tr("【截获吕布购马队，战利品升级】")
	titleContext=titleContext+goumaStr+tr(",获得以下道具:")
	#通过item增加并实际获得之
	_clear_view()
	
#	return {
#		"items": gained_items,
#		"money": money,
#		"population": population
#	}			
	for key in item.items.keys():
		var _count=item.items[key]
		var item_ui:ShopItem = DaojuItem.instantiate()
		item_ui.isShop=false
		_grid_ui.add_child(item_ui)
		item_ui.set_Data(key,_count)
		_queue_item_reward(key, _count)
		_register_reward_flight(item_ui, "item", _count)
		#获取道具

	if item.money>0:
		var itemMoney_ui:ShopItem = DaojuItem.instantiate()
		itemMoney_ui.isShop=false
		_grid_ui.add_child(itemMoney_ui)
		itemMoney_ui.set_Money(item.money)	
		_register_reward_flight(itemMoney_ui, "coin", item.money)
		_pending_coin += item.money
		#获取钱
		
	if item.population>0:
		var itempop_ui:ShopItem = DaojuItem.instantiate()
		itempop_ui.isShop=false
		_grid_ui.add_child(itempop_ui)
		itempop_ui.set_Labor(item.population)	
		_register_reward_flight(itempop_ui, "labor", item.population)
		#获取民力
		_pending_labor += item.population
	if item.get("hplimit", 0)>0:
		var itemHpLimit_ui:ShopItem = DaojuItem.instantiate()
		itemHpLimit_ui.isShop=false
		_grid_ui.add_child(itemHpLimit_ui)
		itemHpLimit_ui.set_HpLimit(item.hplimit)
		_register_reward_flight(itemHpLimit_ui, "energy", item.hplimit)
		_pending_hp_limit += item.hplimit
	title.text=titleContext
	#gird.add_child()
	#播放音效，显示1-2个道具
	#gird
	pass




func showRewardMa(item):
	AchievementManager.set_achievement("NEW_ACHIEVEMENT_1_31")
	imgTarget.texture=victoryPng
	self.show()
	#if GameManager.sav.have_event["吕布之怒"]==false and GameManager.sav.have_event["夏侯偷马"]==true and GameManager.sav.endPath==GameManager.endPath.xiaopei:
	SoundManager.play_sound(sounds.MA_CC_0)
	
	var titleContext=""
	if(coinCost>0 and soilderCost>0):
		titleContext=tr(sucuussContext)+tr(TxtbothCost).format({"coin":str(coinCost),"soilder":str(soilderCost)})
		pass
	elif coinCost>0 and soilderCost==0:
		titleContext=tr(sucuussContext)+tr(TxtcoinCost).format({"coin":str(coinCost)})
	elif coinCost==0 and soilderCost>0:
		titleContext=tr(sucuussContext)+tr(TxtSoiderCost).format({"soilder":str(soilderCost)})
	elif coinCost==0 and soilderCost==0:
		titleContext=tr(sucuussContext)+tr(TxtNoCost)
	var goumaStr=""
	#if GameManager.sav.have_event["吕布之怒"]==false and GameManager.sav.have_event["夏侯偷马"]==true and GameManager.sav.endPath==GameManager.endPath.xiaopei:
	goumaStr=tr("【截获吕布购马队，战利品升级】")
	titleContext=titleContext+goumaStr+tr(",获得以下道具:")
	#通过item增加并实际获得之
	_clear_view()
	
#	return {
#		"items": gained_items,
#		"money": money,
#		"population": population
#	}			
	for key in item.items.keys():
		var _count=item.items[key]
		var item_ui:ShopItem = DaojuItem.instantiate()
		item_ui.isShop=false
		_grid_ui.add_child(item_ui)
		item_ui.set_Data(key,_count)
		_queue_item_reward(key, _count)
		_register_reward_flight(item_ui, "item", _count)
		#获取道具

	if item.money>0:
		var itemMoney_ui:ShopItem = DaojuItem.instantiate()
		itemMoney_ui.isShop=false
		_grid_ui.add_child(itemMoney_ui)
		itemMoney_ui.set_Money(item.money)	
		_register_reward_flight(itemMoney_ui, "coin", item.money)
		_pending_coin += item.money
		#获取钱
		
	if item.population>0:
		var itempop_ui:ShopItem = DaojuItem.instantiate()
		itempop_ui.isShop=false
		_grid_ui.add_child(itempop_ui)
		itempop_ui.set_Labor(item.population)	
		_register_reward_flight(itempop_ui, "labor", item.population)
		#获取民力
		_pending_labor += item.population
	if item.get("hplimit", 0)>0:
		var itemHpLimit_ui:ShopItem = DaojuItem.instantiate()
		itemHpLimit_ui.isShop=false
		_grid_ui.add_child(itemHpLimit_ui)
		itemHpLimit_ui.set_HpLimit(item.hplimit)
		_register_reward_flight(itemHpLimit_ui, "energy", item.hplimit)
		_pending_hp_limit += item.hplimit
	title.text=titleContext

	
	
	
	#imgTarget.texture=maPng
	
func _clear_view() -> void:
	_reward_flight_entries.clear()
	_pending_item_rewards.clear()
	_pending_coin = 0
	_pending_labor = 0
	_pending_hp_limit = 0
	var children = _grid_ui.get_children()
	for child in children:
		_grid_ui.remove_child(child)
		child.queue_free()	
		
			
var coinCost
var soilderCost
var TxtbothCost="你损失了{coin}金和{soilder}个士兵"
var TxtcoinCost="你损失了{coin}金"
var TxtSoiderCost="你损失了{soilder}个士兵"
var TxtNoCost="你没有损失"


var failContext="这场战斗你输了,"
var sucuussContext="这场战斗你赢了,"
func fail():
	imgTarget.texture=failPng
	var titleContext=""
	if(coinCost>0 and soilderCost>0):
		titleContext=tr(failContext)+tr(TxtbothCost).format({"coin":str(coinCost),"soilder":str(soilderCost)})
		pass
	elif coinCost>0 and soilderCost==0:
		titleContext=tr(failContext)+tr(TxtcoinCost).format({"coin":str(coinCost)})
	elif coinCost==0 and soilderCost>0:
		titleContext=tr(failContext)+tr(TxtSoiderCost).format({"soilder":str(soilderCost)})
	elif coinCost==0 and soilderCost==0:
		titleContext=tr(failContext)+tr(TxtNoCost)
	title.text=titleContext
	self.show()
	SoundManager.play_sound(sounds.BAD_BATTLE)


@export var Item: PackedScene

#func _draw_view() -> void:
	#if _inventoryManager:
		#var inventory_db = _inventoryManager.get_inventory_db(inventory) as InventoryInventory
		#if inventory_db:
			#for index in range(inventory_db.stacks):
				#var item_ui = Item.instantiate()
				#grid.add_child(item_ui)
				#item_ui.set_index(index)
			#_set_inventory_manager_to_stacks(self)

func showContext():
	
	
	
	title.text=sucuussContext.format({"coin":str(coinCost),"soilder":str(soilderCost)})
	
	#context}，获得以下奖励

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





func _on_button_button_down():
	if canclick==false:
		return
	canclick=false
	var has_reward_flights := not _reward_flight_entries.is_empty()
	_play_reward_flights()
	_is_collecting = true
	if has_reward_flights:
		_play_reward_sounds()
	self.hide()
	
	for ui in _grid_ui.get_children():
		TooltipManager.unregister_tooltip(ui)
	await get_tree().create_timer(REWARD_FLIGHT_SETTLE_DELAY).timeout
	_apply_pending_rewards()
	_is_collecting = false
	SignalManager.endReward.emit()
	if is_instance_valid(_reward_flight_canvas):
		_reward_flight_canvas.queue_free()
	PanelManager.rewardNode=null
	queue_free()


func _play_reward_sounds() -> void:
	var sound_plan := _build_reward_sound_plan()
	if sound_plan.is_empty():
		return
	SoundManager.play_sound(sound_plan[0])
	if sound_plan.size() < 2:
		return
	await get_tree().create_timer(REWARD_SOUND_SECONDARY_DELAY).timeout
	if not is_inside_tree():
		return
	var secondary_player := SoundManager.play_sound(sound_plan[1])
	if is_instance_valid(secondary_player):
		secondary_player.volume_db = REWARD_SOUND_SECONDARY_VOLUME_DB


func _build_reward_sound_plan() -> Array[AudioStream]:
	var has_coin := false
	var has_labor := false
	var has_energy := false
	var has_item := false
	for entry in _reward_flight_entries:
		match str(entry.get("type", "")):
			"coin":
				has_coin = true
			"labor":
				has_labor = true
			"energy":
				has_energy = true
			"item":
				has_item = true

	var sound_plan: Array[AudioStream] = []
	if has_energy:
		sound_plan.append(sounds.GET_ENERGY)
		if has_coin:
			sound_plan.append(sounds.GETITEM)
		elif has_labor:
			sound_plan.append(sounds.GET_LABOR)
		elif has_item:
			sound_plan.append(sounds.GETITEM_2)
	elif has_coin:
		sound_plan.append(sounds.GETITEM)
		if has_item:
			sound_plan.append(sounds.GETITEM_2)
		elif has_labor:
			sound_plan.append(sounds.GET_LABOR)
	elif has_labor:
		sound_plan.append(sounds.GET_LABOR)
		if has_item:
			sound_plan.append(sounds.GETITEM_2)
	elif has_item:
		sound_plan.append(sounds.GETITEM_2)
	return sound_plan


func _queue_item_reward(item_type: InventoryManagerItem.ItemEnum, amount: int) -> void:
	_pending_item_rewards[item_type] = _pending_item_rewards.get(item_type, 0) + amount


func _apply_pending_rewards() -> void:
	if _rewards_applied:
		return
	_rewards_applied = true
	for item_type in _pending_item_rewards:
		var item_name := InventoryManagerItem.item_by_enum(item_type)
		InventoryManager.add_item(GameManager.inventoryPackege, item_name, _pending_item_rewards[item_type], false)
	if _pending_coin > 0:
		GameManager.sav.coin += _pending_coin
	if _pending_labor > 0:
		GameManager.sav.labor_force += _pending_labor
	if _pending_hp_limit > 0:
		GameManager.sav.maxHP += _pending_hp_limit
		if is_instance_valid(GameManager._engerge):
			GameManager._engerge.changerate(GameManager.sav.hp)


func _exit_tree() -> void:
	# A forced scene change stops this coroutine. Settle the queued reward before this panel is destroyed.
	if _is_collecting and _rewards_applied == false:
		_apply_pending_rewards()
	if is_instance_valid(_reward_flight_canvas):
		_reward_flight_canvas.queue_free()


func _register_reward_flight(source: ShopItem, resource_type: String, amount: int) -> void:
	_reward_flight_entries.append({
		"source": source,
		"type": resource_type,
		"amount": amount,
	})


func _play_reward_flights() -> void:
	if _reward_flight_entries.is_empty():
		return
	_reward_flight_canvas = CanvasLayer.new()
	_reward_flight_canvas.name = "RewardFlightCanvas"
	_reward_flight_canvas.layer = 101
	get_tree().current_scene.add_child(_reward_flight_canvas)
	var flight_layer := Control.new()
	flight_layer.name = "RewardFlightLayer"
	flight_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	# The flight itself is modal so the player cannot click a scene exit before collection completes.
	flight_layer.mouse_filter = Control.MOUSE_FILTER_STOP
	flight_layer.z_index = 100
	_reward_flight_canvas.add_child(flight_layer)
	for entry in _reward_flight_entries:
		var source := entry.source as ShopItem
		if not is_instance_valid(source) or source.context.texture == null:
			continue
		var count := clampi(int(entry.amount), 1, 4)
		if entry.type == "coin" or entry.type == "labor" or entry.type == "energy":
			count = max(count, 3)
		for index in count:
			_spawn_reward_flight(flight_layer, source, entry.type, index, count)


func _spawn_reward_flight(layer: Control, source: ShopItem, resource_type: String, index: int, count: int) -> void:
	var icon := TextureRect.new()
	icon.texture = source.context.texture
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.size = REWARD_FLIGHT_ICON_SIZE
	icon.pivot_offset = REWARD_FLIGHT_ICON_SIZE * 0.5
	var source_rect := source.get_global_rect()
	var target_center := _get_reward_flight_target(resource_type)
	var spread := Vector2((index - (count - 1) * 0.5) * 20.0, -18.0 - (index % 2) * 14.0)
	icon.global_position = source_rect.get_center() - REWARD_FLIGHT_ICON_SIZE * 0.5 + spread
	icon.rotation = randf_range(-0.16, 0.16)
	layer.add_child(icon)

	var target_position := target_center - REWARD_FLIGHT_ICON_SIZE * 0.5 + Vector2(randf_range(-10.0, 10.0), randf_range(-8.0, 8.0))
	var tween := icon.create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	var duration := REWARD_FLIGHT_DURATION + index * REWARD_FLIGHT_STAGGER
	tween.tween_property(icon, "global_position", target_position, duration)
	tween.parallel().tween_property(icon, "scale", Vector2(0.28, 0.28), duration)
	tween.parallel().tween_property(icon, "rotation", 0.0, REWARD_FLIGHT_DURATION)
	tween.tween_callback(icon.queue_free)


func _get_reward_flight_target(resource_type: String) -> Vector2:
	var target: Control = null
	if resource_type == "coin" and is_instance_valid(GameManager._propertyPanel):
		target = GameManager._propertyPanel._coin
	elif resource_type == "labor" and is_instance_valid(GameManager._propertyPanel):
		target = GameManager._propertyPanel._labor
	elif resource_type == "energy" and is_instance_valid(GameManager._engerge):
		target = GameManager._engerge.progress_bar
	elif resource_type == "item" and is_instance_valid(GameManager._engerge):
		target = GameManager._engerge.get_node_or_null("itemButton") as Control
	if is_instance_valid(target):
		return target.get_global_rect().get_center()
	return get_viewport().get_visible_rect().get_center()
	
	
