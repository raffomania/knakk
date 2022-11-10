extends Control


const TEXTURE = preload("res://Action/RedrawCard.svg")

var redraw_tokens := 0:
	set(val):
		redraw_tokens = val
		queue_redraw()


func _ready():
	var _err = Events.consider_action.connect(_on_consider_action)
	_err = Events.take_action.connect(_on_take_action)
	_err = Events.receive_reward.connect(_on_receive_reward)


func _draw():
	draw_line(Vector2.ZERO, Vector2(size.x, 0), ColorPalette.PURPLE)
	draw_line(Vector2(size.x, 0), Vector2(size.x, size.y), ColorPalette.PURPLE)

	var center_y = (size.y - TEXTURE.get_size().y) / 2
	var right_edge = size.x - 20 - TEXTURE.get_size().x
	for index in range(0, redraw_tokens):
		draw_texture(TEXTURE, Vector2(right_edge - index * TEXTURE.get_size().x, center_y), ColorPalette.GREY)


func _on_consider_action(card_type: Array, action: Events.Action, mark_playable: Callable):
	if action != Events.Action.REDRAW:
		return

	var is_playable = redraw_tokens > 0
	mark_playable.call(is_playable)
	if is_playable:
		Events.show_help.emit("Replace %s with a new card" % Cards.get_label(card_type))


func _on_take_action(_card_type: Array, action: Events.Action, card_node: Card):
	if action != Events.Action.REDRAW:
		return

	assert(redraw_tokens > 0, "Redraw triggered but user has no redraw tokens")
	redraw_tokens -= 1

	# Add card as child while keeping its global position
	var card_position = card_node.global_position
	add_child(card_node)
	card_node.global_position = card_position

	card_node.move_to(global_position + Vector2(0, size.y / 2))
	card_node.shrink_to_played_size()


func _on_receive_reward(reward: Reward):
	if reward is Reward.RedrawCard:
		redraw_tokens += 1
