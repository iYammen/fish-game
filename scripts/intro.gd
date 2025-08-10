extends Node2D

var transition: ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transition = get_tree().get_first_node_in_group("Transition")
	await get_tree().create_timer(10).timeout
	transition.fadeOut()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Levels/level.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("gameOver"):
		AudioManager.playButtonClick()
		transition.fadeOut()
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://Levels/level.tscn")
