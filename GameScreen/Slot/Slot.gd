class_name Slot
extends Control


const SIZE = 100
const TEXTURE = preload("res://GameScreen/Slot/Slot.svg")

var color := Color.BLACK:
	set = set_color
var reward: Reward = Reward.Nothing.new():
	set = set_reward
var text := "":
	set = set_text
var is_highlighted := false:
	set = set_is_highlighted
var _filled_number: Variant = null
var _bg_anim_factor := 0.0:
	set = _set_bg_anim_factor

var _scale_tween: Variant


func _ready():
	# Always scale and rotate around the center
	pivot_offset = size / 2

	$Label.text = text
	$Reward.reward = reward


func _draw():
	# Draw white background to hide cards that might
	# lie behind this
	var bg_size = Vector2.ONE * size * 0.85
	bg_size.y *= _bg_anim_factor
	draw_rect(Rect2(size * 0.075, bg_size), color)

	# Draw colored outline
	draw_texture_rect(TEXTURE, Rect2(Vector2.ZERO, size), false, color)

func set_color(value: Color):
	color = value
	$Reward.color = color
	($Label as Label).add_theme_color_override("font_color", color)


func set_reward(value: Reward):
	reward = value
	$Reward.reward = value


func get_reward_node() -> RewardMarker:
	return $Reward


func set_text(value: String):
	text = value
	$Label.text = value


func _set_bg_anim_factor(value: float):
	_bg_anim_factor = value
	queue_redraw()


func set_is_highlighted(value: bool):
	is_highlighted = value

	queue_redraw()

	if _scale_tween:
		_scale_tween.kill()

	if is_highlighted:
		_scale_tween = create_tween()
		_scale_tween.set_ease(Tween.EASE_OUT) \
				.tween_property(self, "scale", Vector2.ONE * 1.2, 0.1)
	else:
		_scale_tween = create_tween()
		_scale_tween.tween_property(self, "scale", Vector2.ONE, 0.05)


func fill_with_card(card_node: Card):
	# Add card as child while keeping its global position
	var card_position = card_node.global_position
	add_child(card_node)
	card_node.global_position = card_position

	card_node.move_to(global_position + size / 2)
	card_node.shrink_to_played_size()

	await get_tree().create_timer(0.4).timeout

	card_node.z_as_relative = true
	card_node.z_index = -1

	_filled_number = card_node.card_type[1]
	set_text(Cards.get_number_sigil(_filled_number))
	($Label as Label).add_theme_color_override("font_color", ColorPalette.WHITE)

	_bg_anim_factor = 0
	var bg_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	bg_tween.tween_property(self, "_bg_anim_factor", 1.0, 0.4)
	await bg_tween.finished

	card_node.queue_free()


func _get_minimum_size():
	return Vector2(SIZE, SIZE)
