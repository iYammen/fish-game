extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("idle")

func ShowAll():
	animation_player.play("popUpAll")
	
func ShowOne():
	animation_player.play("popUpOne")

func Hide():
	animation_player.play("idle")
