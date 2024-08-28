extends Node

class_name CardPair

var _card1: Card
var _card2: Card
var _flip_timer: Timer = Timer.new()
var _match_timer: Timer = Timer.new()

func _init(card1: Card = null, card2: Card = null):
	self._card1 = card1
	self._card2 = card2

func _ready():
	set_process_mode(PROCESS_MODE_ALWAYS)
	_flip_timer.timeout.connect(flip_cards, 5)
	_match_timer.timeout.connect(delete_cards, 5)
	add_child(_match_timer)
	add_child(_flip_timer)
	
func choose_card(card: Card) -> void:
	if not self._card1 or not self._card2:
		if not self._card1:
			self._card1 = card
			self._card1.flip()
			self._card1.set_disabled(true)
		else:
			self._card2 = card
			self._card2.flip()
			self._card2.set_disabled(true)

func cards_chosen() -> bool:
	return self._card1 and self._card2

func check_cards() -> bool:
	if self._card1.get_value() == self._card2.get_value():
		_match_timer.start(0.5)
		return true
	else:
		_flip_timer.start(1)
		return false

func flip_cards() -> void:
	self._card1.flip()
	self._card1.set_disabled(false)
	self._card2.flip()
	self._card2.set_disabled(false)
	unset_cards()
	queue_free()

func delete_cards() -> void:
	if (is_instance_valid(self._card1) and is_instance_valid(self._card2)):
		self._card1.delete_self()
		self._card2.delete_self()
	unset_cards()
	queue_free()

func unset_cards() -> void:
	self._card1 = null
	self._card2 = null
