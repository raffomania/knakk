extends Node2D

@onready var score = $"../Score"

## Check if `card_type` can be chosen by the player right now.
func can_play(card_type) -> bool:
	return $Diamonds.can_play(card_type)

func play_card(card_type) -> void:
	match card_type[0]:
		Cards.Suite.Diamonds:
			var reward = $Diamonds.play_card(card_type[1])
			score.add(reward)
