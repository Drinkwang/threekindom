@tool
extends baseComponent
@onready var img = $img
@export var showName:String="":
	set(value):
		showName=value
		if $Panel!=null and value.length()>0:
			$Panel.show()
			$Panel/Label.text=value;
		else: 
			if $Panel!=null and value.length()==0:
				$Panel.hide()
			
	get:
		return showName
@export var dialogue_doubleclick:String
@export var showborder:bool=true:
	set(isshow):
		showborder=isshow
		if $"8"!=null and isshow==false:
			$"8".hide()
		else: 
			if $"8"!=null and isshow==true:
				$"8".show()
			
	get:
		return showborder
		

@onready var ex_point = $exPoint


@export var showEX:bool=false:
	set(value):
		showEX=value
	
		if ex_point==null:
			return
		if showEX==true:
			ex_point.show()
		else:
			ex_point.hide()

	get:
		return showEX

@export var txt2d:Texture2D:
	#if Engine.editor_hint:
	set(txt):
		txt2d=txt
		print(txt)
		if img!=null:
			img.texture=txt

	get:
		return txt2d
		

# Called when the node enters the scene tree for the first time.
func _ready():
	img.texture=txt2d
	
	if showborder==false:
		$"8".hide()
	else: 
		$"8".show()
		
	if $Panel!=null and showName.length()>0:
		$Panel.show()
		$Panel/Label.text=showName;
	else:
		$Panel.hide()
	SignalManager.changeLanguage.connect(changeLanguage)			
	changeLanguage()	
	
	
	if showEX==true:
		ex_point.show()
	else:
		ex_point.hide()
	
	#const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
	#$TextureRect.texture=preload('res://addons/transitions/images/blurry-noise.png')
	#$Sprite2D.texture=load("res://Asset/内屋.jpg")
	#FancyFade.custom_fade($"..".instance(), 1.5, DISSOLVE_IMAGE)
	pass # Replace with function body.
@onready var label = $Panel/Label
const NOT_JAM_UI_CONDENSED_16 = preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")
func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()

	if currencelanguage=="ru":
		label.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
	else:
		label.remove_theme_font_override("font")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


@export var isHide=true

func _on_area_2d_input_event(viewport, event, shape_idx):
	
	if !(event is InputEventMouseButton):
		return
	print(dialogue_start+var_to_str(event.button_index))
	if(event is InputEventMouseButton and event.button_index==1 and dialogue_start.length()>0):
		SoundManager.play_sound(sounds.SFX_FAST_UI_CLICK)
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
		if isHide==true:
			self.hide()
	#等待2秒，如果2秒还为单击，则为单击
	if(event is InputEventMouseButton and event.double_click==true and dialogue_doubleclick.length()>0):
		SoundManager.play_sound(sounds.SFX_FAST_UI_CLICK)
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_doubleclick)
		if isHide==true:
			self.hide()
	pass



func changeAllClick(_value):
	dialogue_start=_value
	dialogue_doubleclick=_value

func _on_timer_timeout():

	pass # Replace with function body.
