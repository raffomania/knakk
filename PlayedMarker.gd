extends Control

var color: Variant = null:
	set(val):
		color = val
		queue_redraw()

func _draw():
	if color != null:
		draw_rect(Rect2(size / 2, size), color)
