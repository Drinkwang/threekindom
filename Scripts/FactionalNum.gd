extends PanelContainer
class_name factionalname
@onready var progress_bar = $MarginContainer/VBoxContainer/ProgressBar
@onready var label = $MarginContainer/VBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	changeLanguage()
	pass # Replace with function body.

func changeLanguage():
	var currencelanguage=TranslationServer.get_locale()
	if currencelanguage=="ja":
		pass
	elif currencelanguage=="ru":

		label.add_theme_font_override("font",preload("res://addons/inventory_editor/default/fonts/Not Jam UI Condensed 16.ttf"))
			
	else:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	pass

func init(item:cldata):
	label.text=tr(item._name)+tr("-支持度：")
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
	

