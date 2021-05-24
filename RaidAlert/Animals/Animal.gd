extends Node2D
class_name Animal

onready var tween = $Tween
onready var visibility_notifier = $VisibilityNotifier2D

onready var initial_pos = get_position()

onready var vertical_movement_duration : float = rand_range(6.0, 8.0)
onready var horizontal_movement_duration : float = rand_range(0.8, 1.2)
onready var lateral_amplitude = rand_range(10.0, 60.0) * Math.rand_sign()
onready var sprite_size = $Sprite.get_texture().get_size()


export var rotation_amplitude : float = 25.0 


#### ACCESSORS ####

func is_class(value: String): return value == "Animal" or .is_class(value)
func get_class() -> String: return "Animal"


#### BUILT-IN ####

func _ready() -> void:
	var __ = tween.connect("tween_completed", self, "_on_tween_completed")
	visibility_notifier.set_rect(Rect2(Vector2.ZERO, sprite_size))
	
	__ = visibility_notifier.connect("screen_exited", self, "_on_screen_exited")
	
	trigger_vertical_movement()
	trigger_horizontal_movement()



#### VIRTUALS ####



#### LOGIC ####


func trigger_vertical_movement() -> void:
	var __ = tween.interpolate_property(self, "position:y", initial_pos.y, 
		GAME.screen_size.y + sprite_size.y * 1.5, vertical_movement_duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.start()


func trigger_horizontal_movement() -> void:
	lateral_amplitude *= -1
	var pos = get_position()
	
	var __ = tween.interpolate_property(self, "position:x", pos.x, 
		initial_pos.x + lateral_amplitude, horizontal_movement_duration,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	
	__ = tween.interpolate_property(self, "rotation_degrees", get_rotation_degrees(),
		rotation_amplitude * -sign(lateral_amplitude), horizontal_movement_duration,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	
	tween.start()

#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_tween_completed(_obj: Object, key: NodePath) -> void:
	if key.get_subname_count() > 1:
		var axis_name = key.get_subname(1)
		if axis_name == "x":
			trigger_horizontal_movement()


func _on_screen_exited() -> void:
	if position.y > GAME.screen_size.y:
		queue_free()
