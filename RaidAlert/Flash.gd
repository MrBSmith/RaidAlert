extends Node2D
class_name Flash

onready var color_rect = $ColorRect
onready var tween = $Tween

export var flash_color := Color.red

export var flash_duration : float = 1.0
export var nb_flash : int = 3

signal flash_finished

#### ACCESSORS ####

func is_class(value: String): return value == "Alert" or .is_class(value)
func get_class() -> String: return "Alert"


#### BUILT-IN ####

func _ready() -> void:
	color_rect.set_size(GAME.screen_size)
	color_rect.set_frame_color(flash_color)
	color_rect.color.a = 0.0


#### VIRTUALS ####



#### LOGIC ####

func flash():
	for _i in range(nb_flash):
		for j in range(2):
			var from = 0.0 if j == 0 else flash_color.a
			var to = flash_color.a if j == 0 else 0.0
			tween.interpolate_property(color_rect, "color:a", from, to, 
						flash_duration / 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			
			tween.start()
			yield(tween, "tween_all_completed")
	
	emit_signal("flash_finished")

#### INPUTS ####



#### SIGNAL RESPONSES ####
