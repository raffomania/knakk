## The collection of cards that the player can choose from

extends Node2D

## The deck provides us with new cards when a card is played
@onready var deck = $"../Deck"
@onready var field = $"../Field"

var card_scene = preload("res://Cards/Card.tscn")

func _ready():
	draw_initial_cards()

func draw_initial_cards():
	var card_size = Cards.textures[0][0].get_size()

	# Draw three cards and position them to the left and right of our horizontal
	# position
	for card_index in range(-1,2):
		var card_type = self.deck.draw_card()
		spawn_card(card_type, Vector2(card_size.x * card_index, -card_size.y/2))
		card_index += 1

func _choose_card(card):
	field.play_card(card.card_type)
	card.queue_free()
	var next_card_type = deck.draw_card()
	spawn_card(next_card_type, to_local(card.starting_position))

func _consider_card(card):
	card.can_play = field.can_play(card.card_type)

func spawn_card(card_type, card_position):
	var card = card_scene.instantiate()
	card.set_card_type(card_type)
	card.position = card_position
	card.choose.connect(_choose_card.bind(card))
	card.consider.connect(_consider_card.bind(card))
	add_child(card)

func _unhandled_input(event):
	if event.is_action_released("reset_hand") and OS.is_debug_build():
		for child in get_children():
			child.queue_free()

		if len(deck.cards_in_deck) < 3:
			deck.reset()

		draw_initial_cards()