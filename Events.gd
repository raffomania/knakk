# todo rename this file
extends Node

## All the card types currently available to play
## This is not optimal because we have to take care to update this
## when something changes in `Card.gd`, which is error prone.
## But since we need this in different parts of the game,
## it's better to have this here than to refer to 
# the Hand everywhere we need it
var card_types_in_hand: Array[Array]

signal consider_card(card_type)
signal cancel_consider_card
signal choose_card(card_type)
signal turn_complete
