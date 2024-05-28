extends Node2D

class_name baseComponent
@export var dialogue_resource:DialogueResource
@export var dialogue_start:String="start"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _enter_tree():
	self.request_ready()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
