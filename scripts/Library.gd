extends Node

var default_path = "res://Resources/Cards/"

func _ready():
	pass

func dir_contents(path):
    var dir = Directory.new()
    if dir.open(path) == OK:
        dir.list_dir_begin()
        var file_name = dir.get_next()
        while (file_name != ""):
            if dir.current_is_dir():
                print("Found directory: " + file_name)
            else:
                print("Found file: " + file_name)
            file_name = dir.get_next()
    else:
        print("An error occurred when trying to access the path.")
		
func make_all_card_array(path = default_path, rarity = 0):
	var allcards = Array()
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var cardpath = path + file_name
		var card = load(cardpath)
		if rarity != 0:
			while (file_name != ""):
				if !dir.current_is_dir() and card.rarity == rarity: 
					allcards.append(file_name)
				file_name = dir.get_next()
				card = load(path + file_name)
		else:
			while (file_name != ""):
				if !dir.current_is_dir(): 
					allcards.append(file_name)
				file_name = dir.get_next()
	else:
        print("An error occurred when trying to access the path.")
	return allcards

func get_random_card(path = default_path, rarity = 0):
	var cards = make_all_card_array(default_path, rarity)
	cards.shuffle()
	return cards[0]