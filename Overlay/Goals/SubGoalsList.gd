extends NinePatchRect
class_name SubGoals

var goal_line_scene = preload("res://Overlay/Goals/GoalListLine.tscn")

onready var goals_container = $VBoxContainer

#### ACCESSORS ####

func is_class(value: String): return value == "SubGoals" or .is_class(value)
func get_class() -> String: return "SubGoals"


#### BUILT-IN ####

func _ready() -> void:
	var __ = GOALS.connect("goal_reached", self, "_on_GOALS_goal_reached")
	
	_create_goals()

#### VIRTUALS ####



#### LOGIC ####

func _create_goals() -> void:
	for type in GOALS.goals_dict.keys():
		if type != "subs":
			continue
		
		for goal in GOALS.goals_dict[type].keys():
			var value = GOALS.get_goal_value(type, goal)
			var goal_line = goal_line_scene.instance()
			goals_container.call_deferred("add_child", goal_line)
			
			yield(goal_line, "ready")
			
			goal_line.set_name(goal)
			goal_line.get_node("GoalTitle").set_text(goal)
			goal_line.get_node("GoalValue").set_text(str(value))


func _mark_goal_as_reached(goal: String) -> void:
	for goal_line in goals_container.get_children():
		if goal_line.name == goal:
			var left_point = goal_line.rect_position + goal_line.rect_size / 2 * Vector2.DOWN
			var right_point = goal_line.rect_position + Vector2(goal_line.rect_size.x, goal_line.rect_size.y / 2)
			
			goal_line.get_node("Line2D").set_points([left_point, right_point])


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_GOALS_goal_reached(goal_type: String, goal) -> void:
	if goal_type == "subs":
		_mark_goal_as_reached(goal.body)
