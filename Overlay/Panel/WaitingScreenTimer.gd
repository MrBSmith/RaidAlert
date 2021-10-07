extends Label
class_name TimerLabel

onready var timer = $Timer
onready var update_timer = $UpdateTimer

#### ACCESSORS ####

func is_class(value: String): return value == "TimerLabel" or .is_class(value)
func get_class() -> String: return "TimerLabel"


#### BUILT-IN ####

func _ready() -> void:
	var __ = timer.connect("timeout", self, "_on_timer_timeout")
	__ = update_timer.connect("timeout", self, "_on_update_timer_timeout")
	__ = EVENTS.connect("alert", self, "_on_alert_event")
	__ = EVENTS.connect("OBS_scene_changed", self, "_on_OBS_scene_changed")


#### VIRTUALS ####



#### LOGIC ####

func start(waiting_time: float = 600.0) -> void:
	timer.start(waiting_time)
	update_timer.start()


func _update() -> void:
	var stopped = timer.is_stopped() or timer.is_paused()
	var time_left = timer.get_wait_time() if stopped else timer.get_time_left()
	var minutes = int(time_left / 60.0)
	var secondes = int(time_left) % 60
	
	var min_text = "0" + String(minutes) if minutes < 10 else String(minutes)
	var sec_text = "0" + String(secondes) if secondes < 10 else String(secondes)
	
	set_text("%s:%s" % [min_text, sec_text]) 


#### INPUTS ####


#### SIGNAL RESPONSES ####

func _on_update_timer_timeout() -> void:
	_update()


func _on_timer_timeout() -> void:
	update_timer.stop()
	timer.stop()


func _on_alert_event(alert: String) -> void:
	var timer_stopped = timer.is_stopped() or timer.is_paused()
	
	if alert == "timer_toggle":
		if timer_stopped:
			start(timer.get_time_left())
		
		timer.set_paused(!timer_stopped)
	
	if alert == "timer_+1min":
		if timer_stopped:
			timer.set_wait_time(timer.get_wait_time() + 60.0)
			_update()
		else:
			start(timer.get_time_left() + 60.0)


func _on_OBS_scene_changed(_previous_scene: String, next_scene: String) -> void:
	if next_scene == "Pause":
		start(240.0)
