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
		if "(" in word or ")" in word:
			continue
		
		var nb = word.to_int()
		if nb != 0:
			return nb
	return 0

#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_chat_message(sender_data: SenderData, message: String) -> void:
	var user = "" if sender_data == null else sender_data.user

	if "wizebot".is_subsequence_ofi(user) or (OS.is_debug_build() && "babadesbois".is_subsequence_ofi(user)):
		var words_array = message.split(" ")
		
		if "wizebot".is_subsequence_ofi(user):
			words_array.remove(0)
		
		if "RAID" in message:
			var channel_name = words_array[0]
			var message_wo_channel_name = words_array.duplicate()
			message_wo_channel_name.erase(channel_name)
			var nb_raiders = find_number(message_wo_channel_name)
			EVENTS.emit_signal("raid", channel_name, nb_raiders)
		
		elif "FOLLOW" in message:
			var follow = words_array[2].replace(",", "")
			EVENTS.emit_signal("new_follower", follow)
		
		elif "SUB GIFT" in message:
			EVENTS.emit_signal("sub_gift", words_array[3], int(words_array[6]))
		
		elif "RESUB" in message:
			EVENTS.emit_signal("new_subscriber", words_array[1], -1, int(words_array[8]), false)
		
		elif "SUB" in message:
			var is_prime = "prime" in message
			var tier = -1 if is_prime else int(words_array[10])
			EVENTS.emit_signal("new_subscriber", words_array[2], tier, 1, is_prime)
		
		elif "BITS" in message:
			EVENTS.emit_signal("new_donation", words_array[0], int(words_array[4]))
		
	print(sender_data.user + " : " + message)
