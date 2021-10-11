extends Node2D
class_name Spawner

export var obj_to_spawn_scene_dict : Dictionary = {}
export var max_animal_spawned : int = 100
export var max_instance_per_tick : int = 10

onready var min_spawn_y = -GAME.screen_size.y

export var max_spawn_y = -30
export var lateral_spwn_margin : float = 30.0

#### ACCESSORS ####

func is_class(value: String): return value == "Spawner" or .is_class(value)
func get_class() -> String: return "Spawner"


#### BUILT-IN ####


#### VIRTUALS ####



#### LOGIC ####

func spawn_animals(nb: int, animal_key: String) -> void:
	nb = Math.clampi(nb, 1, max_animal_spawned)
	var scene_to_spawn = obj_to_spawn_scene_dict[animal_key]
	var margin = lateral_spwn_margin if animal_key != "follow" else lateral_spwn_margin * 3
	
	for i in range(nb):
		if i % max_instance_per_tick == 0:
			yield(get_tree(), "idle_frame")
		
		var instance = scene_to_spawn.instance()
		
		var pos = Vector2(rand_range(margin, GAME.screen_size.x -margin),
					 rand_range(min_spawn_y, max_spawn_y))
		instance.set_position(pos)
		
		call_deferred("add_child", instance)



#### INPUTS ####



#### SIGNAL RESPONSES ####

