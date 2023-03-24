extends Control


var _redraw_tokens := 0

@onready var container: HBoxContainer = $Container


func _ready():
	var _err = Events.query_playable.connect(_on_query_playable)
	_err = Events.consider_action.connect(_on_consider_action)
	_err = Events.take_action.connect(_on_take_action)
	_err = Events.receive_reward.connect(_on_receive_reward)

	visible = false


func _add_token(marker: RewardMarker):
	marker.reparent(container)

	_redraw_tokens += 1


func _remove_token():
	var node = container.get_child(0)
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


func _on_receive_reward(marker: RewardMarker):
	if not (marker.reward is Reward.RedrawCard):
		return

	visible = true

	# Draw the RewardMarker above field and cards
	marker.z_index = 100

	await marker.tween_to_position(global_position + Vector2(size.x * 0.5, 0))

	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 1.15, 0.05)
	tween.tween_property(self, "scale", Vector2.ONE, 0.05)

	_add_token(marker)
