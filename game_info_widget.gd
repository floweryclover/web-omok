extends Control

class_name GameInfoWidget

@onready var my_info: PlayerInfoWidget = $PlayerInfoArea/MyInfo
@onready var opponent_info: PlayerInfoWidget = $PlayerInfoArea/OpponentInfo
@onready var room_name_label: Label = $RoomNameLabel

func init():
	Network.get_instance().room_info_updated.connect(update_game_info)
	room_name_label.visible = false
	my_info.visible = false
	opponent_info.visible = false
	
func update_game_info(room_name: String, my_nickname: String, my_color: int, opponent_nickname: String, opponent_color: int, is_owner: bool) -> void:
	room_name_label.text = room_name
	room_name_label.visible = true
	
	my_info.set_is_owner(is_owner)
	opponent_info.set_is_owner(!is_owner)
	
	if opponent_nickname.is_empty():
		opponent_info.visible = false
	else:
		opponent_info.set_stone_color(opponent_color)
		opponent_info.set_name(opponent_nickname)
		opponent_info.visible = true
	
	my_info.set_stone_color(my_color)
	my_info.set_name(my_nickname)
	my_info.visible = true