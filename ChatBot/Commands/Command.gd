extends Node
class_name Command

enum ROLE {
	NONE,
	FOLLOWER,
	SUSCRIBER,
	VIP,
	BROADCASTER
}

export var command : String = ""
export var aliases : PoolStringArray = []
export var users : PoolStringArray = []
export var alert : String = ""

export(ROLE) var role : int = ROLE.NONE

#### ACCESSORS ####

func is_class(value: String): return value == "Command" or .is_class(value)
func get_class() -> String: return "Command"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func get_command_keywords() -> PoolStringArray:
	var keywords = aliases if aliases != null else PoolStringArray()
	keywords.push_back(command)
	return keywords


func trigger() -> void:
	if alert != "":
		EVENTS.emit_signal("alert", alert)
	else:
		push_warning("The command %s has been triggered but has no effect" % name)


func is_user_valid(sender_data: SenderData) -> bool:
	if users.empty():
		return true
	else:
		for user in users:
			if user.matchn(sender_data.user):
				return true
	return false


#### INPUTS ####



#### SIGNAL RESPONSES ####
