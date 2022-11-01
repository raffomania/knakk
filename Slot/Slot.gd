extends Control

const MARKER_SCALE = 0.5

var color := Color.BLACK:
	set(val):
		color = val
		$Reward.color = color
		($Label as Label).add_theme_color_override("font_color", color)

## When the player fills this slot by choosing a matching card,
## we'll set this to true.
var is_played := false:
	set(val):
		is_played = val
		if is_played:
			$Marker.color = ColorPalette.GREY

var reward: Reward = Reward.Nothing.new():
	set(val):
		reward = val
		$Reward.reward = val
	get:
		return reward

var text: String = "":
	set(val):
		text = val
		$Label.text = val
	get:
		return text

var is_highlighted: bool = false:
	set(val):
		is_highlighted = val
		queue_redraw()
		if is_highlighted:
			$Marker.color = ColorPalette.GREY
			$Marker.color.a = 0.2
		elif not is_played:
			$Marker.color = null

func _ready():
	$Label.text = text
	$Reward.reward = reward

func _draw():
	var thickness = 5.0 if is_highlighted else 3.0
	# use draw_line instead of draw_rect to get antialiasing
	draw_line(Vector2(0, 0), Vector2(0, size.y), color, thickness, true)
	draw_line(Vector2(0, 0), Vector2(size.x, 0), color, thickness, true)
	draw_line(Vector2(size.x, 0), size, color, thickness, true)
	draw_line(Vector2(0, size.y), size, color, thickness, true)
