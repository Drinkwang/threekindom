extends Node


const APP_ID=3155310
const CLOUD_FILES:Dictionary={
	"user://ysg_data_setting.tres":"ysg_data_setting.tres",
	"user://save_data1.tres":"save_data1.tres",
	"user://save_data2.tres":"save_data2.tres",
	"user://save_data3.tres":"save_data3.tres",
}
const PENDING_DELETE_FILE_PATH:="user://steam_cloud_pending_deletes.cfg"

var steam:Object=null
var is_ready=false
var is_online=false
var is_owned=false
var steam_id:int
var steam_username:String
var _pending_deletes:Dictionary={}

func _ready() -> void:
	_load_pending_deletes()
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

func _can_use_cloud() -> bool:
	if not _can_use_steam() or not is_online:
		return false
	if steam.has_method("isCloudEnabledForAccount") and not bool(steam.call("isCloudEnabledForAccount")):
		return false
	if steam.has_method("isCloudEnabledForApp") and not bool(steam.call("isCloudEnabledForApp")):
		return false
	return true

func _process(_delta: float) -> void:
	if _can_use_steam():
		steam.call("run_callbacks")


func synchronize_cloud_files() -> void:
	if not _can_use_cloud():
		return
	_process_pending_deletes()
	for local_file_name:String in CLOUD_FILES:
		var steam_file_name:String=CLOUD_FILES[local_file_name]
		if _pending_deletes.has(steam_file_name):
			continue
		_sync_cloud_file(local_file_name,steam_file_name)

func synchronize_settings_file() -> void:
	if not _can_use_cloud():
		return
	var local_file_name:="user://ysg_data_setting.tres"
	_sync_cloud_file(local_file_name,CLOUD_FILES[local_file_name])

func synchronize_save_files() -> void:
	if not _can_use_cloud():
		return
	_process_pending_deletes()
	for slot:int in range(1,4):
		var local_file_name:="user://save_data%d.tres" % slot
		var steam_file_name:String=CLOUD_FILES[local_file_name]
		if _pending_deletes.has(steam_file_name):
			continue
		_sync_cloud_file(local_file_name,steam_file_name)

func upload_cloud_file(local_file_name:String) -> bool:
	var steam_file_name:String=CLOUD_FILES.get(local_file_name,"")
	if steam_file_name.is_empty():
		return false
	_remove_pending_delete(steam_file_name)
	return copy_file_to_steam(local_file_name,steam_file_name)

func delete_cloud_file(local_file_name:String) -> void:
	var steam_file_name:String=CLOUD_FILES.get(local_file_name,"")
	if steam_file_name.is_empty():
		return
	if delete_file_from_steam(steam_file_name):
		_remove_pending_delete(steam_file_name)
	else:
		_pending_deletes[steam_file_name]=true
		_save_pending_deletes()

func copy_file_to_steam(local_file_name:String,steam_file_name:String) -> bool:
	if not _can_use_cloud() or not _is_valid_cloud_resource(local_file_name,steam_file_name):
		return false
	var data:=FileAccess.get_file_as_bytes(local_file_name)
	steam.call("beginFileWriteBatch")
	var success:=bool(steam.call("fileWrite",steam_file_name,data,data.size()))
	steam.call("endFileWriteBatch")
	if not success:
		push_warning("Unable to write Steam Cloud file %s." % steam_file_name)
	return success

func copy_file_from_steam(steam_file_name:String,local_file_name:String) -> bool:
	var data:Variant=_read_cloud_file(steam_file_name)
	if data==null:
		return false
	return _install_cloud_data(local_file_name,steam_file_name,data)

func file_exists(steam_file_name:String) -> bool:
	return _can_use_cloud() and bool(steam.call("fileExists",steam_file_name))

func delete_file_from_steam(steam_file_name:String) -> bool:
	if not _can_use_cloud():
		return false
	if not file_exists(steam_file_name):
		return true
	return bool(steam.call("fileDelete",steam_file_name))

func _sync_cloud_file(local_file_name:String,steam_file_name:String) -> void:
	var local_exists:=FileAccess.file_exists(local_file_name)
	var remote_exists:=file_exists(steam_file_name)
	if not local_exists and not remote_exists:
		return
	if not local_exists:
		copy_file_from_steam(steam_file_name,local_file_name)
		return
	if not remote_exists:
		copy_file_to_steam(local_file_name,steam_file_name)
		return

	var remote_data:Variant=_read_cloud_file(steam_file_name)
	if remote_data==null:
		return
	var local_data:=FileAccess.get_file_as_bytes(local_file_name)
	if local_data==remote_data:
		return

	# Only resolve a conflict when the file contents actually differ.
	var remote_timestamp:=0
	if steam.has_method("getFileTimestamp"):
		remote_timestamp=int(steam.call("getFileTimestamp",steam_file_name))
	var local_timestamp:=int(FileAccess.get_modified_time(local_file_name))
	if remote_timestamp>local_timestamp:
		if not _install_cloud_data(local_file_name,steam_file_name,remote_data):
			copy_file_to_steam(local_file_name,steam_file_name)
	elif not copy_file_to_steam(local_file_name,steam_file_name):
		_install_cloud_data(local_file_name,steam_file_name,remote_data)

func _read_cloud_file(steam_file_name:String) -> Variant:
	if not file_exists(steam_file_name):
		return null
	var file_size:=int(steam.call("getFileSize",steam_file_name))
	if file_size<=0:
		return null
	var result:Variant=steam.call("fileRead",steam_file_name,file_size)
	if not result is Dictionary or not bool(result.get("ret",false)):
		push_warning("Unable to read Steam Cloud file %s." % steam_file_name)
		return null
	var data:Variant=result.get("buf",PackedByteArray())
	if not data is PackedByteArray or data.size()!=file_size:
		return null
	return data

func _install_cloud_data(local_file_name:String,steam_file_name:String,data:PackedByteArray) -> bool:
	var temp_file_name:="%s.cloud_tmp.tres" % local_file_name.get_basename()
	_remove_local_file(temp_file_name)
	var file:=FileAccess.open(temp_file_name,FileAccess.WRITE)
	if file==null:
		return false
	file.store_buffer(data)
	file.close()
	if not _is_valid_cloud_resource(temp_file_name,steam_file_name):
		_remove_local_file(temp_file_name)
		push_warning("Ignored invalid Steam Cloud file %s." % steam_file_name)
		return false
	if FileAccess.file_exists(local_file_name) and _remove_local_file(local_file_name)!=OK:
		_remove_local_file(temp_file_name)
		return false
	var error:=DirAccess.rename_absolute(
		ProjectSettings.globalize_path(temp_file_name),
		ProjectSettings.globalize_path(local_file_name)
	)
	if error!=OK:
		_remove_local_file(temp_file_name)
		return false
	return true

func _is_valid_cloud_resource(local_file_name:String,steam_file_name:String) -> bool:
	if not FileAccess.file_exists(local_file_name):
		return false
	var resource:=ResourceLoader.load(local_file_name,"",ResourceLoader.CACHE_MODE_IGNORE)
	if steam_file_name=="ysg_data_setting.tres":
		return resource is SettingsResource
	return resource is saveData

func _remove_local_file(path:String) -> Error:
	if not FileAccess.file_exists(path):
		return OK
	return DirAccess.remove_absolute(ProjectSettings.globalize_path(path))

func _load_pending_deletes() -> void:
	var config:=ConfigFile.new()
	if config.load(PENDING_DELETE_FILE_PATH)!=OK:
		return
	for steam_file_name:Variant in config.get_value("cloud","files",[]):
		if steam_file_name is String and CLOUD_FILES.values().has(steam_file_name):
			_pending_deletes[steam_file_name]=true

func _save_pending_deletes() -> void:
	if _pending_deletes.is_empty():
		_remove_local_file(PENDING_DELETE_FILE_PATH)
		return
	var config:=ConfigFile.new()
	config.set_value("cloud","files",_pending_deletes.keys())
	var error:=config.save(PENDING_DELETE_FILE_PATH)
	if error!=OK:
		push_warning("Unable to save pending Steam Cloud deletions: %s" % error_string(error))

func _remove_pending_delete(steam_file_name:String) -> void:
	if not _pending_deletes.erase(steam_file_name):
		return
	_save_pending_deletes()

func _process_pending_deletes() -> void:
	for steam_file_name:String in _pending_deletes.keys():
		if delete_file_from_steam(steam_file_name):
			_pending_deletes.erase(steam_file_name)
	_save_pending_deletes()
		
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
