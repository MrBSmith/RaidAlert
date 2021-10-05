extends Node2D
class_name RaidAnnouncement

onready var message_container = $MessageContainer
onready var channel_name_label = $MessageContainer/Control/ChannelTitleLabel
onready var nb_raiders_label = $MessageContainer/Control/NbRaidersLabel
onready var tween = $Tween

onready var starting_pos = message_container.get_position()

export var title_message =  "%s lance un raid!!"
export var sub_message =  "%d fourmis sont parachutées dans les bois!!"

var move_offset = Vector2(-640, 95)

signal announcement_finished

#### ACCESSORS ####

func is_class(value: String): return value == "RaidAnnouncement" or .is_class(value)
func get_class() -> String: return "RaidAnnouncement"


#### BUILT-IN ####

func announcement(channel : String, nb_raiders: int) -> void:
	channel_name_label.set_text(title_message % channel)
	nb_raiders_label.set_text(sub_message % nb_raiders)
	message_container.set_position(starting_pos)
	
	for i in range(2):
		var current_pos = message_container.get_position()
		tween.interpolate_property(message_container, "position", current_pos, 
			current_pos + move_offset, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
		tween.start()
		yield(tween, "tween_all_completed")
		if i == 0:
			yield(get_tree().create_timer(2.0), "timeout")
	
	emit_signal("announcement_finished")

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
