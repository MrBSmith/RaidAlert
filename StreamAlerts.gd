extends Node2D

enum ALERT_TYPE {
	FOLLOW,
	SUBSCRIBER,
	SUB_GIFT,
	DONATION
}

onready var animation_player = $AnimationPlayer

onready var audio_alert = $AudioAlerts
onready var moai = $Moai
onready var toucan = $Toucan

export var print_logs := false

export var alert_message_dict = {
	"follow": "Merci pour ton follow [color=red]%s[/color], bienvenue dans les bois!",
	"subscriber": "[color=red]%s[/color] s'élève au dessus de la plèbe %s %s!!",
	"sub_gift": "[color=red]%s[/color] jette %d subs sur la plèbe!! Merci beaucoup!",
	"donation": "[color=red]%s[/color] a donné %d %s! Merci beaucoup mécène boisé!"
}

var alert_queue = []
var video_queue = []
var audio_queue = []

class StreamAlert:
	var alert_type : int = -1
	var args : Array = []
	
	func _init(type: int, arguments: Array) -> void:
		alert_type = type
		args = arguments

#### ACCESSORS ####


#### BUILT-IN ####

func _ready() -> void:
	var __ = EVENTS.connect("alert", self, "_on_alert")
	__ = EVENTS.connect("new_follower", self, "_on_EVENTS_new_follower")
	__ = EVENTS.connect("new_subscriber", self, "_on_EVENTS_new_subscriber")
	__ = EVENTS.connect("new_donation", self, "_on_EVENTS_new_donation")
	__ = EVENTS.connect("sub_gift", self, "_on_EVENTS_sub_gift")
	__ = EVENTS.connect("OBS_scene_changed", self, "_on_OBS_scene_changed")
	__ = animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	__ = $AudioAlerts.connect("finished", self, "_on_audio_alert_finished")
	
	for child in get_children():
		if child is AnimatedSprite:
			child.connect("animation_finished", self, "_on_animated_sprite_animation_finished", [child])
			child.connect("frame_changed", self, "_on_animated_sprite_frame_changed", [child])


#### VIRTUALS ####



#### LOGIC ####


func new_stream_alert(stream_alert: StreamAlert) -> void:
	if !animation_player.is_playing():
		var alert_type_name = Utils.dict_find_key_by_value(ALERT_TYPE, stream_alert.alert_type).to_lower()
		var message = alert_message_dict[alert_type_name] % stream_alert.args
		$Toucan.new_message(message)
		
		var anim_name = alert_type_name.capitalize() if stream_alert.alert_type != ALERT_TYPE.SUB_GIFT else "Subscriber"
		
		if animation_player.has_animation(anim_name):
			animation_player.play(anim_name)
	else:
		alert_queue.append(stream_alert)


func _play_audio_alert(alert_name: String) -> void:
	audio_alert.stream = GAME.alert_dict["audio"][alert_name]
	audio_alert.play()
	
	if print_logs: print("play %s audio" % alert_name)


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_alert(alert_name: String) -> void:
	alert_name = alert_name.to_lower()
	
	# Audio alerts
	if alert_name in GAME.alert_dict["audio"].keys():
		if audio_alert.is_playing():
			audio_queue.append(alert_name)
		else:
			_play_audio_alert(alert_name)
	
	# Special alerts
	else:
		for child in get_children():
			if child.name.to_lower() != alert_name:
				continue
			
			var anim_player = child.get_node("AnimationPlayer")
			var anim_list = anim_player.get_animation_list()
			
			for anim in anim_list:
				if anim.to_lower() != alert_name:
					continue
				
				anim_player.play(anim)
		
		if print_logs: print("play special alert %s" % alert_name)


func _on_audio_alert_finished() -> void:
	if !audio_queue.empty():
		_play_audio_alert(audio_queue.pop_front())


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
			
			if frame == 2:
				moai.get_node("OhYeah").play()
			
			if frame == 8:
				moai.get_node("Ding").play()


func _on_OBS_scene_changed(previous_scene: String, next_scene: String) -> void:
	if "Main" in [previous_scene, next_scene]:
		moai.play("Eyes")


func _on_jamcat_video_player_finished() -> void:
	$JamCat.stop()
	$JamCat.set_visible(false)


func _on_EVENTS_new_follower(follower_name: String) -> void:
	var stream_alert = StreamAlert.new(ALERT_TYPE.FOLLOW, [follower_name])
	new_stream_alert(stream_alert)


func _on_EVENTS_new_subscriber(subscriber_name: String, tier: int, nb_months: int, with_prime: bool = false) -> void:
	var sufix = ""
	
	if with_prime: sufix = "avec prime"
	elif tier != -1: sufix = "avec un abonnement tier %d" % tier
	
	var months_text = "depuis %d mois" % nb_months if nb_months != -1 else ""
	var stream_alert = StreamAlert.new(ALERT_TYPE.SUBSCRIBER, [subscriber_name, months_text, sufix])
	new_stream_alert(stream_alert)


func _on_EVENTS_sub_gift(gifter: String, amount: int) -> void:
	var stream_alert = StreamAlert.new(ALERT_TYPE.SUB_GIFT, [gifter, amount])
	new_stream_alert(stream_alert)


func _on_EVENTS_new_donation(donator: String, amount: int, currency: String) -> void:
	var stream_alert = StreamAlert.new(ALERT_TYPE.DONATION, [donator, amount, currency])
	new_stream_alert(stream_alert)


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	var alert = alert_queue.pop_front()
	if alert:
		new_stream_alert(alert)
