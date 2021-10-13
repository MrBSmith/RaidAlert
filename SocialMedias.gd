extends TextureRect
class_name SocialMedia

onready var tween = $Tween
onready var starting_pos = get_position()

#### ACCESSORS ####

func is_class(value: String): return value == "SocialMedia" or .is_class(value)
func get_class() -> String: return "SocialMedia"


#### BUILT-IN ####

func _ready() -> void:
	var __ = EVENTS.connect("OBS_scene_changed", self, "_on_OBS_scene_changed")


#### VIRTUALS ####



#### LOGIC ####

func _appear() -> void:
	var __ = tween.interpolate_property(self, "rect_position:x", starting_pos.x - 150,
			starting_pos.x, 1.0, Tween.TRANS_BACK, Tween.EASE_OUT, 1.5)
	
	tween.start()


func _disappear() -> void:
	var __ = tween.interpolate_property(self, "rect_position:x", starting_pos.x,
	starting_pos.x - 150, 1.0, Tween.TRANS_BACK, Tween.EASE_OUT)
	
	tween.start()

#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_OBS_scene_changed(previous_scene: String, next_scene: String) -> void:
	if previous_scene == "Main":
		if get_position() != starting_pos:
			_appear()
	elif next_scene == "Main":
		_disappear()
