extends Node2D

var playerdeck = [] #array full of NAMES of card files Note: does not contain path
var playerhand = [] #array full of NAMES of card files in hand Note: does not contain path
var playerhandpaths = [] #array full of card paths for reference
var playerdiscard = [] #array full of discarded cards
var temp_cardnode #REVISIT THIS.  
var card_width #REVISIT THIS TOO.

export (bool) var use_curve : = true 
export var use_focus_area : = true

onready var deck_origin = get_node("../Deck")
onready var deck_on = deck_origin.deck_on_screen
onready var path_length = $Path2D.curve.get_baked_length()


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
	card.connect("card_selected", self, "_card_selected")
	main.add_child(card)
	playerhandpaths.append(card.get_path())
	temp_cardnode = card.find_node("Sprite")
	card_width = temp_cardnode.texture.get_width() * temp_cardnode.scale.x
	print(temp_cardnode.texture.get_width())

#Used for setting up the hand. With arg "nocard" no card check for removal is done. can be used to reset the hand positions
func set_hand(card_played = "nocard"):
	
	if playerhandpaths.size() > 0:

		var space
		var ideal_cardwidth = card_width * 0.8
		print ("starting idealcardwidth: " + str(ideal_cardwidth))
		var hand_width 
		var hand_offset : float = 0.0
		var cardindex = 0

		for card in playerhandpaths:
			var cardID 
			var cardnum
			if card_played != null || card_played != "nocard":
				if card == card_played: 
					cardID = get_node(card)
					cardnum = cardID.base_z -1
					playerhandpaths.remove(cardnum)
					playerdiscard.append(playerhand[cardnum])
					playerhand.remove(cardnum)
					cardID.queue_free()

		hand_width = ideal_cardwidth * playerhandpaths.size()

		if use_curve: 
			space = path_length
			$Path2D/PathFollow2D.offset = 0.0
			if hand_width < path_length:
				$Path2D/PathFollow2D.offset = (space - hand_width)/2
				print("ideal cardwidth space: " + str(ideal_cardwidth))
			else:
				ideal_cardwidth = space / playerhandpaths.size()
				print("ideal cardwidth crowded: " + str(ideal_cardwidth))
	
		elif !use_curve:
			space = $RightPoint.position.x - $LeftPoint.position.x
			var unused_space = space - hand_width
			if hand_width <= space:
				hand_offset += (unused_space/2)
			else:
				ideal_cardwidth = space / playerhandpaths.size()

		for card in playerhandpaths:
			var cardID = get_node(card)
			if !use_curve:
				cardID.z_index = cardindex + 1
				cardID.base_z = cardID.z_index

				if hand_width > space:
					if cardindex == 0:
						cardID.position.x = $LeftPoint.position.x
					else:
						cardID.position.x = $LeftPoint.position.x + hand_offset
				elif hand_width <= space:
					print("hand_width < space")
					cardID.position.x = $LeftPoint.position.x + hand_offset
					
				print ("function idealcardwidth: " + str(ideal_cardwidth))
				hand_offset += ideal_cardwidth
				cardID.position.y = $LeftPoint.position.y
				cardID.hand_location = cardID.position

			elif use_curve: 

				cardID = get_node(card)
				cardID.z_index = cardindex + 1
				cardID.base_z = cardID.z_index
				cardID.hand_location = $Path2D/PathFollow2D/DeckSpawner.get_global_position()
				cardID.hand_rotation = $Path2D/PathFollow2D/DeckSpawner.get_global_transform().get_rotation()
				if cardID.dealt:
					cardID.move_card(cardID.hand_location, cardID.hand_rotation)
				else: 
					cardID.position = cardID.position
					cardID.rotation = cardID.rotation
				if deck_on and !cardID.dealt:
					cardID.rotation = 0
				if use_focus_area:
					cardID.focus_area = $FocusCardArea.position
				$Path2D/PathFollow2D.offset += ideal_cardwidth

			cardindex += 1

			if deck_on and !cardID.dealt:
				cardID.deck_location = $Deck.position
				cardID.position = cardID.deck_location



	emit_signal("update_deck_count", playerdeck)
	emit_signal("update_hand_count", playerhand)
	emit_signal("update_discard_count", playerdiscard)	


func shuffle_discard():
	if playerdiscard.size() > 0:
		playerdiscard.shuffle()
		for card in range(playerdiscard.size()):
			playerdeck.push_back(playerdiscard[card])
	playerdiscard = []

func draw_cards(num): #player = "player" arg removed.  May be added again later if multi-deck/multi-player support is added
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
	set_hand() #"draw" added so as not to trigger "nocard" result.

func _card_selected(sel, card):
	print("card selected")
	get_tree().call_group("cards", "_lock_movement", card, sel)

func _new_card_focus(cardZ):
	get_tree().call_group("cards", "off_focus", cardZ)

#Play effect needs to be implemented more fully for individual games. I recommend passing all the card values and the target when appropriate
#It will be updated to be more universal in the future.
func _play_effect(card_played):
	var card = get_node(card_played)
	if card.card_in_play:
		print("play_effect")
		print(card_played)
		set_hand(card_played)
		get_node("../PlayTarget").particles()
	else:
		set_hand()

func _on_Deck_turn_off_deck():
	print("deck off")
	deck_on = false
	
func _on_Deck_turn_on_deck():
	deck_on = true
	print("deck on")
