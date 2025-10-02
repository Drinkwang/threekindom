@tool
extends CanvasLayer
#extends InventoryUI
class_name rewardPanel
const victoryPng = preload("res://Asset/other/胜利.png")
const failPng = preload("res://Asset/other/骷髅头.png")
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
		
@onready var context = $Control/PanelContainer/MarginContainer/VBoxContainer/context

@onready var title = $Control/PanelContainer/MarginContainer/VBoxContainer/title



# Called when the node enters the scene tree for the first time.
func _ready():

	if(context!=null):
		context.text=contextEX
	if(title!=null):
		title.text=titleEX		
		
	if(txt!=null):
		img.texture=txt
	#hide()
	#GameManager._rewardPanel=self
	pass # Replace with function body.
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
		#获取道具

	#var getMoney=
	if item.money>0:
		var itemMoney_ui:ShopItem = DaojuItem.instantiate()
		itemMoney_ui.isShop=false
		_grid_ui.add_child(itemMoney_ui)
		itemMoney_ui.set_Money(item.money)	
		GameManager.sav.coin=GameManager.sav.coin+item.money
		#获取金钱
		
	if item.population>0:
		var itempop_ui:ShopItem = DaojuItem.instantiate()
		itempop_ui.isShop=false
		_grid_ui.add_child(itempop_ui)
		itempop_ui.set_Labor(item.population)	
		#获取人口
		GameManager.sav.labor_force=GameManager.sav.labor_force+item.population
	title.text=titleContext

@export var DaojuItem: PackedScene	
@onready var _grid_ui = $Control/PanelContainer/MarginContainer/VBoxContainer/Margin/Grid

func getItemSound():
	var ranValue=randi_range(1,3)
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
	titleContext=titleContext+tr(",获得以下道具:")
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
		#获取道具

	if item.money>0:
		var itemMoney_ui:ShopItem = DaojuItem.instantiate()
		itemMoney_ui.isShop=false
		_grid_ui.add_child(itemMoney_ui)
		itemMoney_ui.set_Money(item.money)	
		GameManager.sav.coin=GameManager.sav.coin+item.money
		#获取金钱
		
	if item.population>0:
		var itempop_ui:ShopItem = DaojuItem.instantiate()
		itempop_ui.isShop=false
		_grid_ui.add_child(itempop_ui)
		itempop_ui.set_Labor(item.population)	
		#获取人口
		GameManager.sav.labor_force=GameManager.sav.labor_force+item.population
	title.text=titleContext
	#gird.add_child()
	#播放音效，显示1-2个道具
	#gird
	pass
	
func _clear_view() -> void:
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
	SignalManager.endReward.emit()
	self.hide()
	await get_tree().create_timer(0.5).timeout
	#结算完了
	GameManager.rewardPanel=false
	#endbattle.emit()
	queue_free()
	
	pass # Replace with function body.
