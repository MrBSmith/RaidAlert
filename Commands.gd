tool
class_name CommandList
extends Node


#### ACCESSORS ####



#### BUILT-IN ####


func _ready() -> void:
	for category_dict in GAME.alert_dict.values():
		for alert_name in category_dict.keys():
			if !_has_command(alert_name):
				var command = Command.new()
				command.command = "!" + alert_name.to_lower()
				command.alert = alert_name
				command.cooldown = 30.0
				command.name = alert_name
				var __ = command.connect("ready", self, "_on_command_ready", [command], CONNECT_ONESHOT)
				call_deferred("add_child", command)
				print("command created: %s" % alert_name)



#### VIRTUALS ####



#### LOGIC ####


#### INPUTS ####


func _has_command(command_name: String) -> bool:
	for child in get_children():
		if child.name == command_name:
			return true
	return false


#### SIGNAL RESPONSES ####

func _on_command_ready(command: Command) -> void:
	command.owner = owner
