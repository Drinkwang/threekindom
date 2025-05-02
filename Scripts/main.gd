extends baseComponent
class_name mainHall
@onready var timer = $Timer
@onready var mask = $BackBufferCopy/mask
@onready var inventory_any = $CanvasInventory/InventoryAny
@onready var texture_button = $CanvasButton/TextureButton
var inventoryManager
const FancyFade = preload("res://addons/transitions/FancyFade.gd")
#const DestinationScene = preload("res://Destination.tscn")
@export var clear_inventory:bool = true


const HOUSE = preload("res://Scene/house.tscn")
@onready var rule_book = $CanvasBook/ruleBook

const lightroom = preload("res://Asset/城镇建筑/灵堂亮.jpg")

# Called when the node enters the scene tree for the first time.
func _ready():
	Transitions.post_transition.connect(post_transition)
	SoundManager.play_music(_10__TIME_WHISTLE)
	mask.hide()
	GameManager.currenceScene=self
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
	super._ready()
	initLanguage()

func initLanguage():
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="en":
		tu_label.add_theme_font_size_override("font_size", 30)
		#reallabel.add_theme_font_size_override("font_size", 38)
	elif currencelanguage=="zh":
		tu_label.add_theme_font_size_override("font_size", 46)
		#reallabel.add_theme_font_size_override("font_size", 40)
		#label.font_size=36
	elif currencelanguage=="ru":
		tu_label.add_theme_font_size_override("font_size", 30)
		

	print(TranslationServer.get_locale()) 
	# Replace with function body.
		
	
	#time2.s();
@onready var mask_2 = $BackBufferCopy/mask2
	#pass # Replace with function body.
func _initData():
	$"蜡烛".show()
	mask_2.show()
func _initList():
	pass


func post_transition():
	_initData()
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)


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
@onready var hp_panel = $CanvasInventory/hpPanel
@onready var tu_label = $Label

func setTuLabel(la):
	hp_panel.target_label.text=la
	#GameManager.sav.TargetDestination=la
	tu_label.text=la
const MATCH_STRIKING = preload("res://Asset/sound/Match_striking.wav")
func getcandle():
	tu_label.text=""
	hp_panel.target_label.text=""
	SoundManager.play_sound(MATCH_STRIKING)
	$"蜡烛".hide()
	mask.show()
	$"灯".show()
	$BackBufferCopy/mask2.hide()
	pass
const FLASHLIGHT_OFF = preload("res://Asset/sound/Flashlight off.wav")
const _04_FIRE_EXPLOSION_04_MEDIUM = preload("res://Asset/sound/04_Fire_explosion_04_medium.wav")
func openLight():
	SoundManager.play_sound(FLASHLIGHT_OFF)
	$"灯".hide()
	$"Canvas闪电/ColorRect/AnimationPlayer".play("闪烁")
	$GPUParticles2D.hide()
	$BackBufferCopy/blank.hide()
	$"陶谦".show()
	await  0.35
	$"内屋".texture=lightroom
	SoundManager.play_sound(_04_FIRE_EXPLOSION_04_MEDIUM)

@onready var audio_stream_player_2d = $"Canvas闪电/ColorRect/AnimationPlayer/AudioStreamPlayer2D"
@onready var canvas_book = $CanvasBook

const BOX_SEARCHING = preload("res://Asset/sound/Box_searching.wav")
@onready var bgs = $bgs
func getBook():
	SoundManager.play_sound(BOX_SEARCHING)
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
	SoundManager.play_music(_2__MENTAL_VORTEX)
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
	#SoundManager.play_sound(_翻阅)
	$CanvasBook.show()
	rule_book._changeBtnState(rule_book.buttonState.page)

	rule_book.pageDownDialog="showPageTwo" #这里不一定调用final，只是显示出lookdone，或者无作用 或者这里的作用只是修改文本 以及显示lookdone
	#计时器几秒钟，或者只是单纯修改

func pageTwo():
	rule_book._changeBtnState(rule_book.buttonState.readdone)
	rule_book.lookdoneDialog="final"
	rule_book.context=dontTrutShizu
@onready var monster = $AnimatedSprite2D
const _2__MENTAL_VORTEX = preload("res://Asset/bgm/2- Mental Vortex.mp3")	
const _10__TIME_WHISTLE = preload("res://Asset/bgm/10- Time Whistle.mp3")

const ROBOTIC_GROAN_3 = preload("res://Asset/sound/robotic_groan_3.wav")
func final():
	$CanvasBook.hide()
	monster.show()
	SoundManager.play_sound(ROBOTIC_GROAN_3)
	#播放恐怖音效
	pass
	
func end():
	#$title.show()
	const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
	FancyFade.new().custom_fade(HOUSE.instantiate(), 7, DISSOLVE_IMAGE)
	
	pass

func _on_timer_timeout():
	$"Canvas闪电".hide()
	#const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
	#FancyFade.new().custom_fade(DestinationScene.instantiate(), 1.5, DISSOLVE_IMAGE)
	#pass # Replace with function body.
