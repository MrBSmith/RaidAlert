extends Node
class_name Interpretor

export var users_to_listen := PoolStringArray()

#### ACCESSORS ####

func is_class(value: String): return value == "Interpretor" or .is_class(value)
func get_class() -> String: return "Interpretor"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func find_number(splited_string: PoolStringArray) -> int:
	for word in splited_string:
		var nb = word.to_int()
		if nb != 0:
			return nb
	return 0

#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_chat_message(sender_data: SenderData, message: String) -> void:
	var user = "" if sender_data == null else sender_data.user
	
	if not user in users_to_listen:
		return

	if user == "wizebot" or user == "babadesbois":
		var words_array = message.split(" ")
		
		if "raid".is_subsequence_ofi(message):
			var channel_name = words_array[0]
			words_array.remove(0)
			var nb_raiders = find_number(words_array)
			EVENTS.emit_signal("raid", channel_name, nb_raiders)
		
		elif "follow".is_subsequence_ofi(message):
			var follow = words_array[2]
			EVENTS.emit_signal("new_follower", follow)
		
		elif "sub".is_subsequence_ofi(message):
			pass
	
	print(sender_data.user + " : " + message)
