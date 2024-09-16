extends Control
@onready var timer = $Timer

@onready var animation_player = $AnimationPlayer
var score=0;
# Called when the node enters the scene tree for the first time.
func _ready():
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

	yourscore.text="你的得分：\n"+str(score)
	if(isboot==true):
		time=time+delta
		var resideTime=10-time
		if(resideTime<=0):
			resideTime=0
			over()
		reside_txt.text="倒计时:{str}".format({"str":  round(resideTime * 100) / 100})
	pass

@onready var reside_txt = $resideTxt
@onready var texture_button = $TextureButton
@export var dialogue_resource:DialogueResource
func over():
	isboot=false
	#reward弹出
	var _reward:rewardPanel=PanelManager.new_reward()
	_reward.showTitileReward("你从郑玄哪里受益良多")
	texture_button.show()
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
		title.text="请点击图书并获得积分\n"+"+100"
		timer.start()
		pass	
	pass # Replace with function body.

@onready var starttitle = $starttitle
@onready var title = $title
@onready var button = $Button

func _on_button_button_down():
	
	button.hide()
	isboot=true

	reside_txt.show()
	title.show()
	starttitle.text="大儒辩经已开始"
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
