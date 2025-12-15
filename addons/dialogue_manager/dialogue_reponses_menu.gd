@icon("./assets/responses_menu.svg")

## A VBoxContainer for dialogue responses provided by [b]Dialogue Manager[/b].
class_name DialogueResponsesMenu extends VBoxContainer


## Emitted when a response is selected.
signal response_selected(response)


## Optionally specify a control to duplicate for each response
@export var response_template: Control

## The action for accepting a response (is possibly overridden by parent dialogue balloon).
@export var next_action: StringName = &""

# The list of dialogue responses.
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
					if "[highlight=true]" in response.text:
						response.text = response.text.replace("[highlight=true]", "")
						var sxnum=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.獬豸圣像) 
						if sxnum>0:
							apply_highlight_effect(item)  # 应用高亮效果
					
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
							response.text+=tr("(已通过)")
						elif (characterScore<2 and mode==boardType.boardMode.middle) or (characterScore<4 and mode==boardType.boardMode.high):
							response.text+=tr("(未解锁)")
						#根据角色获得分数，判断 score 如果score怎么样，那么会变成什么样	
					if 	"[infra=true]" in response.text:#暂时无用
						pass
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
						elif GameManager.trainGeneral=="赵云":
							characterScore=GameManager.sav.zhaoyunTrainNum
							haveWeapon=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.龙胆亮银枪)>=1
						#0 小试牛刀开启 1小试牛刀通过 2 对局试炼开启 3对局试验通过 
						if 	(characterScore>=1 and mode==1) or (characterScore>=2 and mode==2) or (characterScore>=3 and mode==3):
							response.text+=tr("(已通过)")
						elif (characterScore<1 and mode==2) or (characterScore<2 and mode==3):
							response.text+=tr("(未解锁)")	
							
						elif (characterScore>=2 and characterScore<3  and mode==3 and not haveWeapon):
							response.text+=tr("(专属武器解锁)")
	
						
					item.text = response.text
					
				item.set_meta("response", response)

				add_child(item)

			_configure_focus()

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


# This is deprecated.
func set_responses(next_responses: Array) -> void:
	self.responses = next_responses


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


func _on_response_gui_input(event: InputEvent, item: Control, response) -> void:
	if "Disallowed" in item.name: return

	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		response_selected.emit(response)
	elif event.is_action_pressed(&"ui_accept" if next_action.is_empty() else next_action) and item in get_menu_items():
		response_selected.emit(response)
