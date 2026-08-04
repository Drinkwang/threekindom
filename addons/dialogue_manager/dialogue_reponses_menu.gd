@icon("./assets/responses_menu.svg")

## A VBoxContainer for dialogue responses provided by [b]Dialogue Manager[/b].
class_name DialogueResponsesMenu extends VBoxContainer


## Emitted when a response is selected.
signal response_selected(response)


## Optionally specify a control to duplicate for each response
@export var response_template: Control

## The action for accepting a response (is possibly overridden by parent dialogue balloon).
@export var next_action: StringName = &""

## Shrink long response text so each option stays inside the response panel.
@export var auto_fit_text: bool = true
@export_range(1, 8, 1) var auto_fit_step: int = 1

# The list of dialogue responses.
var _locale_font: Font
var _response_fit_queued: bool = false
var _response_area_initial_width: float = 0.0
var _response_area_anchor_span: float = 0.0
var _response_area_offset_span: float = 0.0

var responses: Array = []:
	set(value):
		responses = value

		# Remove any current items
		for item in get_children():
			if item == response_template: continue

			remove_child(item)
			item.queue_free()

		# Add new items
		if responses.size() > 0:
			var highlight_enabled_for_menu := GameManager.can_use_highlight()
			var highlight_consumed_for_menu := false
			for response in responses:
				var item: Control
				if is_instance_valid(response_template):
					item = response_template.duplicate(DUPLICATE_GROUPS | DUPLICATE_SCRIPTS | DUPLICATE_SIGNALS)
					item.show()
				else:
					item = Button.new()
				item.name = "Response%d" % get_child_count()
				if not response.is_allowed:
					item.name = String(item.name) + "Disallowed"
					item.disabled = true

				# If the item has a response property then use that
				if "response" in item:
					item.response = response
				# Otherwise assume we can just set the text
				else:
					
					var regex = RegEx.new()

					regex.compile("\\[costHp=(\\d+)\\]") 
					var previewCostHp=0 
					var result = regex.search(response.text)
					if result:
						var hp_str = result.get_string(1) 
						previewCostHp= hp_str.to_int()
						response.text = regex.sub(response.text, "", false)
					else:
						previewCostHp=0
					item.set_meta("previewCostHp", previewCostHp) # 这里存入数值
	# 如果你只想在数值是 10, 20, 30 时执行：					
					
					if "[highlight=true]" in response.text:
						response.text = response.text.replace("[highlight=true]", "")
						if highlight_enabled_for_menu:
							apply_highlight_effect(item)  # 应用高亮效果
							if not highlight_consumed_for_menu:
								highlight_consumed_for_menu = GameManager.consume_highlight_use()
					var diff_regex = RegEx.new()
					diff_regex.compile("\\[diff=(\\d+)\\]")
					var diff_result = diff_regex.search(response.text)
					if diff_result:
						var option_diff = diff_result.get_string(1).to_int()
						response.text = diff_regex.sub(response.text, "", false)
						if option_diff == GameManager.sav.gameDifficulty:
							response.text = tr(response.text) + tr("(当前选择)")
						elif option_diff > GameManager.sav.gameDifficulty and GameManager.sav.have_event["initTaskPolicy"]==true:
							response.text = tr(response.text) + tr("(不可选)")
						else:
							response.text = tr(response.text)

					var credit_regex = RegEx.new()
					credit_regex.compile("\\[credit=(\\d+)\\]")
					var credit_result = credit_regex.search(response.text)
					if credit_result:
						var credit_index = credit_result.get_string(1).to_int()
						response.text = credit_regex.sub(response.text, "", false)
						if credit_index == 1:
							if GameManager._setting.is_clear_normal_line == true:
								response.text = tr(response.text) 
							else:
								response.text = tr(response.text) + tr("【未解锁】")
						elif credit_index == 2:
							if GameManager._setting.is_clear_overlord_line == true:
								response.text = tr(response.text) 
							else:
								response.text = tr(response.text) + tr("【未解锁】")
			
						
					if "[boardgame=true]" in response.text:
						response.text = response.text.replace("[boardgame=true]", "")
						pass #判断有无人物
						var mode:boardType.boardMode
						if "1" in response.text:
							mode=boardType.boardMode.new
						elif "2" in response.text:
							mode=boardType.boardMode.middle
						elif "3" in response.text:
							mode=boardType.boardMode.high
						var characterScore=0	
						if GameManager.selectBoardCharacter==boardType.boardCharacter.caobao:
							characterScore=GameManager.sav.caobaocardgame
						elif GameManager.selectBoardCharacter==boardType.boardCharacter.chenden:
							characterScore=GameManager.sav.chendencardgame	
						elif GameManager.selectBoardCharacter==boardType.boardCharacter.mizhu:
							characterScore=GameManager.sav.mizhucardgame		
						#0 小试牛刀开启 1小试牛刀通过 2 对局试炼开启 3对局试验通过 4 诡秘怪谈开启 5诡秘怪谈通过	
						if 	(characterScore>=1 and mode==boardType.boardMode.new) or (characterScore>=3 and mode==boardType.boardMode.middle) or (characterScore>=5 and mode==boardType.boardMode.high):
							response.text=tr(response.text)+tr("(已通过)")
						elif (characterScore<2 and mode==boardType.boardMode.middle) or (characterScore<4 and mode==boardType.boardMode.high):
							response.text=tr(response.text)+tr("(未解锁)")
						#根据角色获得分数，判断 score 如果score怎么样，那么会变成什么样	
					if 	"[infra=true]" in response.text:
						response.text = response.text.replace("[infra=true]", "")
						var diff = 0
						if "1" in response.text:
							diff = 1
						elif "2" in response.text:
							diff = 2
						elif "3" in response.text:
							diff = 3
						var constructValue = 0
						var scene = GameManager.currenceScene
						if scene is government_building:
							constructValue = GameManager.sav.constructGrain
						elif scene is bouleuterion:
							constructValue = GameManager.sav.constructRiver
						elif scene is drill_ground:
							constructValue = GameManager.sav.constructTower
						if constructValue >= diff:
							response.text = tr(response.text) + tr("(已完成)")
						else:
							response.text = tr(response.text)
					if 	"[istrain=true]" in response.text:
						response.text = response.text.replace("[istrain=true]", "")
						var mode=0
						
						if "1" in response.text:
							mode=1
						elif "2" in response.text:
							mode=2
						elif "3" in response.text:
							mode=3
						
						var characterScore=0
						var haveWeapon=false	
						if GameManager.trainGeneral=="关羽":
							characterScore=GameManager.sav.guanyuTrainNum
							haveWeapon=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.青龙偃月刀)>=1
							
						elif GameManager.trainGeneral=="张飞":
							characterScore=GameManager.sav.zhangfeiTrainNum	
							haveWeapon=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.丈八蛇矛)>=1
						elif GameManager.trainGeneral=="无名":
							characterScore=GameManager.sav.zhaoyunTrainNum
							haveWeapon=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.龙胆亮银枪)>=1
						#0 小试牛刀开启 1小试牛刀通过 2 对局试炼开启 3对局试验通过 
						if 	(characterScore>=1 and mode==1) or (characterScore>=2 and mode==2) or (characterScore>=3 and mode==3):
							response.text=tr(response.text)+tr("(已通过)")
						elif (characterScore<1 and mode==2) or (characterScore<2 and mode==3):
							response.text=tr(response.text)+tr("(未解锁)")	
							
						elif (characterScore>=2 and characterScore<3  and mode==3 and not haveWeapon):
							response.text=tr(response.text)+tr("(专属武器解锁)")

					


					item.text = response.text
					
				item.set_meta("response", response)
				add_child(item)
				_apply_locale_font(item)
				if item is Button:
					item.set_meta("dialogue_response_base_font_size", item.get_theme_font_size("font_size"))

			_configure_focus()
			_queue_response_text_fit()



func apply_highlight_effect(button):
	# 添加金光效果（示例：使用 Shader 或 AnimationPlayer）
	var material = ShaderMaterial.new()
	#material.shader = load("res://shader/glow_effect.gdshader")  # 自定义金光着色器
	#button.material = material
	# 或者使用 AnimationPlayer 播放金光动画
	var animation_player = AnimationPlayer.new()
	button.add_child(animation_player)
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, ":modulate")
	animation.track_insert_key(track_index, 0.0, Color(1, 1, 0, 1))  # 金色
	animation.track_insert_key(track_index, 0.5, Color(1, 1, 1, 1))  # 白色
	animation.track_insert_key(track_index, 1.0, Color(1, 1, 0, 1))  # 金色
	animation.length = 1.0
	animation.loop = true
	
	var library = AnimationLibrary.new()
	library.add_animation("glow", animation)
	animation_player.add_animation_library("glow_library", library)
	
	animation_player.play("glow_library/glow")
func _ready() -> void:
	visibility_changed.connect(func():
		if visible and get_menu_items().size() > 0:
			get_menu_items()[0].grab_focus()
	)

	if is_instance_valid(response_template):
		response_template.hide()

	var response_area := get_parent_control()
	if response_area:
		_response_area_initial_width = response_area.size.x
		_response_area_anchor_span = response_area.anchor_right - response_area.anchor_left
		_response_area_offset_span = response_area.offset_right - response_area.offset_left

	var viewport := get_viewport()
	if viewport and not viewport.size_changed.is_connected(_queue_response_text_fit):
		viewport.size_changed.connect(_queue_response_text_fit)


# This is deprecated.
func set_responses(next_responses: Array) -> void:
	self.responses = next_responses


func set_locale_font(font: Font) -> void:
	_locale_font = font
	_apply_locale_font(response_template)
	for item in get_children():
		if item != response_template:
			_apply_locale_font(item)
	_queue_response_text_fit()


func _apply_locale_font(item: Control) -> void:
	if item == null:
		return
	if _locale_font:
		item.add_theme_font_override("font", _locale_font)
	else:
		item.remove_theme_font_override("font")


func _queue_response_text_fit() -> void:
	if not auto_fit_text or _response_fit_queued or not is_inside_tree():
		return
	_response_fit_queued = true
	call_deferred("_fit_response_texts")


func _fit_response_texts() -> void:
	# Containers finish resolving their width on the next frame. Measuring before
	# that can accidentally use the long button's expanded minimum width.
	await get_tree().process_frame
	_response_fit_queued = false
	if not is_inside_tree():
		return

	var available_width := _get_response_available_width()
	if available_width <= 0:
		return

	for child in get_children():
		if child != response_template and child is Button:
			_fit_response_button_text(child, available_width)


func _fit_response_button_text(button: Button, available_width: float) -> void:
	var base_font_size: int = button.get_meta(
		"dialogue_response_base_font_size",
		button.get_theme_font_size("font_size")
	)
	var font_size := maxi(1, base_font_size)
	button.add_theme_font_size_override("font_size", font_size)

	var style_box := button.get_theme_stylebox("normal")
	var horizontal_padding := style_box.get_content_margin(SIDE_LEFT) \
		+ style_box.get_content_margin(SIDE_RIGHT)
	var outline_width := button.get_theme_constant("outline_size") * 2.0
	var text_width := maxf(1.0, available_width - horizontal_padding - outline_width)
	var font := button.get_theme_font("font")
	var translated_text := tr(button.text)
	var step := maxi(1, auto_fit_step)

	while font_size > 1 and font.get_string_size(
		translated_text,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		font_size
	).x > text_width:
		font_size = maxi(1, font_size - step)

	button.add_theme_font_size_override("font_size", font_size)


func _get_response_available_width() -> float:
	var response_area := get_parent_control()
	if response_area == null:
		return size.x

	# A Button's text contributes to its minimum size, so a long response can
	# temporarily stretch the MarginContainer itself. Reconstruct the intended
	# layout width instead of measuring that already-expanded rectangle.
	var area_parent := response_area.get_parent_control()
	if area_parent:
		var layout_width := area_parent.size.x * _response_area_anchor_span \
			+ _response_area_offset_span
		if layout_width > 0:
			return layout_width

	return _response_area_initial_width if _response_area_initial_width > 0 else response_area.size.x


# Prepare the menu for keyboard and mouse navigation.
func _configure_focus() -> void:
	var items = get_menu_items()
	for i in items.size():
		var item: Control = items[i]

		item.focus_mode = Control.FOCUS_ALL

		item.focus_neighbor_left = item.get_path()
		item.focus_neighbor_right = item.get_path()

		if i == 0:
			item.focus_neighbor_top = item.get_path()
			item.focus_previous = item.get_path()
		else:
			item.focus_neighbor_top = items[i - 1].get_path()
			item.focus_previous = items[i - 1].get_path()

		if i == items.size() - 1:
			item.focus_neighbor_bottom = item.get_path()
			item.focus_next = item.get_path()
		else:
			item.focus_neighbor_bottom = items[i + 1].get_path()
			item.focus_next = items[i + 1].get_path()

		item.mouse_entered.connect(_on_response_mouse_entered.bind(item))
		item.gui_input.connect(_on_response_gui_input.bind(item, item.get_meta("response")))

	items[0].grab_focus()


## Get the selectable items in the menu.
func get_menu_items() -> Array:
	var items: Array = []
	for child in get_children():
		if not child.visible: continue
		if "Disallowed" in child.name: continue
		items.append(child)

	return items


### Signals


func _on_response_mouse_entered(item: Control) -> void:
	if "Disallowed" in item.name: return

	item.grab_focus()
	
	if GameManager.haveMirror():
		
		if GameManager._engerge!=null:
			var previewCostHp = item.get_meta("previewCostHp")
			GameManager._engerge.previewValue=previewCostHp
			GameManager._engerge.changerate(GameManager.sav.hp)
	#GameManager.sav.hp=GameManager.sav.hp

func _on_response_gui_input(event: InputEvent, item: Control, response) -> void:
	if "Disallowed" in item.name: return

	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		response_selected.emit(response)
	elif event.is_action_pressed(&"ui_accept" if next_action.is_empty() else next_action) and item in get_menu_items():
		response_selected.emit(response)
