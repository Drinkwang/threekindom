@tool
class_name policyItem
extends Control
@onready var contextUI = $Panel/context
@onready var check_box = $TextureRect/CheckBox

@onready var texture_rect = $TextureRect
@onready var panel = $Panel
@export var detail:String
@export var context:String:
	get:
		return context
	set(value):
		context=value
		if contextUI!=null:
			contextUI.text=value
		if value.length()>0:
			if panel!=null:
				panel.show()
		else:
			if panel!=null:
				panel.hide()

@export var img:Texture2D:
	get:
		return img
	set(value):
		img=value
		if texture_rect!=null:
			texture_rect.texture=img
		
			
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.changeLanguage.connect(_changeLanguage)		
	_changeLanguage()
	if contextUI!=null:
		contextUI.text=context	
	if texture_rect!=null:
		texture_rect.texture=img	
	if context.length()>0:
		panel.show()
	else:
		panel.hide()

func _changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="ru":

		$Panel/context.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
			
	else:
		$Panel/context.remove_theme_font_override("font")

var data
func initDataByGroup(index,group):

	data=PolicyManager.policy_Item.filter(func(ele): return ele.group == group-1 and ele.index==index)[0]
	detail=data.detail
	context=data.name
	if GameManager.haveMirror():
		
		TooltipManager.register_tooltip(self,data.tootip)
	else:
		TooltipManager.unregister_tooltip(self)
		self.tooltip_text=""
	if group==4:
		heart.show()
	else:
		heart.hide()
@onready var heart = $heart

func setBanStatus(boolvalue):
	if boolvalue==true:
		$TextureRect/discard.show()
		$TextureRect/CheckBox.hide()
	else:
		$TextureRect/discard.hide()
		$TextureRect/CheckBox.show()		
	pass

var _status
var canclick:bool=true
func setStatus(statusvalue):
	var parent:policyPanel=get_parent() as policyPanel
	_status=statusvalue
	if statusvalue==parent.itemStatus.ban:
		$TextureRect/discard.show()
		$TextureRect/CheckBox.hide()
		$TextureRect/succuss.hide()	
		canclick=false		
	elif  statusvalue==parent.itemStatus.select:
		$TextureRect/discard.hide()
		$TextureRect/CheckBox.hide()	
		$TextureRect/succuss.show()	
		canclick=false		
	else:
		$TextureRect/discard.hide()
		$TextureRect/CheckBox.show()
		$TextureRect/succuss.hide()
		canclick=true					
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
