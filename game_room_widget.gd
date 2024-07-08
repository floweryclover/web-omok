extends Control

class_name GameRoomWidget

@onready var _header_area: Control = $HeaderArea
@onready var _board_area: AspectRatioContainer = $BoardArea
@onready var game_info_widget: GameInfoWidget = $HeaderArea/GameInfo
@onready var omok_board: OmokBoard = $BoardArea/OmokBoard
@export var header_minimum_size: int = 200

var _current_room_id: int = -1
var _is_player_in_room: bool = false
var _saved_room_state: int = 0
var _saved_my_nickname: String = ""
var _saved_my_color: int = PlayerInfoWidget.COLOR_HIDDEN
var _saved_opponent_nickname: String = ""
var _saved_opponent_color: int = PlayerInfoWidget.COLOR_HIDDEN
var _saved_is_owner: bool = false

func init() -> void:
	game_info_widget.init()
	omok_board.init()
	Network.get_instance().kicked_from_game_room.connect(_on_leave_room)
	Network.get_instance().entered_to_game_room.connect(_on_join_room)
	Network.get_instance().room_state_changed.connect(_on_room_state_changed)
	Network.get_instance().ownership_updated.connect(_on_ownership_changed)
	Network.get_instance().current_room_name_updated.connect(_on_room_name_updated)
	Network.get_instance().my_name_updated.connect(_on_my_name_updated)
	Network.get_instance().opponent_name_updated.connect(_on_opponent_name_updated)
	Network.get_instance().stone_color_updated.connect(_on_stone_color_updated)
	Network.get_instance().game_message_received.connect(_on_game_message_received)

func _ready():
	_update_layout()
	get_tree().get_root().size_changed.connect(_on_screen_resized)
	game_info_widget.game_start_button_pressed.connect(Network.start_game)
	game_info_widget.leave_room_button_pressed.connect(Network.request_leave_game_room)
	
func _on_screen_resized() -> void:
	if !_is_player_in_room:
		return
	_update_layout()
	omok_board.update_cells_size()

func _update_layout() -> void:
	var screen_size: Vector2i = get_tree().get_root().get_window().get_size()
	var header_size = max(header_minimum_size, screen_size.x - screen_size.y, screen_size.y - screen_size.x)
	var is_wide: bool = screen_size.x > screen_size.y
	
	if is_wide:
		_header_area.anchor_left = 0
		_header_area.anchor_top = 0
		_header_area.anchor_right = header_size*1.0 / screen_size.x
		_header_area.anchor_bottom = 1
		
		_board_area.anchor_left = _header_area.anchor_right
		_board_area.anchor_top = 0
		_board_area.anchor_right = 1
		_board_area.anchor_bottom = 1
	else:
		_header_area.anchor_left = 0
		_header_area.anchor_top = 0
		_header_area.anchor_right = 1
		_header_area.anchor_bottom = header_size*1.0 / screen_size.y
		
		_board_area.anchor_left = 0
		_board_area.anchor_top = _header_area.anchor_bottom
		_board_area.anchor_right = 1
		_board_area.anchor_bottom = 1
		
func _on_leave_room() -> void:
	_is_player_in_room = false
	game_info_widget.visible = true
	_current_room_id = -1
	
func _on_join_room(room_id: int) -> void:
	_update_layout()
	game_info_widget.visible = true
	_current_room_id = room_id
	_is_player_in_room = true
	
func _on_room_state_changed(room_id: int, new_state_number: int) -> void:
	_saved_room_state = new_state_number
	if room_id != _current_room_id:
		return
	if new_state_number != 2:
		game_info_widget.set_my_color(2)
	_update_game_start_button_visibility()
		
func _on_ownership_changed(is_owner: bool) -> void:
	_saved_is_owner = is_owner
	_update_game_start_button_visibility()
	game_info_widget.set_room_owner(is_owner)
	
func _update_game_start_button_visibility() -> void:
	if _saved_is_owner == true and _saved_room_state == 1:
		game_info_widget.show_game_start_button()
	else:
		game_info_widget.hide_game_start_button()
		
func _on_room_name_updated(new_name: String) -> void:
	game_info_widget.update_room_name(new_name)
	
func _on_my_name_updated(new_my_name: String) -> void:
	game_info_widget.update_my_nickname(new_my_name)
 
func _on_opponent_name_updated(new_opponent_name: String) -> void:
	game_info_widget.update_opponent_nickname(new_opponent_name)
	
func _on_stone_color_updated(my_color: int) -> void:
	game_info_widget.set_my_color(my_color)

func _on_game_message_received(message: String) -> void:
	game_info_widget.set_game_message_label(message)