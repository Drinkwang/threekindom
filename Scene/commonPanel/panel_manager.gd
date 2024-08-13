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
func show_reward( title: String = "", extra_game_states: Array = []) -> rewardPanel:
	var balloon_path: String# = DialogueSettings.get_setting(&"balloon_path", _get_example_balloon_path())
	if not ResourceLoader.exists(balloon_path):
		balloon_path = _get_example_balloon_path()
	return show_reward_scene(balloon_path, title, extra_game_states)


## Show a given balloon scene
func show_reward_scene(reward_scene, title: String = "", extra_game_states: Array = []) -> rewardPanel:
	if reward_scene is String:
		reward_scene = load(reward_scene)
	if reward_scene is PackedScene:
		reward_scene = reward_scene.instantiate()

	var balloon: Node = reward_scene
	get_current_scene.call().add_child(balloon)
	#if balloon.has_method(&"start"):
	#	balloon.start(resource, title, extra_game_states)
	#elif balloon.has_method(&"Start"):
	#	balloon.Start(resource, title, extra_game_states)

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

## Show the configured dialogue balloon
func Fade_Blank(color:Color,time,state):
	var balloon_path: String# = DialogueSettings.get_setting(&"balloon_path", _get_example_balloon_path())
	if not ResourceLoader.exists(balloon_path):
		balloon_path = _get_Fade_Blank_path()
	var use:blankPanel= show_Fade_Blank_scene(balloon_path)
	use.fade(color,time,state)

func _get_Fade_Blank_path() -> String:
	var balloon_path: String = "/blankPanel.tscn" #if is_small_window else "/example_balloon/example_balloon.tscn"
	return get_script().resource_path.get_base_dir() + balloon_path


func show_Fade_Blank_scene(tied_scene) -> blankPanel:
	if tied_scene is String:
		tied_scene = load(tied_scene)
	if tied_scene is PackedScene:
		tied_scene = tied_scene.instantiate()

	var balloon: Node = tied_scene
	get_current_scene.call().add_child(balloon)

	return balloon


