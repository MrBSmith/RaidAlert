extends Node2D
class_name AnimalsAlert

onready var alert = $Alert
onready var spawner = $Spawner

func is_class(value: String) -> bool: return value == "RaidAlert" or .is_class(value)
func get_class() -> String: return "RaidAlert"


func _ready() -> void:
	var __ = EVENTS.connect("raid", self, "_on_raid")
	__ = EVENTS.connect("new_follower", self, "_on_new_follower")
	randomize()


func _on_raid(streamer_name: String, nb_raiders: int) -> void:
	alert.trigger_alert(streamer_name, nb_raiders)
	yield(alert, "raid_alert_finished")
	
	spawner.spawn_animals(nb_raiders, "raid")


func _on_new_follower(_follower_name: String) -> void:
	spawner.spawn_animals(1, "follow")
