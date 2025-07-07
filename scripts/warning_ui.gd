extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var number: int
@export var warningPanels: Array[Panel]

func _ready() -> void:
	animation_player.play("idle")

func ShowAll():
	animation_player.play("popUp")
	
func ShowOne():
	animation_player.play("popUpOne")

func Hide():
	animation_player.play("idle")
