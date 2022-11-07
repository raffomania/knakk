extends Control

var play_again_tokens := 0:
	set(val):
		play_again_tokens = val
		queue_redraw()

func _ready():
	var _err = Events.consider_action.connect(_consider_action)
	_err = Events.choose_card.connect(_choose_card)
	_err = Events.receive_reward.connect(_receive_reward)

func _consider_action(_card_type: Array, action: Events.Action, mark_playable: Callable) -> void:
	if action != Events.Action.PLAY_AGAIN:
		return

	var is_playable = play_again_tokens > 0
	mark_playable.call(is_playable)

func _choose_card(_card_type: Array, action: Events.Action, card_node: Card) -> void:
	if action != Events.Action.PLAY_AGAIN:
		return

	assert(play_again_tokens > 0, "PlayAgain triggered but user has no play again tokens")
	play_again_tokens -= 1

	# Add card as child while keeping its global position
	var card_position = card_node.global_position
	add_child(card_node)
	card_node.global_position = card_position

	card_node.move_to(global_position + Vector2(size.x, size.y / 2))
	card_node.shrink_to_played_position()

func _receive_reward(reward: Reward) -> void:
	if reward is Reward.PlayAgain:
		play_again_tokens += 1

func _draw():
	draw_line(Vector2.ZERO, Vector2(size.x, 0), ColorPalette.PURPLE)
	draw_line(Vector2.ZERO, Vector2(0, size.y), ColorPalette.PURPLE)

	for index in range(0, play_again_tokens):
		draw_string(
			get_theme_default_font(), 
			Vector2(20 + index * 40, 70), 
			"++", 0, -1, 
			round(get_theme_default_font_size() * 1.3), 
			get_theme_color("Label"))
