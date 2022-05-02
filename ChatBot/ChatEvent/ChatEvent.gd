extends Node
class_name ChatEvent

export var condition : String = ""
export var oneshot : bool = false

export var requirement : Dictionary = {
	"user_name": [],
	"user_role": []
}

export var alert_event : String = ""

export var keyword : String = ""

#### ACCESSORS ####

func is_class(value: String): return value == "ChatEvent" or .is_class(value)
func get_class() -> String: return "ChatEvent"


#### BUILT-IN ####



#### VIRTUALS ####

func _condition(_user_tracker: UserTracker) -> bool:
	return true


#### LOGIC ####

func trigger() -> void:
	for child in get_children():
		if child.has_method("play"):
			child.play()
	
	if alert_event != "":
		EVENTS.emit_signal("alert", alert_event)
	
	if oneshot:
		queue_free()


func _are_all_requirements_fulfilled(user_tracker: UserTracker) -> bool:
	for key in requirement.keys():
		var requirement_array = requirement[key]
		var lower_req_array = PoolStringArray()
		
		for req in requirement_array:
			lower_req_array.append(req.to_lower())
		
		var user_value = user_tracker.get(key).to_lower()
		
		if !requirement_array.empty() && not user_value in lower_req_array:
			return false
	
	return true



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_chat_event(user_tracker: UserTracker, signal_name: String) -> void:
	if condition != signal_name:
		return
	
	if keyword != "" && !keyword.is_subsequence_ofi(user_tracker.get_last_message()):
		return
	
	if !_are_all_requirements_fulfilled(user_tracker) or !_condition(user_tracker):
		return
	
	trigger()
