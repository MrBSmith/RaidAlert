extends Node2D
class_name BabyBot

onready var idle = $Idle
onready var dance = $Dance

#### ACCESSORS ####

func is_class(value: String): return value == "BabyBot" or .is_class(value)
func get_class() -> String: return "BabyBot"


#### BUILT-IN ####

func _ready() -> void:
	var __ = EVENTS.connect("alert", self, "_on_alert_event")
	__ = dance.connect("animation_finished", self, "_on_animation_finished")



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_alert_event(alert: String) -> void:
	if alert == "babybot_dance" && !dance.is_playing():
		idle.set_visible(false)
		dance.set_visible(true)
		dance.play()


func _on_animation_finished() -> void:
	idle.set_visible(true)
	dance.set_visible(false)
	dance.stop()
	dance.set_frame(0)
