extends Control

class_name CreateRoomWidget

signal create_room_requested(room_name: String)
signal creation_cancelled

@onready var _create_button: Button = $ButtonArea/CreateButton
@onready var _cancel_button: Button = $ButtonArea/CancelButton
@onready var _room_name_text_edit: TextEdit = $RoomNameEnterArea/TextEdit

func _ready():
	_create_button.pressed.connect(_on_create_room_button_pressed)
	_cancel_button.pressed.connect(_on_cancel_button_pressed)
	
func _on_create_room_button_pressed():
	var entered_room_name: String = _room_name_text_edit.text
	_room_name_text_edit.clear()
	create_room_requested.emit(entered_room_name)
	
func _on_cancel_button_pressed() -> void:
	creation_cancelled.emit()
	


