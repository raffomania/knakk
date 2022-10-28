# todo rename this file
extends Node

## All the card types currently available to play
## This is not optimal because we have to take care to update this
## when something changes in `Card.gd`, which is error prone.
## But since we need this in different parts of the game,
## it's better to have this here than to refer to 
# the Hand everywhere we need it
var card_types_in_hand: Array[Array]

enum Action {
	CHOOSE,
	REDRAW,
	NOTHING
}

signal consider_action(card_type: Array, action: Action, mark_playable: Callable)
signal cancel_consider_action
signal choose_card(card_type: Array, action: Action)
signal turn_complete
