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
	if GameManager==null or GameManager.sav==null:
		return		
	SignalManager.changeLanguage.connect(_changeLanguage)				
	_changeLanguage() # Replace with function body.


func _changeLanguage():
	var currencelanguage=TranslationServer.get_locale()	
	if currencelanguage=="ru":
		#label.add_theme_font_size_override("font_size", 34)
		#reallabel.add_theme_font_size_override("font_size", 38)
		#title.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		#context.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
		context.add_theme_font_size_override("font_size", 38)
		#reallabel.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
	else:
		#title.remove_theme_font_override("font")
		#context.remove_theme_font_override("font")
		context.add_theme_font_size_override("font_size", 48)
	
func refreshContext():
	if GameManager.sav.curGovAff.length()>0:
		var display_text = GameManager.sav.curGovAff
		# 序章 day1-day3：标记已完成事项
		var day = GameManager.sav.day
		if day >= 1 and day <= 3:
			var lines = display_text.split("\n")
			var flags = GameManager.sav.have_event
			for i in range(lines.size()):
				var done = false
				if day == 1:
					if i == 0:
						done = flags.get("firstgovernment", false)
					elif i == 1:
						done = flags.get("firstEnterBattle", false)
				elif day == 2:
					if i == 0:
						done = flags.get("firstMeetingEnd", false)
					elif i == 1:
						done = flags.get("firstParliamentary", false)
				elif day == 3:
					if i == 0:
						done = flags.get("firstBattleEnd", false)
				if done and not lines[i].contains("已完成"):
					lines[i] += "（已完成）"
			contextEX = "\n".join(lines)
		else:
			contextEX = display_text
	else:

		var policycontext
		if (GameManager.sav.targetTxt != null and GameManager.sav.targetTxt.length() > 0) or \
		GameManager.sav.TargetDestination=="rest" or \
		GameManager.sav.TargetDestination=="自宅" or \
		GameManager.sav.TargetDestination=="府邸" or \
		GameManager.sav.TargetDestination=="议事厅" or \
		GameManager.sav.TargetDestination=="演武场" or \
		GameManager.sav.TargetDestination=="大儒辩经":	
			var targetValue=GameManager.sav.targetValue
			#获取当前值的枚举类型，根据枚举类型获取对应资源数值，并把资源数值填写进下面的函数
			var currenceValue=GameManager.getTaskCurrenceValue()
	# target，currence
			#判断时不时construct
			#if
			
			
			var iscompleteTask=false    
			if  currenceValue is Array:
				if currenceValue[0]>=GameManager.sav.targetValue and currenceValue[1]>=3:
					iscompleteTask=true
			else:
				if currenceValue>=GameManager.sav.targetValue:
					iscompleteTask=true
			
			
			if iscompleteTask:
				if(GameManager.sav.TargetDestination=="rest"):
					policycontext=tr("任务已完成，休息进入下一旬推进剧情")
				elif GameManager.sav.TargetDestination=="自宅":
					policycontext=tr("任务已完成，请返回自宅触发下一阶段剧情")
				elif GameManager.sav.TargetDestination=="府邸":
					policycontext=tr("任务已完成，请前往府邸触发下一阶段剧情")
				elif GameManager.sav.TargetDestination=="议事厅":
					policycontext=tr("任务已完成，请前往议事厅触发下一阶段剧情")
				elif GameManager.sav.TargetDestination=="演武场":
					policycontext=tr("任务已完成，请前往演武场触发下一阶段剧情")
				elif GameManager.sav.TargetDestination=="大儒辩经":
					policycontext=tr("任务已完成，请前往城外和大儒辩经触发下一阶段剧情")
				else:
					if GameManager.sav.TargetDestination != null and GameManager.sav.TargetDestination.length() > 0:
						policycontext=tr(GameManager.sav.TargetDestination)
					elif GameManager.sav.targetTxt != null and GameManager.sav.targetTxt.length() > 0:
						if currenceValue is Array:
							policycontext=tr(GameManager.sav.targetTxt).format({"target":targetValue,"currence1":currenceValue[0],"currence2":currenceValue[1]})
						
					else:
						policycontext=tr("当前任务：待发现")
			else:
				
				#var currenceValue=GameManager.sav.currenceValue
				if  currenceValue is Array:
					#var targetValue=GameManager.sav.targetValue
					if currenceValue[1]<3:
						policycontext=tr(GameManager.sav.targetTxt).format({"target":targetValue,"currence1":currenceValue[0],"currence2":currenceValue[1]})
					else:
						var strContext=tr("基建已完成，请征集民夫完成后前往府邸触发下一阶段剧情")	
						strContext=strContext+";"+tr("征集民夫数量：{currence1}/{target}").format({"target":targetValue,"currence1":currenceValue[0]})
						policycontext=strContext
				else:				
				
					policycontext=tr(GameManager.sav.targetTxt).format({"target":targetValue,"currence":currenceValue})

					policycontext=tr(GameManager.sav.targetTxt).format({"target":targetValue,"currence":currenceValue})
					if GameManager.sav.endPath!=GameManager.endPath.none:
						var groupName
						if GameManager.sav.endPath==GameManager.endPath.xiaopei:
							groupName=1
						elif GameManager.sav.endPath==GameManager.endPath.xuzhou:
							groupName=2
						var currenv=GameManager.sav.finalPhaseValue
						policycontext=policycontext+"\n"+tr("城内形势:")+StageStateMgr.get_state_name(groupName,currenv)+""+tr("【处理军政、筹措军需及安抚民众，均可稳定城中局势】")
				if GameManager.sav.targetResType==GameManager.ResType.govern:
					if GameManager.dontHaveDominance():
						policycontext=policycontext+"\n"+tr("安抚徐州各派系，将豪族派、士族派、丹阳派、吕布好感度均提升至80。")
					else:
						policycontext=policycontext+"\n"+tr("徐州权柄之路开启！你持有霸道之息解锁霸道线，可镇压所有派系至顺从；或者选用怀柔之策，将所有派系好感度均提至 80，稳固州治")
				#var dailyBattleCount=0
				#if GameManager.sav.endPath==GameManager.endPath.xiaopei:#do
					#dailyBattleCount=3 if GameManager.sav.have_event["吕布之怒"]==true else 1
				#elif GameManager.sav.endPath==GameManager.endPath.xuzhou:
					#dailyBattleCount=3 if GameManager.sav.have_event["夏侯偷马"]==true else 2
				#if dailyBattleCount>0:
					#policycontext=policycontext+"\n"+tr("每旬至少完成{n}次军事行动").format({"n":dailyBattleCount})
		else:
			if GameManager.sav.TargetDestination.length()>0:
				policycontext=GameManager.sav.TargetDestination	
			else:
				if GameManager.sav.have_event["庆功宴结束"]==true:
					policycontext=tr("新目标将与关键角色对话解锁")
				#else:
					
		contextEX=tr("主线任务:")+policycontext
		#每个支线有个名称（枚举）和键值对，如果键值队为数 那么则xxx
		#把若干支线任务需要添加的写进，每个支线销毁，或者不销毁需要[xxx:xxxxx]
		#增加若干支线
		var dd=GameManager.sav.SIDEQUEST_MAP.values()
		var questContexts2=dd.filter(func(a): return a != null && a.length() > 0)
		var questContexts=GameManager.sav.SIDEQUEST_MAP.values().filter(func(a): return a != null && a.length() > 0)
		var sideNum=questContexts.size()
		#var sideNum=0
		if sideNum>0:
			contextEX=contextEX+"\n\n"+tr("支线任务")+"：\n"
			for i in range(0,sideNum):
				contextEX=contextEX+var_to_str(i+1)+":"+questContexts[i]+"\n"
	contextEX=append_prologue_hearsay_progress(contextEX)
	if(context!=null):
		context.text=contextEX
	if(title!=null):
		title.text=titleEX		
		
	if(txt!=null):
		img.texture=txt

func showContext():
	title.text=context

func append_prologue_hearsay_progress(base_text:String)->String:
	if not (GameManager.sav.day<5 and GameManager.sav.have_event["拾荒老人剧情"]==true):
		return base_text
	var collected=0
	for item in GameManager.CanFindSecretItems:
		if item.alreadyGet==true:
			collected+=1
	var progress_text=tr("当前诡闻秘录搜集进度：%d/3")%collected
	if base_text.length()>0:
		return base_text+"\n\n"+tr("支线任务")+":\n"+progress_text
	return progress_text
	

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
