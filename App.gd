extends Node2D

onready var chat_handler = $TwitchChatHandler
onready var alert_handler = $TwitchAlertsHandler

func _ready() -> void:

	# Connect the chat handler to Twitch channel
	var authfile := File.new()
	var __ = authfile.open("./auth.txt", File.READ)
	var _botname := authfile.get_line()
	var _token := authfile.get_line()
	var channel_name = authfile.get_line()
	var client_id = authfile.get_line()
	var secret = authfile.get_line()

#	chat_handler.connect_to_twitch()
#	yield(chat_handler, "twitch_connected")
#
#	chat_handler.authenticate_oauth(botname, token)
#	if(yield(chat_handler, "login_attempt") == false):
#	  print("Invalid username or token.")
#	  return
#
#	chat_handler.join_channel(channel_name)
#
#	chat_handler.connect("cmd_no_permission", self, "no_permission")
#	chat_handler.connect("chat_message", self, "_on_chat_message")
	
	# Connect the alert handler
	alert_handler.connect_to_alerts(client_id, secret, channel_name)



func _on_chat_message(sender_data: SenderData, message: String) -> void:
	print(sender_data.user + " : " + message)
