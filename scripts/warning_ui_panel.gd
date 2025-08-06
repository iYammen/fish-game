extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AnimationManager.bounceAnim(self, 1.1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_button_button_down() -> void:
	AudioManager.playButtonClick()
	visible = false
