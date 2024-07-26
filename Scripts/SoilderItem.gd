@tool
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
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateContext(value):
	pass


