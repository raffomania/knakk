extends Label


func _ready():
	var _err = Events.show_help.connect(_on_set_text)

	text = ""


func _on_set_text(message: String):
	text = message
