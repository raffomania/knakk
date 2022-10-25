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


static func get_number_sigil(number):
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
		_: return "?"

static func is_in_range(value: Number, lower_bound: Number, upper_bound: Number):
	return value >= lower_bound and value <= upper_bound	

# todo remove or use this everywhere
enum Card {
    HeartsAce,
    HeartsTwo,
    HeartsThree,
    HeartsFour,
    HeartsFive,
    HeartsSix,
    HeartsSeven,
    HeartsEight,
    HeartsNine,
    HeartsTen,
    HeartsJack,
    HeartsQueen,
    HeartsKing,
    DiamondsAce,
    DiamondsTwo,
    DiamondsThree,
    DiamondsFour,
    DiamondsFive,
    DiamondsSix,
    DiamondsSeven,
    DiamondsEight,
    DiamondsNine,
    DiamondsTen,
    DiamondsJack,
    DiamondsQueen,
    DiamondsKing,
    SpadesAce,
    SpadesTwo,
    SpadesThree,
    SpadesFour,
    SpadesFive,
    SpadesSix,
    SpadesSeven,
    SpadesEight,
    SpadesNine,
    SpadesTen,
    SpadesJack,
    SpadesQueen,
    SpadesKing,
    ClubsAce,
    ClubsTwo,
    ClubsThree,
    ClubsFour,
    ClubsFive,
    ClubsSix,
    ClubsSeven,
    ClubsEight,
    ClubsNine,
    ClubsTen,
    ClubsJack,
    ClubsQueen,
    ClubsKing,
}

const textures = {
    Suite.Hearts: {
        Number.Ace: preload("res://Cards/images/Clubs_Ace.png"),
        Number.Two: preload("res://Cards/images/Clubs_02.png"),
        Number.Three: preload("res://Cards/images/Clubs_03.png"),
        Number.Four: preload("res://Cards/images/Clubs_04.png"),
        Number.Five: preload("res://Cards/images/Clubs_05.png"),
        Number.Six: preload("res://Cards/images/Clubs_06.png"),
        Number.Seven: preload("res://Cards/images/Clubs_07.png"),
        Number.Eight: preload("res://Cards/images/Clubs_08.png"),
        Number.Nine: preload("res://Cards/images/Clubs_09.png"),
        Number.Ten: preload("res://Cards/images/Clubs_10.png"),
        Number.Jack: preload("res://Cards/images/Clubs_Jack.png"),
        Number.Queen: preload("res://Cards/images/Clubs_Queen.png"),
        Number.King: preload("res://Cards/images/Clubs_King.png"),
    },
    Suite.Diamonds: {
        Number.Ace: preload("res://Cards/images/Diamonds_Ace.png"),
        Number.Two: preload("res://Cards/images/Diamonds_02.png"),
        Number.Three: preload("res://Cards/images/Diamonds_03.png"),
        Number.Four: preload("res://Cards/images/Diamonds_04.png"),
        Number.Five: preload("res://Cards/images/Diamonds_05.png"),
        Number.Six: preload("res://Cards/images/Diamonds_06.png"),
        Number.Seven: preload("res://Cards/images/Diamonds_07.png"),
        Number.Eight: preload("res://Cards/images/Diamonds_08.png"),
        Number.Nine: preload("res://Cards/images/Diamonds_09.png"),
        Number.Ten: preload("res://Cards/images/Diamonds_10.png"),
        Number.Jack: preload("res://Cards/images/Diamonds_Jack.png"),
        Number.Queen: preload("res://Cards/images/Diamonds_Queen.png"),
        Number.King: preload("res://Cards/images/Diamonds_King.png"),
    },
    Suite.Spades: {
        Number.Ace: preload("res://Cards/images/Spades_Ace.png"),
        Number.Two: preload("res://Cards/images/Spades_02.png"),
        Number.Three: preload("res://Cards/images/Spades_03.png"),
        Number.Four: preload("res://Cards/images/Spades_04.png"),
        Number.Five: preload("res://Cards/images/Spades_05.png"),
        Number.Six: preload("res://Cards/images/Spades_06.png"),
        Number.Seven: preload("res://Cards/images/Spades_07.png"),
        Number.Eight: preload("res://Cards/images/Spades_08.png"),
        Number.Nine: preload("res://Cards/images/Spades_09.png"),
        Number.Ten: preload("res://Cards/images/Spades_10.png"),
        Number.Jack: preload("res://Cards/images/Spades_Jack.png"),
        Number.Queen: preload("res://Cards/images/Spades_Queen.png"),
        Number.King: preload("res://Cards/images/Spades_King.png"),
    },
    Suite.Clubs: {
        Number.Ace: preload("res://Cards/images/Clubs_Ace.png"),
        Number.Two: preload("res://Cards/images/Clubs_02.png"),
        Number.Three: preload("res://Cards/images/Clubs_03.png"),
        Number.Four: preload("res://Cards/images/Clubs_04.png"),
        Number.Five: preload("res://Cards/images/Clubs_05.png"),
        Number.Six: preload("res://Cards/images/Clubs_06.png"),
        Number.Seven: preload("res://Cards/images/Clubs_07.png"),
        Number.Eight: preload("res://Cards/images/Clubs_08.png"),
        Number.Nine: preload("res://Cards/images/Clubs_09.png"),
        Number.Ten: preload("res://Cards/images/Clubs_10.png"),
        Number.Jack: preload("res://Cards/images/Clubs_Jack.png"),
        Number.Queen: preload("res://Cards/images/Clubs_Queen.png"),
        Number.King: preload("res://Cards/images/Clubs_King.png"),
    }
}