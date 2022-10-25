extends Node2D

## Check if `card_type` can be chosen by the player right now.
func can_play(card_type):
	return $Diamonds.can_play(card_type)

func play_card(card_type):
	match card_type[0]:
		Cards.Suite.Diamonds:
			$Diamonds.play_card(card_type[1])
