extends Node

class_name PacketManager

signal websocket_message_send_requested(message: String)

func create_room(room_name: String) -> void:
	var msg = { "roomName": room_name }
	var json_string = JSON.stringify(msg)
	websocket_message_send_requested.emit(json_string)
