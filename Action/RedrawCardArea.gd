extends Control


const TEXTURE = preload("res://Action/RedrawCard.svg")

var _redraw_tokens := 0:
	set(val):
		_redraw_tokens = val
		queue_redraw()


func _ready():
	var _err = Events.query_playable.connect(_on_query_playable)
	_err = Events.consider_action.connect(_on_consider_action)
	_err = Events.take_action.connect(_on_take_action)
	_err = Events.receive_reward.connect(_on_receive_reward)


func _draw():
	draw_line(Vector2.ZERO, Vector2(size.x, 0), ColorPalette.PURPLE)
	draw_line(Vector2(size.x, 0), Vector2(size.x, size.y), ColorPalette.PURPLE)

	var center_y = (size.y - TEXTURE.get_size().y) / 2
	var right_edge = size.x - 20 - TEXTURE.get_size().x
	for index in range(0, _redraw_tokens):
		draw_texture(TEXTURE, 
				Vector2(right_edge - index * TEXTURE.get_size().x, center_y), 
				ColorPalette.GREY)


func _can_play() -> bool:
	return _redraw_tokens > 0


func _on_query_playable(_card_type: Array, action: Events.Action, mark_playable: Callable):
	if action != Events.Action.REDRAW:
		return

	mark_playable.call(_can_play())


func _on_consider_action(card_type: Array, action: Events.Action):
	if action != Events.Action.REDRAW:
		return

	if _can_play():
		Events.show_help.emit("Replace %s with a new card" % Cards.get_label(card_type))


func _on_take_action(_card_type: Array, action: Events.Action, card_node: Card):
	if action != Events.Action.REDRAW:
		return

	assert(_redraw_tokens > 0, "Redraw triggered but user has no redraw tokens")
	_redraw_tokens -= 1

	# Add card as child while keeping its global position
	var card_position = card_node.global_position
	add_child(card_node)
	card_node.global_position = card_position

	card_node.move_to(global_position + Vector2(0, size.y / 2))
	card_node.shrink_to_played_size()


func _on_receive_reward(reward: Reward):
	if reward is Reward.RedrawCard:
		_redraw_tokens += 1
