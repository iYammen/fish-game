extends Node

var game_manager: GameManager
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")

func AddMult():
	calculator.multiplier += 0.1
	timer.start()


func _on_timer_timeout() -> void:
	calculator.multiplier -= 0.1
