extends TwitchChatHandler
class_name BabaTwitchChatHandler

#### ACCESSORS ####

func is_class(value: String): return value == "BabaTwitchChatHandler" or .is_class(value)
func get_class() -> String: return "BabaTwitchChatHandler"

func get_badge(badge_name : String, channel_id : String = "_global", scale : String = "1") -> ImageTexture:
	if image_cache:
		return image_cache.get_badge(badge_name, channel_id, scale)
	else: return null
func get_emote(emote_id : String, scale = "1.0") -> ImageTexture:
	if image_cache:
		return image_cache.get_emote(emote_id, scale)
	else: return null

#### BUILT-IN ####

func _ready() -> void:
	var __ = EVENTS.connect("send_query", self, "_on_send_query_event")
	__ = connect("chat_message", $ChatBot, "_on_chat_message")
	__ = connect("chat_message", $Interpretor, "_on_chat_message")


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_send_query_event(query: String) -> void:
	send(query)
