extends Control

@export var dialogue_resource:DialogueResource

var state:_SaveState
var savs:Array[saveData]=[null,null,null]
# Called when the node enters the scene tree for the first time.
func _ready():
	initLoad()
 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@onready var select = $select

var index=0


func saveFile():
	if(index>=1):
		if savs[index-1]!=null:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"SaveFile")
		else:
			confireSaveFile()
	
func confireSaveFile():
	ResourceSaver.save(GameManager.sav,"user://save_data{index}.tres".format({"index":str(index)}))
	savs[index-1]=GameManager.sav
	refresh()	
	
func initLoad():
	for i in range(1,4):
		var path="user://save_data{index}.tres".format({"index":i})
		if(FileAccess.file_exists(path)):
			savs[i-1]=load(path)
	refresh()
func loadFile():
	if(savs[index-1]!=null):
		GameManager.sav=savs[index]

	refresh()


func _on_close_button_down():
	pass # Replace with function body.

@onready var file_1 = $HBoxContainer/file1
@onready var file_2 = $HBoxContainer/file2
@onready var file_3 = $HBoxContainer/file3

func refresh():
	for i in range(1,4):
		if savs[i-1]!=null:
			self["file_"+str(i)].refresh(savs[i-1])
		else:
			self["file_"+str(i)].delete()
	pass

func _on_save_button_button_down():
	select.position=Vector2(180,237)
	
	state=_SaveState.save
	
func _on_load_button_button_down():
	select.position=Vector2(262,237)
	state=_SaveState.load
	
enum _SaveState{
	save,
	load
}

func SaveOrLoad():
	if(state==_SaveState.save):
		saveFile()	
	else:
		loadFile()
	
	

func _on_file_1_gui_input(event):
	if(event is InputEventMouseButton and event.button_index==1 and event.pressed):	
		index=1
		SaveOrLoad()
	#pass # Replace with function body.


func _on_file_2_gui_input(event):
	if(event is InputEventMouseButton and event.button_index==1 and event.pressed):
		index=2
		SaveOrLoad()
	#pass # Replace with function body.


func _on_file_3_gui_input(event):
	if(event is InputEventMouseButton and event.button_index==1 and event.pressed ):	
		index=3
		SaveOrLoad()
	#pass # Replace with function body.


