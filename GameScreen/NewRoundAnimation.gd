extends CanvasLayer


var current_round := 1

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	Events.round_complete.connect(_on_round_complete)
	Events.new_game.connect(_on_new_game)
	visible = false


func _on_new_game(_with_tutorial: bool):
	current_round = 0
	await get_tree().create_timer(1.3).timeout
	_on_round_complete()


func _on_round_complete():
	current_round += 1
	if current_round > 3:
		return

	$TextureRect/TurnCounter.text = "Round %d" % current_round
	animation_player.play("round_complete")
	# instantly jump to the first frame and re-position elements
	# to prevent them from visibly jumping around - without this,
	# the AnimationPlayer would only update the positions in the next frame
	animation_player.seek(0, true)
	visible = true
	await animation_player.animation_finished
	visible = false
