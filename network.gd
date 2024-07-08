extends Node

class_name Network

signal websocket_message_send_requested(message: String)

signal room_item_received(room_id: int, room_name: String, room_owner: String)
signal kicked_from_game_room
signal entered_to_game_room(room_id: int)
signal stone_placed(color: int, row: int, column: int)
signal room_state_changed(room_id: int, room_state_number: int)
signal ownership_updated(is_owner: bool)
signal stone_color_updated(my_color: int)
signal current_room_name_updated(room_name: String)
signal my_name_updated(my_name: String)
signal opponent_name_updated(opponent_name: String)
signal game_message_received(message: String)

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
	
static func place_stone(row: int, column: int) -> void:
	var msg: Dictionary = {
		"msg": "placeStone",
		"row": row,
		"column": column }
	_send_json_string(msg)
	
static func start_game() -> void:
	var msg: Dictionary = {
		"msg": "startGame" }
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
	elif msg == "kickedFromGameRoom":
		_singleton.kicked_from_game_room.emit()
	elif msg == "enterGameRoom":
		var room_id: int = json_object['roomId']
		_singleton.entered_to_game_room.emit(room_id)
	elif msg == "placeStone":
		var color: int = convert_color(json_object['stoneColorNumber'])
		var row: int = json_object['row']
		var column: int = json_object['column']
		_singleton.stone_placed.emit(color, row, column)
	elif msg == "updateRoomState":
		var room_id: int = json_object['roomId']
		var room_state_number: int = json_object['roomStateNumber']
		_singleton.room_state_changed.emit(room_id, room_state_number)
	elif msg == "updateOwnership":
		var is_owner: bool = json_object['isOwner']
		_singleton.ownership_updated.emit(is_owner)
	elif msg == "updateStoneColor":
		var my_color: int = convert_color(json_object['myColorNumber'])
		_singleton.stone_color_updated.emit(my_color)
	elif msg == "updateCurrentRoomName":
		var room_name: String = json_object['roomName']
		_singleton.current_room_name_updated.emit(room_name)
	elif msg == "updateMyName":
		var my_name: String = json_object['myName']
		_singleton.my_name_updated.emit(my_name)
	elif msg == "updateOpponentName":
		var opponent_name: String = json_object['opponentName']
		_singleton.opponent_name_updated.emit(opponent_name)
	elif msg == "gameMessage":
		var game_message: String = json_object['message']
		_singleton.game_message_received.emit(game_message)
	else:
		push_error("처리되지 않은 메시지: " + msg)
	return true
	
static func convert_color(color_number: int) -> int:
	var return_value: int = 0
	if color_number == 0:
		return_value = PlayerInfoWidget.COLOR_BLACK
	elif color_number == 1:
		return_value =  PlayerInfoWidget.COLOR_WHITE
	else:
		return_value =  PlayerInfoWidget.COLOR_HIDDEN
	return return_value
