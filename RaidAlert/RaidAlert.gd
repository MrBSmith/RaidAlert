extends Node2D
class_name RaidAlert

func is_class(value: String) -> bool: return value == "RaidAlert" or .is_class(value)
func get_class() -> String: return "RaidAlert"

func _ready() -> void:
	randomize()
