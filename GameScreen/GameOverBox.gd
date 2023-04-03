extends Control


@export var score: Score

func _ready():
	# Use modulate instead of `visible` to preserve
	# the position of the `FinalScorePosition` node
	modulate = Color.TRANSPARENT
	$ScoreBox/FinalScorePosition/Reward.visible = false
	Events.game_over.connect(_on_game_over)


func _on_game_over():
	var score_position = $ScoreBox/FinalScorePosition.global_position
	await score.animate_final_score(score_position)

	modulate = Color.WHITE
