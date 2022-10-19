## The collection of cards that the player can choose from

extends Node2D

## The card nodes that players can drag around
@onready var cards: Array[Node]
## The deck provides us with new cards when a card is played
@onready var deck = $"../Deck"

var card_scene = preload("res://Cards/Card.tscn")

func _ready():
	var card_size = Cards.textures[0][0].get_size()
	# Draw three cards and position them to the left and right of our horizontal
	# position
	for card_index in range(-1,2):
		var card_type = self.deck.draw_card()
		var card = card_scene.instantiate()
		card.set_card_type(card_type[0], card_type[1])
		card.position = Vector2(card_size.x * card_index, -card_size.y/2)
		card_index += 1
		add_child(card)
