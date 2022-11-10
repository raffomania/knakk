extends Control


var play_again_tokens := 0:
	set(val):
		play_again_tokens = val
		queue_redraw()


func _ready():
	var _err = Events.consider_action.connect(_on_consider_action)
	_err = Events.take_action.connect(_on_take_action)
	_err = Events.receive_reward.connect(_on_receive_reward)


func _draw():
	draw_line(Vector2.ZERO, Vector2(size.x, 0), ColorPalette.PURPLE)
	draw_line(Vector2.ZERO, Vector2(0, size.y), ColorPalette.PURPLE)

	for index in range(0, play_again_tokens):
		draw_string(
			get_theme_default_font(), 
			Vector2(20 + index * 55, 70), 
			"++", 0, -1, 
			round(get_theme_default_font_size() * 1.3), 
			get_theme_color("Label"))


func _on_consider_action(_card_type: Array, action: Events.Action, mark_playable: Callable):
	if action != Events.Action.PLAY_AGAIN:
		return

	var hand_is_full = len(Events.card_types_in_hand) == 3
	var is_playable = play_again_tokens > 0 and hand_is_full
	mark_playable.call(is_playable)
	if is_playable:
		Events.show_help.emit("Duplicate other cards in your hand")
	elif not hand_is_full:
		Events.show_help.emit("You can only duplicate at the start of a turn")


func _on_take_action(_card_type: Array, action: Events.Action, card_node: Card):
	if action != Events.Action.PLAY_AGAIN:
		return

	assert(play_again_tokens > 0, "PlayAgain triggered but user has no play again tokens")
	play_again_tokens -= 1

	# Add card as child while keeping its global position
	var card_position = card_node.global_position
	add_child(card_node)
	card_node.global_position = card_position

	card_node.move_to(global_position + Vector2(size.x, size.y / 2))
	card_node.shrink_to_played_size()


func _on_receive_reward(reward: Reward):
	if reward is Reward.PlayAgain:
		play_again_tokens += 1
