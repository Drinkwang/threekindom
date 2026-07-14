extends Node2D

@export var OccurInScene:SceneManager.roomNode
var itmes:Array[Node]
var _hidden_for_dialogue := false
var _visible_before_dialogue := true
var _active_dialogue_count := 0


@export var dialogue_resource:DialogueResource
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	itmes=self.get_children()
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	if DialogueManager.haveDialoge():
		_active_dialogue_count=1
		_hide_for_dialogue()


func _on_dialogue_started(_resource) -> void:
	_active_dialogue_count+=1
	_hide_for_dialogue()


func _hide_for_dialogue() -> void:
	if _hidden_for_dialogue:
		return
	_visible_before_dialogue=visible
	_hidden_for_dialogue=true
	hide()


func _on_dialogue_ended(_resource) -> void:
	if _active_dialogue_count>0:
		_active_dialogue_count-=1
	if _active_dialogue_count>0 or not _hidden_for_dialogue:
		return
	visible=_visible_before_dialogue
	_hidden_for_dialogue=false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func showItems():
	for ele in GameManager.sav.todayCanFindItems:
		var text=ele.name
		var haskey= text.begins_with("key") #如果有key 不能增加
		if ele.scene==OccurInScene and ele.alreadyGet==false:
			showitem(ele.id,haskey)
			#pass
			#"#id":3,"scene":SceneManager.roomNode.BOULEUTERIO
	#判断今天的item，如果没有捡起，则显示 否则设置成true


func hideItems():
	var arrs=self.get_children()
	for e in arrs:
		e.hide()

func showitem(index,haskey):
	var ele=itmes.filter(func(item): return item.SceneID==index)[0]
	ele.show()
	ele.setSecret(haskey)
