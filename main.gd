extends Node

@export var websocket_manager_scene: PackedScene
@export var websocket_server_url: String
var websocket_manager: WebSocketManager

func _ready():
	websocket_manager = websocket_manager_scene.instantiate()
	self.add_child(websocket_manager)
	websocket_manager.websocket_connected.connect(_on_websocket_connected)
	websocket_manager.websocket_disconnected.connect(_on_websocket_disconnected)
	websocket_manager.connect_to_server(websocket_server_url)
	
func _on_websocket_disconnected(code: int, reason: String) -> void:
	print("Disconnected from server, code: %d, reason: %s" % [code, reason])
	
func _on_websocket_connected():
	print("Connected to server")
