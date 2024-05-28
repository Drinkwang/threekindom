extends baseComponent

@onready var timer = $Timer

const FancyFade = preload("res://addons/transitions/FancyFade.gd")
@export var wisdoms:Array[String]
# Called when the node enters the scene tree for the first time.
func _ready():
	Transitions.post_transition.connect(post_transition)
	label.text=wisdoms[randi() % wisdoms.size()]
	# Replace with function body.

@onready var label = $CanvasLayer/Label

func ban():
	print("xxxx")
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func post_transition():
	print("fadedone")
	$Timer.start()
	#_initData()

	pass

func _on_timer_timeout():
	const DISSOLVE_IMAGE = preload("res://addons/transitions/images/circle-inverted.png")
	FancyFade.new().custom_fade(SceneManager.HOUSE.instantiate(), 2, DISSOLVE_IMAGE)	
	
	#pass # Replace with function body.
