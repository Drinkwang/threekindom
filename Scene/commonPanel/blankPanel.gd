@tool
extends CanvasLayer
class_name blankPanel
@onready var color_rect = $Control/ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func fade(color:Color,time:float,type:PanelManager.fadeType):
	#color_rect.color=color
	#
	var tween = get_tree().create_tween()
	var tcolor= color_rect.color
	
	
	
	
	if type==PanelManager.fadeType.fadeIn:
		tcolor=color#Color(tcolor,1)
		tween.tween_property(color_rect, "color",tcolor, time)
		pass
	elif type==PanelManager.fadeType.fadeOut:
		color_rect.color=color
		tcolor=Color(tcolor,0)
		
		tween.tween_property(color_rect, "color",tcolor, time)
		tween.tween_callback(_on_Tween_tween_all_completed)
		pass
	elif type==PanelManager.fadeType.fadeInAndOut:
		
		tcolor=Color(tcolor,1)
		
		tween.tween_property(color_rect, "color",tcolor, time)
		tcolor=Color(tcolor,0)
		tween.tween_callback(_on_Tween_tween_all_completed)
		tween.tween_property(color_rect, "color",tcolor, time)
		pass
	pass


func _on_Tween_tween_all_completed():
	self.queue_free()
	pass
