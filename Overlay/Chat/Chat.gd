extends VBoxContainer
class_name Chat

onready var chat_handler = $TwitchChatHandler

var line_scene = preload("res://BabaGodotLib/UI/TitleBodyLine/TitleBodyLine.tscn")

export var font : DynamicFont

class EmoteLocation extends Reference:
	var id : String
	var start : int
	var end : int

	func _init(emote_id, start_idx, end_idx):
		self.id = emote_id
		self.start = start_idx
		self.end = end_idx

	static func smaller(a : EmoteLocation, b : EmoteLocation):
		return a.start < b.start

#### ACCESSORS ####

func is_class(value: String): return value == "Chat" or .is_class(value)
func get_class() -> String: return "Chat"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_chat_message(sender_data: SenderData, message: String) -> void:
	var tags = sender_data.tags
	var color_code = tags["color"]
	var user_name = tags["display-name"]
	
	var msg = message
	
	var badges : String = ""
	var badges_names = tags["badges"].split(",", false)
	for badge in badges_names:
		badges += "[img=8]" + chat_handler.get_badge(badge, tags["room-id"]).resource_path + "[/img] "
	
	var locations : Array = []
	for emote in tags["emotes"].split("/", false):
		var data : Array = emote.split(":")
		for d in data[1].split(","):
			var start_end = d.split("-")
			locations.append(EmoteLocation.new(data[0], int(start_end[0]), int(start_end[1])))
	locations.sort_custom(EmoteLocation, "smaller")
	
	var offset = 0
	for loc in locations:
		var emote_string = "[img=10]" + chat_handler.image_cache.get_emote(loc.id).resource_path +"[/img]"
		msg = msg.substr(0, loc.start + offset) + emote_string + msg.substr(loc.end + offset + 1)
		offset += emote_string.length() + loc.start - loc.end - 1
	
	var message_label = RichTextLabel.new()
	var user_name_text = "[b][color=" + color_code + "]" + user_name + "[/color][/b]: "
	
	message_label.add_font_override("normal_font", font)
	message_label.add_font_override("bold_font", font)
	message_label.fit_content_height = true
	message_label.bbcode_enabled = true
	message_label.bbcode_text = badges + user_name_text + msg
	
	call_deferred("add_child", message_label)
