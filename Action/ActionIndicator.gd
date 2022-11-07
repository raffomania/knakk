extends Label

func _ready():
	var _err = Events.show_help.connect(_set_text)

	text = ""

func _set_text(message: String) -> void:
	text = message