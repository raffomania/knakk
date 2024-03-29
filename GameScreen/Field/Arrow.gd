extends Control


const END_TEXTURE = preload("res://GameScreen/Field/ArrowEnd.svg")

var is_vertical := false
var color := Color.BLACK:
	set = set_color


func _draw():
	var padding = 10
	# To preserve the aspect ratio of the arrow, it is drawn with a line 
	# and a texture for the end,
	# the end is sized to fit into the bounding box given to the arrow
	var end_dimension = size.x if is_vertical else size.y
	var end_size = Vector2.ONE * end_dimension * 0.3
	if is_vertical:
		# Rotate everything and center it on the vertical axis
		draw_set_transform(Vector2(size.x / 2, 0), PI / 2)
		draw_line(
				Vector2(padding, 0), 
				Vector2(size.y - padding - 5, 0), 
				color, 3.0)
		draw_texture_rect(END_TEXTURE, 
				Rect2(Vector2(size.y - end_size.y - padding, -end_size.x / 2), end_size), 
				false, color)
	else:
		# Center everything on the horizontal axis
		draw_set_transform(Vector2(0, size.y / 2))
		draw_line(
				Vector2(padding, 0),
				Vector2(size.x - padding - 5, 0), 
				color, 3.0)
		draw_texture_rect(END_TEXTURE, 
				Rect2(Vector2(size.x - end_size.x - padding, -end_size.y / 2), end_size), 
				false, color)


func set_color(value: Color):
	color = value
