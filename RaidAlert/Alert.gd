extends Node2D
class_name Alert

onready var flash_node = $Flash
onready var announcement_node = $Announcement
onready var audio_stream_player = $AudioStreamPlayer

signal raid_alert_finished

#### ACCESSORS ####

func is_class(value: String): return value == "Alert" or .is_class(value)
func get_class() -> String: return "Alert"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func trigger_alert(channel_name : String, nb_raiders: int) -> void:
#	flash_node.flash()
	announcement_node.announcement(channel_name, nb_raiders)
	trigger_sound()
	
	yield(announcement_node, "announcement_finished")
	emit_signal("raid_alert_finished")


func trigger_sound():
	for _i in range(3):
		audio_stream_player.play()
		yield(audio_stream_player, "finished")
	
	audio_stream_player.stop()

#### INPUTS ####



#### SIGNAL RESPONSES ####
