@tool
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
	if contextUI!=null:
		contextUI.text=context	
	if texture_rect!=null:
		texture_rect.texture=img	
	if context.length()>0:
		panel.show()
	else:
		panel.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
