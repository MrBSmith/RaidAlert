extends AnimatedSprite
class_name TV

onready var tween = $Tween
onready var default_position = get_position()

export var on : bool = true setget set_on, is_on

var hidden : bool = false

signal on_changed(value)
signal turn_animation_finished()
signal zap_animation_finished()
signal appear_animation_finshed()

#### ACCESSORS ####

func is_class(value: String): return value == "TV" or .is_class(value)
func get_class() -> String: return "TV"

func set_on(value: bool) -> void:
	if value != on:
		on = value
		emit_signal("on_changed", on)
func is_on() -> bool: return on

#### BUILT-IN ####

func _ready() -> void:
	var __ = connect("on_changed", self, "_on_on_changed")
	__ = EVENTS.connect("alert", self, "_on_EVENTS_alert")

#### VIRTUALS ####



#### LOGIC ####


func zap(between_delay: float = 0.0) -> void:
	if !on:
		push_warning("The TV must be on to be albe to call zap()")
		return
	
	set_on(false)
	yield(self, "turn_animation_finished")
	
	if between_delay != 0.0:
		yield(get_tree().create_timer(between_delay), "timeout")
	
	set_on(true)
	yield(self, "turn_animation_finished")
	
	emit_signal("zap_animation_finished")


func appear() -> void:
	position.x = default_position.x
	
	tween.interpolate_property(self, "position:y", default_position.y - 400, 
					default_position.y, 1.0, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	hidden = false
	
	yield(tween, "tween_all_completed")
	set_on(true)
	
	yield(self, "turn_animation_finished")
	emit_signal("appear_animation_finshed")


func disappear() -> void:
	tween.interpolate_property(self, "position", position, 
						default_position + Vector2(100.0, 150.0), 
						0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	hidden = true



#### INPUTS ####



#### SIGNAL RESPONSES ####


func _on_on_changed(_value: bool) -> void:
	var sufix = "On" if on else "Off"
	play("Turn" + sufix)
	
	yield(self, "animation_finished")
	
	play(sufix)
	emit_signal("turn_animation_finished")


func _on_EVENTS_alert(alert: String) -> void:
	if alert == "timtimpx":
		set_on(false)
		yield(self, "turn_animation_finished")
		
		yield(get_tree().create_timer(0.7), "timeout")
		
		$TimtimPX.set_frame(0)
		$TimtimPX.set_visible(true)
		$TimtimPX.play("TimtimPX")
		$BonjourAToi.play()
		yield($TimtimPX, "animation_finished")
		
		yield(get_tree().create_timer(0.5), "timeout")
		
		$TimtimPX.set_visible(false)
		set_on(true)
		
