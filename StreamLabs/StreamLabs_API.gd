extends Node
class_name StreamLabs_API

var websocket := WebSocketClient.new()

#### ACCESSORS ####

func is_class(value: String): return value == "StreamLabs_API" or .is_class(value)
func get_class() -> String: return "StreamLabs_API"


#### BUILT-IN ####

func _ready() -> void:
	var __ = websocket.connect("data_received", self, "_on_data_received")
	__ = websocket.connect("connection_established", self, "_on_connection_established")
	__ = websocket.connect("connection_closed", self, "_on_connection_closed")
	__ = websocket.connect("server_close_request", self, "_on_sever_close_request")
	__ = websocket.connect("connection_error", self, "_on_connection_error")


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_data_received() -> void:
	pass


func _on_connection_established() -> void:
	pass


func _on_connection_closed() -> void:
	pass


func _on_sever_close_request() -> void:
	pass


func _on_connection_error() -> void:
	pass
