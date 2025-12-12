class_name granary_house
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currenceValue=0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
@onready var detail: Label = $Label3

@export var currenceValue=0
@export var maxValue=-1





var numGranary
var _index
func initData(index):
	currenceValue=0
	isOverFill=false
	numGranary="{num}号粮仓".format({"num":index})
	_index=index
	if GameManager.selectPuzzleDiffcult==SceneManager.puzzlediffucult.easy:
		maxValue=100
	elif GameManager.selectPuzzleDiffcult==SceneManager.puzzlediffucult.middle:
		maxValue=100
	elif GameManager.selectPuzzleDiffcult==SceneManager.puzzlediffucult.high:
		if index==1 or index==5:
			maxValue=250
		else:
			maxValue=100
	refreshText()
@onready var texture_rect_6: TextureRect = $TextureRect6

var isOverFill=false
func refreshText():
	if currenceValue<=maxValue:
		detail.text=numGranary+"({num1}/{num2})".format({"num1":currenceValue,"num2":maxValue})
	else:
		isOverFill=true
		detail.text=numGranary+"(已报废)"
		texture_rect_6.modulate=Color.RED
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !(event is InputEventMouseButton) or DialogueManager.dialogBegin==true or GameManager.rewardPanel==true or isOverFill==true:
		return
	#大概率是后面二项导致的	
	print("dialogBegin "+var_to_str(DialogueManager.dialogBegin))
	print("rewardPanel "+var_to_str(GameManager.rewardPanel))
	if(event is InputEventMouseButton and event.button_index==1):
		SoundManager.play_sound(sounds.SFX_FAST_UI_CLICK)
		
		GameManager.PuzzleScene.selectGrannary(self)
func addValue(_value):
	currenceValue+=_value
	refreshText()
	GameManager.PuzzleScene._distrutionGrand(_value)
