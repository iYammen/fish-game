extends AnimatedSprite2D

@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AnimationManager.bounceAnim(self, 1.15)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func setTimer(time: float):
	timer.start(time)


func _on_timer_timeout() -> void:
	queue_free()
