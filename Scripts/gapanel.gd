@tool
extends Control
@onready var img = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/img

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
		
@onready var title = $PanelContainer/MarginContainer/VBoxContainer/title
@onready var context = $PanelContainer/MarginContainer/VBoxContainer/context




# Called when the node enters the scene tree for the first time.
func _ready():
	if(context!=null):
		context.text=contextEX
	if(title!=null):
		title.text=titleEX		
		
	if(txt!=null):
		img.texture=txt
	changeLanguage() # Replace with function body.


func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()	
	if currencelanguage=="en":
		pass
	elif currencelanguage=="zh":
		pass
	elif currencelanguage=="ru":
		#label.add_theme_font_size_override("font_size", 34)
		#reallabel.add_theme_font_size_override("font_size", 38)
		title.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		context.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		context.add_theme_font_size_override("font_size", 38)
		#reallabel.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
	

func showContext():
	title.text=context
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@export var dialogue_resource:DialogueResource
@export var clickEvent:String="start"
func _on_button_button_down():
	self.hide()
	if clickEvent.length()>0 and dialogue_resource!=null:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,clickEvent)
		
	pass # Replace with function body.
