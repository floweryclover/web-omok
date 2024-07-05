extends Control

class_name OmokCell

signal pressed

@onready var button: Button = $Button
@onready var stone_rect: ColorRect = $StoneRect

func _ready() -> void:
	button.pressed.connect(func(): pressed.emit())
	set_color(PlayerInfoWidget.COLOR_HIDDEN)
	
func set_color(color: int) -> void:
	if color == PlayerInfoWidget.COLOR_HIDDEN:
		stone_rect.visible = false
		return
	
	if color == PlayerInfoWidget.COLOR_BLACK:
		stone_rect.set_color(Color())
	else:
		stone_rect.set_color(Color(1.0, 1.0, 1.0))
	stone_rect.visible = true