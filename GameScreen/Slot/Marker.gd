extends Control

var color: Variant = null:
	set(val):
		color = val
		queue_redraw()


func _draw():
	if color != null:
		draw_rect(Rect2(Vector2.ZERO, size), color)
