extends TextureRect
class_name TV

onready var tween = $Tween
onready var default_position = get_position()

var hidden : bool = false

signal animation_finshed()

#### ACCESSORS ####

func is_class(value: String): return value == "TV" or .is_class(value)
func get_class() -> String: return "TV"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func appear() -> void:
	rect_position.x = default_position.x
	
	tween.interpolate_property(self, "rect_position:y", default_position.y - 400, 
					default_position.y, 1.0, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	hidden = false
	
	yield(tween, "tween_all_completed")
	emit_signal("animation_finshed")


func disappear() -> void:
	tween.interpolate_property(self, "rect_position", rect_position, 
						default_position + Vector2(100.0, 150.0), 
						0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	hidden = true
	
	yield(tween, "tween_all_completed")
	emit_signal("animation_finshed")



#### INPUTS ####



#### SIGNAL RESPONSES ####
