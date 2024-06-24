extends Node

@onready var _websocket_manager: WebSocketManager = $WebSocketManager
@onready var _packet_manager: PacketManager = $PacketManager
@onready var _disconnected_widget: DisconnectedWidget = $DisconnectedWidget
@onready var _lobby_widget: LobbyWidget = $LobbyWidget
@onready var _flash_message_widget: FlashMessageWidget = $FlashMessageWidget
@export var websocket_server_url: String

func _ready():
	_lobby_widget.packet_manager = _packet_manager
	_websocket_manager.websocket_connected.connect(_on_websocket_connected)
	_websocket_manager.websocket_disconnected.connect(_on_websocket_disconnected)
	_packet_manager.websocket_message_send_requested.connect(_websocket_manager.send_string)
	_disconnected_widget.reconnect_tried.connect(_connect_to_server)
	FlashMessageWidget.init(_flash_message_widget)
	
	_connect_to_server()
	
func _connect_to_server() -> bool:
	return _websocket_manager.connect_to_server(websocket_server_url)
	
func _on_websocket_disconnected(code: int, reason: String) -> void:
	print("서버와의 연결이 해제되었습니다: 코드: %d, 내용: %s" % [code, reason])
	_disconnected_widget.visible = true
	_lobby_widget.visible = false

func _on_websocket_connected():
	_disconnected_widget.visible = false
	_lobby_widget.visible = true
