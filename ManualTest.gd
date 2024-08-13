
extends Control

#const DestinationScene = load("res://Destination.tscn")
const FancyFade = preload("res://addons/transitions/FancyFade.gd")
var readyInitData
func _ready():
	print("xxxx")

func _on_instant_button_pressed():
	Transitions.change_scene_to_instance( GameManager.DESTINATION.instantiate(), Transitions.FadeType.Instant)
	
func _on_cross_fade_button_pressed():
	Transitions.change_scene_to_instance(  GameManager.DESTINATION.instantiate(), Transitions.FadeType.CrossFade)

func _on_blend_button_pressed():
	#FancyFade.new().blurry_noise( load("res://Destination.tscn").instantiate())
	
	
	const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
	FancyFade.new().custom_fade( GameManager.DESTINATION.instantiate(), 2, DISSOLVE_IMAGE)
