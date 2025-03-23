extends CanvasLayer

@onready var title = $Control/PanelContainer/MarginContainer/VBoxContainer/title
@onready var texture_button = $Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _initPanel(factionName,index,point):
	var indexName
	if index>=0:
		indexName="支持度"
	else:
		indexName="好感"	
	title.text="是否给{factionName}赠送礼物,赠送可以增加{point}点{indexName}".format({"factionName":factionName,"point":point,"indexName":indexName})
	texture_button.tooltip_text=tr("珍品礼盒")
	#0 支持度
	#1 好感
	#是否给徐州派赠送礼物,赠送可以增加15点支持度
	#是否给吕布赠送礼物,赠送可以增加15点好感
	#是否消耗200金给 {{getFactionByIndex()._name}} 让其在议会中的人数提升{{(3+GameManager.sav.randomIndex)}}人
	pass
@onready var bag_label = $Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/bagLabel

func refreshBag():
	
	var to_inventory= InventoryManagerItem.item_by_enum(InventoryManagerItem.ItemEnum.珍品礼盒)
	var _inventoryManager = get_tree().get_root().get_node("InventoryManager")
	var quantity=_inventoryManager.has_item_quantity(to_inventory)

	#var _num=0
	bag_label.text="\n"+"拥有礼盒数量:{_num}".format({"_num":quantity})

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_send_gift_button_down():
	mainPanel.sendgift()
	self.hide()
	pass # Replace with function body.

@onready var mainPanel = $".."

func _on_cancel_button_down():
	#get_node("../../..")
	mainPanel.SummonFaction(mainPanel._faction)
	pass # Replace with function body.
