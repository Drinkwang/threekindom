extends CanvasLayer

func _on_rest():
	SoundManager.stop_music()
	GameManager.SkipPrologue()
	SoundManager.play_sound(sounds.confiresound)
	SoundManager.play_sound(sounds.COLLECT_SMALL_JEWEL_1)
	SceneManager.changeScene(SceneManager.roomNode.GOVERNMENT_BUILDING, 2)

func _on_cancel():
	SoundManager.play_sound(sounds.confiresound)
	GameManager.sav.day = 1
	SoundManager.play_sound(sounds.COLLECT_SMALL_JEWEL_1)
	SceneManager.changeScene(SceneManager.roomNode.PRE_SCENE, 2)
