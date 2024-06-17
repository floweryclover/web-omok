extends Control

class_name Lobby

@onready var _create_room_button: Button = $Header/CreateRoomButton
var packet_manager: PacketManager
@onready var _create_room_widget: CreateRoomWidget = $CreateRoomWidget

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
	packet_manager.create_room(room_name)
