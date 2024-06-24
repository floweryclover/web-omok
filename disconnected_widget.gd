extends Control

class_name DisconnectedWidget

signal reconnect_tried

@onready var _try_reconnect_button: Button = $Button

func _ready():
	_try_reconnect_button.pressed.connect(func(): reconnect_tried.emit())
