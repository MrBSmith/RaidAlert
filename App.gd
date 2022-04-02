extends Node2D

onready var raid_alert = $Overlay/Foreground/StreamAlerts/RaidAlert
onready var chat_handler = $Overlay/MainScene/ChatPanel/Chat/TwitchChatHandler
onready var chat = $Overlay/MainScene/ChatPanel/Chat

export var nick_name : String = ""
export var token : String = ""
export var channel_to_listen : String = ""

func _ready() -> void:
	chat_handler.connect_to_twitch()
	yield(chat_handler, "twitch_connected")
	
	chat_handler.authenticate_oauth(nick_name, token)
	if(yield(chat_handler, "login_attempt") == false):
	  print("Invalid username or token.")
	  return
	
	chat_handler.join_channel(channel_to_listen)
	
	var _err = chat_handler.connect("chat_message", chat, "_on_chat_message")

