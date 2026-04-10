@tool

extends Control
#商品信息

const InventoryManagerName = "InventoryManager"
@export var autosave: bool = true
@export var to_inventory: String 

@onready var context = $frame/context
@onready var alreaysold =$frame/miss
@onready var guiyiguaitan=""
@export var isstatue:int=0:
	get:
		return isstatue
	set(value):
		isstatue=value
		if value==0:
			alreaysold.visible=false
			context.modulate=Color("#1c1c1c")
		elif value==1:
			context.modulate=Color.WHITE
			alreaysold.visible=false
		elif value==2:
			context.modulate=Color.WHITE
			alreaysold.visible=true
#=1
#=2
#未获得0
#已错过=1
#获得=2
@export var img:Texture2D:
	
	get:
		return img
	set(value):
		img=value
		if context!=null:
			context.texture=img
			#context.gre
		#if texture_rect!=null:
		#	texture_rect.texture=img
		
#	return {
#		"items": gained_items,
#		"money": money,
#		"population": population


@export var itemContext:String=""
@export var itemstype:InventoryManagerItem.ItemEnum:
	
	get:
		return itemstype
	set(value):
		itemstype=value

	
	#var itemname= InventoryManagerItem.item_by_enum(key)
	#var remainder = InventoryManager.add_item(GameManager.inventoryPackege, itemname, quantity, false)

const LABOR = preload("res://Asset/ui/战力.png")	

const COIN = preload("res://Asset/ui/钱财.png")

#const questManagerName = "QuestManager"		
# Called when the node enters the scene tree for the first time.
func _ready():
	
#	if get_tree().get_root().has_node(InventoryManagerName):
#		_inventoryManager = get_tree().get_root().get_node(InventoryManagerName)
	context.texture=img
	#if isShop==false:
		#return
	if GameManager==null or GameManager.sav==null:
		return
	getStuatus()
	var itemname= InventoryManagerItem.item_by_enum(itemstype)
	var db:InventoryItem=InventoryManager.get_item_db(itemname)
	var properties:Array=db.properties
	var statuesTxt=""
	
	
	if isstatue==0:
		statuesTxt="未获取"
	elif isstatue==1:
		statuesTxt="已获得"
	elif isstatue==2:
		statuesTxt="已错过"
	var _context=tr(db.name)+":"+statuesTxt


	

	
	

	if TooltipManager and TooltipManager.has_method("register_tooltip"):
		TooltipManager.register_tooltip(self,_context)		
	#if get_tree().get_root().has_node(questManagerName):
	#	questManager = get_tree().get_root().get_node(questManagerName)

#1已获得
#2已失去
func getStuatus():
	if itemstype==InventoryManagerItem.ItemEnum.迷魂木筒:
		if GameManager.sav.have_event["获得过木桶标记"]==true:#获得
			isstatue=1
		elif GameManager.sav.have_event["错失木桶"]==true :#选择焚烧#超时
			isstatue=2
		else:
			isstatue=0
	elif itemstype==InventoryManagerItem.ItemEnum.黄麻药囊:
		if GameManager.sav.have_event["获得锦囊"]:
			isstatue=1
		elif GameManager.sav.have_event["错失木桶"]==true or GameManager.sav.have_event["错失锦囊"]:
			isstatue=2
		else:
			isstatue=0
	elif itemstype==InventoryManagerItem.ItemEnum.饥蛊骨签:
		if GameManager.sav.have_event["获得古棒"]:
			isstatue=1
		elif GameManager.sav.have_event["错失木桶"]==true or GameManager.sav.have_event["错失锦囊"] or GameManager.sav.have_event["错失古棒"]:
			isstatue=2
		else:
			isstatue=0
			
	#
	elif itemstype==InventoryManagerItem.ItemEnum.陶谦血袖:
		if GameManager.sav.have_event["获得血袖"]:
			isstatue=1
		elif GameManager.sav.have_event["错失血袖"]:#选错对话或者打输了
			isstatue=2
		else:
			isstatue=0
	elif itemstype==InventoryManagerItem.ItemEnum.血姬傀儡:
		if GameManager.sav.have_event["获得娃娃"]:
			isstatue=1
		elif GameManager.sav.have_event["错失娃娃"]:#选错对话或者打输了
			isstatue=2
		else:
			isstatue=0
	elif itemstype==InventoryManagerItem.ItemEnum.龙胆亮银枪:
		if GameManager.sav.have_event["获得亮银"]:
			isstatue=1
		elif GameManager.sav.have_event["错失亮银"]:#选错对话或者打输了
			isstatue=2
		else:
			isstatue=0						
	elif itemstype==InventoryManagerItem.ItemEnum.玄阴玉符:
		if GameManager.sav.have_event["获得玄阴"]:
			isstatue=1
		elif GameManager.sav.endPath==GameManager.endPath.xiaopei and GameManager.sav.caobaocardgame<5:#进入小沛 且caobao最终没有通关
			isstatue=2
		else:
			isstatue=0
func _process(delta):
	pass

@onready var control: Control = $"../.."

func _on_gui_input(event):
	
	if event is InputEventMouseButton and event.button_index==1:
	
		var itemname= InventoryManagerItem.item_by_enum(itemstype)
		var db:InventoryItem=InventoryManager.get_item_db(itemname)
		control.refreshPage(db.name,isstatue,itemContext)#价格和介绍
	#pass # Replace with function body.
