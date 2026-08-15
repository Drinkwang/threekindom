extends Control
const normalbtn = preload("res://Asset/ui/panel_Example1.png")
const pressbtn =preload("res://Asset/ui/panel_Example2.png")
const hoverbtn = preload("res://Asset/ui/panel_Example3.png")
const russian_font = preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")
const BUTTON_TEXT_WIDTH := 360.0
const BUTTON_TEXT_MIN_SIZE := 32
const BUTTON_TEXT_RECT := Rect2(50, 0, BUTTON_TEXT_WIDTH, 150)
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
	var is_dialog = DialogueManager.haveDialoge()
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
		var text_label:=Label.new()
		text_label.autowrap_mode=TextServer.AUTOWRAP_OFF
		text_label.text=btnContext
		text_label.position=BUTTON_TEXT_RECT.position
		text_label.size=BUTTON_TEXT_RECT.size
		text_label.vertical_alignment=VERTICAL_ALIGNMENT_CENTER
		text_label.mouse_filter=Control.MOUSE_FILTER_PASS
		text_label.add_theme_color_override("font_outline_color",Color.DARK_RED)
		text_label.add_theme_constant_override("outline_size",0)
		text_label.clip_text=true
		text_label.modulate=Color.DIM_GRAY
		var buttton:=TextureButton.new()
		#buttton.set_custom_minimum_size(Vector2(450,48))
		#buttton.ignore_texture_size=true
		#buttton.stretch_mode=TextureButton.STRETCH_KEEP_ASPECT
		buttton.add_child(text_label)
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
			TooltipManager.register_tooltip(text_label,tr(item.tooltip))
		index=index+1
		$VBoxContainer.add_child(buttton)
		_update_button_text_style(text_label)

func changeLanguage():
	for e in $VBoxContainer.get_children():
		var text_label:Label=e.get_child(0)
		_update_button_text_style(text_label)


func _update_button_text_style(text_label:Label):
	var locale=TranslationServer.get_locale()
	var translated_text=tr(text_label.text)
	var preferred_size=55
	text_label.position=BUTTON_TEXT_RECT.position
	text_label.size=BUTTON_TEXT_RECT.size
	text_label.vertical_alignment=VERTICAL_ALIGNMENT_CENTER
	if locale=="ru":
		preferred_size=36 if translated_text.length()>=9 else 40
		text_label.add_theme_font_override("font",russian_font)
	else:
		text_label.remove_theme_font_override("font")
		if locale=="en" and translated_text.length()>=14:
			preferred_size=46
		elif locale=="en" and translated_text.length()>=12:
			preferred_size=48

	var font=text_label.get_theme_font("font")
	var fitted_size=preferred_size
	while fitted_size>BUTTON_TEXT_MIN_SIZE and font.get_string_size(translated_text,HORIZONTAL_ALIGNMENT_LEFT,-1,fitted_size).x>BUTTON_TEXT_WIDTH:
		fitted_size-=1
	text_label.add_theme_font_size_override("font_size",fitted_size)
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
