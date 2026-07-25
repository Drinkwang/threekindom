extends Control
const normalbtn = preload("res://Asset/ui/panel_Example1.png")
const pressbtn =preload("res://Asset/ui/panel_Example2.png")
const hoverbtn = preload("res://Asset/ui/panel_Example3.png")
const russian_font = preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")
const BUTTON_TEXT_WIDTH := 360.0
const BUTTON_TEXT_MIN_SIZE := 32
@onready var node_2d = $Node2D

signal buttonClick
signal buttonHover
const focusbtn = preload("res://Asset/ui/panel_Example4.png")
var guilds:Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	guilds = $"Node2D/5Yellow" as Sprite2D
	SignalManager.changeLanguage.connect(changeLanguage)
		#"id":"3",
		#"context":"外出",#前往大街
		#"visible":"false"
	#_processList(initData)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var is_dialog = DialogueManager.dialogBegin
	for child in $VBoxContainer.get_children():
		child.disabled = is_dialog


func _processList(data):
	var index=0;
	if($VBoxContainer.get_child_count()>0):
		return
	for item in data:
		if item.visible=="false":
			continue
		var btnContext=item.context
		var richTxt:RichTextLabel =RichTextLabel.new()
		richTxt.fit_content=false
		richTxt.autowrap_mode=TextServer.AUTOWRAP_OFF
		richTxt.set_text(btnContext)
		#richTxt.set_size(Vector2(200,50))
		#可以修改成动态调整的大小
		
		#var text_size: Vector2 = richTxt.get_content_rect()
		#var padding: Vector2 = Vector2(20, 10)  # 宽度和高度的内边距
		#richTxt.set_size(Vector2(text_size.x + padding.x, text_size.y + padding.y))
		richTxt.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
		richTxt.set_size(Vector2(400,80))
		richTxt.mouse_filter=Control.MOUSE_FILTER_PASS

		richTxt.add_theme_color_override("font_outline_color",Color.DARK_RED)
		richTxt.add_theme_constant_override("outline_size",0)
		richTxt.clip_contents=true
		richTxt.scroll_active=false
		richTxt.set_modulate(Color.DIM_GRAY)
		richTxt.set_position(Vector2(50,45))
		#richTxt.add_theme_font_override("")
		#richTxt.horizontal_alignment = CENTER
		#richTxt.outline_color=Color.BLACK
		var buttton:=TextureButton.new()
		#buttton.set_custom_minimum_size(Vector2(450,48))
		#buttton.ignore_texture_size=true
		#buttton.stretch_mode=TextureButton.STRETCH_KEEP_ASPECT
		buttton.add_child(richTxt)
		buttton.mouse_filter=Control.MOUSE_FILTER_PASS
		buttton.texture_normal=normalbtn
		buttton.texture_pressed=pressbtn
		buttton.texture_hover=hoverbtn
		buttton.texture_focused=focusbtn
		buttton.texture_disabled=normalbtn
		buttton.mouse_entered.connect(_buttonHover.bind(item))
		buttton.mouse_exited.connect(_buttonExit)
		buttton.pressed.connect(_button_ation.bind(item,index))
		buttton.name="button"+var_to_str(index)
		if item.has("tooltip"):
			TooltipManager.register_tooltip(richTxt,tr(item.tooltip))	
		index=index+1
		$VBoxContainer.add_child(buttton)
		_update_button_text_style(richTxt)

	#	richTxt.set_size(Vector2(buttton.size.x,50))

func changeLanguage():
	for e in $VBoxContainer.get_children():
		var richTxt:RichTextLabel=e.get_child(0)
		_update_button_text_style(richTxt)


func _update_button_text_style(rich_text:RichTextLabel):
	var locale=TranslationServer.get_locale()
	var translated_text=tr(rich_text.text)
	var preferred_size=55
	if locale=="ru":
		preferred_size=36 if translated_text.length()>=9 else 40
		rich_text.add_theme_font_override("normal_font",russian_font)
	else:
		rich_text.remove_theme_font_override("normal_font")
		if locale=="en" and translated_text.length()>=14:
			preferred_size=46
		elif locale=="en" and translated_text.length()>=12:
			preferred_size=48

	var font=rich_text.get_theme_font("normal_font")
	var fitted_size=preferred_size
	while fitted_size>BUTTON_TEXT_MIN_SIZE and font.get_string_size(translated_text,HORIZONTAL_ALIGNMENT_LEFT,-1,fitted_size).x>BUTTON_TEXT_WIDTH:
		fitted_size-=1
	rich_text.add_theme_font_size_override("normal_font_size",fitted_size)
@onready var animation_player = $"Node2D/5Yellow/AnimationPlayer"
func _buttonHover(item):
	if DialogueManager.haveDialoge()==true:
		return
	SoundManager.play_sound(sounds.hoversound)
	buttonHover.emit(item)
	
func _buttonExit():
	if GameManager._engerge != null and GameManager._engerge.previewValue!=0:
		GameManager._engerge.stopPreviewHP()
func _show_button_5_yellow(index):
	if index==-1:
		node_2d.hide()
		return
	#await $VBoxContainer.get_node("button1").position.y>0
	var findpattern="button"+var_to_str(index)
	var groups=$VBoxContainer.get_node_or_null(findpattern)
	if groups == null:
		await get_tree().process_frame
		groups=$VBoxContainer.get_node_or_null(findpattern)
	if groups == null:
		push_warning("Tutorial highlight target not found: " + findpattern)
		node_2d.hide()
		return
	node_2d.show()
	var texbtn:TextureButton=groups
	#print(texbtn.position)
	if(index>0 and texbtn.position.y==0):
		node_2d.position=texbtn.position+Vector2(472,65)+Vector2(0,155*index)
	else:
		node_2d.position=texbtn.position+Vector2(478,65)#+Vector2(0,155*index)
	animation_player.play("YELLOWGUILD")
	pass

#func _show_button_ToolTip(index):
	#if index==-1:
		#node_2d.hide()
		#return
	#else:
		#node_2d.show()
	##await $VBoxContainer.get_node("button1").position.y>0
	#var findpattern="button"+var_to_str(index)
	#var groups=$VBoxContainer.get_node(findpattern)
	#var texbtn:TextureButton=groups
func _button_ation(item,index):
	if DialogueManager.haveDialoge()==true:
		return
	SoundManager.play_sound(sounds.confiresound)
	#_show_button_5_yellow(index)
	buttonClick.emit(item)
	if item.context=="":
		pass
	pass
