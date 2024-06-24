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
	
static func handle_message(message: String) -> bool:
	if _singleton == null:
		return false
	var json_object = JSON.parse_string(message)
	if json_object == null:
		return false
		
	var msg: String = json_object['msg']
	if msg == "flash":
		var text: String = json_object['text']
		var flash_type_number = json_object['flashType']
		var flash_type: int = FlashMessageWidget.FLASH_INFO
		if flash_type_number == 0:
			flash_type = FlashMessageWidget.FLASH_INFO
		elif flash_type_number == 1:
			flash_type = FlashMessageWidget.FLASH_WARNING
		else:
			flash_type = FlashMessageWidget.FLASH_ERROR
		FlashMessageWidget.flash(text, flash_type)
			
	return true
	
