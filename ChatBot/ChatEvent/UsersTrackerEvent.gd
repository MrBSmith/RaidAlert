extends ChatEvent
class_name UserTrackerEvent

onready var chat_bot = get_parent().get_parent()

export var time_interval_dict := {"hour": 0, "minute": 2, "seconde": 0}

#### ACCESSORS ####

func is_class(value: String): return value == "UserTrackerEvent" or .is_class(value)
func get_class() -> String: return "UserTrackerEvent"


#### BUILT-IN ####



#### VIRTUALS ####

## FUNCTION OVERRIDE ##
func _condition(user_tracker: UserTracker) -> bool:
	var user = user_tracker.user_name
	
	for tracked_user in requirement["user_name"]:
		if tracked_user.to_lower() == user:
			continue
		
		var tracker = chat_bot.get_user_tracker(tracked_user)
		if tracker == null:
			return false
		
		var time_since_last_message = tracker.get_time_since_last_message()
		
		if Utils.compare_times(time_since_last_message, time_interval_dict) != OP_LESS:
			return false
	
	return true


#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
