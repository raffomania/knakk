extends Control


const START_TEXTURE = preload("res://Field/ArrowStart.svg")
const END_TEXTURE = preload("res://Field/ArrowEnd.svg")

var text: String
var is_vertical := false
var color := Color.BLACK:
	set = set_color

		
@onready var label = $Label


func _ready():
	if is_instance_valid(label):
		label.add_theme_color_override("font_color", color)
	label.size = size
	label.text = text


func _draw():
	# To preserve the aspect ratio of the arrow, it is drawn in two parts, 
	# each with a square size that scales to fit the overall arrow bounding box
	var part_size = Vector2.ONE * min(size.x, size.y) * 0.4
	if is_vertical:
		# Draw parts centered on the vertical axis and rotate them
		draw_set_transform(Vector2((size.x + part_size.x) / 2, 0), PI / 2)
		draw_texture_rect(START_TEXTURE, Rect2(Vector2(0, 0), part_size), false)
		draw_texture_rect(END_TEXTURE, Rect2(Vector2(size.y - part_size.y, 0), part_size), false)
	else:
		# Draw parts centered on the horizontal axis
		draw_texture_rect(START_TEXTURE, Rect2(Vector2(0, (size.y - part_size.y) / 2), part_size), false)
		draw_texture_rect(END_TEXTURE, Rect2(Vector2(size.x - part_size.x, (size.y - part_size.y) / 2), part_size), false)


func set_color(value: Color):
	color = value

	if is_instance_valid(label):
		label.add_theme_color_override("font_color", color)
