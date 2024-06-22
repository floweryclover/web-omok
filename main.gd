extends Node

@onready var _websocket_manager: WebSocketManager = $WebSocketManager
@onready var _packet_manager: PacketManager = $PacketManager
@onready var _disconnected_widget: DisconnectedWidget = $DisconnectedWidget
@export var lobby_scene: PackedScene
@export var websocket_server_url: String
var _lobby: Lobby = null

func _ready():
	_websocket_manager.websocket_connected.connect(_on_websocket_connected)
	_websocket_manager.websocket_disconnected.connect(_on_websocket_disconnected)
	_packet_manager.websocket_message_send_requested.connect(_websocket_manager.send_string)
	_disconnected_widget.visible = false
	
func _on_websocket_disconnected(code: int, reason: String) -> void:
	print("Disconnected from server, code: %d, reason: %s" % [code, reason])
	_disconnected_widget.visible = true
	_disconnected_widget.on_try_reconnect.connect(_connect_to_server)
	if _lobby:
		self.remove_child(_lobby)

func _connect_to_server() -> void:
		_websocket_manager.connect_to_server(websocket_server_url)

func _on_websocket_connected():
	_lobby = lobby_scene.instantiate()
	self.add_child(_lobby)
	_disconnected_widget.visible = false
	_disconnected_widget.on_try_reconnect.disconnect(_connect_to_server)
	_lobby.packet_manager = _packet_manager
