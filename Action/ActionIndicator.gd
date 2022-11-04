extends Label

func _ready():
	var _err = Events.consider_action.connect(_consider_action)
	_err = Events.choose_card.connect(_choose_card)
	_err = Events.cancel_consider_action.connect(_cancel_consider_action)

	text = ""

func _consider_action(card_type: Array, action: Events.Action, _mark_playable: Callable) -> void:
	var card_label = "%s of %s" % [Cards.get_number_label(card_type[1]), Cards.get_suite_label(card_type[0])]
	match action:
		Events.Action.CHOOSE:
			text = "Play %s" % card_label
		Events.Action.REDRAW:
			text = "Replace %s with a new card" % card_label
		Events.Action.PLAY_AGAIN:
			text = "Play an extra turn with your current cards"
		_:
			text = "Take unknown action"

func _choose_card(_card_type: Array, _action: Events.Action) -> void:
	text = ""

func _cancel_consider_action() -> void:
	text = ""