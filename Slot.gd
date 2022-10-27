# todo change this into control?
extends Node2D

class_name Slot

@export var size := Vector2(50, 50):
	set(value):
		size = value
		$Label.size = size

@export var color := Color.BLACK

## When the player fills this slot by choosing a matching card,
## we'll set this to true.
## This is for the visual indicator only. The logic around filling slots
## is handled in the `Diamonds` node.
var is_played := false:
	set(val):
		is_played = val
		queue_redraw()

var text: String:
	set(val):
		$Label.text = val
	get:
		return $Label.text

var is_highlighted: bool = false:
	set(val):
		is_highlighted = val
		if is_highlighted:
			scale = Vector2.ONE * 1.1
		else:
			scale = Vector2.ONE

func _draw():
	# use draw_line instead of draw_box to get antialiasing
	draw_line(Vector2(0, 0), Vector2(0, size.y), color, 2.0, true)
	draw_line(Vector2(0, 0), Vector2(size.x, 0), color, 2.0, true)
	draw_line(Vector2(size.x, 0), size, color, 2.0, true)
	draw_line(Vector2(0, size.y), size, color, 2.0, true)

	if is_played:
		draw_line(Vector2(0, 0), size, color, 4.0, true)
		draw_line(Vector2(size.x, 0), Vector2(0, size.y), color, 4.0, true)
