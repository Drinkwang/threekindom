extends Control
const normalbtn = preload("res://Asset/ui/panel_Example1.png")
const pressbtn =preload("res://Asset/ui/panel_Example2.png")
const hoverbtn = preload("res://Asset/ui/panel_Example3.png")
@onready var node_2d = $Node2D

signal buttonClick
const focusbtn = preload("res://Asset/ui/panel_Example4.png")
var guilds:Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	guilds = $"Node2D/5Yellow" as Sprite2D
		#"id":"3",
		#"context":"外出",#前往大街
		#"visible":"false"
	#_processList(initData)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _processList(data):
	var index=0;
	if($VBoxContainer.get_child_count()>0):
		return
	for item in data:
		if item.visible=="false":
			continue
		var btnContext=item.context
		var richTxt:RichTextLabel =RichTextLabel.new()
		richTxt.set_text(btnContext)
		richTxt.set_size(Vector2(850,80))
		richTxt.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
		richTxt.add_theme_font_size_override("normal_font_size",55)
		richTxt.add_theme_color_override("font_outline_color",Color.BLACK)
		richTxt.add_theme_constant_override("outline_size",5)
		richTxt.clip_contents=true
		richTxt.scroll_active=false
		richTxt.set_modulate(Color.WHITE)
		richTxt.set_position(Vector2(50,45))
		#richTxt.add_theme_font_override("")
		#richTxt.horizontal_alignment = CENTER
		#richTxt.outline_color=Color.BLACK
		var buttton:=TextureButton.new()
		buttton.add_child(richTxt)
		buttton.texture_normal=normalbtn
		buttton.texture_pressed=pressbtn
		buttton.texture_hover=hoverbtn
		buttton.texture_focused=focusbtn
		buttton.pressed.connect(_button_ation.bind(item,index))
		buttton.name="button"+var_to_str(index)
		index=index+1
		$VBoxContainer.add_child(buttton)		
	

@onready var animation_player = $"Node2D/5Yellow/AnimationPlayer"
	
func _show_button_5_yellow(index):
	#await $VBoxContainer.get_node("button1").position.y>0
	var findpattern="button"+var_to_str(index)
	var groups=$VBoxContainer.get_node(findpattern)
	var texbtn:TextureButton=groups
	print(texbtn.position)
	if(index>0 and texbtn.position.y==0):
		node_2d.position=texbtn.position+Vector2(472,65)+Vector2(0,155*index)
	else:
		node_2d.position=texbtn.position+Vector2(472,65)#+Vector2(0,155*index)
	animation_player.play("YELLOWGUILD")
	pass


func _button_ation(item,index):
	#_show_button_5_yellow(index)
	buttonClick.emit(item)
	if item.context=="":
		pass
	pass

