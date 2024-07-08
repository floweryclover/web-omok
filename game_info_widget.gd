extends Control

class_name GameInfoWidget

signal game_start_button_pressed
signal leave_room_button_pressed

@onready var my_info_widget: PlayerInfoWidget = $PlayerInfoArea/MyInfo
@onready var opponent_info_widget: PlayerInfoWidget = $PlayerInfoArea/OpponentInfo
@onready var room_name_label: Label = $RoomNameLabel
@onready var game_message_label: Label = $GameMessageLabel
@onready var game_start_button: Button = $GameStartButton
@onready var leave_room_button: Button = $LeaveRoomButton

func _ready():
	game_start_button.pressed.connect(func(): game_start_button_pressed.emit())
	leave_room_button.pressed.connect(func(): leave_room_button_pressed.emit())

func init():
	pass
	
func show_game_start_button() -> void:
	game_start_button.visible = true
	
func hide_game_start_button() -> void:
	game_start_button.visible = false
	
func set_room_owner(is_me: bool) -> void:
	my_info_widget.set_is_owner(is_me)
	opponent_info_widget.set_is_owner(!is_me)
	
func update_room_name(new_name: String) -> void:
	room_name_label.text = new_name
	room_name_label.visible = true
	
func update_my_nickname(new_my_name: String) -> void:
	my_info_widget.set_player_name(new_my_name)
	my_info_widget.visible = !new_my_name.is_empty()

func update_opponent_nickname(new_opponent_name: String) -> void:
	opponent_info_widget.set_player_name(new_opponent_name)
	opponent_info_widget.visible = !new_opponent_name.is_empty()
	
func set_my_color(my_color: int) -> void:
	if my_color == PlayerInfoWidget.COLOR_HIDDEN:
		my_info_widget.set_stone_color(PlayerInfoWidget.COLOR_HIDDEN)
		opponent_info_widget.set_stone_color(PlayerInfoWidget.COLOR_HIDDEN)
	elif my_color == PlayerInfoWidget.COLOR_BLACK:
		my_info_widget.set_stone_color(PlayerInfoWidget.COLOR_BLACK)
		opponent_info_widget.set_stone_color(PlayerInfoWidget.COLOR_WHITE)
	else:
		my_info_widget.set_stone_color(PlayerInfoWidget.COLOR_WHITE)
		opponent_info_widget.set_stone_color(PlayerInfoWidget.COLOR_BLACK)
		
func set_game_message_label(message: String) -> void:
	game_message_label.text = message
