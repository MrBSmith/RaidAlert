tool
extends Node

const VIDEO_ALERT_DIR_PATH = "res://Alerts/Videos/"
const AUDIO_ALERT_DIR_PATH = "res://Alerts/Audios/"



var print_logs := true

var alert_dict = { "audio" : {
		"vilain": load("res://Alerts/Audios/Vilain.ogg"),
		"malaxe": load("res://Alerts/Audios/Malaxe.ogg"),
		"coquinou": load("res://Alerts/Audios/Coquinou.ogg"),
		"hadoken": load("res://Alerts/Audios/hadouken.mp3")
	}}

var screen_size = Vector2(ProjectSettings.get_setting("display/window/size/width"),
						ProjectSettings.get_setting("display/window/size/height"))

#### ACCESSORS ####



#### BUILT-IN ####

func _ready() -> void:
	_fetch_alerts_files(VIDEO_ALERT_DIR_PATH, "video")


#### VIRTUALS ####



#### LOGIC ####


func _fetch_alerts_files(path: String, category_name: String) -> void:
	var file_array = DirNavHelper.fetch_dir_content(path, DirNavHelper.DIR_FETCH_MODE.FILE_ONLY)
	if print_logs: print("%s file fetching started")
	
	if !alert_dict.has(category_name):
		alert_dict[category_name] = {}
	
	for file in file_array:
		if ".import".is_subsequence_ofi(file):
			continue
		
		var resource = load(path + file)
		if print_logs: print("%s file loaded at path %s" % [file, path + file])
		
		alert_dict[category_name][file.split(".")[0].to_lower()] = resource




#### INPUTS ####



#### SIGNAL RESPONSES ####
