extends Node2D

@export var OccurInScene:SceneManager.roomNode
var itmes:Array[Node]


@export var dialogue_resource:DialogueResource
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	itmes=self.get_children()
	



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



func showitem(index,haskey):
	var ele=itmes.filter(func(item): return item.SceneID==index)[0]
	ele.show()
	ele.setSecret(haskey)
