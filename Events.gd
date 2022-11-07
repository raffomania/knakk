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
	PLAY_AGAIN,
	NOTHING
}

signal consider_action(card_type: Array, action: Action, mark_playable: Callable)
signal cancel_consider_action
signal choose_card(card_type: Array, action: Action, card_node: Card)

signal receive_reward(reward: Reward)

signal show_help(message: String)

## Each time the player marks a slot and obtains a reward, a turn is completed.
## After 5 turns, all cards are returned to the deck and it is shuffled, beginning a new round
signal turn_complete
## After three rounds, the game is over
signal round_complete
## When the game is over, the game over screen is shown
signal game_over
## Start a new game, usually triggered on the game over screen.
signal new_game