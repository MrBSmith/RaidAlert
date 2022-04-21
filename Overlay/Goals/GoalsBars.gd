extends Control
class_name GoalsBars

onready var tween = $Tween

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


func appear_animation(appear: bool = true, instant: bool = false) -> void:
	var ease_type = Tween.EASE_OUT if appear else Tween.EASE_IN
	var from = 50.0 if appear else 0.0
	var to = 0.0 if appear else 50.0
	var dur = 0.8 if !instant else 0.0
	var delay = 1.2 if appear and !instant else 0.0
	
	for child in get_children():
		if child is Control:
			child.rect_position.y = from
	
	if delay != 0.0:
		yield(get_tree().create_timer(delay), "timeout")
	
	for i in range(get_child_count()):
		var child = get_child(i)
		
		if not child is Control:
			continue
		
		var __ = tween.interpolate_property(child, "rect_position:y", from, to, 
						dur, Tween.TRANS_BACK, ease_type, i * 0.3)
	
	var __ = tween.start()


#### INPUTS ####



#### SIGNAL RESPONSES ####


func _on_GOALS_goal_changed(goal_type: String, new_goal) -> void:
	var gauge = get_node(goal_type.capitalize() + "/Gauge")
	gauge.set_goal_text(new_goal.body)


func _on_GOALS_count_changed(count_type: String) -> void:
	_update_counter(count_type)
