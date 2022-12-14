extends MarginContainer


@onready var button: Button = $MarginBox/Button

signal new_game


func _ready():
	reset()

	var _err = button.pressed.connect(_on_new_game)

	$MarginBox/ScoreBox/Reward.animation_speed = 2.0


func animate_score(score: int):
	var duration = score / 20.0
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var _tweener = tween.tween_method(set_score, 0, score, duration)


func set_score(score: int):
	$MarginBox/ScoreBox/Reward.reward = Reward.Points.new(score)


func reset():
	set_score(0)


func _on_new_game():
	new_game.emit()
