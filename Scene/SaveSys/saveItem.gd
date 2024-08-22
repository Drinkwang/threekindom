extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
@onready var label = $Label
@onready var nodate = $nodate

func refresh(sav:saveData):
	nodate.hide()
	label.show()
	label.text="時間：2024/8/21\n/15/31\n游戲天數：5\n擁有黃金：100\n人心：80\n勞夫：90"
	
func delete():
	nodate.show()
	label.hide()	
