extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var table = $Table

var playerdeck = []
var enemydeck = []

signal deal_hand

func _ready():
	randomize()
	get_player_deck()
	deal_hand("player", 5)

func get_player_deck():
	playerdeck = $Deck.default_deck()
	playerdeck.shuffle()
	table.make_player_deck(playerdeck)

func deal_hand(player, numb):
	emit_signal("deal_hand", player, numb)

func _on_PlayTarget_area_entered(area):
	area.set_play_area()
	print(area.power)
	print(area.card_in_play)


func _on_PlayTarget_area_exited(area):
	area.unset_play_area()


func _on_Table_update_deck_count(deck):
	$CardsInDeck.text = "Cards in Deck: " + str(deck.size())
	

func _on_Table_update_discard_count(discard):
	$CardsInDiscard.text = "Cards in Discard: " + str(discard.size())

func _on_Table_update_hand_count(hand):
	$CardsInHand.text = "Cards in Hand: " + str(hand.size())
