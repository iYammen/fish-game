extends ColorRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func fadeIn():
	animation_player.play("fade_in")

func fadeOut():
	animation_player.play("fade_out")
