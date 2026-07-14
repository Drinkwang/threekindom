extends baseComponent
class_name _cget_scene_item

@onready var items_in_scene: Node2D = $".."
@onready var area_2d: Area2D = $Area2D
@export var isKeyPoint:bool=false

var currenceKey:bool=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



var isHide=true
var _pickup_consumed := false


#@export var OccurInScene:SceneManager.roomNode
@export var SceneID=-1

#点击有二种可能 这个是不是诡异怪谈的道具，如果是诡异怪谈的道具，获得怪异道具-触发剧情，并把存档文件的是否获得给标注下
#如果不是的话，你需要判定一个东西，一个是这个是从哪里获取的，另外一个从哪里地方获取的

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

func setSecret(key):
	currenceKey=key
	if(currenceKey==true):
		gpu_particles_2d.modulate=Color.GREEN
	else:
		gpu_particles_2d.modulate=Color.WHITE

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:

	if !(event is InputEventMouseButton):
		return
	if not event.pressed:
		return
	if DialogueManager.haveDialoge() or _is_mouse_blocked():
		return
	if _pickup_consumed:
		return
	print(dialogue_start+var_to_str(event.button_index))
	if(event is InputEventMouseButton and event.button_index==1 and dialogue_start.length()>0):
		var item_records = GameManager.sav.todayCanFindItems.filter(func(item):return item.scene==items_in_scene.OccurInScene and item.id==SceneID)
		if item_records.is_empty():
			return
		_pickup_consumed = true
		area_2d.input_pickable = false
		SoundManager.play_sound(sounds.SFX_FAST_UI_CLICK)
		#如果是隐藏道具
		item_records[0].alreadyGet=true
		#将存档的道具改成alreadyGet改成==true
		if currenceKey==true:
			getSceneInItemSecret()
		else:
			getSceneInItem()
		if isHide==true:
			self.hide()


# Scene pickups are Area2D nodes, so they need the same modal-UI guard as clickBlock.
func _is_mouse_blocked() -> bool:
	var tree := get_tree()
	if tree == null:
		return false
	var mouse_position := get_viewport().get_mouse_position()
	var viewport_size := get_viewport().get_visible_rect().size
	var min_size := viewport_size * 0.6
	var canvas_layers: Array = []
	_collect_canvas_layers(tree.root, canvas_layers)
	for canvas_layer in canvas_layers:
		if canvas_layer.visible == false:
			continue
		for child in canvas_layer.get_children():
			if not (child is Control) or child.visible == false:
				continue
			var blocker := child as Control
			if blocker.mouse_filter == Control.MOUSE_FILTER_IGNORE:
				continue
			if not _is_blocker_above_self(blocker):
				continue
			var rect := blocker.get_global_rect()
			if rect.size.x >= min_size.x and rect.size.y >= min_size.y and rect.has_point(mouse_position):
				return true
	return false


func _is_blocker_above_self(blocker: Control) -> bool:
	var blocker_layer := _get_canvas_layer_for_node(blocker)
	var self_layer := _get_canvas_layer_for_node(self)
	if blocker_layer != self_layer:
		if blocker_layer == null:
			return false
		if self_layer == null:
			return true
		if blocker_layer.layer != self_layer.layer:
			return blocker_layer.layer > self_layer.layer
		return blocker_layer.get_index() > self_layer.get_index()

	var compare_parent: Node = blocker_layer if blocker_layer != null else blocker.get_parent()
	var blocker_branch := _get_direct_child_under(compare_parent, blocker)
	var self_branch := _get_direct_child_under(compare_parent, self)
	if blocker_branch == null or self_branch == null or blocker_branch == self_branch:
		return false
	if blocker_branch is CanvasItem and self_branch is CanvasItem:
		if (blocker_branch as CanvasItem).z_index != (self_branch as CanvasItem).z_index:
			return (blocker_branch as CanvasItem).z_index > (self_branch as CanvasItem).z_index
	return blocker_branch.get_index() > self_branch.get_index()


func _get_canvas_layer_for_node(node: Node) -> CanvasLayer:
	var current := node
	while current != null:
		if current is CanvasLayer:
			return current
		current = current.get_parent()
	return null


func _get_direct_child_under(parent_node: Node, node: Node) -> Node:
	var current := node
	while current != null and current.get_parent() != parent_node:
		current = current.get_parent()
	return current if current != null and current.get_parent() == parent_node else null


func _collect_canvas_layers(node: Node, result: Array) -> void:
	if node is CanvasLayer:
		result.append(node)
	for child in node.get_children():
		_collect_canvas_layers(child, result)

func getSceneInItemSecret():
	var sceneNode:SceneManager.roomNode=items_in_scene.OccurInScene
	if sceneNode==SceneManager.roomNode.BOULEUTERION:
		DialogueManager.show_example_dialogue_balloon(items_in_scene.dialogue_resource,"发现诡秘怪谈")
	elif sceneNode==SceneManager.roomNode.GOVERNMENT_BUILDING:
		DialogueManager.show_example_dialogue_balloon(items_in_scene.dialogue_resource,"发现诡秘怪谈")
	elif sceneNode==SceneManager.roomNode.DRILL_GROUND:
		DialogueManager.show_example_dialogue_balloon(items_in_scene.dialogue_resource,"发现诡秘怪谈")

func getSceneInItem():
	var sceneNode:SceneManager.roomNode=items_in_scene.OccurInScene
	GameManager.getItemAction=func():
		GameManager.getItemAction = func():
			pass
		var items:Array=[InventoryManagerItem.ItemEnum.珍品礼盒,InventoryManagerItem.ItemEnum.益气丸, InventoryManagerItem.ItemEnum.胜战锦囊, InventoryManagerItem.ItemEnum.诸子百家论集]
		var rindex= randi_range(0,items.size()-1)
		var itemname= InventoryManagerItem.item_by_enum(items[rindex])
	
		var item
		var randomValue=randi_range(0,8)
		if randomValue<=2:
			item={
				"items": {items[rindex]:1},
				"money": 0,
				"population": 0
			}
		else:
			item={
				"items":null,
				"money": 10+10*GameManager.sav.randomIndex,
				"population": 0
			}
	
		var _reward:rewardPanel=PanelManager.new_reward()
		AchievementManager.set_achievement("NEW_ACHIEVEMENT_1_5")
		_reward.showTitileReward(tr("你发现了以下道具"),item)
	DialogueManager.show_example_dialogue_balloon(items_in_scene.dialogue_resource,"发现场景道具"+var_to_str(SceneID))
