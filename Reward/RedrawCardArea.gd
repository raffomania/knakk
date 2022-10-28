extends Control

var play_again_count := 0

var TEXTURE = preload("res://Reward/RedrawCard.svg")

func _draw():
	draw_line(Vector2.ZERO, Vector2(size.x, 0), ColorPalette.PURPLE)
	draw_line(Vector2(size.x, 0), Vector2(size.x, size.y), ColorPalette.PURPLE)

	var center_y = (size.y - TEXTURE.get_size().y) / 2
	for index in range(0, play_again_count):
		draw_texture(TEXTURE, Vector2(index * TEXTURE.get_size().x, center_y))

func add_one():
	play_again_count += 1
	queue_redraw()
