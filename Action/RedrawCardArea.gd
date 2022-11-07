extends Control

# todo rename redraw bc of conflict with queue_redraw?

var redraw_tokens := 0:
	set(val):
		redraw_tokens = val
		queue_redraw()

var TEXTURE = preload("res://Action/RedrawCard.svg")

func _ready():
	var _err = Events.consider_action.connect(_consider_action)
	_err = Events.choose_card.connect(_choose_card)
	_err = Events.receive_reward.connect(_receive_reward)

func _consider_action(card_type: Array, action: Events.Action, mark_playable: Callable) -> void:
	if action != Events.Action.REDRAW:
		return

	var is_playable = redraw_tokens > 0
	mark_playable.call(is_playable)
	if is_playable:
		Events.show_help.emit("Replace %s with a new card" % Cards.get_label(card_type))

func _choose_card(_card_type: Array, action: Events.Action, _card_node: Card) -> void:
	if action != Events.Action.REDRAW:
		return

	assert(redraw_tokens > 0, "Redraw triggered but user has no redraw tokens")
	redraw_tokens -= 1

func _receive_reward(reward: Reward) -> void:
	if reward is Reward.RedrawCard:
		redraw_tokens += 1

func _draw():
	draw_line(Vector2.ZERO, Vector2(size.x, 0), ColorPalette.PURPLE)
	draw_line(Vector2(size.x, 0), Vector2(size.x, size.y), ColorPalette.PURPLE)

	var center_y = (size.y - TEXTURE.get_size().y) / 2
	for index in range(0, redraw_tokens):
		draw_texture(TEXTURE, Vector2(index * TEXTURE.get_size().x, center_y), ColorPalette.GREY)