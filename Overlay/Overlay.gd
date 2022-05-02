extends Control
class_name Overlay

onready var timer = $Timer
onready var main_scene = $MainScene
onready var panel = $Panel
onready var tv = $TV

var scene_file_path = "D:/StreamDeck/StreamLabels/scenes.txt"
var alert_file_path = "D:/StreamDeck/StreamLabels/alerts.txt"

var current_scene = "WaitingScreen" setget set_current_scene

#### ACCESSORS ####

func is_class(value: String): return value == "Overlay" or .is_class(value)
func get_class() -> String: return "Overlay"

func set_current_scene(value: String):
	if value != current_scene && value != "":
		var previous_scene = current_scene
		current_scene = value
		EVENTS.emit_signal("OBS_scene_changed", previous_scene, current_scene)

#### BUILT-IN ####

func _ready() -> void: 
	var __ = timer.connect("timeout", self, "_on_timer_timeout")
	__ = EVENTS.connect("OBS_scene_changed", self, "_on_OBS_scene_changed")
	
	_empty_file(scene_file_path)
	_empty_file(alert_file_path)
	_on_OBS_scene_changed("Main", "WaitingScreen")


#### VIRTUALS ####



#### LOGIC ####


func _empty_file(path: String) -> void:
	var file = File.new()
	file.open(path, File.WRITE)
	file.close()


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_timer_timeout() -> void:
	set_current_scene(DirNavHelper.read_file_line(scene_file_path).replace(" ", ""))
	var alert = DirNavHelper.read_file_line(alert_file_path).replace(" ", "")
	
	if alert != "":
		_empty_file(alert_file_path)
		EVENTS.emit_signal("alert", alert)


func _on_OBS_scene_changed(previous_scene: String, scene_name: String) -> void:
	_empty_file(scene_file_path)
	
	var logo_transition = previous_scene == "WaitingScreen" or scene_name == "EndingScreen"
	var delay = 1.0 if logo_transition else 0.0 
	
	# TV appear/disappear animation
	if scene_name in ["Main", "Pause", "FullScreen"]:
		if tv.hidden:
			tv.appear()
	
	elif !tv.hidden:
		tv.disappear()
	
	# FullScreen scene
	var full_screen = (scene_name == "FullScreen")
	var facecam = scene_name == "FaceCam"
	$Foreground.set_visible(!full_screen)
	$Spotify.set_visible(!full_screen && !facecam)
	
	# Main scene animation
	if scene_name == "Main":
		main_scene.appear_animation(true, logo_transition, delay)
		$Goals.appear_animation(true, logo_transition)
	
	elif previous_scene == "Main":
		main_scene.appear_animation(false, logo_transition, delay)
		$Goals.appear_animation(false, logo_transition)
		
		if !logo_transition:
			yield(get_tree().create_timer(1.0), "timeout")
	
	# Panel animation
	if scene_name in ["WaitingScreen", "EndingScreen", "Pause"]:
		panel.set_offseted(scene_name == "Pause")
		panel.appear_animation(true, logo_transition, delay)
	
	elif previous_scene in ["WaitingScreen", "EndingScreen", "Pause"]:
		panel.appear_animation(false, logo_transition, delay)
	
	if "Pause" in [scene_name, previous_scene]:
		tv.zap(1.0)
	
	if logo_transition:
		$LogoTransition.set_frame(0)
		$LogoTransition.play("default")
