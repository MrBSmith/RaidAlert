extends TextureRect
class_name StreamPanel

onready var tween = $Tween
onready var content = $CenterContainer/Content
onready var timer_label = $CenterContainer/Content/TimerLabel

onready var initial_pos = rect_position

var panel_scene_array = ["WaitingScreen", "EndingScreen", "Pause"]


#### ACCESSORS ####

func is_class(value: String): return value == "StreamPanel" or .is_class(value)
func get_class() -> String: return "StreamPanel"



#### BUILT-IN ####

func _ready() -> void:
	var __ = EVENTS.connect("OBS_scene_changed", self, "_on_OBS_scene_changed")


#### VIRTUALS ####



#### LOGIC ####

func appear_animation(appear: bool = true) -> void:
	var from = -rect_size.y if appear else initial_pos.y
	var to = initial_pos.y if appear else -rect_size.y
	var trans_type = Tween.TRANS_BOUNCE if appear else Tween.TRANS_LINEAR
	var ease_type = Tween.EASE_OUT if appear else Tween.EASE_IN
	var dur = 1.0 if appear else 0.5
	
	var __ = tween.interpolate_property(self, "rect_position:y", from, to, dur, 
									trans_type, ease_type)
	
	__ = tween.start()


func set_offseted(value: bool) -> void:
	if initial_pos == Vector2.ZERO:
		yield(self, "ready")
	
	rect_position.x = initial_pos.x - (40.0 * int(value))


#### INPUTS ####




#### SIGNAL RESPONSES ####

func _on_OBS_scene_changed(_previous_scene: String, next_scene: String) -> void:
	if not next_scene in panel_scene_array:
		return
	
	for child in content.get_children():
		child.set_visible(child.name == next_scene)
	
	timer_label.set_visible(next_scene in ["WaitingScreen", "Pause"])

