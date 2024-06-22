extends Control

class_name DisconnectedWidget

signal on_try_reconnect

@onready var _try_reconnect_button: Button = $Button

func _ready():
	_try_reconnect_button.pressed.connect(func(): on_try_reconnect.emit())
