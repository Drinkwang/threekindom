extends Control
@onready var str_standard = $str_standard

@onready var str_reside = $str_reside
@export var happys:Array[int]
@export var accepts:Array[int]
@export var doubts:Array[int]
@export var sads:Array[int]


@onready var control_1 = $Control_1
@onready var control_2 = $Control_2
@onready var control_3 = $Control_3

# Called when the node enters the scene tree for the first time.
func _ready():
	changeLanguage()

	SignalManager.changeLanguage.connect(changeLanguage)	
	pass # Replace with function body.
func _refreshStand():
	var index=GameManager.sav.GrainIndex
	var happy=happys[index]
	var accept=accepts[index]
	var doubt=doubts[index]
	var sad=sads[index]
	if index==0:
		GameManager.resideGrain=5
	elif index==1:
		GameManager.resideGrain=8
	elif index==2:
		GameManager.resideGrain=12
	
	str_standard.text=tr("_disaterPanelDetail").format({"happy":happy,"accept":accept,"doubt":doubt,"sad":sad})
@onready var label_5 = $Label5

const NOT_JAM_UI_CONDENSED_16 = preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")
func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="ja":
		pass
	elif currencelanguage=="ru":
		str_reside.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		label_5.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		str_standard.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		str_standard.add_theme_font_size_override("font_size",25)
		str_standard.add_theme_constant_override("line_spacing",-5)
	elif currencelanguage=="en":
		str_standard.add_theme_constant_override("line_spacing",0)
		str_standard.add_theme_font_size_override("font_size",25)
	else:
		str_standard.add_theme_constant_override("line_spacing",0)
		str_standard.add_theme_font_size_override("font_size",31)
		#detail_cotext.add_theme_font_size_override("font_size",25)
	_refreshStand()	

func _refreshReside():
	var resideNum=GameManager.resideGrain
	str_reside.text=tr("剩余粮食数：{str}（万吨）").format({"str":resideNum})


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_refreshReside()	
	pass
@export var literatiValue=0
@export var greatValue=0
@export var DanYangValue=0

@onready var animation_player = $TextureRect/AnimationPlayer
@onready var animation_player2 = $"运动的马尔,/AnimationPlayer"

@onready var texture_rect = $TextureRect

const mache = preload("res://Asset/sound/马车.mp3")
func confireAllocation():
	texture_rect.show()
	SoundManager.play_sound(mache)
	animation_player.play("carriage")
	if(GameManager.resideGrain!=0):
		DialogueManager.show_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"必须分配")
	
		return
	
	var index=GameManager.sav.GrainIndex
	var happy=happys[index]
	var accept=accepts[index]
	var doubt=doubts[index]
	var sad=sads[index]
	#士族派 对你的支持度下降了，豪族派 对你的好感度 丹阳派对你的好感度，民心下降了xxx点，
	#当前士族派对你的支持度为 当前豪族派对你的支持度为 当前民心为
#这里做好感度现实
	#0 降低
	GameManager.sav.GrainIndex+=1
	
	#+5
	#-5
	#+10
	#-10
	#+15
	#-15
	#10、5、-5   第一次
	#10、
	var UpValue=5*(index+1)
	if control_1._num+control_1.factionSurpuls._num_grain>=happy:
		literatiValue=UpValue+5
	elif  control_1._num+control_1.factionSurpuls._num_grain>=accept:
		literatiValue=UpValue
	elif  control_1._num+control_1.factionSurpuls._num_grain<doubt:
		literatiValue=0-UpValue
		
	if control_2._num+control_2.factionSurpuls._num_grain>=happy:
		greatValue=UpValue+5
	elif  control_2._num+control_2.factionSurpuls._num_grain>=accept:
		greatValue=UpValue
	elif  control_2._num+control_2.factionSurpuls._num_grain<doubt:
		greatValue=0-UpValue	
		
	if control_3._num+control_3.factionSurpuls._num_grain>=happy:
		DanYangValue=UpValue+5
	elif  control_3._num+control_3.factionSurpuls._num_grain>=accept:
		DanYangValue=UpValue
	elif  control_3._num+control_3.factionSurpuls._num_grain<doubt:
		DanYangValue=0-UpValue	
	
	GameManager.sav.BENTUPAI.ChangeSupport(literatiValue)
	GameManager.sav.HAOZUPAI.ChangeSupport(greatValue)
	GameManager.sav.WAIDIPAI.ChangeSupport(DanYangValue)
	
	DialogueManager.show_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"分配成功")
	
	#control 1士族
	#control 2豪族
	#control 3丹阳派
	
	#if control_1.
	#判断buff增益 control1 判断、control2判断、control3判断

#这里可能不写
func afterAllocation():
	control_1.factionSurpuls._num_grain=control_1._num+control_1.factionSurpuls._num_grain
	control_2.factionSurpuls._num_grain=control_2._num+control_2.factionSurpuls._num_grain
	control_3.factionSurpuls._num_grain=control_3._num+control_3.factionSurpuls._num_grain			
	texture_rect.hide()
	SoundManager.stop_sound(mache)
	self.hide()
	pass

func cancelAllocation():
	control_1.resetZero()
	control_2.resetZero()
	control_3.resetZero()		
	#pass


#const dialogue_resource = preload("res://dialogues/府邸.dialogue")

func _on_allocation_down():
	#开启对话框
	var resideNum=GameManager.resideGrain
	if resideNum>0:
		DialogueManager.show_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"必须分配")
	else:
		DialogueManager.show_dialogue_balloon(GameManager.currenceScene.dialogue_resource,"确定分配")
	pass # Replace with function body.
