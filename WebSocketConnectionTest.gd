extends Button

@export var websocket_url: String;

var _client = WebSocketPeer.new()

func _ready():
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		push_error("Unable to connect")
		set_process(false)
		return
	set_process(true)

func _process(_delta: float):
	_client.poll()
	var state = _client.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while _client.get_available_packet_count():
			var raw = _client.get_packet()
			print("Server:" + raw.get_string_from_utf8())
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = _client.get_close_code()
		var reason = _client.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.
