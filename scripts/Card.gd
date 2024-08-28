extends TextureButton

class_name Card

var _suit: GameManager.Suit
var _value: int
var _face: Texture2D
var _back: Texture2D
var _deleting: bool

var _delete_timer: Timer = Timer.new()

const SHRINK_SPEED = 0.9
const ROT_SPEED = 10

func _ready():
	set_process_mode(PROCESS_MODE_ALWAYS)
	set_h_size_flags(3)
	set_v_size_flags(3)
	set_stretch_mode(TextureButton.STRETCH_KEEP_ASPECT_CENTERED)
	set_ignore_texture_size(true)
	
	_delete_timer.timeout.connect(end_delete, 5)
	add_child(_delete_timer)

func _init(suit: GameManager.Suit, value: int):
	self._suit = suit
	self._value = value
	self._face = load("res://assets/cards/card-"+str(int(suit))+"-"+str(value)+".png")
	self._back = GameManager.card_back
	set_texture_normal(_back)

func _pressed():
	GameManager.choose_card(self)

func _process(delta):
	if self._deleting:
		set_position(Vector2(position.x + get_new_offset(size.x), position.y + get_new_offset(size.y)))
		set_size(Vector2(size.x * SHRINK_SPEED, size.y * SHRINK_SPEED))
		set_rotation(get_rotation() + deg_to_rad(ROT_SPEED))
		set_modulate(Color(1.0, 1.0, 1.0, 0.5))
	pass
	
func flip():
	if get_texture_normal() == _back:
		set_texture_normal(_face)
	else:
		set_texture_normal(_back)

func get_new_offset(size: float) -> float:
	return (size * (1.0 - SHRINK_SPEED))/2

func get_value() -> int:
	return _value

func delete_self():
	_delete_timer.start(0.5)
	self._deleting = true

func end_delete():
	self._deleting = false
	set_texture_normal(null)
