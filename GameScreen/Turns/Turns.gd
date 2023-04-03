extends HBoxContainer


var current_round := 1


func _ready():
	var _err = Events.turn_complete.connect(_on_turn_complete)
	_err = Events.round_complete.connect(_on_round_complete)


func _on_turn_complete():
	get_node("Round%d" % current_round).completed_turns += 1


func _on_round_complete():
	current_round += 1

	if current_round > 3:
		Events.game_over.emit()
