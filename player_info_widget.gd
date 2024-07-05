extends Control

class_name PlayerInfoWidget

@onready var stone_color: ColorRect = $LeftArea/StoneColor
@onready var nickname_label: Label = $RightArea/NicknameLabel
var _saved_nickname: String = ""

enum {
	COLOR_BLACK,
	COLOR_WHITE,
	COLOR_HIDDEN
}	

func _ready():
	stone_color.visible = false
	nickname_label.visible = false
	
func set_stone_color(color: int) -> void:
	if color == COLOR_HIDDEN:
		stone_color.visible = false
		return
		
	if color == COLOR_BLACK:
		stone_color.color = Color()
	else:
		stone_color.color = Color(1.0, 1.0, 1.0)
	stone_color.visible = true
	
func set_player_name(name: String) -> void:
	nickname_label.text = name
	nickname_label.visible = true
	_saved_nickname = name
	
func set_is_owner(is_owner: bool) -> void:
	if is_owner:
		nickname_label.text = _saved_nickname + " (방장)"
	else:
		nickname_label.text = _saved_nickname