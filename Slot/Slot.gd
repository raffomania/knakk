class_name Slot
extends Control


var color := Color.BLACK:
	set = set_color
var reward: Reward = Reward.Nothing.new():
	set = set_reward
var text := "":
	set = set_text
var is_highlighted := false:
	set = set_is_highlighted


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


func set_color(value: Color):
		color = value
		$Reward.color = color
		($Label as Label).add_theme_color_override("font_color", color)


func set_reward(value: Reward):
	reward = value
	$Reward.reward = value


func set_text(value: String):
	text = value
	$Label.text = value


func set_is_highlighted(value: bool):
	is_highlighted = value

	queue_redraw()

	if is_highlighted:
		$Marker.color = ColorPalette.GREY
		$Marker.color.a = 0.2
	else:
		$Marker.color = null


func fill_with_card(card_node: Card):
	# Add card as child while keeping its global position
	var card_position = card_node.global_position
	add_child(card_node)
	card_node.global_position = card_position

	card_node.move_to(global_position + size / 2)
	card_node.shrink_to_played_size()
