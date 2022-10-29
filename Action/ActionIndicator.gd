extends Label


func _ready():
	Events.consider_action.connect(_consider_action)
	Events.choose_card.connect(_choose_card)
	Events.cancel_consider_action.connect(_cancel_consider_action)

	text = ""

func _consider_action(card_type: Array, action: Events.Action, _mark_playable: Callable) -> void:
	var card_label = "%s of %s" % [Cards.get_number_label(card_type[1]), Cards.get_suite_label(card_type[0])]
	match action:
		Events.Action.CHOOSE:
			text = "Play %s" % card_label
		Events.Action.REDRAW:
			text = "Replace %s with a new card" % card_label
		_:
			text = "Take unknown action" % card_label

func _choose_card(_card_type: Array, _action: Events.Action) -> void:
	text = ""

func _cancel_consider_action() -> void:
	text = ""