extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	initLanguage()
	SignalManager.changeLanguage.connect(initLanguage)
	
@onready var nodate = $nodate
	
const NOT_JAM_UI_CONDENSED_16 = preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf")
	
const BAKUDAI_BOLD = preload("res://Asset/Font/Bakudai-Bold.ttf")
func initLanguage():
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="ja":
		#nodate.add_theme_font_size_override("font",42)
		nodate.add_theme_font_override("font",BAKUDAI_BOLD)
		label.add_theme_font_override("font",BAKUDAI_BOLD)
		label.add_theme_constant_override("line_spacing",0)
	elif currencelanguage=="ru":
		label.add_theme_constant_override("line_spacing",-5)
		nodate.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		label.add_theme_font_override("font",NOT_JAM_UI_CONDENSED_16)
		nodate.add_theme_font_size_override("font_size",50)
	else:
		label.add_theme_constant_override("line_spacing",0)
		nodate.add_theme_font_size_override("font_size",72)
		nodate.add_theme_font_override("font",BAKUDAI_BOLD)
		label.add_theme_font_override("font",BAKUDAI_BOLD)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
@onready var label = $Label


func refresh(sav:saveData):
	nodate.hide()
	label.show()

	#GameManager.sav.current_datetime
	var formatStr=tr("savefiledata")
	if sav.autoSave == true:
		formatStr=("({auto})").format({"auto":tr("自动存档")})+"\n"+formatStr

	label.text=formatStr.format({"current_datetime":sav.current_datetime,"day":sav.day,"coin":sav.coin,"heart":sav.people_surrport,"people":sav.labor_force})
	
	
func delete():
	nodate.show()
	label.hide()	
