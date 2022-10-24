extends Node2D

class_name Slot

@onready var label := $Label

@export var size := Vector2(50, 50):
	set(value):
		size = value
		if is_instance_valid(label):
			label.size = size

@export var color := Color.BLACK

func _ready():
	label.size = size

func _draw():
	# use draw_line instead of draw_box to get antialiasing
	draw_line(Vector2(0, 0), Vector2(0, size.y), color, 2.0, true)
	draw_line(Vector2(0, 0), Vector2(size.x, 0), color, 2.0, true)
	draw_line(Vector2(size.x, 0), size, color, 2.0, true)
	draw_line(Vector2(0, size.y), size, color, 2.0, true)
