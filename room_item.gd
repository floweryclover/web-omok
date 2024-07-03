extends Control

class_name RoomItem

signal pressed

@onready var _room_button_node: Button = $RoomButton
@onready var _room_name_node: Label = $RoomName
@onready var _room_owner_node: Label = $RoomOwner

func _ready():
	_room_name_node.text = room_name
	_room_owner_node.text = room_owner
	_room_button_node.pressed.connect(func(): pressed.emit())

var room_name: String:
	get:
		return room_name
	set(value):
		room_name = value
		if _room_name_node != null:
			_room_name_node.text = value

var room_owner: String:
	get:
		return room_owner
	set(value):
		room_owner = value
		if _room_owner_node != null:
			_room_owner_node.text = value

