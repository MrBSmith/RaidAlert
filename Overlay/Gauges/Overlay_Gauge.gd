tool
extends TextureProgress
class_name Overlay_Gauge

onready var particles = $Particles2D
onready var nine_patch_rect = $NinePatchRect
onready var animated_sprite = $AnimatedSprite
onready var label = $Label
onready var tween = $Tween

onready var fill_texture_max_size = nine_patch_rect.get_size()

export var fill_texture_color := Color.white setget set_fill_texture_color
export var goal_text : String = "Goal text here" setget set_goal_text

export var text_color := Color("52002d") setget set_text_color


#### ACCESSORS ####

func is_class(value: String): return value == "Overlay_Gauge" or .is_class(value)
func get_class() -> String: return "Overlay_Gauge"

func set_fill_texture_color(val: Color) -> void:
	fill_texture_color = val
	
	if nine_patch_rect == null: yield(self, "ready")
	nine_patch_rect.set_modulate(fill_texture_color)

func set_goal_text(val: String) -> void:
	goal_text = val
	
	if label == null: yield(self, "ready")
	label.set_text(goal_text)

func set_text_color(val: Color) -> void:
	text_color = val
	
	if label == null: yield(self, "ready")
	label.set_modulate(text_color)


#### BUILT-IN ####

func _ready() -> void:
	var __ = connect("value_changed", self, "_on_value_changed")
	__ = animated_sprite.connect("frame_changed", self, "_on_animated_sprite_frame_changed")
	
	label.set_text(goal_text)
	label.set_modulate(text_color)
	nine_patch_rect.set_modulate(fill_texture_color)



#### VIRTUALS ####



#### LOGIC ####

func _goal_reached_feedback() -> void:
	particles.set_emitting(true)
	
	for i in range(6):
		var to = Vector2(1.3, 1.3) if i % 2 == 0 else Vector2.ONE
		
		$AudioStreamPlayer2D.play()
		
		var __ = tween.interpolate_property(self, "rect_scale", rect_scale, 
						to, 0.3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		
		tween.start()
		yield(tween, "tween_all_completed")


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_value_changed(_val: float) -> void:
	var x_size = lerp(nine_patch_rect.get_minimum_size().x, fill_texture_max_size.x, ratio)
	
	var nine_patch_size = nine_patch_rect.get_size()
	nine_patch_rect.set_size(Vector2(x_size, nine_patch_size.y))
	
	if is_equal_approx(value, max_value):
		_goal_reached_feedback()


func _on_animated_sprite_frame_changed() -> void:
	var frame_id = animated_sprite.get_frame()
	var texture = animated_sprite.get_sprite_frames().get_frame("default", frame_id)
	
	nine_patch_rect.set_texture(texture)
