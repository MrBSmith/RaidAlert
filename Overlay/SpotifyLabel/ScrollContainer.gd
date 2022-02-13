extends ScrollContainer

onready var content = $CenterContainer
onready var tween = $Tween
onready var timer = $Timer

var content_x_size : float = 54.0
var max_scroll = 0
var scroll_dir = -1


#### ACCESSORS ####



#### BUILT-IN ####

func _ready() -> void:
	var __ = timer.connect("timeout", self, "_on_timer_timeout")


#### VIRTUALS ####



#### LOGIC ####

func update_scroll() -> void:
	scroll_horizontal = 0
	tween.stop_all()
	timer.stop()
	content.set_size(Vector2.ZERO)
	
	yield(get_tree(), "idle_frame")
	
	content_x_size = content.rect_size.x
	max_scroll = int(max(0, content_x_size - rect_size.x))
	scroll_dir = 1
	
	if max_scroll != 0:
		_trigger_scroll(3.0)


func _trigger_scroll(delay: float = 0.0) -> void:
	tween.stop_all()
	
	var from = scroll_horizontal
	var dest = 0 if scroll_dir == -1 else max_scroll
	var duration = content_x_size / 30.0
	
	tween.interpolate_property(self, "scroll_horizontal", from, dest, duration,
								Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
	
	timer.start(duration + delay)
	
	tween.start()


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_timer_timeout() -> void:
	scroll_dir = -scroll_dir
	_trigger_scroll(4.0)
