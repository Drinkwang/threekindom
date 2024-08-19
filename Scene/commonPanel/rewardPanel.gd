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


func showTitileReward(context):
	imgTarget.texture=victoryPng
	self.show()
	var titleContext=context
	titleContext=titleContext+",获得以下道具:"
	title.text=titleContext	
func showReward():
	imgTarget.texture=victoryPng
	self.show()
	

	var titleContext=""
	if(coinCost>0 and soilderCost>0):
		titleContext=sucuussContext+TxtbothCost.format({"coin":str(coinCost),"soilder":str(soilderCost)})
		pass
	elif coinCost>0 and soilderCost==0:
		titleContext=sucuussContext+TxtcoinCost.format({"coin":str(coinCost)})
	elif coinCost==0 and soilderCost>0:
		titleContext=sucuussContext+TxtSoiderCost.format({"soilder":str(soilderCost)})
	elif coinCost==0 and soilderCost==0:
		titleContext=sucuussContext+TxtNoCost
	titleContext=titleContext+",获得以下道具:"
	title.text=titleContext
	#播放音效，显示1-2个道具
	#gird
	pass
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
		titleContext=failContext+TxtbothCost.format({"coin":str(coinCost),"soilder":str(soilderCost)})
		pass
	elif coinCost>0 and soilderCost==0:
		titleContext=failContext+TxtcoinCost.format({"coin":str(coinCost)})
	elif coinCost==0 and soilderCost>0:
		titleContext=failContext+TxtSoiderCost.format({"soilder":str(soilderCost)})
	elif coinCost==0 and soilderCost==0:
		titleContext=failContext+TxtNoCost
	title.text=titleContext
	self.show()


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
	#结算完了
	#endbattle.emit()
	queue_free()
	
	pass # Replace with function body.
