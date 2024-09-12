extends Node2D



	

func _on_exit_button_down():
	get_tree().quit()
	pass # Replace with function body.

#需要修改，此处应该是hero剪辑欸
#@onready var policyPanel = $"政务面板"
@onready var control = $Control

func _on_begin_button_down():
	control.show()
#policyPanel.show()



func _on_continue_button_down():
	pass # Replace with function body.
