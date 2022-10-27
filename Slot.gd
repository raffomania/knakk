# todo change this into control?
extends Node2D

class_name Slot

@export var size := Vector2(50, 50):
	set(value):
		size = value
		$Label.size = size

@export var color := Color.BLACK

const HIGHLIGHT_SCALE = 1.15
const PLAYED_MARKER_SCALE = 0.5

const PLAYED_MARKER_SCENE = preload("res://PlayedMarker.tscn")

## When the player fills this slot by choosing a matching card,
## we'll set this to true.
## This is for the visual indicator only. The logic around filling slots
## is handled in the `Diamonds` node.
var is_played := false:
	set(val):
		is_played = val
		if is_played:
			var marker = PLAYED_MARKER_SCENE.instantiate()
			marker.size = size * PLAYED_MARKER_SCALE
			add_child(marker)

var text: String:
	set(val):
		$Label.text = val
	get:
		return $Label.text

var is_highlighted: bool = false:
	set(val):
		is_highlighted = val
		queue_redraw()

func _draw():
	if is_highlighted:
		draw_rect(Rect2(size * PLAYED_MARKER_SCALE * 0.5, size * PLAYED_MARKER_SCALE), ColorPalette.GREY.lightened(0.8))

	# use draw_line instead of draw_rect to get antialiasing
	draw_line(Vector2(0, 0), Vector2(0, size.y), color, 2.0, true)
	draw_line(Vector2(0, 0), Vector2(size.x, 0), color, 2.0, true)
	draw_line(Vector2(size.x, 0), size, color, 2.0, true)
	draw_line(Vector2(0, size.y), size, color, 2.0, true)