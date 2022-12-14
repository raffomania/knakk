extends HBoxContainer


var _play_again_tokens := 0
var _token_nodes: Array[Node] = []


func _ready():
	var _err = Events.query_playable.connect(_on_query_playable)
	_err = Events.consider_action.connect(_on_consider_action)
	_err = Events.take_action.connect(_on_take_action)
	_err = Events.receive_reward.connect(_on_receive_reward)

	visible = false


func _draw():
	draw_line(Vector2.ZERO, Vector2(size.x, 0), ColorPalette.PURPLE)
	draw_line(Vector2.ZERO, Vector2(0, size.y), ColorPalette.PURPLE)


func _add_token(marker: RewardMarker):
	marker.reparent(self)
	_token_nodes.append(marker)

	_play_again_tokens += 1

func _remove_token():
	var node = _token_nodes.pop_back()
	node.queue_free()

	_play_again_tokens -= 1


func _can_play() -> bool:
	var hand_is_full = len(Events.card_types_in_hand) == 3
	return _play_again_tokens > 0 and hand_is_full


func _on_query_playable(_card_type: Array, action: Events.Action, mark_playable: Callable):
	if action != Events.Action.PLAY_AGAIN:
		return

	mark_playable.call(_can_play())


func _on_consider_action(_card_type: Array, action: Events.Action):
	if action != Events.Action.PLAY_AGAIN:
		return

	var hand_is_full = len(Events.card_types_in_hand) == 3
	if _can_play():
		Events.show_help.emit("Duplicate other cards in your hand")
	elif not hand_is_full:
		Events.show_help.emit("You can only duplicate at the start of a turn")


func _on_take_action(_card_type: Array, action: Events.Action, card_node: Card):
	if action != Events.Action.PLAY_AGAIN:
		return

	assert(_play_again_tokens > 0, "PlayAgain triggered but user has no play again tokens")

	_remove_token()

	# Add card as child while keeping its global position
	var card_position = card_node.global_position
	add_child(card_node)
	card_node.global_position = card_position

	card_node.move_to(global_position + Vector2(size.x, size.y / 2))
	card_node.shrink_to_played_size()


func _on_receive_reward(marker: RewardMarker):
	if not (marker.reward is Reward.PlayAgain):
		return
		
	visible = true

	# Draw the RewardMarker above field and cards
	marker.z_index = 100

	await marker.tween_to_position(global_position + Vector2(size.x * 0.5, 0))

	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 1.15, 0.05)
	tween.tween_property(self, "scale", Vector2.ONE, 0.05)

	_add_token(marker)