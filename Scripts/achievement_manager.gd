extends Node


#var steam

const APP_ID=3155310
var is_ready=true
var is_online=false
var is_owned=false
var steam_id:int
var steam_username:String
func _ready() -> void:

	#if Engine.has_singleton("Steam"):
	#	steam = Engine.get_singleton("Steam")
	#else:
	#	push_warning("Steam singleton not found.")
	#	return
	init_steam()
	set_achievement("ACH_WIN_ONE_GAME")
func init_steam():
	if Engine.has_singleton(("Steam")) and APP_ID>0:
		var init_response:Dictionary=Steam.steamInitEx(APP_ID)
		if init_response['status']>0:
			is_ready=false
			return 
		is_online=Steam.loggedOn()
		is_owned=Steam.isSubscribed()
		steam_id=Steam.getSteamID()
	else:
		steam_id=0
		is_ready=false
		print("steam is not support")	

func _process(_delta: float) -> void:
	if is_ready:
		Steam.run_callbacks()


func copy_file_to_steam(local_file_name:String,steam_file_name:String):
	if is_ready:
		Steam.beginFileWriteBatch()
		if FileAccess.file_exists(local_file_name):
			var data=FileAccess.get_file_as_bytes(local_file_name)
			if Steam.fileWrite(steam_file_name,data,data.size()):
				print("file %s saved to the Steam Cloud." % steam_file_name)
			else:
				print("Unable to write Steam file %s." %steam_file_name)
		else:
			print("unable to find local file %s."%local_file_name)
		Steam.endFileWriteBatch()		

func copy_file_from_steam(steam_file_name:String,local_file_name:String):
	if is_ready:
		if file_exists(steam_file_name):
			var file_size=Steam.getFileSize(steam_file_name)
			var result=Steam.fileRead(steam_file_name,file_size)
			if result.ret:
				var data=result.buf
				var file=FileAccess.open(local_file_name,FileAccess.WRITE)
				file.store_buffer(data)
				file.close()
			else:
				print("unable to read steam file %s"% steam_file_name)
		else:
			print("unable to find steam file %s."%steam_file_name)
			

func file_exists(steam_file_name:String):
	return is_ready and Steam.fileExists(steam_file_name)

func delete_file_from_steam(steam_file_name:String):
	if is_ready and file_exists(steam_file_name):
		Steam.fileDelete(steam_file_name)
		
func set_achievement(achievement_id:String):
	if is_ready and achievement_id:
		var result= Steam.setAchievement(achievement_id)
		if result:
			Steam.storeStats()
			print("steam achivement %s is set"%achievement_id)
		else:
			print("steam achivement %s is Not set"%achievement_id)	
