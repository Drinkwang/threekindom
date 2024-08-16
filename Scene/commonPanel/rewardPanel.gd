@tool
extends InventoryUI
class_name rewardPanel


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

func showReward():
	self.show()
	#播放音效，显示1-2个道具
	#gird
	pass

@export var Item: PackedScene

func _draw_view() -> void:
	if _inventoryManager:
		var inventory_db = _inventoryManager.get_inventory_db(inventory) as InventoryInventory
		if inventory_db:
			for index in range(inventory_db.stacks):
				var item_ui = Item.instantiate()
				grid.add_child(item_ui)
				item_ui.set_index(index)
			_set_inventory_manager_to_stacks(self)

func showContext():
	title.text=context
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





func _on_button_button_down():
	SignalManager.endReward.emit()
	#结算完了
	#endbattle.emit()
	queue_free()
	
	pass # Replace with function body.
