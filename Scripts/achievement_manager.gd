extends Node


const APP_ID=3155310
var steam:Object=null
var is_ready=false
var is_online=false
var is_owned=false
var steam_id:int
var steam_username:String
func _ready() -> void:
	init_steam()
	#set_achievement("ACH_WIN_ONE_GAME")
func init_steam():
	is_ready=false
	is_online=false
	is_owned=false
	steam_id=0
	steam=null
	if APP_ID<=0 or not Engine.has_singleton("Steam"):
		return
	steam=Engine.get_singleton("Steam")
	if not is_instance_valid(steam):
		steam=null
		return
	var init_result:Variant=steam.call("steamInitEx",APP_ID)
	if not init_result is Dictionary:
		return
	var init_response:Dictionary=init_result
	if int(init_response.get("status",1))>0:
		return
	is_ready=true
	is_online=bool(steam.call("loggedOn"))
	is_owned=bool(steam.call("isSubscribed"))
	steam_id=int(steam.call("getSteamID"))

func _can_use_steam() -> bool:
	return is_ready and is_instance_valid(steam)

func _process(_delta: float) -> void:
	if _can_use_steam():
		steam.call("run_callbacks")


func copy_file_to_steam(local_file_name:String,steam_file_name:String):
	if _can_use_steam():
		steam.call("beginFileWriteBatch")
		if FileAccess.file_exists(local_file_name):
			var data=FileAccess.get_file_as_bytes(local_file_name)
			if bool(steam.call("fileWrite",steam_file_name,data,data.size())):
				print("file %s saved to the Steam Cloud." % steam_file_name)
			else:
				print("Unable to write Steam file %s." %steam_file_name)
		else:
			print("unable to find local file %s."%local_file_name)
		steam.call("endFileWriteBatch")

func copy_file_from_steam(steam_file_name:String,local_file_name:String):
	if _can_use_steam():
		if file_exists(steam_file_name):
			var file_size=int(steam.call("getFileSize",steam_file_name))
			var result:Variant=steam.call("fileRead",steam_file_name,file_size)
			if result is Dictionary and bool(result.get("ret",false)):
				var data:PackedByteArray=result.get("buf",PackedByteArray())
				var file=FileAccess.open(local_file_name,FileAccess.WRITE)
				file.store_buffer(data)
				file.close()
			else:
				print("unable to read steam file %s"% steam_file_name)
		else:
			print("unable to find steam file %s."%steam_file_name)
			

func file_exists(steam_file_name:String):
	return _can_use_steam() and bool(steam.call("fileExists",steam_file_name))

func delete_file_from_steam(steam_file_name:String):
	if _can_use_steam() and file_exists(steam_file_name):
		steam.call("fileDelete",steam_file_name)
		
func set_achievement(achievement_id:String):
	if _can_use_steam() and achievement_id:
		var result=bool(steam.call("setAchievement",achievement_id))
		if result:
			steam.call("storeStats")
			print("steam achivement %s is set"%achievement_id)
		else:
			print("steam achivement %s is Not set"%achievement_id)	

func set_general_level_10_achievement(general: Dictionary) -> void:
	if int(general.get("level", 0)) < int(general.get("max_level", 10)):
		return

	match general.get("name", ""):
		"关羽":
			set_achievement("NEW_ACHIEVEMENT_1_26")
		"张飞":
			set_achievement("NEW_ACHIEVEMENT_1_27")
		"无名":
			set_achievement("NEW_ACHIEVEMENT_1_28")

func sync_general_level_10_achievements(generals: Dictionary) -> void:
	for general in generals.values():
		set_general_level_10_achievement(general)
