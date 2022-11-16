extends Control


const REWARD_MARKER_SCENE := preload("res://Reward/RewardMarker.tscn")

var _redraw_tokens := 0
var _token_nodes: Array[Node] = []


func _ready():
	var _err = Events.query_playable.connect(_on_query_playable)
	_err = Events.consider_action.connect(_on_consider_action)
	_err = Events.take_action.connect(_on_take_action)
	_err = Events.receive_reward.connect(_on_receive_reward)


func _draw():
	draw_line(Vector2.ZERO, Vector2(size.x, 0), ColorPalette.PURPLE)
	draw_line(Vector2(size.x, 0), Vector2(size.x, size.y), ColorPalette.PURPLE)


func _add_token():
	var marker = REWARD_MARKER_SCENE.instantiate()
	marker.reward = Reward.RedrawCard.new()
	marker.color = ColorPalette.PURPLE
	add_child(marker)
	_token_nodes.append(marker)
	_redraw_tokens += 1


func _remove_token():
	var node = _token_nodes.pop_back()
	node.queue_free()
	_redraw_tokens -= 1


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
	_remove_token()

	# Add card as child while keeping its global position
	var card_position = card_node.global_position
	add_child(card_node)
	card_node.global_position = card_position

	card_node.move_to(global_position + Vector2(0, size.y / 2))
	card_node.shrink_to_played_size()


func _on_receive_reward(reward: Reward):
	if reward is Reward.RedrawCard:
		_add_token()
