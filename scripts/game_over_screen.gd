extends Control
@onready var label: Label = $Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


func gameOver(stage: int):
	AudioManager.playGameOver()
	get_tree().paused = true
	visible = true
	label.text = "Game Over:\nAn error Occured at Stage: " + str(stage) + "\nNo Guppies Left Alive. \n* Press Enter to restart"
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
