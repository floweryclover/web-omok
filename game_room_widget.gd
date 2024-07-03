extends Control

class_name GameRoomWidget

@onready var _header_area: Control = $HeaderArea
@onready var _board_area: AspectRatioContainer = $BoardArea
@export var header_minimum_size: int = 200

func _ready():
	_update_layout()
	get_tree().get_root().size_changed.connect(_on_screen_resized)
	
func _on_screen_resized() -> void:
	_update_layout()

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
		