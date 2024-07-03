extends Node

@onready var _websocket_manager: WebSocketManager = $WebSocketManager
@onready var _network: Network = $Network
@onready var _disconnected_widget: DisconnectedWidget = $DisconnectedWidget
@onready var _lobby_widget: LobbyWidget = $LobbyWidget
@onready var _flash_message_widget: FlashMessageWidget = $FlashMessageWidget
@onready var _game_room_widget: GameRoomWidget = $GameRoomWidget
@export var websocket_server_url: String

enum {
	SCENE_DISCONNECTED,
	SCENE_LOBBY,
	SCENE_GAME_ROOM,
}

func _ready():
	Network.init(_network)
	FlashMessageWidget.init(_flash_message_widget)
	_websocket_manager.websocket_connected.connect(_on_websocket_connected)
	_websocket_manager.websocket_disconnected.connect(_on_websocket_disconnected)
	_network.websocket_message_send_requested.connect(_websocket_manager.send_string)
	_network.entered_to_game_room.connect(_on_game_room_entered)
	_network.kicked_from_game_room.connect(_on_game_room_left)
	_disconnected_widget.reconnect_tried.connect(_connect_to_server)
	
	_lobby_widget.init()
	_connect_to_server()
	
func _connect_to_server() -> bool:
	_disconnected_widget.visible = false
	return _websocket_manager.connect_to_server(websocket_server_url)
	
func _on_websocket_disconnected(code: int, reason: String) -> void:
	_switch_scene(SCENE_DISCONNECTED)
	print("서버와의 연결이 해제되었습니다: 코드: %d, 내용: %s" % [code, reason])

func _on_websocket_connected() -> void:
	_switch_scene(SCENE_LOBBY)
	Network.request_all_room_datas()

func _on_game_room_entered() -> void:
	_switch_scene(SCENE_GAME_ROOM)	
func _on_game_room_left() -> void:
	_switch_scene(SCENE_LOBBY)
	
func _switch_scene(new_scene: int) -> void:
	if new_scene == SCENE_DISCONNECTED:
		_lobby_widget.visible = false
		_lobby_widget.clear_room_list()
		_disconnected_widget.visible = true
		_game_room_widget.visible = false
	elif new_scene == SCENE_LOBBY:
		_lobby_widget.visible = true
		_disconnected_widget.visible = false
		_game_room_widget.visible = false
	elif new_scene == SCENE_GAME_ROOM:
		_lobby_widget.visible = false
		_disconnected_widget.visible = false
		_game_room_widget.visible = true