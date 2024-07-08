extends Control

class_name LobbyWidget

@onready var _create_room_button: Button = $Header/CreateRoomButton
@onready var change_nickname_button: Button = $Header/ChangeNicknameButton
@onready var _create_room_widget: CreateRoomWidget = $CreateRoomWidget
@onready var change_nickname_widget: ChangeNicknameWidget = $ChangeNicknameWidget
@onready var _room_list: RoomList = $RoomList

func init() -> void:
	Network.get_instance().room_item_received.connect(_on_room_item_received)
	Network.get_instance().room_state_changed.connect(_on_room_state_changed)
func clear_room_list() -> void:
	_room_list.clear()

func _ready():
	_hide_create_room_widget()
	_create_room_widget.creation_cancelled.connect(_hide_create_room_widget)
	_create_room_widget.create_room_requested.connect(_on_create_room_requested)
	_create_room_button.pressed.connect(_on_create_room_pressed)
	change_nickname_widget.change_cancelled.connect(_hide_change_nickname_widget)
	change_nickname_widget.nickname_change_requested.connect(_on_change_nickname_requested)
	change_nickname_button.pressed.connect(_on_change_nickname_pressed)
	_room_list.room_pressed.connect(_on_room_item_pressed)

func _on_create_room_pressed() -> void:
	_create_room_widget.visible = true
	
func _hide_create_room_widget() -> void:
	_create_room_widget.visible = false
	
func _on_create_room_requested(room_name: String) -> void:
	_hide_create_room_widget()
	Network.create_room(room_name)

func _on_change_nickname_pressed() -> void:
	change_nickname_widget.visible = true

func _hide_change_nickname_widget() -> void:
	change_nickname_widget.visible = false

func _on_change_nickname_requested(nickname: String) -> void:
	_hide_change_nickname_widget()
	Network.change_nickname(nickname)
	
func _on_room_item_received(room_id: int, room_name: String, room_owner: String) -> void:
	_room_list.add_or_update_room_item(room_id, room_name, room_owner)
	
func _on_room_item_pressed(room_id: int) -> void:
	Network.request_join_game_room(room_id)
	
func _on_room_state_changed(room_id: int, room_state: int) -> void:
	if room_state == 0: # inactve
		_room_list.remove_room_item(room_id)