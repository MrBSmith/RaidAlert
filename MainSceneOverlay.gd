extends Control
class_name MainScene

onready var tween = $Tween
onready var chat = $ChatPanel
onready var goals = $Goals
onready var background = $Background

var border_start_pos := Array()

#### ACCESSORS ####

func is_class(value: String): return value == "MainScene" or .is_class(value)
func get_class() -> String: return "MainScene"


#### BUILT-IN ####

func _ready() -> void:
	for border in background.get_children():
		if not border is TextureRect: continue
		border_start_pos.append(border.get_position())


#### VIRTUALS ####



#### LOGIC ####


func appear_animation(appear: bool = true) -> void:
	var background_delay = 0.0 if appear else 1.2 
	var chat_delay = 1.0
	var goals_delay = 1.2 if appear else 0.0
	
	set_visible(true)
	
	_trigger_background_animation(appear, background_delay)
	_trigger_chat_appear_animation(appear, chat_delay)
	_trigger_goals_appear_animation(appear, goals_delay)
	
	if !appear:
		yield(tween, "tween_all_completed")
		set_visible(false)


func _trigger_chat_appear_animation(appear: bool = true, delay: float = 0.0) -> void:
	var trans = Tween.TRANS_BOUNCE if appear else Tween.TRANS_CUBIC
	var form = -chat.rect_size.y if appear else 0
	var to = 0 if appear else -chat.rect_size.y
	
	chat.set_position(Vector2(chat.rect_position.x, form))
	
	if delay != 0.0:
		yield(get_tree().create_timer(delay), "timeout")
	
	var __ = tween.interpolate_property(chat, "rect_position:y", 
				form, to, 1.0, trans, Tween.EASE_OUT)
	
	__ = tween.start()


func _trigger_goals_appear_animation(appear: bool = true, delay: float = 0.0) -> void:
	var ease_type = Tween.EASE_OUT if appear else Tween.EASE_IN
	var from = -200.0 if appear else 0.0
	var to = 0.0 if appear else -200.0
	
	var children = goals.get_children()
	
	for child in children:
		if child is Control:
			child.rect_position.x = from
	
	if delay != 0.0:
		yield(get_tree().create_timer(delay), "timeout")
	
	for i in range(children.size()):
		var child = children[i]
		
		if not child is Control:
			continue
		
		var __ = tween.interpolate_property(child, "rect_position:x", from, to, 
						0.8, Tween.TRANS_BACK, ease_type, i * 0.3)
	
	var __ = tween.start()


func _trigger_background_animation(appear: bool = true, delay: float = 0.0) -> void:
	if delay != 0.0:
		yield(get_tree().create_timer(delay), "timeout")
	
	var borders_array = background.get_children()
	for i in range(borders_array.size()):
		var border = borders_array[i]
		
		if not border is TextureRect:
			continue
		
		var mov_dir = Vector2.RIGHT if i < 2 else Vector2.DOWN
		var mov_sign = -1 if i % 2 == 0 else 1
		
		var from = border.get_position()
		var to = border_start_pos[i] + border.get_size() * mov_dir * mov_sign if !appear else border_start_pos[i]
		
		var __ = tween.interpolate_property(border, "rect_position", from, to, 
										1.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	
	var __ = tween.start()
	
	$Background/AudioStreamPlayer.play()



#### INPUTS ####



#### SIGNAL RESPONSES ####



