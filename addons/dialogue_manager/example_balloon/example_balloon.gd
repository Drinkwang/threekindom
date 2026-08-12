extends CanvasLayer

## The action to use for advancing the dialogue
@export var next_action: StringName = &"ui_accept"

## The action to use to skip typing the dialogue
@export var skip_action: StringName = &"ui_cancel"

@onready var balloon: Control = %Balloon
@onready var character_label: RichTextLabel = %CharacterLabel
@onready var dialogue_label: DialogueLabel = %DialogueLabel
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu

const RUSSIAN_DIALOGUE_FONT = preload("res://Asset/Font/1_sim.ttf")
const RICH_TEXT_FONT_KEYS: PackedStringArray = [
	"normal_font",
	"bold_font",
	"italics_font",
	"bold_italics_font",
	"mono_font"
]

## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## See if we are running a long mutation and should hide the balloon
var will_hide_balloon: bool = false

## 通关后Ctrl快进时标记当前行是否已推进，防止一帧内多次推进
var _fast_forward_current_line: bool = false
const CTRL_FAST_FORWARD_DELAY := 0.4
var _ctrl_hold_time := 0.0

## The current line
var dialogue_line: DialogueLine:
	set(next_dialogue_line):
		is_waiting_for_input = false
		_fast_forward_current_line = false
		balloon.focus_mode = Control.FOCUS_ALL
		balloon.grab_focus()

		# The dialogue has finished so close the balloon
		if not next_dialogue_line:
			DialogueManager.dialogBegin = false
			queue_free()
			return

		# If the node isn't ready yet then none of the labels will be ready yet either
		if not is_node_ready():
			await ready

		dialogue_line = next_dialogue_line
		_apply_locale_font()

		character_label.visible = not dialogue_line.character.is_empty()
		character_label.text = tr(dialogue_line.character, "dialogue")

		dialogue_label.hide()
		dialogue_label.dialogue_line = dialogue_line

		responses_menu.hide()
		responses_menu.set_responses(dialogue_line.responses)

		# Show our balloon
		balloon.show()
		will_hide_balloon = false

		# Keep the full line in the layout for measurement, but never expose its
		# unfitted base font size to the player.
		dialogue_label.self_modulate.a = 0.0
		dialogue_label.show()
		await get_tree().process_frame
		await dialogue_label.fit_text_to_box()
		if not dialogue_line.text.is_empty():
			dialogue_label.visible_characters = 0
			dialogue_label.visible_ratio = 0.0
			dialogue_label.self_modulate.a = 1.0
			dialogue_label.type_out()
			await dialogue_label.finished_typing
		else:
			dialogue_label.self_modulate.a = 1.0

		# Wait for input
		if dialogue_line.responses.size() > 0:
			balloon.focus_mode = Control.FOCUS_NONE
			responses_menu.show()
		elif dialogue_line.time != "":
			var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
			await get_tree().create_timer(time).timeout
			next(dialogue_line.next_id)
		else:
			is_waiting_for_input = true
			balloon.focus_mode = Control.FOCUS_ALL
			balloon.grab_focus()
	get:
		return dialogue_line


func _ready() -> void:
	balloon.hide()
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)
	_apply_locale_font()

	# If the responses menu doesn't have a next action set, use this one
	if responses_menu.next_action.is_empty():
		responses_menu.next_action = next_action


func _apply_locale_font() -> void:
	var dialogue_font = RUSSIAN_DIALOGUE_FONT if TranslationServer.get_locale().begins_with("ru") else null
	_apply_rich_text_font(character_label, dialogue_font)
	_apply_rich_text_font(dialogue_label, dialogue_font)
	responses_menu.set_locale_font(dialogue_font)


func _apply_rich_text_font(label: RichTextLabel, font: Font) -> void:
	for key in RICH_TEXT_FONT_KEYS:
		if font:
			label.add_theme_font_override(key, font)
		else:
			label.remove_theme_font_override(key)



func _process(delta: float) -> void:
	# Ctrl快进：通关霸道线或常规线后，按住Ctrl可快速跳过对话
	var fast_forward_unlocked = GameManager._setting.is_clear_normal_line or GameManager._setting.is_clear_overlord_line
	var ctrl_only_pressed = Input.is_key_pressed(KEY_CTRL) and not (
		Input.is_key_pressed(KEY_SHIFT) or
		Input.is_key_pressed(KEY_ALT) or
		Input.is_key_pressed(KEY_META)
	)

	if fast_forward_unlocked and ctrl_only_pressed:
		_ctrl_hold_time += delta
	else:
		_ctrl_hold_time = 0.0

	var can_fast_forward = _ctrl_hold_time >= CTRL_FAST_FORWARD_DELAY

	if not can_fast_forward:
		return

	# 正在打字时直接跳过打字动画
	if dialogue_label.is_typing:
		dialogue_label.skip_typing()
		return

	# 等待输入且无选项时自动推进到下一行
	if is_waiting_for_input and dialogue_line.responses.size() == 0 and not _fast_forward_current_line:
		_fast_forward_current_line = true
		next(dialogue_line.next_id)

func _unhandled_input(_event: InputEvent) -> void:
	# Only the balloon is allowed to handle input while it's showing
	if balloon.is_visible_in_tree():
		get_viewport().set_input_as_handled()


## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	temporary_game_states =  [self] + extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)


## Go to the next line
func next(next_id: String) -> void:
	SoundManager.stop_ui_sound()
	DialogueManager.dialogBegin = true
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


### Signals


func _on_mutated(_mutation: Dictionary) -> void:
	is_waiting_for_input = false
	will_hide_balloon = true
	get_tree().create_timer(0.1).timeout.connect(func():
		if will_hide_balloon:
			will_hide_balloon = false
			balloon.hide()
	)


func _on_balloon_gui_input(event: InputEvent) -> void:
	# See if we need to skip typing of the dialogue
	if dialogue_label.is_typing:
		var mouse_was_clicked: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
		var skip_button_was_pressed: bool = event.is_action_pressed(skip_action)
		if mouse_was_clicked or skip_button_was_pressed:
			get_viewport().set_input_as_handled()
			dialogue_label.skip_typing()
			return

	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the balloon itself is the clickable thing
	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		next(dialogue_line.next_id)
	elif event.is_action_pressed(next_action) and get_viewport().gui_get_focus_owner() == balloon:
		next(dialogue_line.next_id)


func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)
