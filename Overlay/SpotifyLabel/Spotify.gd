extends TextureRect

onready var scroll_container = $HBoxContainer/VBoxContainer/ScrollContainer
onready var title_label = $HBoxContainer/VBoxContainer/ScrollContainer/HBoxContainer/Title
onready var album_label = $HBoxContainer/VBoxContainer/ScrollContainer/HBoxContainer/Album
onready var artist_label = $HBoxContainer/VBoxContainer/Artist
onready var cover_texture_rect = $HBoxContainer/CoverFrame/Cover

var track_name_file_path = "D:/Snip/Snip_Track.txt"
var album_name_file_path = "D:/Snip/Snip_Album.txt"
var artist_name_file_path = "D:/Snip/Snip_Artist.txt"
var cover_file_path = "D:/Snip/Snip_Artwork.jpg"

#### ACCESSORS ####



#### BUILT-IN ####

func _ready() -> void:
	var __ = $Timer.connect("timeout", self, "_on_timer_timeout")


#### VIRTUALS ####



#### LOGIC ####

func _update() -> void:
	var track : String = DirNavHelper.read_file_line(track_name_file_path)
	var album : String = DirNavHelper.read_file_line(album_name_file_path)
	var artist : String = DirNavHelper.read_file_line(artist_name_file_path)
	
	if track != title_label.get_text():
		title_label.set_text(track)
		artist_label.set_text(artist)
		
		scroll_container.update_scroll()
	
	if album != album_label.get_text():
		album_label.set_text(album)
		
		var cover = ImageTexture.new()
		var image = Image.new()
		image.load(cover_file_path)
		cover.create_from_image(image)
		cover_texture_rect.set_texture(cover)


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_timer_timeout() -> void:
	_update()

