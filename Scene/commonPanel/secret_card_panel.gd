extends CanvasLayer

@onready var control_1: ShopItem = $Control/Grid/Control1
@onready var control_2: ShopItem = $Control/Grid/Control2
@onready var control_3: ShopItem = $Control/Grid/Control3
@onready var control_4: ShopItem = $Control/Grid/Control4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initSecretCard(arrs) # Replace with function body.



@export var arrs=[true,true,true,true]

func initSecretCard(_arrs):
	arrs = _arrs.duplicate()

	if GameManager._boardMode==boardType.boardMode.middle:
		# 有道具→可获取，无道具→不可获取
		arrs[0] = InventoryManager.has_item(InventoryManagerItem.仕诡卡血姬)
		arrs[1] = InventoryManager.has_item(InventoryManagerItem.仕诡卡骨龙)
		arrs[2] = InventoryManager.has_item(InventoryManagerItem.仕诡卡尸皇)
		arrs[3] = false  # 黑商中级不可用

	for i in range(1,5):
		if arrs[i-1]==false:
			self["control_"+str(i)].alreaysold.show()
		else:
			self["control_"+str(i)].alreaysold.hide()
		self["control_"+str(i)].set_Data(null,1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_control_1_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index==1:
		control_gui_press(1)
@onready var button: Button = $Control/VBoxContainer/HBoxContainer/Button
			
func control_gui_press(index):
	
	if arrs[index-1]==true:
		button.disabled=false
		selectCard=index
		var control=self["control_"+str(index)]
		var itemname= InventoryManagerItem.item_by_enum(control.itemstype)
		var properties:Array=InventoryManager.get_item_properties(itemname)
		var item=properties.filter(func(a):return a["name"]=="detail")[0]
		var detail=item["value"]
		var db:InventoryItem=InventoryManager.get_item_db(itemname)					
		detail_txt.text=tr(db.name)+" "+tr(detail)
	else:
		button.disabled=true
		if GameManager._boardMode==boardType.boardMode.middle:
			detail_txt.text=tr("你没有该仕诡牌")	
		else:
			detail_txt.text=tr("当前卡牌已经被使用了")				
			
			
func _on_control_2_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index==1:	
		control_gui_press(2)

func _on_control_3_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index==1:
		control_gui_press(3)

func _on_control_4_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index==1:
		control_gui_press(4)
var selectCard=-1
@onready var detail_txt: Label = $Control/VBoxContainer/detail

func refreshSecretCardPanel(index):
	if arrs[index-1]==true:
		pass
	else:
		detail_txt.text=tr("当前卡牌已经被使用了")
	pass


func _on_button_button_down() -> void:
	if selectCard!=-1:
		GameManager.currenceScene.getSecretCard(selectCard)
		GameManager.currenceScene.hasSecretCard=arrs
		self.queue_free()
