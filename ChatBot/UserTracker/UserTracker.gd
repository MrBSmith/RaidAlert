extends Node
class_name UserTracker

var user_name : String = "" setget set_user_name, get_user_name
var user_role : String = "" setget set_user_role, get_user_role

var messages := Array()

var logs : bool = true 

signal first_message()

class Message:
	var message : String = ""
	var timecode : Dictionary = {}
	
	func _init(m: String, time: Dictionary) -> void:
		message = m
		timecode = time
	

#### ACCESSORS ####

func is_class(value: String): return value == "UserTracker" or .is_class(value)
func get_class() -> String: return "UserTracker"

func set_user_name(value: String): user_name = value
func get_user_name() -> String: return user_name

func set_user_role(value: String): user_role = value
func get_user_role() -> String: return user_role

#### BUILT-IN ####


func _init(_user_name: String, _user_role: String) -> void:
	set_user_name(_user_name)
	set_user_role(_user_role)


func _ready() -> void:
	if logs:
		print("user tracker added for %s, role: %s" % [user_name, user_role])


#### VIRTUALS ####



#### LOGIC ####

func add_message(message: String) -> void:
	messages.append(Message.new(message, OS.get_time()))
	
	if messages.size() == 1:
		emit_signal("first_message")


func get_last_message() -> String:
	if messages.size() > 0:
		return messages[-1]
	else:
		return ""


func get_time_since_last_message() -> Dictionary:
	if messages.empty():
		return {}
	
	var current_time = OS.get_time()
	var last_message_time = messages[-1].timecode
	var past_time = {}
	
	for i in range(current_time.keys()):
		var key = current_time.keys()[i]
		past_time[key] = current_time[key] - last_message_time[key]
		
		if past_time[key] < 0.0 && i > 0:
			var previous_key = current_time.keys()[i - 1]
			past_time[previous_key] -= 1.0 
			past_time[key] += 60.0
	
	return past_time



#### INPUTS ####



#### SIGNAL RESPONSES ####
