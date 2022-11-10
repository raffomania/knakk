extends Control


const TURN_SIZE := 45

var completed_turns := 0:
	set = set_completed_turns


func _draw():
	draw_rect(Rect2(Vector2.ZERO, size), ColorPalette.GREY, false, 3.0)

	for i in range(0, 5):
		draw_line(Vector2(i * TURN_SIZE, 0), Vector2(i * TURN_SIZE, size.y), ColorPalette.GREY)
	
	for i in range(0, completed_turns):
		var padding = TURN_SIZE / 4.0
		draw_rect(Rect2(Vector2(i * TURN_SIZE + padding, padding), Vector2(TURN_SIZE - padding * 2, TURN_SIZE - padding * 2)), ColorPalette.GREY, true)


func set_completed_turns(value: int):
	completed_turns = value

	queue_redraw()

	if completed_turns >= 5:
		Events.round_complete.emit()


func _get_minimum_size() -> Vector2:
	return Vector2(TURN_SIZE * 5, TURN_SIZE)
