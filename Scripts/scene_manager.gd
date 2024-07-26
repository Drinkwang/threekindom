extends Node
class_name  scenemanager
var SLEEP_BLANK = preload("res://Scene/sleepBlank.tscn")
var STREET = preload("res://Scene/street.tscn")
var BOULEUTERION = preload("res://Scene/Bouleuterion.tscn")
var DRILL_GROUND = preload("res://Scene/battleSys/drill_ground.tscn")
var GOVERNMENT_BUILDING = preload("res://Scene/government_building.tscn")
var HOUSE = preload("res://Scene/house.tscn")
const FancyFade = preload("res://addons/transitions/FancyFade.gd")


enum roomNode{
	SLEEP_BLANK,
	STREET,
	BOULEUTERION,
	DRILL_GROUND,
	GOVERNMENT_BUILDING,
	HOUSE
	
	
	
}

func changeScene(tempnode:roomNode,time:float):
	const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
	if tempnode==roomNode.SLEEP_BLANK:
		FancyFade.new().custom_fade(SLEEP_BLANK.instantiate(), time, DISSOLVE_IMAGE)
	elif tempnode==roomNode.STREET:
		FancyFade.new().custom_fade(STREET.instantiate(), time, DISSOLVE_IMAGE)
	elif tempnode==roomNode.BOULEUTERION:
		FancyFade.new().custom_fade(BOULEUTERION.instantiate(), time, DISSOLVE_IMAGE)
	elif tempnode==roomNode.DRILL_GROUND:	
		FancyFade.new().custom_fade(DRILL_GROUND.instantiate(), time, DISSOLVE_IMAGE)
	elif tempnode==roomNode.GOVERNMENT_BUILDING:
		FancyFade.new().custom_fade(GOVERNMENT_BUILDING.instantiate(), time, DISSOLVE_IMAGE)
	elif tempnode==roomNode.HOUSE:
		FancyFade.new().custom_fade(HOUSE.instantiate(), time, DISSOLVE_IMAGE)
