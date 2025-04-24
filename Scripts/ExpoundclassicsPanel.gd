extends Control
@onready var timer = $Timer

@onready var animation_player = $AnimationPlayer
var score=0
var db
@onready var itemUseLabel = $itemUse/Label
# Called when the node enters the scene tree for the first time.
func refreshCount():
	var count=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.诸子百家论集)
	itemUseLabel.text="点击图标使用\n快速结束辩经\n（库存：{num}）".format({"num":count})
	if count<1:
		item_use.context.modulate = Color(0.5, 0.5, 0.5, 1.0)
	else:
		item_use.context.modulate = Color(1.0, 1.0, 1.0, 1.0)
func _ready():
#	var itemname= InventoryManagerItem.item_by_enum(InventoryManagerItem.诸子百家论集)
	db=InventoryManager.get_item_db(InventoryManagerItem.诸子百家论集)
	#self.tooltip_text=db.name
	refreshCount()
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="en":
		starttitle.add_theme_font_size_override("font_size", 60)
		reside_txt.add_theme_font_size_override("font_size", 60)
		title.add_theme_font_size_override("font_size", 60)
		button.add_theme_font_size_override("font_size", 60)
		#if(starttitle.size()>)
	elif currencelanguage=="zh":
		starttitle.add_theme_font_size_override("font_size", 81)
		reside_txt.add_theme_font_size_override("font_size", 81)
		title.add_theme_font_size_override("font_size", 81)
		button.add_theme_font_size_override("font_size", 81)
	elif currencelanguage=="ja":
		starttitle.add_theme_font_size_override("font_size", 50)
		reside_txt.add_theme_font_size_override("font_size", 50)
		title.add_theme_font_size_override("font_size", 50)
		button.add_theme_font_size_override("font_size", 50)
	#获取各个语言大小，微调
	elif currencelanguage=="ru":
		starttitle.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		reside_txt.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		title.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		button.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		yourscore.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		yourscore.add_theme_font_size_override("font_size", 60)
					
		starttitle.add_theme_font_size_override("font_size", 45)
		reside_txt.add_theme_font_size_override("font_size", 50)
		title.add_theme_font_size_override("font_size", 50)
		button.add_theme_font_size_override("font_size", 50)
	pass # Replace with function body.
#请点击图书并获得积分




func _expoundClass():
	animation_player.play("click")
	pass
@onready var yourscore = $yourscore

var time=0
var isboot=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	yourscore.text=tr("你的得分：")+"\n"+str(score)
	if(isboot==true):
		time=time+delta
		var resideTime=10-time
		if(resideTime<=0):
			resideTime=0
			over()
		reside_txt.text=tr("倒计时:{str}").format({"str":  round(resideTime * 100) / 100})
	pass

@onready var reside_txt = $resideTxt
@onready var texture_button = $TextureButton
@export var dialogue_resource:DialogueResource
func over():
	#item_use.hide()
	isboot=false
	#reward弹出
	var _reward:rewardPanel=PanelManager.new_reward()
	var items=GameManager.ScoreToItem(score/10)
	_reward.showTitileReward(tr("你从郑玄哪里受益良多"),items)
	texture_button.show()
	GameManager.sav.isVisitScholar=true
	await  SignalManager.endReward
	if GameManager.sav.have_event["firstVisitScholarsEnd"]==false:
		GameManager.sav.have_event["firstVisitScholarsEnd"]=true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,"大儒辩经结束")
	pass

@onready var audio_stream_player = $Timer/AudioStreamPlayer

func _on_panel_container_gui_input(event):
	if(event is InputEventMouseButton and event.button_index==1 and isboot==true):
		_expoundClass()
		score=score+100
		audio_stream_player.play()
		title.text=tr("请点击图书并获得积分")+"\n+100"
		timer.start()
		pass	
	pass # Replace with function body.

@onready var starttitle = $starttitle
@onready var title = $title
@onready var button = $Button
@onready var item_use = $itemUse

func _on_button_button_down():
	
	button.hide()
	isboot=true
	refreshCount()
	reside_txt.show()
	title.show()
	item_use.show()
	starttitle.text=tr("大儒辩经已开始")
	pass # Replace with function body.


func _on_timer_timeout():
	title.text="请点击图书并获得积分"
	pass # Replace with function body.
const STREET = preload("res://Asset/bgm/street.wav")
const MINISTREET = preload("res://Asset/bgm/ministreet.wav")
func _on_exit_button_button_down():
	self.hide()
	if GameManager.sav.day<=4:
		SoundManager.play_music(MINISTREET)
	else:
		SoundManager.play_music(STREET)		
	pass # Replace with function body.


func _on_item_use_gui_input(event):
	var count=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.诸子百家论集)

	if event is InputEventMouseButton and event.button_index==1 and isboot==true:
		if count>0:
			InventoryManager._remove_item(GameManager.inventoryPackege,InventoryManagerItem.诸子百家论集,1)
			itemUseLabel.text="点击图标使用\n快速结束辩经\n（库存：{num}）".format({"num":count-1})
			score=9000
			yourscore.text=tr("你的得分：")+"\n"+str(score)
			over()
		#判断道具数量
		#消耗道具
