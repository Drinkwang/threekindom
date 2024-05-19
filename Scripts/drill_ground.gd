extends Node2D


@onready var control= $Control2

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var initData=[
	{	
		"id":"1",
		"context":"离开此地", #前往小道通向议事厅 
		"visible":"true"
	},
	{
		"id":"2",
		"context":"操练士兵", #前往花园并通向小道
		"visible":"true"
	},
	{
		"id":"3",
		"context":"军事行动",#前往大街
		"visible":"true"
	},

	]
	control._processList(initData)

	control.buttonClick.connect(_buttonListClick)


func _buttonListClick(item):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
