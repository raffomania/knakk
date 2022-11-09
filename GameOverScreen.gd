extends MarginContainer


@onready var button: Button = $MarginBox/Button


func _ready():
	set_score(0)

	var _err = button.pressed.connect(_on_new_game)


func animate_score(score: int) -> void:
	var duration = score / 20.0
	var _tweener = create_tween().set_ease(Tween.EASE_OUT).tween_method(set_score, 0, score, duration)


func set_score(score: int) -> void:
	$MarginBox/ScoreBox/Reward.reward = Reward.Points.new(score)


func _on_new_game() -> void:
	Events.new_game.emit()
