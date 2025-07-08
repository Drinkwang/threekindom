extends CanvasLayer
class_name savePanel
@export var dialogue_resource:DialogueResource

var state:_SaveState
var savs:Array[saveData]=[null,null,null]
var isHide:bool=true
# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager._savePanel=self
	initLoad()
	if DialogueManager.gameover==true:
		_on_load_button_button_down()
		save_text.add_theme_color_override("font_color",Color.DIM_GRAY)
 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@onready var select = $Control/select

var index=0

@onready var load_text = $Control/load
@onready var save_text = $Control/save



func saveFile():
	if(index>=1):
		if savs[index-1]!=null:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource,"SaveFile")
		else:
			confireSaveFile()
	
func confireSaveFile():
	#GameManager.sav.current_datetime=Time.get_datetime_string_from_datetime_dict(Time.get_unix_time_from_system(),false)
	#Time.get_unix_time_from_system()

	var DateTime = Time.get_datetime_dict_from_system()
	var strTime="{year}/{month}/{day}\n/{hour}/{minus}".format({"year":DateTime.year,"month":DateTime.month,"day":DateTime.day,"hour":DateTime.hour,"minus":DateTime.minute})

# 格式化DateTime对象为字符串
	#var formatted_time = DateTime.format_datetime("%Y年 %m月 %d日")
	#print( formatted_time)
	GameManager.sav.current_datetime=strTime
	if(GameManager.currenceScene!=null):
		GameManager.sav.saveScene.pack(GameManager.currenceScene)
		pass
	GameManager.sav.autoSave=false
	# 格式化DateTime对象为字符串
	#var formatted_time = GameManager.sav.current_datetime.format_datetime("%Y-%m-%d %H:%M:%S")
	#print("Formatted date and time:", current_datetime)
	ResourceSaver.save(GameManager.sav,"user://save_data{index}.tres".format({"index":str(index)}))
	savs[index-1]=GameManager.sav
	refresh()	
	
func initLoad():
	for i in range(1,4):
		var path="user://save_data{index}.tres".format({"index":i})
		if(FileAccess.file_exists(path)):
			savs[i-1]=load(path)
	refresh()
	
	
#赈灾次数
var _GrainNum=0
func loadFile():
	if(savs[index-1]!=null):
		GameManager.sav=savs[index-1].duplicate(false)
		GameManager.sav.ensure_default_fields()
		get_tree().change_scene_to_packed(savs[index-1].saveScene)

	refresh()
	self.hide()




func _on_close_button_down():
	if isHide==true:
		self.hide()
	else:
		self.queue_free()
	#pass # Replace with function body.

@onready var file_1 = $Control/HBoxContainer/file1
@onready var file_2 = $Control/HBoxContainer/file2
@onready var file_3 = $Control/HBoxContainer/file3

func refresh():
	for i in range(1,4):
		if savs[i-1]!=null:
			self["file_"+str(i)].refresh(savs[i-1])
		else:
			self["file_"+str(i)].delete()
	pass

func _on_save_button_button_down():
	if DialogueManager.gameover==false:
		select.position=Vector2(736,654.87)
	
		state=_SaveState.save
	
func _on_load_button_button_down():
	select.position=Vector2(912,654.87)
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


