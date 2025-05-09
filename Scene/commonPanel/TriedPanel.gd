@tool
extends CanvasLayer
class_name TiredPanel

@onready var texture_button = $Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/TextureButton

@onready var resideLabel = $Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/TextureButton/Label/Label

func _ready():
	var count=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.益气丸)

	if count>0:
		resideLabel.text=tr("剩余库存:{num}\n(点击消耗精力丸回复体力)").format({"num":count})
		texture_button.show()
	else:
		texture_button.hide()
	
	

func _on_rest():
	GameManager.triedPanelDone.emit()
	self.hide()	
	GameManager._rest()
	pass # Replace with function body.


func _on_cancel():
	GameManager.triedPanelDone.emit()
	self.hide()
	pass # Replace with function body.


func _on_jingliwan_button_down():
	var count=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.益气丸)

	if count>0:
		InventoryManager._remove_item(GameManager.inventoryPackege,InventoryManagerItem.益气丸,1)
		GameManager.triedPanelDone.emit()
		GameManager.recoverHp(40)
		self.hide()		
		#itemUseLabel.text="点击图标使用\n快速结束辩经\n（库存：{num}）".format({"num":count-1})
		#score=9000
		#yourscore.text=tr("你的得分：")+"\n"+str(score)
		#恢复体力并隐藏面板
