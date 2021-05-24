extends Node2D
class_name Spawner

export var obj_to_spawn_scene_path : String = ""
export var max_animal_spawned : int = 100
export var max_instance_per_tick : int = 10
onready var scene_to_spawn = load(obj_to_spawn_scene_path)

#### ACCESSORS ####

func is_class(value: String): return value == "Spawner" or .is_class(value)
func get_class() -> String: return "Spawner"


#### BUILT-IN ####

func _ready() -> void:
	var __ = EVENTS.connect("raid", self, "_on_raid_event")

#### VIRTUALS ####



#### LOGIC ####

func spawn_animals(nb: int) -> void:
	nb = Math.clampi(nb, 1, max_animal_spawned)
	
	for i in range(nb):
		if i % max_instance_per_tick == 0:
			yield(get_tree(), "idle_frame")
		
		var instance = scene_to_spawn.instance()
		
		var pos = Vector2(rand_range(0, GAME.screen_size.x), -50)
		instance.set_position(pos)
		
		call_deferred("add_child", instance)

#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_raid_event(_streamer_name: String, nb_raiders: int) -> void:
	spawn_animals(nb_raiders)
