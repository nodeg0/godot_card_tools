extends Resource

class_name Cardtypes

#Custom resource to create cards.  Variable can be changed to whatever you want to use.

export var card_name : String = "Card"

enum RARITY {all, common, uncommon, rare, legendary}

export(RARITY) var rarity = RARITY.common
export var cost : int
export var type : String
export var power : int
export var defense : int
export var flavour_text : String
export var health : int
export (Texture) var sprite