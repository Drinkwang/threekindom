@tool
class_name lawpoint
extends Control
var isUnlock:bool=false

@onready var control = $"../.."
const _0_RED = preload("res://Scene/0_red.png")
const _1_BLUE = preload("res://Scene/1_blue.png")
const _2_GREEN = preload("res://Scene/2_green.png")
@export var costPoint:int=3
@export var _color:lawcolor
@export var lawpoins:Array[lawpoint]
@export var detail:String
#detail 由收益理由 加收益组成 收益放在外面
@export var IncomeBg:String
@export var IncomeTxt:String

@export var context:String:
	get:
		return context
	set(value):
		context=value
		if $PanelContainer/MarginContainer/Label!=null:
			$PanelContainer/MarginContainer/Label.text=value
		

var context_tr:String:
	get:
		return tr(context)
@export var num1=-1
@export var num2=-1
# Called when the node enters the scene tree for the first time.
func _ready():
	$PanelContainer/MarginContainer/Label.text=context
	#判断是否该解锁，通过存档数据
	detail="{bg}({Txt})".format({"bg":IncomeBg,"Txt":IncomeTxt})
	var stringandNum=self.name.get_slice("-",0)
	num1=-1
	num2= int(self.name.get_slice("-",1))
	
	var regex = RegEx.new()
	regex.compile("\\d+")
	var all_numbers_found = regex.search_all(stringandNum)
	
	for number in all_numbers_found:
		num1 = int(number.get_string())-1
	
	#print(num1)
	#GameManager.sav.laws[num1].append(num1)	
	if GameManager.sav!=null and GameManager.sav.laws!=null and GameManager.sav.laws[num1].has(num2):
		self.isUnlock=true
	
	_initData()
	if SignalManager and SignalManager.has_signal("changeLanguage"):
		SignalManager.changeLanguage.connect(_changeLanguage)			
	_changeLanguage()
	pass # Replace with function body.


func _changeLanguage():
	var currencelanguage=TranslationServer.get_locale()

	if currencelanguage=="ru":

		$PanelContainer/MarginContainer/Label.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
			
	else:
		$PanelContainer/MarginContainer/Label.remove_theme_font_override("font")

@onready var texture_rect = $TextureRect2/TextureRect
@onready var animation_player = $AnimationPlayer

func _initData():
	if isUnlock==true:
		texture_rect.show()
		animation_player.stop()
		if _color==lawcolor.red:
			$TextureRect2/TextureRect.texture=_0_RED
		elif _color==lawcolor.blue:
			$TextureRect2/TextureRect.texture=_1_BLUE
		elif _color==lawcolor.green:
			$TextureRect2/TextureRect.texture=_2_GREEN
		#已解锁
	if lawpoins.size()>0:
		if lawpoins.any(func(value):return value.isUnlock==true)==true:
			texture_rect.show()
			animation_player.play("blink")
			#待解锁
		else:
			pass
			texture_rect.hide()
			#未解锁
	else:
		texture_rect.show()
		animation_player.play("blink")
		#待解锁
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

const _001_HOVER_01 = preload("res://Asset/sound/ui/001_Hover_01.wav")
const _013_CONFIRM_03 = preload("res://Asset/sound/ui/013_Confirm_03.wav")
func _on_gui_input(event):
	if GameManager.sav.curLawName.length()>0 or GameManager.sav.curLawNum1!=-1 or GameManager.sav.curLawNum2!=-1:
		return 

	
	if isUnlock==true:
		return
	if lawpoins.size()>0:
		if lawpoins.any(func(value):return value.isUnlock==true)==false:
			return
	if event is InputEventMouseButton and event.button_index==1:
		control.preLaw(self)
		#SoundManager.play_sound(_001_HOVER_01)
	elif(event is InputEventMouseButton and event.double_click==true):
		control.excuteLaw(self)
		SoundManager.play_sound(_013_CONFIRM_03)
		#GameManager.sav.
	pass # Replace with function body.

enum lawcolor{
	red,blue,green
}


func _on_mouse_entered():
	pass
	#SoundManager.play_sound(_001_HOVER_01)
