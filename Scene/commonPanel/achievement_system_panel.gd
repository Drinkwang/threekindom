extends CanvasLayer

@onready var grid_container: GridContainer = $Control/PanelContainer/MarginContainer/VBoxContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initView()


var card_achives
func initView():
	card_achives=GameManager.sav.card_achives
	var achis= grid_container.get_children()
	for i in range(0,9):
		achis[i].initData(card_achives[i])
		#
	var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.玄阴玉符)
	

	if num>=1:
		unlockHighReward()


func unlockHighReward():
	var achis= grid_container.get_children()

	if GameManager.sav.have_event["解锁高级成就"]==false:
		GameManager.sav.have_event["解锁高级成就"]=true
		for i in range(6,10):
			achis[i].changeState(achiClass.lockState.unlock)
	pass
	#播放解锁声，播完播锁链声音
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_button_down() -> void:
	self.hide()
