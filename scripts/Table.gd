extends Node2D

var playerdeck = [] #array full of NAMES of card files Note: does not contain path
var playerhand = [] #array full of NAMES of card files in hand Note: does not contain path
var playerhandpaths = [] #array full of card paths for reference
var playerdiscard = [] #array full of discarded cards
export (float) var card_tilt # measurement in degrees of the tilt of the furthest card for a fan effect

signal update_deck_count
signal update_discard_count
signal update_hand_count

func _ready():
	pass

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
func place_hand():
	var cardcount = playerhandpaths.size()
	var space = $RightPoint.position.x - $LeftPoint.position.x

	var ideal_cardwidth = 80 #Slightly less than the card width so as to have overlap. Could be increased if you want a gap
	var hand_width = ideal_cardwidth * cardcount
	var unused_space = space - hand_width
	var cardID
	
	if cardcount > 0:
		var gap = space/cardcount	
		for card in range(playerhandpaths.size()):
			cardID = get_node(playerhandpaths[card])
			cardID.z_index = card + 1
			cardID.position.x = (unused_space/2) + $LeftPoint.position.x + card * ideal_cardwidth
			cardID.position.y = $LeftPoint.position.y
			cardID.hand_location = cardID.position
		tilt_cards()
# Deals hand. player arg is for later use in multiple player games. num is cards dealt. Cards are created and deck is reduced
func reset_hand_after_play(card_played = "nocard"):
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
					var cardnum = cardID.z_index -1
					playerhandpaths.remove(cardnum)
					playerdiscard.append(playerhand[cardnum])
					playerhand.remove(cardnum)
					cardID.queue_free()
			for card in range(playerhandpaths.size()):
				cardID = get_node(playerhandpaths[card])
				cardID.z_index = card + 1
				cardID.position.x = (unused_space/2) + $LeftPoint.position.x + card * ideal_cardwidth
				cardID.position.y = $LeftPoint.position.y
				cardID.hand_location = cardID.position
	place_hand()
	emit_signal("update_deck_count", playerdeck)
	emit_signal("update_hand_count", playerhand)
	emit_signal("update_discard_count", playerdiscard)


func tilt_cards():
#	var y
#	var max_tilt = card_tilt
#	var halfway = ceil(playerhandpaths.size()/2)
#	var tilt_card = max_tilt / (halfway - 2)
#	var tiltarray = []
#
#	for x in range (playerhandpaths.size()):
#		var card = get_node(playerhandpaths[x])
#		if playerhandpaths.size() > 1:
#				if x == halfway || x == halfway and playerhandpaths.size() % 2 ==0:
#					card.rotation_degrees = 0
#				elif x < halfway:
#					y = max_tilt + ((x-1) * tilt_card)
#					tiltarray.append(y)
#					card.rotation_degrees = y
#				elif x >halfway and playerhandpaths.size() % 2 != 0 || x > halfway + 1 and playerhandpaths.size() % 2 == 0:
#					y = tiltarray.back() * -1
#					tiltarray.pop_back()
#					card.rotation_degrees = y
	pass


func shuffle_discard():
	if playerdiscard.size() > 0:
		playerdiscard.shuffle()
		for card in range(playerdiscard.size()):
			playerdeck.push_back(playerdiscard[card])
	playerdiscard = []

func draw_cards(num):
	for x in num:
		if playerdeck.size() >0:
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
		reset_hand_after_play()
		

func _on_Main_deal_hand(player, num):
#	print("here is the deck before")
#	print(playerdeck)
	for card in range(num):
		if playerdeck.size() > 0:
			playerhand.append(playerdeck[0])
			print("here is hand:")
			print(playerhand)
			make_card(playerdeck[0])
			playerdeck.remove(0)
			print("here is deck:")
			print(playerdeck)
		elif playerdeck.size() == 0:
			shuffle_discard()
			if playerdeck.size() == 0:
				break
#	print("here is the deck after")
#	print(playerdeck)
	emit_signal("update_deck_count", playerdeck)
	emit_signal("update_hand_count", playerhand)
	emit_signal("update_discard_count", playerdiscard)
	place_hand()

	
func _new_card_focus(cardZ):
	get_tree().call_group("cards", "off_focus", cardZ)

#Play effect needs to be implemented more fully for individual games. I recommend passing all the card values and the target when appropriate
#It will be updated to be more universal in the future.
func _play_effect(card_played):
	print("play_effect")
	reset_hand_after_play(card_played)
	get_node("../PlayTarget").particles()
	draw_cards(1) # for testing purposes. Remove and connect to your game via signal perhaps


	