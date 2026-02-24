@tool
class_name allocationItem
extends Control
@onready var head = $TextureRect


@export var factionIndex:cldata.factionIndex
var factionSurpuls:cldata
#@export var heroIndex:int
#



@export var headImg:Texture2D:
	get:
		return headImg
	set(value):
		headImg=value
		if(headImg!=null):
			$TextureRect.texture=headImg
@onready var context: Label = $Panel/context

@onready var delay: TextureRect = $delay
@onready var already_give: TextureRect = $alreadyGive





@export var namelv:String:
	get:
		return namelv
	set(value):
		namelv=value
		if(namelv!=null and context!=null):
			context.text=namelv



# Called when the node enters the scene tree for the first time.
func _ready():
	if(headImg!=null):
		$TextureRect.texture=headImg# Replace with function body.
	if is_instance_valid(GameManager):	
		factionSurpuls=GameManager.getFractionByEnum(factionIndex)

	changeLanguage()
	if is_instance_valid(SignalManager):	
		SignalManager.changeLanguage.connect(changeLanguage)
func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="ru":
		context.add_theme_font_size_override("font_size",15)
		context.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)



	else:
		context.add_theme_font_size_override("font_size",23)
		context.remove_theme_font_override("font")

	if(namelv!=null):
		context.text=tr(namelv)
@onready var button: Button = $Button

const NOT_JAM_UI_CONDENSED_16 = preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
@onready var grid: GridContainer = $Grid
@onready var check_box: CheckBox = $CheckBox
var data:cldata
func initData():
	data=GameManager.getFractionByEnum(factionIndex)
	if data.isAutoAllocation==true:
		check_box.toggle_mode=true
	else:
		check_box.toggle_mode=false
	if GameManager.sav.allocationDay==1:
		pass#支付
	
	elif GameManager.sav.allocationDay==2:
		if data.allocationStatue==0:
			button.disabled=false
			delay.show()
		else:
			#已经支付
			button.disabled=true
	if GameManager.sav.allocationDay==3:
		button.disabled=true
		#新的需求来了，必定为false
	else:
		if data.allocationStatue==0:
			button.disabled=false
			already_give.hide()
		else:
			already_give.show()
			#已经支付
			button.disabled=true
		if GameManager.sav.allocationDay==2:
			delay.show()
		elif GameManager.sav.allocationDay==1:
			delay.hide()
			#already_give.show()
	showReward(data.demand)


func _clear_view():
	var children = grid.get_children()
	for child in children:
		grid.remove_child(child)
		child.queue_free()	
@export var DaojuItem: PackedScene	
func showReward(item):
	#imgTarget.texture=victoryPng
	self.show()
	#getItemSound()


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
		grid.add_child(item_ui)
		item_ui.set_Data(key,_count)	
		#需要修改方法道具 不获得道具,已修改，不知道 有无bug

	if item.money>0:
		var itemMoney_ui:ShopItem = DaojuItem.instantiate()
		itemMoney_ui.isShop=false
		grid.add_child(itemMoney_ui)
		itemMoney_ui.set_Money(item.money)	

		
	if item.population>0:
		var itempop_ui:ShopItem = DaojuItem.instantiate()
		itempop_ui.isShop=false
		grid.add_child(itempop_ui)
		itempop_ui.set_Labor(item.population)	

	pass
var _num=0
#当文本改变


func _on_check_box_toggled(toggled_on: bool) -> void:
	data.isAutoAllocation=toggled_on
