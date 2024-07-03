extends Node

class_name Network

signal websocket_message_send_requested(message: String)

signal room_item_received(room_id: int, room_name: String, room_owner: String)
signal room_item_removed(room_id: int)
signal kicked_from_game_room
signal entered_to_game_room

static var _singleton: Network = null

static func init(instance: Network) -> void:
	_singleton = instance

static func get_instance() -> Network:
	return _singleton

static func create_room(room_name: String) -> void:
	var msg: Dictionary = {
	  	"msg": "createRoom", 
	    "roomName": room_name }
	_send_json_string(msg)
	
static func request_all_room_datas() -> void:
	var msg: Dictionary = {
		"msg": "requestAllRoomDatas" }
	_send_json_string(msg)
	
static func request_join_game_room(room_id: int) -> void:
	var msg: Dictionary = {
		"msg": "requestJoinGameRoom",
		"roomId": room_id }
	_send_json_string(msg)
	
static func request_leave_game_room() -> void:
	var msg: Dictionary = {
		"msg": "requestLeaveGameRoom" }
	_send_json_string(msg)
	
static func _send_json_string(json_object: Dictionary) -> void:
	var json_string: String = JSON.stringify(json_object)
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
	elif msg == "sendRoomItem":
		var room_id: int = json_object['roomId']
		var room_name: String = json_object['roomName']
		var room_owner: String = json_object['roomOwner']
		_singleton.room_item_received.emit(room_id, room_name, room_owner)
	elif msg == "removeRoomItem":
		var room_id: int = json_object['roomId']
		_singleton.room_item_removed.emit(room_id)
	elif msg == "leaveGameRoom":
		_singleton.kicked_from_game_room.emit()
	elif msg == "enterGameRoom":
		_singleton.entered_to_game_room.emit()
	else:
		push_error("처리되지 않은 메시지: " + msg)
			
	return true
	
