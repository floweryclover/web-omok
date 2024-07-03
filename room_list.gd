extends Control

class_name RoomList

signal room_pressed(room_id: int)
@onready var room_list_container: BoxContainer = $RoomListContainer
@onready var room_item_scene: PackedScene = load("res://room_item.tscn")
var room_datas: Dictionary = {}

func add_or_update_room_item(room_id: int, room_name: String, room_owner) -> void:
	remove_room_item(room_id)
	var new_room_item: RoomItem = room_item_scene.instantiate()
	room_datas[room_id] = new_room_item
	new_room_item.room_name = room_name
	new_room_item.room_owner = room_owner
	new_room_item.pressed.connect(func(): room_pressed.emit(room_id))
	room_list_container.add_child(new_room_item)
	
func remove_room_item(room_id: int) -> void:
	if !room_datas.has(room_id):
		return
	room_list_container.remove_child(room_datas[room_id])
	room_datas.erase(room_id)
	
func clear() -> void:
	var room_ids: Array = room_datas.keys()
	for room_id in room_ids:
		remove_room_item(room_id)