extends Area2D

signal in_focus
signal play_effect

export (int) var focus_move_on_y
export (bool) var drag_and_drop #Used for drag and drop of cards.  If turned off interface is click to select.

var card : Resource
var card_name : String
var cost : int
var type : String
var power : int
var defense : int
var flavour_text : String
var health : int
var sprite : Sprite

var hand_location #modified on creation to store default location on Table node
var tilt : float 
var dragMouse :  = false
var focusCard :  = false
var card_in_play = false

func _ready():
	pass

func _process(delta):
	if drag_and_drop:
		if(dragMouse):
			set_position(get_viewport().get_mouse_position()+ Vector2(-40, -80))


func card_initialize(path, type):
	card = load(path + type)
	card_name = card.card_name
	$name.text = card_name
	cost = card.cost
	$Cost.text = str(cost)
	type = card.type
	power = card.power
	$power.text = str(power)
	defense = card.defense
	$defense.text = str(defense)
	flavour_text = card.flavour_text
	$flavour.text = flavour_text
	health = card.health
	sprite = card.sprite
	hand_location = position

func make_focus():
	emit_signal("in_focus", z_index)
	focusCard = true
	if position == hand_location:
		position.y -= focus_move_on_y

func off_focus(z):
	if z != z_index && !card_in_play:
		focusCard = false
		position = hand_location
	else:
		focusCard = true

func set_play_area():
	card_in_play = true

func unset_play_area():
	card_in_play = false

func _unhandled_input(event):
	if event is InputEventMouseButton and not event.is_action_pressed("left_click"):
		dragMouse = false
		pass


		
func _on_Card_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and drag_and_drop:
		if event.is_action_pressed("left_click") and focusCard:
			dragMouse = true
		if event.is_action_released("left_click") and card_in_play:
			emit_signal("play_effect", self.get_path())
	pass

func _on_Card_mouse_entered():

#	var cards_detected = get_overlapping_areas()
#	var highest_z = 0
#	var highest_node
#	if get_overlapping_areas().size() > 1:
#		for node in cards_detected:
#			if node.z_index > highest_z:
#				highest_z = node.z_index
#				highest_node = node
#		highest_node.make_focus()
#	else:
		 make_focus()

func _on_Card_mouse_exited():
#	position = hand_location
	pass



func _on_EnterDelayTimer_timeout():
	pass