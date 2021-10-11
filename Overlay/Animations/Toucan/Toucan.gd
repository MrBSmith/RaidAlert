extends AnimatedSprite
class_name Toucan

onready var bubble = $Bubble

var queue : Array = []

#### ACCESSORS ####

func is_class(value: String): return value == "Toucan" or .is_class(value)
func get_class() -> String: return "Toucan"


#### BUILT-IN ####

func _ready() -> void:
	var __ = EVENTS.connect("new_follower", self, "_on_new_follower")
	__ = bubble.connect("animation_finished", self, "_on_bubble_animation_finished")


#### VIRTUALS ####



#### LOGIC ####

func new_follow_alert(follower_name: String) -> void:
	bubble.rich_text_label.bbcode_text = bubble.message % follower_name
	
	bubble.appear()
	yield(get_tree().create_timer(0.9), "timeout")
	play("Croa")
	$Croa.play()
	
	yield(get_tree().create_timer(3.1), "timeout")
	bubble.appear(false)


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_new_follower(follower_name: String) -> void:
	if bubble.is_playing():
		queue.append(follower_name)
	else:
		new_follow_alert(follower_name)


func _on_bubble_animation_finished(open: bool) -> void:
	if open == false && !queue.empty():
		new_follow_alert(queue.pop_front())
