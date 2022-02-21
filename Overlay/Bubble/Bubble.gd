extends RichTextLabel
class_name Bubble

onready var tween = $Tween
onready var nine_patch_rect = $NinePatchRect

var playing := false

signal animation_finished(open)

#### ACCESSORS ####

func is_class(value: String): return value == "Bubble" or .is_class(value)
func get_class() -> String: return "Bubble"


#### BUILT-IN ####


#### VIRTUALS ####



#### LOGIC ####

func appear(open: bool = true) -> void:
	tween.remove_all()
	
	var a_from = 0.0 if open else 1.0
	var a_to = 1.0 if open else 0.0
	
	playing = true
	
	var __ = tween.interpolate_property(self, "modulate:a", a_from, a_to, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()

	yield(tween, "tween_all_completed")
	
	playing = false
	emit_signal("animation_finished", open)


func is_playing() -> bool:
	return playing


#### INPUTS ####



#### SIGNAL RESPONSES ####


