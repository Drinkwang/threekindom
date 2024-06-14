extends PanelContainer
class_name factionalname
@onready var progress_bar = $MarginContainer/VBoxContainer/ProgressBar
@onready var label = $MarginContainer/VBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	pass

func init(item:cldata):
	label.text=item._name+"-支持度："
	progress_bar.value=item._support_rate
	if item.index==cldata.factionIndex.weidipai:
		var sb = StyleBoxFlat.new()
		progress_bar.add_theme_stylebox_override("fill", sb)
		sb.bg_color = Color.RED
	elif item.index==cldata.factionIndex.bentupai:
		var sb = StyleBoxFlat.new()
		progress_bar.add_theme_stylebox_override("fill", sb)
		sb.bg_color = Color.GREEN
	elif item.index==cldata.factionIndex.haozupai:
		var sb = StyleBoxFlat.new()
		progress_bar.add_theme_stylebox_override("fill", sb)
		sb.bg_color = Color.BLUE
	pass
	

