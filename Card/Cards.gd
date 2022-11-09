class_name Cards

enum Suite {
    Hearts,
    Diamonds,
    Spades,
    Clubs
}

enum Number {
    Ace,
    Two,
    Three,
    Four,
    Five,
    Six,
    Seven,
    Eight,
    Nine,
    Ten,
    Jack,
    Queen,
    King
}

const textures = {
    Suite.Hearts: {
        Number.Ace: preload("res://Card/images/Hearts_Ace.png"),
        Number.Two: preload("res://Card/images/Hearts_02.png"),
        Number.Three: preload("res://Card/images/Hearts_03.png"),
        Number.Four: preload("res://Card/images/Hearts_04.png"),
        Number.Five: preload("res://Card/images/Hearts_05.png"),
        Number.Six: preload("res://Card/images/Hearts_06.png"),
        Number.Seven: preload("res://Card/images/Hearts_07.png"),
        Number.Eight: preload("res://Card/images/Hearts_08.png"),
        Number.Nine: preload("res://Card/images/Hearts_09.png"),
        Number.Ten: preload("res://Card/images/Hearts_10.png"),
        Number.Jack: preload("res://Card/images/Hearts_Jack.png"),
        Number.Queen: preload("res://Card/images/Hearts_Queen.png"),
        Number.King: preload("res://Card/images/Hearts_King.png"),
    },
    Suite.Diamonds: {
        Number.Ace: preload("res://Card/images/Diamonds_Ace.png"),
        Number.Two: preload("res://Card/images/Diamonds_02.png"),
        Number.Three: preload("res://Card/images/Diamonds_03.png"),
        Number.Four: preload("res://Card/images/Diamonds_04.png"),
        Number.Five: preload("res://Card/images/Diamonds_05.png"),
        Number.Six: preload("res://Card/images/Diamonds_06.png"),
        Number.Seven: preload("res://Card/images/Diamonds_07.png"),
        Number.Eight: preload("res://Card/images/Diamonds_08.png"),
        Number.Nine: preload("res://Card/images/Diamonds_09.png"),
        Number.Ten: preload("res://Card/images/Diamonds_10.png"),
        Number.Jack: preload("res://Card/images/Diamonds_Jack.png"),
        Number.Queen: preload("res://Card/images/Diamonds_Queen.png"),
        Number.King: preload("res://Card/images/Diamonds_King.png"),
    },
    Suite.Spades: {
        Number.Ace: preload("res://Card/images/Spades_Ace.png"),
        Number.Two: preload("res://Card/images/Spades_02.png"),
        Number.Three: preload("res://Card/images/Spades_03.png"),
        Number.Four: preload("res://Card/images/Spades_04.png"),
        Number.Five: preload("res://Card/images/Spades_05.png"),
        Number.Six: preload("res://Card/images/Spades_06.png"),
        Number.Seven: preload("res://Card/images/Spades_07.png"),
        Number.Eight: preload("res://Card/images/Spades_08.png"),
        Number.Nine: preload("res://Card/images/Spades_09.png"),
        Number.Ten: preload("res://Card/images/Spades_10.png"),
        Number.Jack: preload("res://Card/images/Spades_Jack.png"),
        Number.Queen: preload("res://Card/images/Spades_Queen.png"),
        Number.King: preload("res://Card/images/Spades_King.png"),
    },
    Suite.Clubs: {
        Number.Ace: preload("res://Card/images/Clubs_Ace.png"),
        Number.Two: preload("res://Card/images/Clubs_02.png"),
        Number.Three: preload("res://Card/images/Clubs_03.png"),
        Number.Four: preload("res://Card/images/Clubs_04.png"),
        Number.Five: preload("res://Card/images/Clubs_05.png"),
        Number.Six: preload("res://Card/images/Clubs_06.png"),
        Number.Seven: preload("res://Card/images/Clubs_07.png"),
        Number.Eight: preload("res://Card/images/Clubs_08.png"),
        Number.Nine: preload("res://Card/images/Clubs_09.png"),
        Number.Ten: preload("res://Card/images/Clubs_10.png"),
        Number.Jack: preload("res://Card/images/Clubs_Jack.png"),
        Number.Queen: preload("res://Card/images/Clubs_Queen.png"),
        Number.King: preload("res://Card/images/Clubs_King.png"),
    }
}


static func get_label(card_type: Array) -> String:
	return "%s of %s" % [get_suite_label(card_type[0]), get_number_label(card_type[1])]


static func get_suite_label(suite: Cards.Suite) -> String:
	return Suite.find_key(suite)


static func get_number_label(number: Cards.Number) -> String:
	return Number.find_key(number)


static func get_number_sigil(number: Cards.Number) -> String:
	match number:
		Number.Ace: return "A"
		Number.Two: return "2"
		Number.Three: return "3"
		Number.Four: return "4"
		Number.Five: return "5"
		Number.Six: return "6"
		Number.Seven: return "7"
		Number.Eight: return "8"
		Number.Nine: return "9"
		Number.Ten: return "10"
		Number.Jack: return "J"
		Number.Queen: return "Q"
		Number.King: return "K"

	return "?"


## Check if the given `value` is in the given bounds (inclusive).
## `bounds` should be a two-element [lower_bound, upper_bound] array.
static func is_in_range(value: Number, bounds: Array):
	return value >= bounds[0] and value <= bounds[1]	
