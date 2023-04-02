class_name Cards

enum Suit {
    Hearts,
    Diamonds,
    Spades,
    Clubs
}

enum Number {
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
    King,
    Ace
}

const textures = {
    Suit.Hearts: {
        Number.Two: preload("res://GameScreen/Card/images/Hearts_02.png"),
        Number.Three: preload("res://GameScreen/Card/images/Hearts_03.png"),
        Number.Four: preload("res://GameScreen/Card/images/Hearts_04.png"),
        Number.Five: preload("res://GameScreen/Card/images/Hearts_05.png"),
        Number.Six: preload("res://GameScreen/Card/images/Hearts_06.png"),
        Number.Seven: preload("res://GameScreen/Card/images/Hearts_07.png"),
        Number.Eight: preload("res://GameScreen/Card/images/Hearts_08.png"),
        Number.Nine: preload("res://GameScreen/Card/images/Hearts_09.png"),
        Number.Ten: preload("res://GameScreen/Card/images/Hearts_10.png"),
        Number.Jack: preload("res://GameScreen/Card/images/Hearts_Jack.png"),
        Number.Queen: preload("res://GameScreen/Card/images/Hearts_Queen.png"),
        Number.King: preload("res://GameScreen/Card/images/Hearts_King.png"),
        Number.Ace: preload("res://GameScreen/Card/images/Hearts_Ace.png"),
    },
    Suit.Diamonds: {
        Number.Two: preload("res://GameScreen/Card/images/Diamonds_02.png"),
        Number.Three: preload("res://GameScreen/Card/images/Diamonds_03.png"),
        Number.Four: preload("res://GameScreen/Card/images/Diamonds_04.png"),
        Number.Five: preload("res://GameScreen/Card/images/Diamonds_05.png"),
        Number.Six: preload("res://GameScreen/Card/images/Diamonds_06.png"),
        Number.Seven: preload("res://GameScreen/Card/images/Diamonds_07.png"),
        Number.Eight: preload("res://GameScreen/Card/images/Diamonds_08.png"),
        Number.Nine: preload("res://GameScreen/Card/images/Diamonds_09.png"),
        Number.Ten: preload("res://GameScreen/Card/images/Diamonds_10.png"),
        Number.Jack: preload("res://GameScreen/Card/images/Diamonds_Jack.png"),
        Number.Queen: preload("res://GameScreen/Card/images/Diamonds_Queen.png"),
        Number.King: preload("res://GameScreen/Card/images/Diamonds_King.png"),
        Number.Ace: preload("res://GameScreen/Card/images/Diamonds_Ace.png"),
    },
    Suit.Spades: {
        Number.Two: preload("res://GameScreen/Card/images/Spades_02.png"),
        Number.Three: preload("res://GameScreen/Card/images/Spades_03.png"),
        Number.Four: preload("res://GameScreen/Card/images/Spades_04.png"),
        Number.Five: preload("res://GameScreen/Card/images/Spades_05.png"),
        Number.Six: preload("res://GameScreen/Card/images/Spades_06.png"),
        Number.Seven: preload("res://GameScreen/Card/images/Spades_07.png"),
        Number.Eight: preload("res://GameScreen/Card/images/Spades_08.png"),
        Number.Nine: preload("res://GameScreen/Card/images/Spades_09.png"),
        Number.Ten: preload("res://GameScreen/Card/images/Spades_10.png"),
        Number.Jack: preload("res://GameScreen/Card/images/Spades_Jack.png"),
        Number.Queen: preload("res://GameScreen/Card/images/Spades_Queen.png"),
        Number.King: preload("res://GameScreen/Card/images/Spades_King.png"),
        Number.Ace: preload("res://GameScreen/Card/images/Spades_Ace.png"),
    },
    Suit.Clubs: {
        Number.Two: preload("res://GameScreen/Card/images/Clubs_02.png"),
        Number.Three: preload("res://GameScreen/Card/images/Clubs_03.png"),
        Number.Four: preload("res://GameScreen/Card/images/Clubs_04.png"),
        Number.Five: preload("res://GameScreen/Card/images/Clubs_05.png"),
        Number.Six: preload("res://GameScreen/Card/images/Clubs_06.png"),
        Number.Seven: preload("res://GameScreen/Card/images/Clubs_07.png"),
        Number.Eight: preload("res://GameScreen/Card/images/Clubs_08.png"),
        Number.Nine: preload("res://GameScreen/Card/images/Clubs_09.png"),
        Number.Ten: preload("res://GameScreen/Card/images/Clubs_10.png"),
        Number.Jack: preload("res://GameScreen/Card/images/Clubs_Jack.png"),
        Number.Queen: preload("res://GameScreen/Card/images/Clubs_Queen.png"),
        Number.King: preload("res://GameScreen/Card/images/Clubs_King.png"),
        Number.Ace: preload("res://GameScreen/Card/images/Clubs_Ace.png"),
    }
}


const suit_textures = {
	Suit.Spades: preload("res://GameScreen/Suit/Spades.png"),
	Suit.Clubs:  preload("res://GameScreen/Suit/Clubs.png"),
	Suit.Hearts: preload("res://GameScreen/Suit/Hearts.png"),
	Suit.Diamonds: preload("res://GameScreen/Suit/Diamonds.png"),
}


static func get_label(card_type: Array) -> String:
	return "%s of %s" % [get_number_label(card_type[1]), get_suit_label(card_type[0])]


static func get_suit_label(suit: Cards.Suit) -> String:
	return Suit.find_key(suit)


static func get_number_label(number: Cards.Number) -> String:
	return Number.find_key(number)


static func get_number_sigil(number: Cards.Number) -> String:
	match number:
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
		Number.Ace: return "A"

	return "?"


## Check if the given `value` is in the given bounds (inclusive).
## `bounds` should be a two-element [lower_bound, upper_bound] array.
static func is_in_range(value: Number, bounds: Array):
	return value >= bounds[0] and value <= bounds[1]	
