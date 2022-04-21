extends Control
class_name SubGoals

var goal_line_scene = preload("res://Overlay/Goals/GoalListLine.tscn")

var mouse_inside : bool = false
var is_dragged : bool = false

var grab_offset := Vector2.ZERO

onready var goals_container = $VBoxContainer/NinePatchRect/VBoxContainer

#### ACCESSORS ####

func is_class(value: String): return value == "SubGoals" or .is_class(value)
func get_class() -> String: return "SubGoals"


#### BUILT-IN ####

func _ready() -> void:
	var __ = GOALS.connect("goal_reached", self, "_on_GOALS_goal_reached")
	__ = EVENTS.connect("alert", self, "_on_alert")
	__ = connect("mouse_entered", self, "_on_mouse_entered")
	__ = connect("mouse_exited", self, "_on_mouse_exited")
	
	_create_goals()


func _physics_process(_delta: float) -> void:
	if is_dragged:
		var mouse_pos = get_global_mouse_position()
		set_position(mouse_pos - grab_offset)


#### VIRTUALS ####



#### LOGIC ####

func _create_goals() -> void:
	for type in GOALS.goals_dict.keys():
		if type != "subs":
			continue
		
		for goal in GOALS.goals_dict[type]:
			var value = goal.goal
			var goal_line = goal_line_scene.instance()
			goals_container.call_deferred("add_child", goal_line)
			
			yield(goal_line, "ready")
			
			goal_line.set_name(goal.body)
			goal_line.get_node("GoalTitle").set_text(goal.body)
			goal_line.get_node("GoalValue").set_text(str(value))


func _mark_goal_as_reached(goal: String) -> void:
	var goal_line = goals_container.get_node(goal)
	var left_point = goal_line.rect_size / 2 * Vector2.DOWN
	var right_point = Vector2(goal_line.rect_size.x, goal_line.rect_size.y / 2)
	
	goal_line.get_node("Line2D").set_points([left_point, right_point])


func drag() -> void:
	is_dragged = true
	grab_offset = get_local_mouse_position()


func drop() -> void:
	is_dragged = false
	grab_offset = Vector2.ZERO


#### INPUTS ####


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		if event.is_pressed() && mouse_inside && is_visible():
			if !event.is_echo():
				drag()
		elif is_dragged:
			drop()


#### SIGNAL RESPONSES ####

func _on_GOALS_goal_reached(goal_type: String, goal) -> void:
	if goal_type == "subs":
		_mark_goal_as_reached(goal.body)
		EVENTS.emit_signal("alert", "fireworks")


func _on_alert(alert: String) -> void:
	if alert == "toggle_subgoal_panel":
		set_visible(!visible)


func _on_mouse_entered() -> void:
	mouse_inside = true


func _on_mouse_exited() -> void:
	mouse_inside = false
