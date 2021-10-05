extends Control
class_name Overlay

onready var timer = $Timer
onready var main_scene_overlay = $MainSceneOverlay

var scene_file_path = "D:/StreamDeck/StreamLabels/scenes.txt"
var alert_file_path = "D:/StreamDeck/StreamLabels/alerts.txt"

var current_scene = "WaitingScreen" setget set_current_scene

#### ACCESSORS ####

func is_class(value: String): return value == "Overlay" or .is_class(value)
func get_class() -> String: return "Overlay"

func set_current_scene(value: String):
	if value != current_scene && value != "":
		current_scene = value
		EVENTS.emit_signal("OBS_scene_changed", current_scene)

#### BUILT-IN ####

func _ready() -> void: 
	var __ = timer.connect("timeout", self, "_on_timer_timeout")
	__ = EVENTS.connect("OBS_scene_changed", self, "_on_OBS_scene_changed")
	
	_empty_file(scene_file_path)
	_empty_file(alert_file_path)


#### VIRTUALS ####



#### LOGIC ####

func _read_file(path: String) -> String:
	var file = File.new()
	file.open(path, File.READ_WRITE)
	
	var line = file.get_line()
	file.close()
	
	return line


func _empty_file(path: String) -> void:
	var file = File.new()
	file.open(path, File.WRITE)
	file.close()


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_timer_timeout() -> void:
	set_current_scene(_read_file(scene_file_path).replace(" ", ""))
	var alert = _read_file(alert_file_path).replace(" ", "")
	
	if alert != "":
		EVENTS.emit_signal("alert", alert)


func _on_OBS_scene_changed(scene_name: String) -> void:
	_empty_file(scene_file_path)
	main_scene_overlay.set_visible(scene_name == "Main")
	print("scene changed: %s" % scene_name)
