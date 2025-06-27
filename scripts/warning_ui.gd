extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("idle")

func Show():
	animation_player.play("popUp")

func Hide():
	animation_player.play("idle")
