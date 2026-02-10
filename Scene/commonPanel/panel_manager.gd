extends Node




func _ready() -> void:
	pass
	# Cache the known Node2D properties

## Show the example balloon
func show_example_dialogue_balloon(title: String = "", extra_game_states: Array = [])->CanvasLayer:
	var balloon: Node = load(_get_example_balloon_path()).instantiate()
	get_current_scene.call().add_child(balloon)
	#balloon.start(resource, title, extra_game_states)

	return balloon

## Show the configured dialogue balloon
func show_Tied( ) -> TiredPanel:
	var balloon_path: String# = DialogueSettings.get_setting(&"balloon_path", _get_example_balloon_path())
	if not ResourceLoader.exists(balloon_path):
		balloon_path = _get_tied_example_balloon_path()
	return show_tied_scene(balloon_path)


func _get_tied_example_balloon_path() -> String:
	var balloon_path: String = "/TriedPanel.tscn" #if is_small_window else "/example_balloon/example_balloon.tscn"
	return get_script().resource_path.get_base_dir() + balloon_path


func show_tied_scene(tied_scene) -> TiredPanel:
	if tied_scene is String:
		tied_scene = load(tied_scene)
	if tied_scene is PackedScene:
		tied_scene = tied_scene.instantiate()

	var balloon: Node = tied_scene
	get_current_scene.call().add_child(balloon)

	return balloon




## Show the configured dialogue balloon
func new_reward( title: String = "") -> rewardPanel:
	#GameManager.rewardPanel=true
	var balloon_path: String# = DialogueSettings.get_setting(&"balloon_path", _get_example_balloon_path())
	if not ResourceLoader.exists(balloon_path):
		balloon_path = _get_example_balloon_path()
	return show_reward_scene(balloon_path, title)


## Show a given balloon scene
func show_reward_scene(reward_scene, title: String = ""):
	if reward_scene is String:
		reward_scene = load(reward_scene)
	if reward_scene is PackedScene:
		reward_scene = reward_scene.instantiate()

	var balloon: Node = reward_scene
	get_current_scene.call().add_child(balloon)

	return balloon



const SAVE_PANEL = preload("res://Scene/SaveSys/savePanel.tscn")

func show_Save_panel():

	var tied_scene = SAVE_PANEL.instantiate()

	var balloon: savePanel = tied_scene
	balloon.isHide=false
	get_current_scene.call().add_child(balloon)

	return balloon


#下面二个方法无需变更

# Get the path to the example balloon
func _get_example_balloon_path() -> String:
	var is_small_window: bool = ProjectSettings.get_setting("display/window/size/viewport_width") < 400
	var balloon_path: String = "/rewardPanel.tscn" #if is_small_window else "/example_balloon/example_balloon.tscn"
	return get_script().resource_path.get_base_dir() + balloon_path

var get_current_scene: Callable = func():
	var current_scene: Node = get_tree().current_scene
	if current_scene == null:
		current_scene = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
	return current_scene

### Dotnet bridge


enum fadeType{
	fadeIn,
	fadeOut,
	fadeInAndOut
}
var use:blankPanel
## Show the configured dialogue balloon
func Fade_Blank(color:Color,time,state):
	var balloon_path: String# = DialogueSettings.get_setting(&"balloon_path", _get_example_balloon_path())
	if not ResourceLoader.exists(balloon_path):
		balloon_path = _get_Fade_Blank_path()
	if(use==null):
		use =show_Fade_Blank_scene(balloon_path)
	use.fade(color,time,state)
	if(state!=PanelManager.fadeType.fadeIn):
		use=null

func _get_Fade_Blank_path() -> String:
	var balloon_path: String = "/blankPanel.tscn" #if is_small_window else "/example_balloon/example_balloon.tscn"
	return get_script().resource_path.get_base_dir() + balloon_path

#func _get_SavePanel_path() -> String:
	#var balloon_path: String = "/blankPanel.tscn" #if is_small_window else "/example_balloon/example_balloon.tscn"
	#return get_script().resource_path.get_base_dir() + balloon_path



func show_Fade_Blank_scene(tied_scene) -> blankPanel:
	if tied_scene is String:
		tied_scene = load(tied_scene)
	if tied_scene is PackedScene:
		tied_scene = tied_scene.instantiate()

	var balloon: Node = tied_scene
	get_current_scene.call().add_child(balloon)

	return balloon





@export var isOpenSetting=false

## Show the configured dialogue balloon
func new_SettingMenu( title: String = "") -> SettingMenu:
	var balloon_path: String# = DialogueSettings.get_setting(&"balloon_path", _get_example_balloon_path())
	if not ResourceLoader.exists(balloon_path):
		balloon_path = _get_setting_balloon_path()
	isOpenSetting=true	
	return show_reward_scene(balloon_path, title)





func _get_setting_balloon_path() -> String:
	var is_small_window: bool = ProjectSettings.get_setting("display/window/size/viewport_width") < 400
	var balloon_path: String = "/SettingMenu.tscn" #if is_small_window else "/example_balloon/example_balloon.tscn"
	return get_script().resource_path.get_base_dir() + balloon_path



## Show the configured dialogue balloon
func new_ChaoView( title: String = "") -> CanvasLayer:
	var balloon_path: String# = DialogueSettings.get_setting(&"balloon_path", _get_example_balloon_path())
	if not ResourceLoader.exists(balloon_path):
		balloon_path = _get_chao_balloon_path()
	return show_reward_scene(balloon_path, title)





func _get_chao_balloon_path() -> String:
	var is_small_window: bool = ProjectSettings.get_setting("display/window/size/viewport_width") < 400
	var balloon_path: String = "/chaoPanel.tscn" #if is_small_window else "/example_balloon/example_balloon.tscn"
	return get_script().resource_path.get_base_dir() + balloon_path
	
	

## Show the configured dialogue balloon
func new_SecretCardView( title: String = "") -> CanvasLayer:
	var balloon_path: String# = DialogueSettings.get_setting(&"balloon_path", _get_example_balloon_path())
	if not ResourceLoader.exists(balloon_path):
		balloon_path = _get_secretCard_path()
	return show_reward_scene(balloon_path, title)

	
	
func _get_secretCard_path()-> String:
	
	var is_small_window: bool = ProjectSettings.get_setting("display/window/size/viewport_width") < 400
	var balloon_path: String = "/secretCardPanel.tscn" #if is_small_window else "/example_balloon/example_balloon.tscn"
	return get_script().resource_path.get_base_dir() + balloon_path	



## S
func new_GuiMiAchiView( title: String = "") -> CanvasLayer:
	var balloon_path: String# = DialogueSettings.get_setting(&"balloon_path", _get_example_balloon_path())
	if not ResourceLoader.exists(balloon_path):
		balloon_path = _get_GuimiAchi_path()
	return show_reward_scene(balloon_path, title)

	
	
func _get_GuimiAchi_path()-> String:
	
	var is_small_window: bool = ProjectSettings.get_setting("display/window/size/viewport_width") < 400
	var balloon_path: String = "/AchievementSystemPanel.tscn" #if is_small_window else "/example_balloon/example_balloon.tscn"
	return get_script().resource_path.get_base_dir() + balloon_path	
