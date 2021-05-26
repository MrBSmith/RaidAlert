extends Node
class_name StreamLabsAlertsHandler

onready var http_request = $HTTPRequest 

export var callback_url = "" 

var client_id : String = ""
var secret : String = ""

var websocket := WebSocketClient.new()
var app_token : String = ""
var channel_name : String = ""
var broadcaster_id : String = ""

var fetch_token_url = "https://id.twitch.tv/oauth2/token"
var test_url : String = "https://api.twitch.tv/helix/search/channels?query=a_seagull"

signal token_obtained(token)
signal broadcaster_id_obtained(id)

#signal raid()
#signal host()
#signal sub()
#signal resub()
#signal follow()
#signal donation()
#signal bits()

#### ACCESSORS ####

func is_class(value: String): return value == "StreamLabsAlertsHandler" or .is_class(value)
func get_class() -> String: return "StreamLabsAlertsHandler"


#### BUILT-IN ####

func _ready() -> void:
	var __ = websocket.connect("data_received", self, "_on_websocket_data_received")
	__ = websocket.connect("connection_established", self, "_on_websocket_connection_established")
	__ = websocket.connect("connection_closed", self, "_on_websocket_connection_closed")
	__ = websocket.connect("server_close_request", self, "_on_websocket_sever_close_request")
	__ = websocket.connect("connection_error", self, "_on_websocket_connection_error")
	
	http_request.connect("request_completed", self, "_on_request_completed")


#### VIRTUALS ####



#### LOGIC ####

func connect_to_alerts(_client_id: String, _secret: String, _channel_name: String):
	client_id = _client_id
	secret = _secret
	channel_name = _channel_name
	
	fetch_token()
	yield(self, "token_obtained")
	
	fetch_broadcaster_id()
	yield(self, "broadcaster_id_obtained")

	subscribe_to_twich_api()


func fetch_token() -> void:
	var http_client := HTTPClient.new()
	var headers_dict = {"client_id": client_id, 
						"client_secret": secret, 
						"grant_type": "client_credentials"}
	
	var request_headers = http_client.query_string_from_dict(headers_dict)
	var request = fetch_token_url + "?" + request_headers
	var err = http_request.request(request, [], true, HTTPClient.METHOD_POST)
	if err != OK: printerr(err)


func fetch_broadcaster_id() -> void:
	var headers = ["Client-ID: %s" % client_id,
					"Authorization: Bearer %s" % app_token]
	
	var err = http_request.request("https://api.twitch.tv/helix/users?login=%s" % channel_name,
		headers, true, HTTPClient.METHOD_GET)
	if err != OK: printerr(err)


func subscribe_to_twich_api() -> void:
	var request = "https://api.twitch.tv/helix/eventsub/subscriptions"
	var headers = ["Client-ID: %s" % client_id,
					"Authorization: Bearer %s" % app_token,
					"Content-Type: application/json"]
	
	var body : Dictionary = {
		"type": "channel.follow",
		"version": "1",
		"condition": {
			"broadcaster_user_id": broadcaster_id
		},
		"transport": {
			"method": "webhook",
			"callback": callback_url,
			"secret": secret
		}
	}
	
	var json_body = JSON.print(body)
	print(json_body)
	var err = http_request.request(request, headers, true, HTTPClient.METHOD_POST, json_body)
	
	if err != OK:
		printerr(err)

#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_websocket_data_received():
	pass

func _on_websocket_connection_established():
	pass

func _on_websocket_connection_closed():
	pass

func _on_websocket_sever_close_request():
	pass

func _on_websocket_connection_error():
	pass

func _on_request_completed(_result, _reponse_code, _headers, body: PoolByteArray):
	var parsed_json = JSON.parse(body.get_string_from_utf8())
	var parsed_json_result = parsed_json.get_result()
	
	if "access_token" in parsed_json_result.keys():
		app_token = parsed_json_result["access_token"]
		emit_signal("token_obtained", app_token)
		return
	
	if "data" in parsed_json_result.keys():
		var data_dict = parsed_json_result["data"][0]
		if "broadcaster_type":
			broadcaster_id = data_dict["id"]
			emit_signal("broadcaster_id_obtained", broadcaster_id)
			return

