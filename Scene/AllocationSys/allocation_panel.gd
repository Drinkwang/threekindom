extends Control
@export var arrs:Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initData() # Replace with function body.

func initData():

	for i in range(0,4):
		arrs[i].show()
		arrs[i].initData()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
