extends Control
class_name GoalsBars

onready var follower_gauge = $Followers/Gauge
onready var subs_gauge = $Subs/Gauge


#### ACCESSORS ####

func is_class(value: String): return value == "GoalsBars" or .is_class(value)
func get_class() -> String: return "GoalsBars"


#### BUILT-IN ####

func _ready() -> void:
	var __ = GOALS.connect("count_changed", self, "_on_GOALS_count_changed")
	__ = GOALS.connect("goal_changed", self, "_on_GOALS_goal_changed")
	
	for section in GOALS.goals_dict.keys():
		_on_GOALS_goal_changed(section, GOALS.current_goals[section])
		_update_counter(section)


#### VIRTUALS ####


#### LOGIC ####


func _update_counter(counter_name: String) -> void:
	var goal_type_name = counter_name.capitalize()
	
	var current_goal = GOALS.current_goals[counter_name]
	var previous_goal_value : int = 1
	
	if current_goal.id > 0:
		previous_goal_value = GOALS.get_goal_value_by_id(counter_name, current_goal.id - 1)
	
	var current_value = GOALS.counters_dict[counter_name]
	var current_goal_value = current_goal.goal
	var ratio = float(current_value - previous_goal_value) / float(current_goal_value - previous_goal_value)
	
	var gauge = get_node(goal_type_name + "/Gauge")
	gauge.set_as_ratio(ratio)
	
	var counter_label = get_node(goal_type_name + "/Header/CounterLabel")
	counter_label.set_text(String(current_value) + "/" + String(current_goal_value))


#### INPUTS ####



#### SIGNAL RESPONSES ####


func _on_GOALS_goal_changed(goal_type: String, new_goal) -> void:
	var gauge = get_node(goal_type.capitalize() + "/Gauge")
	gauge.set_goal_text(new_goal.body)


func _on_GOALS_count_changed(count_type: String) -> void:
	_update_counter(count_type)
