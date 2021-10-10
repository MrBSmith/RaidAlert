extends Node2D
class_name Animations

onready var moai = $Moai
onready var toucan = $Toucan

#### ACCESSORS ####

func is_class(value: String): return value == "Animations" or .is_class(value)
func get_class() -> String: return "Animations"


#### BUILT-IN ####

func _ready() -> void:
	var __ = EVENTS.connect("alert", self, "_on_alert")
	
	for child in get_children():
		if child is AnimatedSprite:
			child.connect("animation_finished", self, "_on_animated_sprite_animation_finished", [child])
			child.connect("frame_changed", self, "_on_animated_sprite_frame_changed", [child])



#### VIRTUALS ####



#### LOGIC ####

func _panier_animation() -> void:
	toucan.play("Panier")
	yield(toucan, "animation_finished")
	
	moai.play("OhYeah")
	
	yield(get_tree().create_timer(0.1), "timeout")
	moai.get_node("OhYeah").play()

#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_alert(alert_name: String) -> void:
	if alert_name == "Panier":
		_panier_animation()


func _on_animated_sprite_animation_finished(animated_sprite: AnimatedSprite) -> void:
	animated_sprite.set_animation("default")


func _on_animated_sprite_frame_changed(animated_sprite: AnimatedSprite) -> void:
	var frame = animated_sprite.get_frame()
	var anim = animated_sprite.get_animation()
	
	if animated_sprite == toucan:
		if anim == "Panier":
			if frame == 3:
				toucan.get_node("Bell").play()
			elif frame == 5:
				toucan.get_node("Croa").play()
	
	elif animated_sprite == moai:
		if anim == "OhYeah":
			if frame in [3, 5, 13]:
				var delay = 0.2 if frame == 13 else 0.4
				
				moai.stop()
				yield(get_tree().create_timer(delay), "timeout")
				
				moai.play()
			
			if frame == 8:
				moai.get_node("Ding").play()
