extends Node2D

#### ACCESSORS ####



#### BUILT-IN ####

func _ready() -> void:
	for child in get_children():
		if child is AnimatedSprite:
			child.connect("animation_finished", self, "_on_Firework_animation_finished", [child])


#### VIRTUALS ####



#### LOGIC ####

func play():
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("Fireworks")

#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_Firework_animation_finished(animated_sprite: AnimatedSprite) -> void:
	animated_sprite.play("default")


