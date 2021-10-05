extends Node
class_name ChatEvent

export var condition : String = ""

export var requirement : Dictionary = {
	"user_name": "",
	"user_role": ""
}

export var keyword : String = ""

#### ACCESSORS ####

func is_class(value: String): return value == "ChatEvent" or .is_class(value)
func get_class() -> String: return "ChatEvent"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func trigger() -> void:
	for child in get_children():
		if child.has_method("play"):
			child.play()


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_chat_event(user_tracker: UserTracker, signal_name: String) -> void:
	if condition != signal_name:
		return
	
	if keyword != "" && !keyword.is_subsequence_ofi(user_tracker.get_last_message()):
		return
	
	for key in requirement.keys():
		var value = requirement[key]
		if value != "" && value.to_lower() != user_tracker.get(key).to_lower():
			return
	
	trigger()
