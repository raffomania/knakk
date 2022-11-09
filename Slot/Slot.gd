class_name Slot
extends Control

var color := Color.BLACK:
	set(val):
		color = val
		$Reward.color = color
		($Label as Label).add_theme_color_override("font_color", color)

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
		else:
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


func fill_with_card(card_node: Card) -> void:
	# Add card as child while keeping its global position
	var card_position = card_node.global_position
	add_child(card_node)
	card_node.global_position = card_position

	card_node.move_to(global_position + size / 2)
	card_node.shrink_to_played_size()