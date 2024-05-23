extends baseComponent

@onready var control = $Control

# Called when the node enters the scene tree for the first time.
func _ready():
	#DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
	var initData=[
	{	
		"id":"1",
		"context":"执行政策", #前往小道通向议事厅 
		"visible":"true"
	},
	{
		"id":"2",
		"context":"召见手下", #前往花园并通向小道
		"visible":"true"
	},
	{
		"id":"3",
		"context":"离开",#前往大街
		"visible":"true"
	},

	]
	control._processList(initData)

	control.buttonClick.connect(_buttonListClick)

		
	pass # Replace with function body.


func _buttonListClick(item):
	if item.context == "执行政策":

		pass
	elif item.context == "召见手下":
		#显示接下来要点击啥
		pass
	elif item.context == "离开":
		const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
		#FancyFade.new().custom_fade(STREET.instantiate(), 2, DISSOLVE_IMAGE)
		#显示金钱 民心 xx 武将面板
	print(item)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
