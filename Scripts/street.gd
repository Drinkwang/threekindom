extends Node2D

@onready var control = $Control

# Called when the node enters the scene tree for the first time.
func _ready():
	var initData=[
	{	
		"id":"1",
		"context":"府邸", #前往小道通向议事厅 
		"visible":"true"
	},
	{
		"id":"2",
		"context":"自宅", #前往花园并通向小道
		"visible":"true"
	},
	{
		"id":"3",
		"context":"议事厅",#前往大街
		"visible":"true"
	},
	{
		"id":"4",
		"context":"商店",#打开人物面板
		"visible":"true"
	},
	{
		"id":"5",
		"context":"军事商店",#打开属性ui
		"visible":"true"
	},
	{
		"id":"6",
		"context":"城门-军事驻地", #天数加1 进入过度
		"visible":"true"
	}]
	control._processList(initData)

	control.buttonClick.connect(_buttonListClick)

		
	pass # Replace with function body.

func _buttonListClick(item):
	if item.context == "外出":
		pass
	elif item.context == "今日政务":
		pass
	elif item.context == "属性面板":
		pass
	print(item)
	pass
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
