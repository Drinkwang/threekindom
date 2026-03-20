@tool
class_name SoilderItem
extends Control
@onready var head = $TextureRect
@onready var rsp = $TextureRect/rsp
const scissor= preload("res://Asset/other/剪刀.png")
const paper= preload("res://Asset/other/布.png")
const stone = preload("res://Asset/other/石头.png")
@onready var check_box = $TextureRect/CheckBox



#@export var heroIndex:int
#

@export var canSelect:bool=true:
	get:
		return canSelect
	set(value):
		canSelect=value
		if(check_box!=null):
			if(canSelect==true):
				check_box.show()
			else: 
				check_box.hide()

@export var headImg:Texture2D:
	get:
		return headImg
	set(value):
		headImg=value
		if(headImg!=null):
			$TextureRect.texture=headImg


@export var namelv:String:
	get:
		return namelv
	set(value):
		namelv=value
		if(namelv!=null):
			$TextureRect/Label2.text=namelv


@export var repImg:GameManager.RspEnum:
	get:
		return repImg
	set(value):
		if(repImg!=null):
			repImg=value
			if repImg==GameManager.RspEnum.ROCK:
				$TextureRect/rsp.texture=stone
			elif repImg==GameManager.RspEnum.PAPER:
				$TextureRect/rsp.texture=paper				
			elif repImg==GameManager.RspEnum.SCISSORS:
				$TextureRect/rsp.texture=scissor	
			else:
				$TextureRect/rsp.texture=null
			
# Called when the node enters the scene tree for the first time.
func _ready():
	if(headImg!=null):
		$TextureRect.texture=headImg# Replace with function body.
	if(namelv!=null):
		$TextureRect/Label2.text=namelv	
		
		
	if repImg==GameManager.RspEnum.ROCK:
		$TextureRect/rsp.texture=stone
	elif repImg==GameManager.RspEnum.PAPER:
		$TextureRect/rsp.texture=paper				
	elif repImg==GameManager.RspEnum.SCISSORS:
		$TextureRect/rsp.texture=scissor	
	else:
		$TextureRect/rsp.texture=null
		
	if(canSelect==true):
		check_box.show()
	else: 
		check_box.hide()
	if is_instance_valid(SignalManager):	
		SignalManager.changeLanguage.connect(_changeLanguage)				
	_changeLanguage()
func _changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="ja":
		pass
	elif currencelanguage=="ru":
		pass
		#
		#$TextureRect/Label2.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		#$TextureRect/Label2.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
	else:
		pass
		
		
const NOT_JAM_UI_CONDENSED_16 = preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
@onready var already_use = $alreadyUse

var alreadyUse:bool=false:
	get:
		return alreadyUse
	set(value):
		alreadyUse=value
		if(check_box!=null):
			if(alreadyUse==true):
				check_box.hide()
				already_use.show()
			else: 
				check_box.show()
				already_use.hide()
func Use():
	alreadyUse=true
	pass
	
@onready var isdie: TextureRect = $isdie
@onready var isexit: TextureRect = $isexit

	
var liubeitxt=preload("res://Asset/人物/刘备.png")
var xiahoutxt=preload("res://Asset/人物/夏侯淳.png")
#赵云：lv1	
#{"name": "张飞", "level": 1, "max_level": 10, "randominit": -1,"isBattle":false}
func updateContext(value):
	var general=GameManager.sav.generals[repImg]
	var _name=general.name
	var _level=general.level
	if value==0:
		if GameManager.sav.have_event["关羽求援期间"]==true and GameManager.sav.have_event["关羽求援结束"]==false:
			isexit.show()
			#alreadyUse=false
			#canSelect=false
			check_box.hide()
			already_use.hide()			
		#关羽且无法点击
	
	elif value==1:
		#是张飞

		if GameManager.sav.have_event["战斗袁术血战模式"]==true and GameManager.sav.have_event["血战袁术完成"]==false:
			_name="刘备"
			_level=10
			headImg=liubeitxt
			#利用这个判断
			#pass
	elif value==2:
		if GameManager.sav.have_event["无名之死"]==true and GameManager.sav.have_event["夏侯偷马"]==false:
			isdie.show()
			#alreadyUse=false
			#canSelect=false
			check_box.hide()
			already_use.hide()
		elif GameManager.sav.have_event["夏侯偷马"]==true:
			_name="夏侯淳"
			_level=10
			headImg=xiahoutxt
		#赵云之死
	namelv=tr(str(_name))+":"+"LV"+str(_level)
