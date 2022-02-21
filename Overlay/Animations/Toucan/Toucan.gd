extends AnimatedSprite
class_name Toucan

onready var bubble = $BubbleText

#### ACCESSORS ####

func is_class(value: String): return value == "Toucan" or .is_class(value)
func get_class() -> String: return "Toucan"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####

func _is_active() -> bool:
	return bubble.is_playing()

func new_message(message: String) -> void:
	bubble.bbcode_text = message
	
	bubble.appear()
	yield(get_tree().create_timer(0.9), "timeout")
	play("Croa")
	$Croa.play()
	
	yield(get_tree().create_timer(3.1), "timeout")
	bubble.appear(false)


#### INPUTS ####



#### SIGNAL RESPONSES ####


