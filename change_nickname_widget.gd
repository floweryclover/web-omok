extends Control

class_name ChangeNicknameWidget

signal nickname_change_requested(room_name: String)
signal change_cancelled

@onready var _change_button: Button = $ButtonArea/ChangeButton
@onready var _cancel_button: Button = $ButtonArea/CancelButton
@onready var _nickname_text_edit: TextEdit = $NicknameEnterArea/TextEdit

func _ready():
	_change_button.pressed.connect(_on_change_button_pressed)
	_cancel_button.pressed.connect(_on_cancel_button_pressed)

func _on_change_button_pressed():
	var entered_nickname: String = _nickname_text_edit.text
	_nickname_text_edit.clear()
	nickname_change_requested.emit(entered_nickname)

func _on_cancel_button_pressed() -> void:
	change_cancelled.emit()
	


