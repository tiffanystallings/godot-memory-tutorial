extends Node

@onready var Game: Node = get_node("/root/Game/")
var pop_up: PackedScene = preload("res://pop_up.tscn")
var reset_button: TextureButton

enum Suit {SPADES = 1, HEARTS, DIAMONDS, CLUBS}

var card_back: Texture2D = preload("res://assets/cards/cardBack_red2.png")
var deck: Array[Card]
var active_pair: CardPair = CardPair.new()

var seconds_timer: Timer = Timer.new()

var score: int = 0
var moves: int = 0
var seconds: float = 0

var score_label: Label
var timer_label: Label
var moves_label: Label

func _ready():
	fill_deck()
	deal_deck()
	Game.add_child(active_pair)
	
	setup_hud()
	
	seconds_timer.timeout.connect(add_second, 1)
	add_child(seconds_timer)
	seconds_timer.start(1)
	
	var splash = pop_up.instantiate()
	Game.add_child(splash)

func setup_hud():
	score_label = Game.get_node("HUD/Panel/Sections/SectionScore/Score")
	timer_label = Game.get_node("HUD/Panel/Sections/SectionSeconds/Seconds")
	moves_label = Game.get_node("HUD/Panel/Sections/SectionMoves/Moves")
	score_label.set_text(str(score))
	timer_label.set_text(str(seconds))
	moves_label.set_text(str(moves))
	
	reset_button = Game.get_node("HUD/Panel/Sections/SectionButtons/ButtonReset")
	reset_button.pressed.connect(reset_game)

func fill_deck() -> void:
	for suit in range(1, 5):
		for value in range(1, 14):
			deck.append(Card.new(suit, value))
	deck.shuffle()

func deal_deck() -> void:
	for card in deck:
		Game.find_child("GridContainer", false).add_child(card)
		
func choose_card(card: Card) -> void:
	if not active_pair.cards_chosen() and not get_tree().is_paused():
		active_pair.choose_card(card)
		
		if active_pair.cards_chosen():
			moves += 1
			moves_label.set_text(str(moves))
			if active_pair.check_cards():
				score += 1
				score_label.set_text(str(score))
				check_score()
			active_pair = CardPair.new()
			Game.add_child(active_pair)

func check_score():
	if score == deck.size()/2:
		var win_screen = pop_up.instantiate()
		Game.add_child(win_screen)
		win_screen.win()

func add_second():
	seconds += 1
	timer_label.set_text(str(seconds))
	seconds_timer.start()
	
func reset_game():
	active_pair.queue_free()
	for card in deck:
		card.queue_free()
	deck.clear()
	
	score = 0
	seconds = 0
	moves = 0
	score_label.text = str(score)
	timer_label.text = str(seconds)
	moves_label.text = str(moves)
	
	fill_deck()
	deal_deck()
	active_pair = CardPair.new()
	Game.add_child(active_pair)
