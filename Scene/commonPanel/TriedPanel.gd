
extends CanvasLayer
class_name TiredPanel

@onready var texture_button = $Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/TextureButton

@onready var resideLabel = $Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/TextureButton/Label/Label
@onready var initrestBtn: Button = $Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Button2

func _ready():
	var count=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.益气丸)

	if count>0:
		resideLabel.text=tr("剩余库存:{num}\n(点击消耗精力丸回复体力)").format({"num":count})
		texture_button.show()
	else:
		texture_button.hide()
		

	var _item_db=InventoryManager.get_item_db(InventoryManagerItem.益气丸)
	var properties:Array=_item_db.properties

		
	var detail=properties.filter(func(a):return a["name"]=="detail")[0]
	var _context
	if tr(detail["value"]).length()>0:
					
		_context=tr(_item_db.name)+":"+tr(detail["value"])

					

					
	if InventoryManager.has_item(InventoryManagerItem.饥蛊骨签):
		_context = _context.replace("40", "60") 
		_context=_context+tr("【已强化】")
		
	TooltipManager.register_tooltip(texture_button,_context)	
	
	
	
	
	if GameManager.sav.have_event["initTaskPolicy"]==false:
		var context=tr("请先离开府邸完成流程，否则无法休息。")
		if initrestBtn!=null:
			TooltipManager.register_tooltip(initrestBtn,context)
			initrestBtn.disabled=true
			

	elif GameManager.sav.have_event["chaosBegin"]==true and GameManager.sav.have_event["chaoDialogEnd"]==false:
		var context=tr("请先与手下对话了解内乱情况，否则无法休息")
		if initrestBtn!=null:
			TooltipManager.register_tooltip(initrestBtn,context)
			initrestBtn.disabled=true
	
	elif GameManager.sav.have_event["派系安稳完成"]==true and GameManager.sav.have_event["亲征对话结束"]==false:
		var context=tr("请先与手下陈登和糜竺咨询情况，否则无法休息。")
		if initrestBtn!=null:
			TooltipManager.register_tooltip(initrestBtn,context)
			initrestBtn.disabled=true		
		
	else:
		if initrestBtn!=null:
			initrestBtn.disabled=false
	

func _on_rest():
	GameManager.triedResult = true
	GameManager.triedPanelDone.emit()
	self.hide()
	if GameManager.checkAndHandleLazy():
		return  # 对话会通过 do GameManager.oneDayidness()/moreDayidness() 最终调用 _rest()
	GameManager._rest()
	pass # Replace with function body.


func _on_cancel():
	GameManager.triedResult = true
	GameManager.triedPanelDone.emit()
	self.hide()
	pass # Replace with function body.


func _on_jingliwan_button_down():
	var count=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.益气丸)

	if count>0:
		InventoryManager._remove_item(GameManager.inventoryPackege,InventoryManagerItem.益气丸,1)
		GameManager.triedResult = false
		GameManager.triedPanelDone.emit()
		
		if InventoryManager.has_item(InventoryManagerItem.饥蛊骨签):
			GameManager.recoverHp(60)
			AchievementManager.set_achievement("NEW_ACHIEVEMENT_1_3")
		else:
			GameManager.recoverHp(40)
		SoundManager.play_sound(sounds.tunyan)
		self.hide()		
		#itemUseLabel.text="点击图标使用\n快速结束辩经\n（库存：{num}）".format({"num":count-1})
		#score=9000
		#yourscore.text=tr("你的得分：")+"\n"+str(score)
		#恢复体力并隐藏面板
