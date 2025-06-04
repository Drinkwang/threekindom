@tool
extends Control
@onready var img = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/img

@export var txt:Texture2D:
	get:
		return txt
	set(value):
		txt=value
		if(img!=null):
			img.texture=txt

@export_multiline var contextEX:String:
	get:
		return contextEX
	set(value): 
		contextEX=value
		if(context!=null):
			context.text=contextEX

@export var titleEX:String:
	get:
		return titleEX
	set(value):
		titleEX=value
		if(title!=null):
			title.text=titleEX
		
@onready var title = $PanelContainer/MarginContainer/VBoxContainer/title
@onready var context = $PanelContainer/MarginContainer/VBoxContainer/context




# Called when the node enters the scene tree for the first time.
func _ready():
	if(context!=null):
		context.text=contextEX
	if(title!=null):
		title.text=titleEX		
	if titleEX.length()<=0:
		title.hide()
	else:
		title.show()	
	if(txt!=null):
		img.texture=txt
	SignalManager.changeLanguage.connect(_changeLanguage)				
	_changeLanguage() # Replace with function body.


func _changeLanguage():
	var currencelanguage=TranslationServer.get_locale()	
	if currencelanguage=="ru":
		#label.add_theme_font_size_override("font_size", 34)
		#reallabel.add_theme_font_size_override("font_size", 38)
		title.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		context.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		context.add_theme_font_size_override("font_size", 38)
		#reallabel.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
	else:
		title.remove_theme_font_override("font")
		context.remove_theme_font_override("font")
		context.add_theme_font_size_override("font_size", 48)
	
func refreshContext():
	if GameManager.sav.curGovAff.length()>0:
		
		contextEX=GameManager.sav.curGovAff
	else:
		var policycontext
		if(GameManager.sav.TargetDestination=="rest"):
			policycontext=tr("当前暂无")
		elif GameManager.sav.TargetDestination=="自宅":
			policycontext=tr("当前暂无")
		elif GameManager.sav.TargetDestination=="府邸":
			policycontext=tr("当前暂无")
		elif GameManager.sav.TargetDestination=="议事厅":
			policycontext=tr("当前暂无")
		elif GameManager.sav.TargetDestination=="演武场":
			policycontext=tr("当前暂无")
		elif GameManager.sav.TargetDestination=="大儒辩经":
			policycontext=tr("当前暂无")	
		else:
			policycontext=GameManager.sav.TargetDestination	
		contextEX=tr("主线任务:")+policycontext
		#每个支线有个名称（枚举）和键值对，如果键值队为数 那么则xxx
		#把若干支线任务需要添加的写进，每个支线销毁，或者不销毁需要[xxx:xxxxx]
		#增加若干支线
		var questContexts=GameManager.sav.SIDEQUEST_MAP.values().filter(func(a):a.length()>0)
		var sideNum=questContexts.size()
		#var sideNum=0
		if sideNum>0:
			contextEX=contextEX+"支线任务：\n"
			for i in range(1,sideNum):
				contextEX=contextEX+questContexts[i-1]+"\n"
	if(context!=null):
		context.text=contextEX
	if(title!=null):
		title.text=titleEX		
		
	if(txt!=null):
		img.texture=txt

func showContext():
	title.text=context
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@export var dialogue_resource:DialogueResource
@export var clickEvent:String="start"
func _on_button_button_down():
	self.hide()
	if clickEvent.length()>0 and dialogue_resource!=null:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource,clickEvent)
		
	pass # Replace with function body.
