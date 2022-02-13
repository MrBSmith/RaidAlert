tool
extends Node

const VIDEO_ALERT_DIR_PATH = "res://Alerts/Videos/"
const AUDIO_ALERT_DIR_PATH = "res://Alerts/Audios/"

var alert_dict = {}

var screen_size = Vector2(ProjectSettings.get_setting("display/window/size/width"),
						ProjectSettings.get_setting("display/window/size/height"))

#### ACCESSORS ####



#### BUILT-IN ####

func _ready() -> void:
	_fetch_alerts_files(VIDEO_ALERT_DIR_PATH, "video")
	_fetch_alerts_files(AUDIO_ALERT_DIR_PATH, "audio")
	return


#### VIRTUALS ####



#### LOGIC ####


func _fetch_alerts_files(path: String, category_name: String) -> void:
	var file_array = DirNavHelper.fetch_dir_content(path, DirNavHelper.DIR_FETCH_MODE.FILE_ONLY)
	
	if !alert_dict.has(category_name):
		alert_dict[category_name] = {}
	
	for file in file_array:
		if ".import".is_subsequence_ofi(file):
			continue
		
		alert_dict[category_name][file.split(".")[0]] = load(path + file)



#### INPUTS ####



#### SIGNAL RESPONSES ####
