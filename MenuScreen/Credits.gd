extends VBoxContainer


signal back


func _ready():
	$Back.pressed.connect(func(): back.emit())
	$Text.meta_clicked.connect(_on_meta_clicked)


## When a link in the credits is clicked, open it in the browser.
func _on_meta_clicked(meta):
	OS.shell_open(str(meta))

