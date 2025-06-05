extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
@onready var label = $Label
@onready var nodate = $nodate

func refresh(sav:saveData):
	nodate.hide()
	label.show()

	#GameManager.sav.current_datetime
	var formatStr=tr("時間:{current_datetime}\n游戲天數：{day}\n擁有黃金：{coin}\n人心：{heart}\n勞夫：{people}")
	if sav.autoSave == true:
		formatStr=("({auto})").format({"auto":tr("自动存档")})+"\n"+formatStr

	label.text=formatStr.format({"current_datetime":sav.current_datetime,"day":sav.day,"coin":sav.coin,"heart":sav.people_surrport,"people":sav.labor_force})
	
	
func delete():
	nodate.show()
	label.hide()	
