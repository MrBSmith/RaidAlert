extends Control
class_name Spawner

export var obj_to_spawn_scene_path : String = ""
onready var scene_to_spawn = load(obj_to_spawn_scene_path)

#### ACCESSORS ####

func is_class(value: String): return value == "Spawner" or .is_class(value)
func get_class() -> String: return "Spawner"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
