extends Node

onready var timer = Timer.new()

export var goals_cfg_file_path = "D:/StreamDeck/StreamLabels/goals.cfg"

var counters_dict := Dictionary()
var current_goals := Dictionary() 
var goals_dict := Dictionary()

var counter_file_path_dict : Dictionary = {
	"followers" : "D:/StreamDeck/StreamLabels/total_follower_count.txt",
	"subs" : "D:/StreamDeck/StreamLabels/total_subscriber_count.txt"
}

class Goal:
	var body : String = ""
	var goal : int = 0
	var id : int = 0
	
	func _init(_goal: int, _body: String, _id) -> void:
		goal = _goal
		body = _body
		id = _id

signal count_changed(counter_name)
signal goal_reached(goal_type, goal)
signal goal_changed(goal_type, new_goal)

#### ACCESSORS ####


#### BUILT-IN ####

func _ready() -> void:
	var __ = timer.connect("timeout", self, "_on_timer_timeout")
	__ = connect("count_changed", self, "_on_count_changed")
	
	add_child(timer)
	timer.set_wait_time(0.5)
	timer.start()
	
	_fetch_goals()
	_fetch_counter_files(true)

	for section in GOALS.goals_dict.keys():
		GOALS.current_goals[section] = find_next_goal(section)


#### VIRTUALS ####



#### LOGIC ####

func _fetch_goals() -> void:
	var config_file = ConfigFile.new()
	config_file.load(goals_cfg_file_path)
	var sections_array = config_file.get_sections()
	
	goals_dict = {}
	
	for section in sections_array:
		goals_dict[section] = {}
		for key in config_file.get_section_keys(section):
			var value = config_file.get_value(section, key)
			goals_dict[section][key] = value


func _set_count(key: String, value: int, init: bool = false) -> void:
	if key in counters_dict.keys() or init:
		counters_dict[key] = value
		if !init:
			emit_signal("count_changed", key)
	else:
		push_warning("key %s not found in counters_dict, can't set the value")


func _fetch_counter_files(init: bool = false) -> void:
	for key in counter_file_path_dict.keys():
		_set_count(key, _read_count_file(counter_file_path_dict[key]), init)


func find_next_goal(goal_key: String) -> Goal:
	var keys_array = goals_dict[goal_key].keys()
	var nb_keys = keys_array.size()
	
	for i in range(nb_keys):
		var key = keys_array[i]
		var value = goals_dict[goal_key][key]
		
		if counters_dict[goal_key] < value or i == nb_keys - 1:
			return Goal.new(value, key, i)
	return null


func get_goal_value(goal_type_name: String, goal_key: String) -> int:
	return goals_dict[goal_type_name.to_lower()][goal_key]


func get_goal_value_by_id(goal_type_name: String, id: int) -> int:
	var goal_value_dict = goals_dict[goal_type_name.to_lower()]
	return goal_value_dict.values()[id]


func _read_count_file(path: String) -> int:
	var file := File.new()
	var error = file.open(path, File.READ)
	
	if error == OK:
		var text = file.get_as_text()
		file.close()
		return int(text)
	else:
		push_error("file couldn't be opend at path: %s, error code %d" % [path, error])
		return 0



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_timer_timeout() -> void:
	_fetch_counter_files()


func _on_count_changed(goal_type: String) -> void:
	var current_goal = current_goals[goal_type]
	var goal_value = current_goal.goal
	
	if counters_dict[goal_type] >= goal_value:
		emit_signal("goal_reached", goal_type, current_goal)
		var new_goal = find_next_goal(goal_type)
		current_goals[goal_type] = new_goal
		emit_signal("goal_changed", goal_type, new_goal)
