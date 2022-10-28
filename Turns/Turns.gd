extends HBoxContainer

var current_round := 1

func _ready():
	Events.turn_complete.connect(_turn_complete)
	Events.round_complete.connect(_round_complete)

func _turn_complete() -> void:
	get_node("Round%d" % current_round).completed_turns += 1

func _round_complete() -> void:
	current_round += 1
