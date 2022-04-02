extends CanvasLayer

onready var video_player = $VideoPlayer
onready var video_player_rect = video_player.get_rect()

var video_queue = []

export var print_logs : bool = false

#### ACCESSORS ####

func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""


#### BUILT-IN ####

func _ready() -> void:
	var __ = EVENTS.connect("alert", self, "_on_alert")
	__ = video_player.connect("finished", self, "_on_video_player_finished")

#### VIRTUALS ####



#### LOGIC ####


func _play_video_alert(alert_name: String, fullscreen: bool = false) -> void:
	video_player.stream = GAME.alert_dict["video"][alert_name]
	
	if fullscreen:
		video_player.set_size(GAME.screen_size)
		video_player.set_position(Vector2.ZERO)
	else:
		video_player.set_size(video_player_rect.size)
		video_player.set_position(video_player_rect.position)
	
	video_player.play()
	
	yield(get_tree().create_timer(0.5), "timeout")
	video_player.set_visible(true)
	
	if print_logs: print("play %s video" % alert_name)


#### INPUTS ####



#### SIGNAL RESPONSES ####


func _on_alert(alert_name: String) -> void:
	alert_name = alert_name.to_lower()
	
	# Video alerts
	if alert_name in GAME.alert_dict["video"].keys():
		if video_player.is_playing():
			video_queue.append(alert_name)
		else:
			_play_video_alert(alert_name, alert_name == "xionleak")
		
		if print_logs: print("Play video alert: %s" % alert_name)


func _on_video_player_finished() -> void:
	if !video_queue.empty():
		_play_video_alert(video_queue.pop_front())
	else:
		video_player.set_visible(false)
