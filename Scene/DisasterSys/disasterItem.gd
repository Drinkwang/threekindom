@tool
class_name disaterItem
extends Control
@onready var head = $TextureRect

const scissor= preload("res://Asset/other/剪刀.png")
const paper= preload("res://Asset/other/布.png")
const stone = preload("res://Asset/other/石头.png")


@export var factionSurpuls:cldata
#@export var heroIndex:int
#



@export var headImg:Texture2D:
	get:
		return headImg
	set(value):
		headImg=value
		if(headImg!=null):
			$TextureRect.texture=headImg
@onready var context = $Panel/context

@onready var detail_cotext = $detail3

@export_multiline var detail_str:String:
	get:
		return detail_str
	set(value):
		detail_str=value
		if(detail_cotext!=null and detail_cotext!=null):
			detail_cotext.text=detail_str


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
	if(namelv!=null):
		context.text=namelv
		
	if(detail_cotext!=null and detail_cotext!=null):
		detail_cotext.text=detail_str
		
	refreshHaveGrain()	
	changeLanguage()
func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="ja":
		pass
	elif currencelanguage=="ru":
		
		$TextureRect/Label2.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		$TextureRect/Label2.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
	else:
		pass
		
		
const NOT_JAM_UI_CONDENSED_16 = preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func resetZero():
	if(_num>=1):
		
		GameManager.resideGrain=GameManager.resideGrain+_num
		_num=0
	edit_txt.text = str(_num)
	refreshHaveGrain()	

#func settlement(int happy,int)->bool:
	#if _num+factionSurpuls._num_grain>
	#pass

#赵云：lv1	
#{"name": "张飞", "level": 1, "max_level": 10, "randominit": -1,"isBattle":false}




func _on_up_btn_button_down():
	if  GameManager.resideGrain>=1:
		_num=_num+1
		GameManager.resideGrain=GameManager.resideGrain-1
	edit_txt.text = str(_num)
	refreshHaveGrain()
	#pass # Replace with function body.


func _on_down_btn_button_down():
	if(_num>=1):
		_num=_num-1
		GameManager.resideGrain=GameManager.resideGrain+1
	edit_txt.text = str(_num)
	refreshHaveGrain()
	#pass # Replace with function body.
@onready var edit_txt = $TextEdit3

var _num=0
#当文本改变
func _on_text_edit_3_text_changed():
	GameManager.resideGrain=GameManager.resideGrain+_num
	var num=float(edit_txt.text)
	if(num>=GameManager.resideGrain):
		num=GameManager.resideGrain
	_num=num
	GameManager.resideGrain=GameManager.resideGrain-_num	
	edit_txt.text = str(_num)
	refreshHaveGrain()
@onready var have_grain = $haveGrain

func refreshHaveGrain():
	have_grain.text="已有粮食数量："+str(_num+factionSurpuls._num_grain)
	
	#pass # Replace with function body.
