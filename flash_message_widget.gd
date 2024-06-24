extends Control

class_name FlashMessageWidget

@onready var _background: ColorRect = $Background
@onready var _text: Label = $Text
var _last_flash_time: int
static var singleton: FlashMessageWidget = null

const FLASH_TIME: int = 5000

enum {
	FLASH_INFO,
	FLASH_WARNING,
	FLASH_ERROR,
}

func _ready():
	_text.text = ""
	_background.color.r = 255
	_background.color.g = 0
	_background.color.b = 0
	_background.color.a = 0
	
func _process(delta: float) -> void:
	var current_time: int = Time.get_ticks_msec()
	if current_time >= _last_flash_time + FLASH_TIME:
		visible = false
		set_process(false)
		
static func init(instance: FlashMessageWidget) -> void:
	singleton = instance
		
static func flash(message: String, flash_type: int) -> void:
	if singleton == null:
		return
		
	singleton._text.text = message
	
	if flash_type == FLASH_INFO:
		singleton._background.set_color(Color(0.4509804, 0.60784316, 0.90588236))
	elif flash_type == FLASH_WARNING:
		singleton._background.set_color(Color(1.0, 0.7529412, 0.31764707))
	else:
		singleton._background.set_color(Color(0.9019608, 0.18039216, 0.18039216))
	singleton.set_process(true)
	singleton.visible = true
	singleton._last_flash_time = Time.get_ticks_msec()
		
