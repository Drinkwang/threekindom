extends Node2D

class_name baseComponent
@export var dialogue_resource:DialogueResource
@export var dialogue_start:String="start"

var readyInitData:bool=true
# Called when the node enters the scene tree for the first time.
func _ready():
	if(readyInitData==true):
		_initData()
	#pass # Replace with function body.

func _initData():
	pass
func confireSaveFile():
	GameManager._savePanel.confireSaveFile()
	pass
	
	
	
func _enter_tree():
	self.request_ready()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
