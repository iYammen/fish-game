extends Control

@export var powerUpIcons: Array[powerUpIcon]
@export var powerUps: Array[powerResource]
var game_manager: GameManager
var scaleTween: Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in powerUpIcons.size():
		powerUpIcons[i].tooltip_text = powerUps[i].description


func animateIcon(id: int):
	if scaleTween and scaleTween.is_running():
		return
	
	scaleTween = create_tween()
	# Scale up (quick ease out)
	scaleTween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	scaleTween.tween_property(powerUpIcons[id], "scale", Vector2(1.25, 1.25), 0.1)

	# Then scale down (with bounce)
	scaleTween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	scaleTween.tween_property(powerUpIcons[id], "scale", Vector2(1, 1), 0.25)
