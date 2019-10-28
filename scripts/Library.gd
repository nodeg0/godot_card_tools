extends Node


func _ready():
	dir_contents("res://Resources/Cards/")
	make_all_card_array("res://Resources/Cards/")

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
		
func make_all_card_array(path = "res://Resources/Cards/", rarity = 0):
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
	print(allcards)
#	return allcards

