# todo change this into control?
extends Node2D

const MARKER_SCALE = 0.5
const REDRAW_TEXTURE = preload("res://Action/RedrawCard.svg")

@export var size := Vector2(50, 50):
	set(value):
		size = value
		$RewardLabel.size = size
		$Marker.size = size * MARKER_SCALE

@export var color := Color.BLACK

## When the player fills this slot by choosing a matching card,
## we'll set this to true.
var is_played := false:
	set(val):
		is_played = val
		if is_played:
			$Marker.color = ColorPalette.GREY

var reward:
	set(val):
		reward = val
		if reward is Reward.Points:
			$RewardLabel.text = str(val.points)
		elif reward is Reward.PlayAgain:
			$RewardLabel.text = "+1"
		queue_redraw()

var is_highlighted: bool = false:
	set(val):
		is_highlighted = val
		queue_redraw()
		if is_highlighted:
			$Marker.color = ColorPalette.GREY
			$Marker.color.a = 0.2
		elif not is_played:
			$Marker.color = null

func _draw():
	var thickness = 5.0 if is_highlighted else 3.0
	# use draw_line instead of draw_rect to get antialiasing
	draw_line(Vector2(0, 0), Vector2(0, size.y), color, thickness, true)
	draw_line(Vector2(0, 0), Vector2(size.x, 0), color, thickness, true)
	draw_line(Vector2(size.x, 0), size, color, thickness, true)
	draw_line(Vector2(0, size.y), size, color, thickness, true)

	if reward is Reward.RedrawCard:
		draw_texture_rect(REDRAW_TEXTURE, Rect2(size / 4, size * 2/4), false, ColorPalette.GREY)