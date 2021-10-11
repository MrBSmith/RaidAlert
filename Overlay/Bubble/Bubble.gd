extends NinePatchRect
class_name Bubble

onready var starting_pos = get_position()
onready var starting_size = get_size()
onready var tween = $Tween
onready var rich_text_label = $RichTextLabel

export var opened_size := Vector2(175, 39)
export var message = "Merci pour ton follow [color=red]%s[/color], bienvenue dans les bois!"

signal animation_finished(open)

#### ACCESSORS ####

func is_class(value: String): return value == "Bubble" or .is_class(value)
func get_class() -> String: return "Bubble"


#### BUILT-IN ####


#### VIRTUALS ####



#### LOGIC ####

func appear(open: bool = true) -> void:
	var size_property = "rect_min_size" if open else "rect_size"
	var a_from = 0.0 if open else 1.0
	var a_to = 1.0 if open else 0.0
	var size_from = starting_size if open else opened_size
	var size_to = opened_size if open else starting_size
	var bubble_size_delay = 0.0 if open else 1.0
	var bubble_mod_delay = 0.0 if open else 0.5
	var content_delay = 1.0 if open else 0.0
	
	if open:
		rich_text_label.set_modulate(Color.transparent)
	else:
		rect_min_size = starting_size
	
	var __ = tween.interpolate_property(self, "modulate:a", a_from, a_to, 0.5, 
									Tween.TRANS_CUBIC,Tween.EASE_IN_OUT, bubble_mod_delay)
	
	__ = tween.interpolate_property(self, size_property, size_from, size_to, 1.0, 
									Tween.TRANS_CUBIC,Tween.EASE_IN_OUT, bubble_size_delay)
	
	if !open:
		__ = tween.interpolate_property(self, "rect_position", get_position(), starting_pos, 1.0, 
									Tween.TRANS_CUBIC,Tween.EASE_IN_OUT, bubble_size_delay)
	
	__ = tween.interpolate_property(rich_text_label, "modulate:a", a_from, a_to, 1.0, 
									Tween.TRANS_CUBIC,Tween.EASE_IN_OUT, content_delay)
	
	tween.start()
	
	yield(tween, "tween_all_completed")
	emit_signal("animation_finished", open)


func is_playing() -> bool:
	return tween.is_active()

#### INPUTS ####



#### SIGNAL RESPONSES ####


