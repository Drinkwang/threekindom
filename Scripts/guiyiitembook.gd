extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
@onready var detail: Label = $detail


func _on_texture_button_2_button_down() -> void:
	PanelManager.isOpenSetting=false	
	self.hide()
func refreshPage(_name,isstatue,context):
	var statuesTxt
	if isstatue==0:
		statuesTxt="未获取"
	elif isstatue==1:
		statuesTxt="已获得"
	elif isstatue==2:
		statuesTxt="已错过"
	#var statecontext="状态：{s}".format({"s":statuesTxt})
	
	var guaitan=tr("怪谈故事：")+tr(context)
	detail.text=guaitan
