extends Control

class_name Arrow

@onready var label = $Label

var text: String

var is_vertical := false

var color := Color.BLACK:
	set(value):
		color = value
		if is_instance_valid(label):
			label.add_theme_color_override("font_color", color)

func _ready():
	if is_instance_valid(label):
		label.add_theme_color_override("font_color", color)
	label.size = size
	label.text = text

# todo fix vertical drawing
# func _draw():
# 	draw_line(
# 		Vector2(0, size.y / 2),
# 		Vector2(size.x * 1/5, size.y / 2), 
# 		color, 2.0, true)
# 	draw_line(
# 		Vector2(size.x * 4/5, size.y / 2), 
# 		Vector2(size.x, size.y / 2), 
# 		color, 2.0, true)
# 	draw_line(
# 		Vector2(size.x * 9/10, size.y * 2/5), 
# 		Vector2(size.x - 2, size.y / 2), 
# 		color, 2.0, true)
# 	draw_line(Vector2(size.x * 9/10, size.y * 3/5), Vector2(size.x - 2, size.y / 2), color, 2.0, true)
