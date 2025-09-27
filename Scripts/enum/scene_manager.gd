extends Node
class_name  scenemanager
var SLEEP_BLANK = preload("res://Scene/sleepBlank.tscn")
var STREET = preload("res://Scene/street.tscn")
var BOULEUTERION = preload("res://Scene/Bouleuterion.tscn")
var DRILL_GROUND = preload("res://Scene/battleSys/drill_ground.tscn")
var GOVERNMENT_BUILDING = preload("res://Scene/government_building.tscn")
var HOUSE = preload("res://Scene/house.tscn")
const GAMEHALL = preload("res://Scene/game.tscn")
const FancyFade = preload("res://addons/transitions/FancyFade.gd")
const BOARD_GAME = preload("res://Scene/boardGame.tscn")
var MAIN = preload("res://Scene/main.tscn")
enum roomNode{
	PRE_SCENE,
	SLEEP_BLANK,
	STREET,
	BOULEUTERION,
	DRILL_GROUND,
	GOVERNMENT_BUILDING,
	HOUSE,
	MainMenu,
	Shop,
	BoardGame,
	
}

enum sideQuest{
	CHENDENG,
	MIZHU,
	KESULU,
	CAOBAO,
	DARU,
	
	
}
var beforeNode
func changeScene(tempnode:roomNode,time:float):
	beforeNode=tempnode
	GameManager.CanClickUI=false
	const DISSOLVE_IMAGE = preload('res://addons/transitions/images/blurry-noise.png')
	if tempnode==roomNode.PRE_SCENE:
		FancyFade.new().custom_fade(MAIN.instantiate(), time, DISSOLVE_IMAGE)
	elif tempnode==roomNode.SLEEP_BLANK:
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
	elif tempnode==roomNode.MainMenu:
		FancyFade.new().custom_fade(GAMEHALL.instantiate(), time, DISSOLVE_IMAGE)
	elif tempnode==roomNode.Shop:
		FancyFade.new().custom_fade(STREET.instantiate(), time, DISSOLVE_IMAGE)
	elif tempnode==roomNode.BoardGame:
		FancyFade.new().custom_fade(BOARD_GAME.instantiate(), time, DISSOLVE_IMAGE)

func rest_scene(tempnode:roomNode):
	
	if tempnode==roomNode.SLEEP_BLANK:
		GameManager.restFadeScene=SceneManager.SLEEP_BLANK
	elif tempnode==roomNode.STREET:
		GameManager.restFadeScene=SceneManager.STREET
	elif tempnode==roomNode.BOULEUTERION:
		GameManager.restFadeScene=SceneManager.BOULEUTERION		

	elif tempnode==roomNode.DRILL_GROUND:	
		GameManager.restFadeScene=SceneManager.DRILL_GROUND		

	elif tempnode==roomNode.GOVERNMENT_BUILDING:
		GameManager.restFadeScene=SceneManager.GOVERNMENT_BUILDING		

	elif tempnode==roomNode.HOUSE:
		GameManager.restFadeScene=HOUSE

	
	
	SoundManager.stop_music()

		
	GameManager._rest(false)


enum bossMode{
	none,
	tao,
	mi,
	huang,
	zhenren
	
}


enum etraTaskType{
	none,
	costMoney,
	loseGame,
	dontLoseGame
	
}
