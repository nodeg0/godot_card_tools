extends Node2D

var playerdeck = [] #array full of NAMES of card files Note: does not contain path
var playerhand = [] #array full of NAMES of card files in hand Note: does not contain path
var playerhandpaths = [] #array full of card paths for reference
var playerdiscard = [] #array full of discarded cards
export (int) var ideal_cardwidth = 80 #Slightly less than the card width so as to have overlap. Could be increased if you want a gap
export (bool) var use_curve = true

onready var deck_origin = get_node("../Deck")
onready var deck_on = deck_origin.deck_on_screen
onready var path_length = $Path2D.curve.get_baked_length()
onready var spawner_follow = $Path2D/PathFollow2D
onready var spawner_position = $Path2D/PathFollow2D/DeckSpawner.get_global_position()
onready var spawner_rotation = $Path2D/PathFollow2D/DeckSpawner.get_global_transform().get_rotation()

#Connect to UI as necessary
signal update_deck_count 
signal update_discard_count
signal update_hand_count

func _ready():
	deck_origin.connect("turn_off_deck", self, "_on_Deck_turn_off_deck")
	deck_origin.connect("turn_on_deck", self, "_on_Deck_turn_on_deck")

func make_player_deck(deck):
	playerdeck = deck
#	print("This is the player deck")
#	print(playerdeck)

func make_card(cardname):
	var card = load("res://Scenes/Card.tscn").instance()
	var main = $PlayerHand
	card.card_initialize("res://Resources/Cards/", cardname)
	card.connect("in_focus", self, "_new_card_focus")
	card.connect("play_effect", self, "_play_effect")
	main.add_child(card)
	playerhandpaths.append(card.get_path())
#
func set_hand(card_played = "nocard"):

	var cardcount = playerhandpaths.size()
	var space = $RightPoint.position.x - $LeftPoint.position.x
	var cardID
	var ideal_cardwidth = 80 #Slightly less than the card width so as to have overlap. Could be increased if you want a gap
	var hand_width = ideal_cardwidth * cardcount
	var unused_space = space - hand_width
	
	if cardcount > 0:

		for card in playerhandpaths:
			if card_played != null || card_played != "nocard":
				if card == card_played:
					cardID = get_node(card)
					var cardnum = cardID.base_z -1

					playerhandpaths.remove(cardnum)
					playerdiscard.append(playerhand[cardnum])
					playerhand.remove(cardnum)
					cardID.queue_free()
			spawner_follow.offset = 0
			for card in range(playerhandpaths.size()):
				if !use_curve:
					pass
#					if hand_width > space:
#						ideal_cardwidth = space / cardcount
#						for card in range(playerhandpaths.size()):
#							cardID = get_node(playerhandpaths[card])
#							cardID.z_index = card + 1
#							cardID.base_z = cardID.z_index
#							cardID.position.x = $LeftPoint.position.x + card * ideal_cardwidth
#							cardID.position.y = $LeftPoint.position.y
#							cardID.hand_location = cardID.position	
#							if deck_on and !cardID.dealt:
#								cardID.deck_location = $Deck.position
#								cardID.position = cardID.deck_location
#					else:
#						for card in range(playerhandpaths.size()):
#							cardID = get_node(playerhandpaths[card])
#							cardID.z_index = card + 1
#							cardID.base_z = cardID.z_index
#							cardID.position.x = (unused_space/2) + $LeftPoint.position.x + card * ideal_cardwidth
#							cardID.position.y = $LeftPoint.position.y
#							cardID.hand_location = cardID.position
#							if deck_on and !cardID.dealt:
#								cardID.deck_location = $Deck.position
#								cardID.position = cardID.deck_location
				else: 

					cardID = get_node(playerhandpaths[card])
					cardID.z_index = card + 1
					cardID.base_z = cardID.z_index
					cardID.position = spawner_position
					cardID.rotation = spawner_rotation
					cardID.hand_location = cardID.position
					spawner_follow.offset += ideal_cardwidth
					cardID.hand_location = cardID.position

	emit_signal("update_deck_count", playerdeck)
	emit_signal("update_hand_count", playerhand)
	emit_signal("update_discard_count", playerdiscard)	


func shuffle_discard():
	if playerdiscard.size() > 0:
		playerdiscard.shuffle()
		for card in range(playerdiscard.size()):
			playerdeck.push_back(playerdiscard[card])
	playerdiscard = []

func draw_cards(num, player = "player"):
	for x in num:
		if playerdeck.size() > 0:
			playerhand.append(playerdeck[0])
			make_card(playerdeck[0])
			playerdeck.remove(0)
		elif playerdiscard.size() > 0:
			shuffle_discard()
			playerhand.append(playerdeck[0])
			make_card(playerdeck[0])
			playerdeck.remove(0)
		else:
			print("out of cards")
		set_hand("draw") #"draw" added so as not to trigger "nocard" result.

func _new_card_focus(cardZ):
	get_tree().call_group("cards", "off_focus", cardZ)

#Play effect needs to be implemented more fully for individual games. I recommend passing all the card values and the target when appropriate
#It will be updated to be more universal in the future.
func _play_effect(card_played):
	print("play_effect")
	print(card_played)
	set_hand(card_played)
	get_node("../PlayTarget").particles()

func _on_Deck_turn_off_deck():
	print("deck off")
	deck_on = false
	
func _on_Deck_turn_on_deck():
	deck_on = true
	print("deck on")
