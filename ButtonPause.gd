extends TextureButton

var pause_texture = load("res://assets/ui/pause.png")
var play_texture = load("res://assets/ui/play.png")

func _pressed():
	if get_tree().is_paused():
		get_tree().set_pause(false)
		set_texture_normal(pause_texture)
	else:
		get_tree().set_pause(true)
		set_texture_normal(play_texture)
