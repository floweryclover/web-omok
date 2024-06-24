extends Node

class_name WebSocketManager

signal websocket_disconnected(code: int, reason: String)
signal websocket_connected

var _websocket: WebSocketPeer = null
var _is_new_connection: bool = true

const MAX_MESSAGE_SIZE: int = 256

func connect_to_server(url: String) -> bool:
	if _websocket != null:
		var state: int = _websocket.get_ready_state()
		if state != WebSocketPeer.STATE_CLOSED:
			if state == WebSocketPeer.STATE_OPEN:
				push_warning("이미 접속되어 있습니다.")
			else:
				push_warning("웹소켓이 준비되지 않았습니다.")
			return false
	else:
		_websocket = WebSocketPeer.new()
		
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
			var message: String = _websocket.get_packet().get_string_from_utf8()
			if Network.handle_message(message) == false:
				push_error("메시지 처리 중 에러가 발생하였습니다.")
				_websocket.close(-1, "메시지 처리 중 에러가 발생하였습니다.")
				return
	elif state == WebSocketPeer.STATE_CLOSING:
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code: int = _websocket.get_close_code()
		var reason: String = _websocket.get_close_reason()
		websocket_disconnected.emit(code, reason)
		_websocket = null
		set_process(false)
	
func is_connected_to_server() -> bool:
	return _websocket.get_ready_state() == WebSocketPeer.STATE_OPEN
	
func send_string(string: String) -> void:
	if !is_connected_to_server():
		return
	if string.length() > MAX_MESSAGE_SIZE:
		var error_message: String = "메시지 크기가 최대 크기 {max}byte를 초과합니다: {current}".format({"max":MAX_MESSAGE_SIZE, "current": string.length()})
		push_error(error_message)
		_websocket.close(-1, error_message)
		return
	_websocket.send_text(string)
