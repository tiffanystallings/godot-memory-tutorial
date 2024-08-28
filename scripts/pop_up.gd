extends Control

var play_button: Node

func _ready():
	play_button = get_node("CenterContainer/Panel/VBoxContainer/Button")
	play_button.pressed.connect(new_game)
	get_tree().set_pause(true)
	
func new_game():
	get_tree().set_pause(false)
	GameManager.reset_game()
	queue_free()

func win():
	var base_label_string = "You found {score} pairs in {secs} seconds, and flipped {moves} pairs of cards!"
	var formatter = { 
		"score": GameManager.score, 
		"secs": GameManager.seconds,  
		"moves": GameManager.moves
	}
	$CenterContainer/Panel/VBoxContainer/TextureRect.set_texture(load("res://assets/ui/complete.png"))
	$CenterContainer/Panel/VBoxContainer/Label.text = base_label_string.format(formatter)
