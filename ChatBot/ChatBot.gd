extends Node
class_name ChatBot

onready var user_tracker_list = $UserTrackerList
onready var commands = $Commands

export var users_to_track := PoolStringArray()
export var message_alert_dict : Dictionary = {}

#### ACCESSORS ####

func is_class(value: String): return value == "ChatBot" or .is_class(value)
func get_class() -> String: return "ChatBot"


#### BUILT-IN ####

func _ready() -> void:
	var __ = connect("alert", self, "_on_EVENTS_alert")


#### VIRTUALS ####



#### LOGIC ####

func _is_user_tracked(user_name: String) -> bool:
	for child in user_tracker_list.get_children():
		if child.get_user_name() == user_name:
			return true
	return false


func _get_user_tracker(user_name: String) -> UserTracker:
	for child in user_tracker_list.get_children():
		if child.get_user_name() == user_name:
			return child
	return null


func is_user_in_users_to_track(user_name: String) -> bool:
	for user in users_to_track:
		if user.to_lower() == user_name.to_lower():
			return true
	return false


func _trigger_user_tracker(sender_data: SenderData, message: String) -> void:
	var user = "" if sender_data == null else sender_data.user
	
	if !is_user_in_users_to_track(user):
		return
	
	var user_tracker = _get_user_tracker(user)
	
	if user_tracker == null:
		user_tracker = UserTracker.new(user, sender_data.tags["user-type"])
		user_tracker_list.add_child(user_tracker)
		
		for event in $Events.get_children():
			user_tracker.connect("first_message", event, "_on_chat_event", 
						[user_tracker, "first_message"])
	
	user_tracker.add_message(message)


func _trigger_commands(sender_data: SenderData, message: String) -> void:
	for command in commands.get_children():
		for keyword in command.get_command_keywords():
			if keyword in message:
				if command.is_user_valid(sender_data):
					command.trigger()



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_chat_message(sender_data: SenderData, message: String) -> void:
	_trigger_user_tracker(sender_data, message)
	_trigger_commands(sender_data, message)


func _on_EVENTS_alert(alert: String) -> void:
	pass
