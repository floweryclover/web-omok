extends Control

class_name RoomItem

const INVALID_ROOM_ID: int = -1

@onready var _room_button_node: Button = $RoomButton
@onready var _room_name_node: Label = $RoomName
@onready var _room_owner_node: Label = $RoomOwner

var room_id: int = INVALID_ROOM_ID:
	get:
		return room_id
	set(value):
		room_id = value
		
var room_name: String:
	get:
		return _room_name_node.text
	set(value):
		_room_name_node.text = value
		
var room_owner: String:
	get:
		return _room_owner_node.text
	set(value):
		_room_owner_node.text = value

