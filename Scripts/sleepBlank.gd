extends baseComponent

@onready var timer = $Timer

const FancyFade = preload("res://addons/transitions/FancyFade.gd")
@export var wisdoms:Array[String]
# Called when the node enters the scene tree for the first time.
func _ready():
	#GameManager.currenceScene=self
	Transitions.post_transition.connect(post_transition)
	if GameManager.restLabel.length()<=0:
		var day=GameManager.sav.currenceValue
		if GameManager.sav.have_event["战斗袁术血战模式"]==true:
			label.text=tr("血战模式第{n}天").format({"n":day})+"\n"+wisdoms[randi() % wisdoms.size()]
		else:
			label.text=wisdoms[randi() % wisdoms.size()]
		fadeScene=SceneManager.HOUSE
	else:
		label.text=GameManager.restLabel
		GameManager.restLabel=""
	
	if(GameManager.restFadeScene!=null):
		fadeScene=GameManager.restFadeScene
		GameManager.restFadeScene=null
	else:
		fadeScene=SceneManager.HOUSE
	# Replace with function body.
	$Timer.wait_time=GameManager.wait_time
@onready var label = $CanvasLayer/Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func post_transition():
	print("fadedone")
	$Timer.start()
	changeAndSave()
	#存档，数据变化
	#_initData()

	pass

func changeAndSave():
	if GameManager.sav.Merit_points<3:
		GameManager.sav.Merit_points=GameManager.sav.Merit_points+1;
	pass


var fadeScene
func _on_timer_timeout():
	const DISSOLVE_IMAGE = preload("res://addons/transitions/images/circle-inverted.png")
	FancyFade.new().custom_fade(fadeScene.instantiate(), 2, DISSOLVE_IMAGE)	
	GameManager.wait_time=2
	#pass # Replace with function body.
