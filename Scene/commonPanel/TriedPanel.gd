@tool
extends CanvasLayer
class_name TiredPanel






func _on_rest():
	GameManager.triedPanelDone.emit()
	self.hide()	
	GameManager._rest()
	pass # Replace with function body.


func _on_cancel():
	GameManager.triedPanelDone.emit()
	self.hide()
	pass # Replace with function body.
