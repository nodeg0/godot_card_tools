extends Node

# signals for turning on/off dealing from deck. No requirement for use outside of the demo.
signal turn_off_deck
signal turn_on_deck

# used to determine if deck is being used.
export var deck_on_screen : bool = false setget deckonscreen

func _ready():
	pass

func deckonscreen(val):
	deck_on_screen = val
	if deck_on_screen == true:
		emit_signal("turn_on_deck")
	if deck_on_screen == false:
		emit_signal("turn_off_deck")

# to be used later to load and save decks
func load_deck(owner):
	pass

func save_deck(owner):
	pass

# default deck.  can be used for the default starter deck. 
func default_deck():
	var deck = ["heal.tres", "heal.tres", "dodge.tres", "dodge.tres", "dodge.tres", "dodge.tres", "stab_attack.tres", "stab_attack.tres", "stab_attack.tres", "stab_attack.tres"]
	return deck
	


