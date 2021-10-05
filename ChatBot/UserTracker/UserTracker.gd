extends Node
class_name UserTracker

var user_name : String = "" setget set_user_name, get_user_name
var user_role : String = "" setget set_user_role, get_user_role

var messages := PoolStringArray()

var logs : bool = true 

signal first_message()

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
	messages.append(message)
	
	if messages.size() == 1:
		emit_signal("first_message")


func get_last_message() -> String:
	if messages.size() > 0:
		return messages[-1]
	else:
		return ""


#### INPUTS ####



#### SIGNAL RESPONSES ####
