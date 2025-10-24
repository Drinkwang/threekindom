extends baseComponent
class_name _cget_scene_item

@onready var items_in_scene: Node2D = $".."
@export var isKeyPoint:bool=false

var currenceKey:bool=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



var isHide=true


#@export var OccurInScene:SceneManager.roomNode
@export var SceneID=-1

#点击有二种可能 这个是不是诡异怪谈的道具，如果是诡异怪谈的道具，获得怪异道具-触发剧情，并把存档文件的是否获得给标注下
#如果不是的话，你需要判定一个东西，一个是这个是从哪里获取的，另外一个从哪里地方获取的

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

func setSecret(key):
	currenceKey=key
	if(currenceKey==true):
		gpu_particles_2d.modulate=Color.DARK_GREEN
	else:
		gpu_particles_2d.modulate=Color.WHITE

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:

	if !(event is InputEventMouseButton):
		return
	print(dialogue_start+var_to_str(event.button_index))
	if(event is InputEventMouseButton and event.button_index==1 and dialogue_start.length()>0):
		SoundManager.play_sound(sounds.SFX_FAST_UI_CLICK)
		#如果是隐藏道具
		GameManager.sav.todayCanFindItems.filter(func(item):return item.scene==items_in_scene.OccurInScene and item.id==SceneID)[0].alreadyGet=true
		#将存档的道具改成alreadyGet改成==true
		if currenceKey==true:
			getSceneInItemSecret()
		else:
			getSceneInItem()
			
		
		if isHide==true:
			self.hide()

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
	
	
	
	#积分随机抽奖物品逻辑，但存在问题是给的道具太多了，
	#我目前想法是 捡到钱可能就几十，然后或者商城道具随机一个
	
	
	#var _reward:rewardPanel=PanelManager.new_reward()
	#var items={
	#	"items": {InventoryManagerItem.ItemEnum.益气丸:2},
	#	"money": 0,
	#	"population": 0
	#}
	#GameManager.ScoreToItem()
	#GameManager.sav.hp=GameManager.sav.hp+10
	#_reward.showTitileReward(tr("恭喜你，你获得-益气丸x2"),items)	


	#是用积分逻辑 还是用物品逻辑
	#这里加上逻辑，可能获得道具，金钱，或者别的
	
	#这里将这个塞入回调，放在对话框可以执行
	
	
	DialogueManager.show_example_dialogue_balloon(items_in_scene.dialogue_resource,"发现场景道具"+var_to_str(SceneID))
	GameManager.getItemAction=func():
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
	
	
	

		_reward.showTitileReward(tr("你发现了以下道具"),item)
	
