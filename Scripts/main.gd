extends baseComponent
@onready var timer = $Timer
@onready var mask = $BackBufferCopy/mask
@onready var inventory_any = $CanvasInventory/InventoryAny
@onready var texture_button = $CanvasButton/TextureButton
var inventoryManager
const FancyFade = preload("res://addons/transitions/FancyFade.gd")
const DestinationScene = preload("res://Destination.tscn")
@export var clear_inventory:bool = true


@onready var rule_book = $CanvasBook/ruleBook



# Called when the node enters the scene tree for the first time.
func _ready():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
	mask.hide()
	#timer.start()
	if get_tree().get_root().has_node("InventoryManager"):
	#_error_ui.queue_free()
		inventoryManager = get_tree().get_root().get_node("InventoryManager")
		#inventoryManager.player = $Player
		if clear_inventory:
			inventoryManager.clear_inventory(inventory_any.inventory)
			texture_button.pressed.connect(_on_inventory_button_pressed)
	pass	

	var initData=[
		{
			
			"id":"1",
			"context":"议事厅",
			"visible":"false"
		},
		{
			
			"id":"2",
			"context":"花园",
			"visible":"false"
		}
	]
	
	#time2.s();

	#pass # Replace with function body.

func _initList():
	pass



func _on_inventory_button_pressed() -> void:
	if inventory_any.visible:
		inventory_any.hide()
	else:
		inventory_any.show()




func _input(event):
	if event is InputEventMouseMotion:
		mask.position=event.global_position
	#print(event)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func getcandle():
	$"蜡烛".hide()
	mask.show()
	$"灯".show()
	$BackBufferCopy/mask2.hide()
	pass

func openLight():
	$"Canvas闪电/ColorRect/AnimationPlayer".play("闪烁")
	$GPUParticles2D.hide()
	$BackBufferCopy/blank.hide()
	$"陶谦".show()

@onready var audio_stream_player_2d = $"Canvas闪电/ColorRect/AnimationPlayer/AudioStreamPlayer2D"
@onready var canvas_book = $CanvasBook
@onready var control = $CanvasBook/Control

@onready var bgs = $bgs
func getBook():
	$"陶谦".hide()
	#bgs.stream=;
	bgs.play()


func showBook():
	#rule_book.hasPage=true
	canvas_book.show()
	rule_book.lookdoneDialog="third"
 #士族生存法则，这是啥--显示规则书。点击显示文本和读完按钮确认
 #啊！

#func showBack():
#	pass


func lightning():
	$CanvasBook.hide()
	$"Canvas闪电".show()
	timer.start()
	$"Canvas闪电/ColorRect/AnimationPlayer".play("闪烁")
	audio_stream_player_2d.play()
#全屏闪电特效
@export_multiline var dontTrutShizu:String
#家仆: 陶x少爷,灵堂发生什么事了，需要我进来帮忙么？
# : 我是陶x...怎么回事，我不应该名字叫刘备么？我想我应该在小沛
#弹出规则书翻页按钮.  
func bookToTwo():
	
	$CanvasBook.show()
	rule_book._changeBtnState(rule_book.buttonState.page)

	rule_book.pageDownDialog="showPageTwo" #这里不一定调用final，只是显示出lookdone，或者无作用 或者这里的作用只是修改文本 以及显示lookdone
	#计时器几秒钟，或者只是单纯修改

func pageTwo():
	rule_book._changeBtnState(rule_book.buttonState.readdone)
	rule_book.lookdoneDialog="final"
	rule_book.context=dontTrutShizu
	
func final():
	$CanvasBook.hide()
	pass
	
func end():
	#$title.show()
	const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
	FancyFade.new().custom_fade(DestinationScene.instantiate(), 7, DISSOLVE_IMAGE)
	pass

func _on_timer_timeout():
	$"Canvas闪电".hide()
	#const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
	#FancyFade.new().custom_fade(DestinationScene.instantiate(), 1.5, DISSOLVE_IMAGE)
	#pass # Replace with function body.
