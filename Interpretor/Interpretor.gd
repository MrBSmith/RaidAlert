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
		
#		# Removes empty words
#		var i = 0
#		while(i < words_array.size()):
#			var word = words_array[i]
#
#			if word in [" ", ""] or (word.substr(0, 1) == ":" and word.substr(word.length() - 1, 1) == ":"):
#				words_array.remove(i)
#			else:
#				i += 1
		
		if "RAID".is_subsequence_of(message):
			var channel_name = words_array[1]
			words_array.remove(0)
			var nb_raiders = find_number(words_array)
			EVENTS.emit_signal("raid", channel_name, nb_raiders)
		
		elif "FOLLOW".is_subsequence_of(message):
			var follow = words_array[3]
			EVENTS.emit_signal("new_follower", follow)
		
		elif "sub".is_subsequence_ofi(message):
			pass
	
	print(sender_data.user + " : " + message)
