
extends Control

#const DestinationScene = load("res://Destination.tscn")
const FancyFade = preload("res://addons/transitions/FancyFade.gd")

func _ready():
	print("xxxx")

func _on_instant_button_pressed():
	Transitions.change_scene_to_instance( load("res://Destination.tscn").instantiate(), Transitions.FadeType.Instant)
	
func _on_cross_fade_button_pressed():
	Transitions.change_scene_to_instance( load("res://Destination.tscn").instantiate(), Transitions.FadeType.CrossFade)

func _on_blend_button_pressed():
	#FancyFade.new().blurry_noise( load("res://Destination.tscn").instantiate())
	
	
	const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
	FancyFade.new().custom_fade(load("res://Destination.tscn").instantiate(), 2, DISSOLVE_IMAGE)
