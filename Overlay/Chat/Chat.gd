extends VBoxContainer
class_name Chat

onready var chat_handler = $TwitchChatHandler
onready var message_min_y = get_global_position().y

export var normal_font : DynamicFont
export var bold_font : DynamicFont

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
	var color_code = tags["color"] if tags["color"] != "" else "aqua"
	var user_name = tags["display-name"]
	
	var msg = message
	
	var badges : String = ""
	var badges_names = tags["badges"].split(",", false)
	
	# Fetch badges
	for badge in badges_names:
		var badge_texture = chat_handler.get_badge(badge, tags["room-id"])
		var badge_res_path = badge_texture.resource_path
		if badge_texture == null or badge_res_path == "":
			continue
		
		badges += "[img=18]%s[/img] " % badge_res_path
	
	# Fetch emote locations in the message
	var locations : Array = []
	for emote in tags["emotes"].split("/", false):
		var data : Array = emote.split(":")
		for d in data[1].split(","):
			var start_end = d.split("-")
			locations.append(EmoteLocation.new(data[0], int(start_end[0]), int(start_end[1])))
	locations.sort_custom(EmoteLocation, "smaller")
	
	# Fetch & place emotes in the message
	var offset = 0
	for loc in locations:
		var emote_texture = chat_handler.get_emote(loc.id)
		var emote_path = emote_texture.resource_path
		var emote_string = "[img]%s[/img]" % emote_path if emote_path != "" else ""
		msg = msg.substr(0, loc.start + offset) + emote_string + msg.substr(loc.end + offset + 1)
		offset += emote_string.length() + loc.start - loc.end - 1
	
	var message_label = RichTextLabel.new()
	var user_name_text = "[b][color=%s]%s[/color][/b]: " % [color_code, user_name]
	
	message_label.add_font_override("normal_font", normal_font)
	message_label.add_font_override("bold_font", bold_font)
	message_label.fit_content_height = true
	message_label.bbcode_enabled = true
	message_label.bbcode_text = badges + user_name_text + msg
	
	message_label.connect("ready", self, "_on_message_ready", [], CONNECT_ONESHOT)
	call_deferred("add_child", message_label)


func _on_message_ready() -> void:
	var first_message = get_child(1)
	
	if get_child_count() > 10:
		first_message.queue_free()
