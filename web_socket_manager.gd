extends Node

class_name WebSocketManager

signal websocket_disconnected(code: int, reason: String)
signal websocket_connected

var _websocket: WebSocketPeer = WebSocketPeer.new()
var _is_new_connection: bool = true

func connect_to_server(url: String) -> bool:
	var state: int = _websocket.get_ready_state()
	if state != WebSocketPeer.STATE_CLOSED:
		if state == WebSocketPeer.STATE_OPEN:
			push_warning("이미 접속되어 있습니다.")
		else:
			push_warning("웹소켓이 준비되지 않았습니다.")
		return false
		
	var err: int = _websocket.connect_to_url(url)
	if err != OK:
		push_error(url + " 서버에 접속할 수 없습니다.")
		set_process(false)
		return false
	
	set_process(true)
	_is_new_connection = true
	return true

func _process(_delta: float) -> void:
	_websocket.poll()
	var state: int = _websocket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		if _is_new_connection:
			websocket_connected.emit()
		while _websocket.get_available_packet_count():
			var raw = _websocket.get_packet()
			print("Server:" + raw.get_string_from_utf8())
	elif state == WebSocketPeer.STATE_CLOSING:
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code: int = _websocket.get_close_code()
		var reason: String = _websocket.get_close_reason()
		websocket_disconnected.emit(code, reason)
		set_process(false)
	
func is_connected_to_server() -> bool:
	return _websocket.get_ready_state() == WebSocketPeer.STATE_OPEN
	
func send_string(string: String) -> void:
	if !is_connected_to_server():
		return
	_websocket.send_text(string)
