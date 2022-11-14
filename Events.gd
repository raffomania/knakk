extends Node


enum Action {
	CHOOSE,
	REDRAW,
	PLAY_AGAIN,
	SKIP_ROUND,
	NOTHING
}

## Emitted when some node needs to know if the given action and card
## are playable. Any other node can respond by calling `mark_playable`
## with a boolean argument.
signal query_playable(card_type: Array, action: Action, mark_playable: Callable)
## Emitted when the player hovers over the field while still holding the card.
## If the player lets go of the card afterwards, the `take_action` event is emitted.
## Contains a callback that allows any component of the game to allow or prohibit that action
signal consider_action(card_type: Array, action: Action)
## Emitted when the player moves the card away from the field.
## If the player lets go of the card afterwards, it's returned to the hand.
signal cancel_consider_action(action: Action)
## Emitted when a player drops a card on the field.
## By convention, this can only be emitted when that action was marked as playable using the
## `consider_action` event.
signal take_action(card_type: Array, action: Action, card_node: Card)

## Emitted when the player receives a reward, usually by filling a slot on the field.
signal receive_reward(reward: Reward)

## Change the message displayed at the bottom of the screen.
signal show_help(message: String)

## Each time the player marks a slot and obtains a reward, a turn is completed and this is emitted.
signal turn_complete
## Emitted when 5 turns have been played. 
## All cards are returned to the deck and it is shuffled, beginning a new round
signal round_complete
## After three rounds, the game is over and the game over screen is shown
signal game_over
## Start a new game, usually triggered on the game over screen.
signal new_game

## All the card types currently available to play
## This is not optimal because we have to take care to update this
## when something changes in `Card.gd`, which is error prone.
## But since we need this in different parts of the game,
## it's better to have this here than to refer to 
# the Hand everywhere we need it
var card_types_in_hand: Array[Array]

func is_playable(card_type: Array, action: Action) -> bool:
	# Wrap our result value in an object to get a reference in the callable below,
	# allowing it to write the `result` key
	var result_obj = { result = false }
	query_playable.emit(card_type, action, func(response_result): 
			result_obj.result = response_result
	)
	return result_obj.result
