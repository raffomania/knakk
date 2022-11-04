extends HBoxContainer

var current_round := 1

func _ready():
	var _err = Events.turn_complete.connect(_turn_complete)
	_err = Events.round_complete.connect(_round_complete)

func _turn_complete() -> void:
	get_node("Round%d" % current_round).completed_turns += 1

func _round_complete() -> void:
	current_round += 1

	if current_round > 3:
		Events.game_over.emit()