extends AnimatedSprite


#### ACCESSORS ####



#### BUILT-IN ####

func _ready() -> void:
	var __ = EVENTS.connect("alert", self, "_on_alert_event")
	__ = connect("animation_finished", self, "_on_animation_finished")

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_alert_event(alert: String) -> void:
	if alert == "dark_babar" && !is_visible():
		set_visible(true)
		$ImperialMarch.play()
		
		yield(get_tree().create_timer(3.0), "timeout")
		play()
		
		yield(get_tree().create_timer(0.5), "timeout")
		$BabarSound.play()


func _on_animation_finished() -> void:
	stop()
	yield(get_tree().create_timer(2.0), "timeout")
	set_frame(0)
	set_visible(false)
