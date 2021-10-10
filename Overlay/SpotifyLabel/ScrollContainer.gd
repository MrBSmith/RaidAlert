extends ScrollContainer

onready var content = $CenterContainer
onready var tween = $Tween

var content_x_size : float = 54.0
var max_scroll = 0
var scroll_dir = -1

#### ACCESSORS ####

func _ready() -> void:
	var __ = tween.connect("tween_all_completed", self, "_on_tween_completed")

#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func update_scroll() -> void:
	content_x_size = content.get_size().x
	max_scroll = abs(content_x_size - get_size().x)
	scroll_dir = 1
	
	_trigger_scroll(3.0)


func _trigger_scroll(delay: float = 0.0) -> void:
	tween.stop_all()
	
	var from = max_scroll if scroll_dir == -1 else 0
	var dest = 0 if scroll_dir == -1 else max_scroll
	
	tween.interpolate_property(self, "scroll_horizontal", from, dest,
								 content_x_size / 30.0, Tween.TRANS_LINEAR,
								 Tween.EASE_IN_OUT, delay)
	
	tween.start()


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_tween_completed() -> void:
	scroll_dir = -scroll_dir
	var delay = 0.0 if scroll_dir == -1 else 2.0
	_trigger_scroll(delay)
