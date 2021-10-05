extends Control
class_name Goals

onready var timer = $Timer
onready var follower_gauge = $Followers/Gauge
onready var subs_gauge = $Subs/Gauge

export var goals_cfg_file_path = "D:/StreamDeck/StreamLabels/goals.cfg"

var counter_file_path_dict : Dictionary = {
	"followers" : "D:/StreamDeck/StreamLabels/total_follower_count.txt",
	"subs" : "D:/StreamDeck/StreamLabels/total_subscriber_count.txt"
}

var counters_dict := Dictionary()
var goals_dict := Dictionary() 
var current_goals := Dictionary() 

class Goal:
	var body : String = ""
	var goal : int = 0
	var id : int = 0
	
	func _init(_goal: int, _body: String, _id) -> void:
		goal = _goal
		body = _body
		id = _id

signal count_changed(counter_name)
signal goal_changed(goal_type, new_goal)

#### ACCESSORS ####

func is_class(value: String): return value == "Goals" or .is_class(value)
func get_class() -> String: return "Goals"


#### BUILT-IN ####

func _ready() -> void:
	var __ = timer.connect("timeout", self, "_on_timer_timeout")
	__ = connect("count_changed", self, "_on_count_changed")
	__ = connect("goal_changed", self, "_on_goal_changed")
	
	__ = EVENTS.connect("alert", self, "_on_alert")
	
	_fetch_counter_files(true)
	_fetch_goals()
	
	for section in goals_dict.keys():
		current_goals[section] = _find_next_goal(section)
		_on_goal_changed(section, current_goals[section])
		_update_counter(section)


#### VIRTUALS ####


#### LOGIC ####

func _set_count(key: String, value: int, init: bool = false) -> void:
	if key in counters_dict.keys() or init:
		counters_dict[key] = value
		if !init:
			emit_signal("count_changed", key)
	else:
		push_warning("key %s not found in counters_dict, can't set the value")


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


func _fetch_counter_files(init: bool = false) -> void:
	for key in counter_file_path_dict.keys():
		_set_count(key, _read_count_file(counter_file_path_dict[key]), init)


func _find_next_goal(goal_key: String) -> Goal:
	var keys_array = goals_dict[goal_key].keys()
	var nb_keys = keys_array.size()
	
	for i in range(nb_keys):
		var key = keys_array[i]
		var value = goals_dict[goal_key][key]
		
		if counters_dict[goal_key] < value or i == nb_keys - 1:
			return Goal.new(value, key, i)
	return null


func _get_goal_value(goal_type_name: String, goal_key: String) -> int:
	return goals_dict[goal_type_name.to_lower()][goal_key]


func _get_goal_value_by_id(goal_type_name: String, id: int) -> int:
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


func _update_counter(counter_name: String) -> void:
	var goal_type_name = counter_name.capitalize()
	
	var current_goal = current_goals[counter_name]
	var previous_goal_value : int = 1
	
	if current_goal.id > 0:
		previous_goal_value = _get_goal_value_by_id(counter_name, current_goal.id - 1)
	
	var current_value = counters_dict[counter_name]
	var current_goal_value = current_goal.goal
	var ratio = float(current_value - previous_goal_value) / float(current_goal_value - previous_goal_value)
	
	var gauge = get_node(goal_type_name + "/Gauge")
	gauge.set_as_ratio(ratio)
	
	var counter_label = get_node(goal_type_name + "/Header/CounterLabel")
	counter_label.set_text(String(current_value) + "/" + String(current_goal_value))


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_timer_timeout() -> void:
	_fetch_counter_files()


func _on_count_changed(count_type: String) -> void:
	var current_goal = current_goals[count_type]
	var goal_value = current_goal.goal
	_update_counter(count_type)
	
	if counters_dict[count_type] >= goal_value:
		var new_goal = _find_next_goal(count_type)
		current_goals[count_type] = new_goal
		emit_signal("goal_changed", count_type, new_goal)


func _on_goal_changed(goal_type: String, new_goal: Goal) -> void:
	var gauge = get_node(goal_type.capitalize() + "/Gauge")
	gauge.set_goal_text(new_goal.body)


func _on_alert(_alert: String) -> void:
	pass

