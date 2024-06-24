extends Node

class_name Network

signal websocket_message_send_requested(message: String)

static var _singleton: Network = null
	
static func init(instance: Network) -> void:
	_singleton = instance

static func create_room(room_name: String) -> void:
	var msg: Dictionary = { 
				  "msg": "createRoom",
				  "roomName": room_name }
	var json_string: String = JSON.stringify(msg)
	_singleton.websocket_message_send_requested.emit(json_string)
