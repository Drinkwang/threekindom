extends Node2D

@onready var liubei = $liubei

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _input(event):
	if event is InputEventMouseMotion:
		liubei.position=event.global_position
	#print(event)
		pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
