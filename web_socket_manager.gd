extends Node

class_name WebSocketManager

signal websocket_disconnected(code: int, reason: String)
signal websocket_connected

var _websocket = WebSocketPeer.new()

func connect_to_server(url: String) -> void:
	if is_connected_to_server():
		push_warning("이미 서버에 접속되어 있습니다.")
		return
		
	var err = _websocket.connect_to_url(url)
	if err != OK:
		push_error(url + " 서버에 접속할 수 없습니다.")
		websocket_disconnected.emit(0, "서버에 접속할 수 없습니다.")
		set_process(false)
		return
	set_process(true)
	websocket_connected.emit()

func _process(_delta: float):
	_websocket.poll()
	var state = _websocket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while _websocket.get_available_packet_count():
			var raw = _websocket.get_packet()
			print("Server:" + raw.get_string_from_utf8())
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = _websocket.get_close_code()
		var reason = _websocket.get_close_reason()
		websocket_disconnected.emit(code, reason)
		set_process(false) # Stop processing.
	
func is_connected_to_server() -> bool:
	return _websocket.get_ready_state() == WebSocketPeer.STATE_OPEN
	
func send_string(string: String) -> void:
	if !is_connected_to_server():
		return
	_websocket.send_text(string)
