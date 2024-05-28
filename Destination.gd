extends baseComponent

const FancyFade = preload("res://addons/transitions/FancyFade.gd")
func _ready():
	print("xxxx")

func _on_button_pressed():
	#get_tree().change_scene_to_packed(load("res://Scene/house.tscn"))
	#const HOUSE = preload("res://Scene/house.tscn")
	FancyFade.new().blurry_noise(GameManager.MANUAL_TEST.instantiate())

#const House = preload("res://Scripts/house.gd")

	#const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
	#FancyFade.new().custom_fade(load("res://ManualTest.tscn").instantiate(), 2, DISSOLVE_IMAGE)
