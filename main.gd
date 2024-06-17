extends Node

@onready var websocket_manager: WebSocketManager = $WebSocketManager
@onready var packet_manager: PacketManager = $PacketManager
@export var lobby_scene: PackedScene
@export var websocket_server_url: String

func _ready():
	websocket_manager.websocket_connected.connect(_on_websocket_connected)
	websocket_manager.websocket_disconnected.connect(_on_websocket_disconnected)
	websocket_manager.connect_to_server(websocket_server_url)
	packet_manager.websocket_message_send_requested.connect(websocket_manager.send_string)
	
func _on_websocket_disconnected(code: int, reason: String) -> void:
	print("Disconnected from server, code: %d, reason: %s" % [code, reason])
	
func _on_websocket_connected():
	var lobby = lobby_scene.instantiate()
	self.add_child(lobby)
	lobby.packet_manager = packet_manager
