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
export var alert : String = ""
export var cooldown : float = 0.0
export var aliases : PoolStringArray = []
export var users : PoolStringArray = []

export(ROLE) var role : int = ROLE.NONE


onready var cooldown_timer := Timer.new()

#### ACCESSORS ####

func is_class(value: String): return value == "Command" or .is_class(value)
func get_class() -> String: return "Command"


#### BUILT-IN ####


func _ready() -> void:
	cooldown_timer.set_autostart(false)
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)
	cooldown_timer.stop()


#### VIRTUALS ####



#### LOGIC ####

func _is_cooldown_running() -> bool:
	return !cooldown_timer.is_paused() && !cooldown_timer.is_stopped()

func get_command_keywords() -> PoolStringArray:
	var keywords = aliases if aliases != null else PoolStringArray()
	keywords.push_back(command)
	return keywords


func trigger() -> void:
	if _is_cooldown_running():
		return
	
	if alert != "":
		cooldown_timer.start()
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
