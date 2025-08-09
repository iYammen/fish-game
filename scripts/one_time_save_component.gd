extends Node

const GUPPY = preload("res://scenes/Fish/guppy.tscn")
var game_manager: GameManager

func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")

func SavePlayer():
	game_manager.gameJustStarted = true
	var spawn:= GUPPY.instantiate()
	get_tree().current_scene.add_child(spawn)
	spawn.global_position = game_manager.GetDirection()
	queue_free()
	game_manager.editPowerUpBar(11, false)
