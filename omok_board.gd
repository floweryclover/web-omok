extends Control

class_name OmokBoard

@onready var omok_cell_class: PackedScene = load("res://omok_cell.tscn")
@onready var cell_container: GridContainer = $CellContainer
var _cells: Array = []

func init() -> void:
	for row in range(15):
		_cells.append([])
		for column in range(15):
			var new_cell: OmokCell = omok_cell_class.instantiate()
			new_cell.pressed.connect(func(): _on_cell_clicked(row, column))
			_cells[row].append(new_cell)
			cell_container.add_child(new_cell)
			
	update_cells_size()
	Network.get_instance().stone_placed.connect(_on_server_stone_placed)
	
func update_cells_size() -> void:
	var board_size: float = self.size.x
	var cell_size: float = board_size / 15.0
	
	for row in range(15):
		for column in range(15):
			(_cells[row][column] as OmokCell).custom_minimum_size = Vector2(cell_size, cell_size)
			
func _on_cell_clicked(row: int, column: int) -> void:
	Network.place_stone(row, column)
	
func _on_server_stone_placed(color: int, row: int, column: int) -> void:
	_cells[row][column].set_color(color)
