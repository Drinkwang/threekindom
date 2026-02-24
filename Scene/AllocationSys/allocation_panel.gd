extends Control
@export var arrs:Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func initData():
	var sizeLenth=3
	if GameManager.sav.have_event["lvbuJoin"]==true:
		sizeLenth=4
	for i in range(0,sizeLenth):
		arrs[i].show()
		arrs[i].initData()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
