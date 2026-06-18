extends Node2D

class_name baseComponent
@export var dialogue_resource:DialogueResource
@export var dialogue_start:String="start"

var readyInitData:bool=true
# Called when the node enters the scene tree for the first time.
func _ready():
	if(readyInitData==true):
		_initData()
		if(GameManager._savePanel!=null):
			GameManager._savePanel.hide()

	# clear stale dialog state on scene entry, prevents ESC not working after story transition
	DialogueManager.dialogBegin=false
	# 延迟一帧再清一次，防止 _ready 阶段触发的对话在气球异步初始化后重设该标志
	call_deferred("_clear_dialog_begin")

	if GameManager.isLoadingSave==true:
		GameManager.showLoadSuccusss()
	#pass # Replace with function body.

func _initData():
	pass

# 延迟清理 dialogBegin，解决 _ready 中触发对话后点击被吞的问题
func _clear_dialog_begin():
	DialogueManager.dialogBegin = false
func confireSaveFile():
	GameManager._savePanel.confireSaveFile()

	

	
func _enter_tree():
	self.request_ready()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
