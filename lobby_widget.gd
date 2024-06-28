extends Control

class_name LobbyWidget

@onready var _create_room_button: Button = $Header/CreateRoomButton
@onready var _create_room_widget: CreateRoomWidget = $CreateRoomWidget
@onready var _room_list: RoomList = $RoomList

func init() -> void:
	Network.get_instance().room_item_received.connect(_on_room_item_received)
	Network.get_instance().room_item_removed.connect(_on_room_item_removed)

func _ready():
	_hide_create_room_widget()
	_create_room_widget.creation_cancelled.connect(_hide_create_room_widget)
	_create_room_widget.create_room_requested.connect(_on_create_room_requested)
	_create_room_button.pressed.connect(_on_create_room_pressed)

func _on_create_room_pressed() -> void:
	_create_room_widget.visible = true
	
func _hide_create_room_widget() -> void:
	_create_room_widget.visible = false
	
func _on_create_room_requested(room_name: String) -> void:
	_hide_create_room_widget()
	Network.create_room(room_name)
	
func _on_room_item_received(room_id: int, room_name: String, room_owner: String) -> void:
	_room_list.add_or_update_room_item(room_id, room_name, room_owner)
	
func _on_room_item_removed(room_id: int) -> void:
	_room_list.remove_room_item(room_id)
	