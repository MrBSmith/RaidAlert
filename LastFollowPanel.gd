extends TextureRect
class_name LastFollowPanel

onready var timer = $Timer
onready var last_follower_label = $HBoxContainer/VBoxContainer/LastFollower
onready var last_subscriber_label = $HBoxContainer/VBoxContainer/LastSubscriber
onready var top_donater_label = $HBoxContainer/VBoxContainer2/TopDonater
onready var top_sub_gifter_label = $HBoxContainer/VBoxContainer2/TopSubGifter

var last_follower_file_path = "D:/StreamDeck/StreamLabels/most_recent_follower.txt"
var last_sub_file_path = "D:/StreamDeck/StreamLabels/most_recent_subscriber.txt"
var top_donater_file_path = "D:/StreamDeck/StreamLabels/weekly_top_cheerer.txt"
var top_sub_gifter_file_path = "D:/StreamDeck/StreamLabels/weekly_top_sub_gifter.txt"

var last_follow : String = ""
var last_sub : String = ""

#### ACCESSORS ####

func is_class(value: String): return value == "LastFollowPanel" or .is_class(value)
func get_class() -> String: return "LastFollowPanel"


#### BUILT-IN ####

func _ready() -> void:
	var __ = timer.connect("timeout", self, "_on_timer_timeout")
	
	_update()


#### VIRTUALS ####



#### LOGIC ####

func _update() -> void:
	var follow = DirNavHelper.read_file_line(last_follower_file_path)
	if follow != last_follow && follow != "":
		last_follower_label.set_text("Dernier follow: %s" % follow)
		last_follow = follow
	
	var sub = DirNavHelper.read_file_line(last_sub_file_path)
	if sub != last_sub && sub != "":
		last_subscriber_label.set_text(sub)
		last_sub = sub
	
	top_donater_label.set_text(DirNavHelper.read_file_line(top_donater_file_path))
	top_sub_gifter_label.set_text(DirNavHelper.read_file_line(top_sub_gifter_file_path))


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_timer_timeout() -> void:
	_update()
