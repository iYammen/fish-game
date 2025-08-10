extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	RenderingServer.set_default_clear_color(Color.BLACK)


func shakeAnim(obj: Node):
	if obj:
		var tweenNode: Tween
		tweenNode = create_tween()
		var x
		var first_value = bool(randi() % 2)
		if first_value:
			x = -6.6
		else:
			x = 6.6
		# Scale up (quick ease out)
		tweenNode.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
		tweenNode.tween_property(obj, "rotation_degrees", x, 0.05)
		tweenNode.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
		tweenNode.tween_property(obj, "rotation_degrees", -x, 0.05)
		# Then scale down (with bounce)
		tweenNode.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
		tweenNode.tween_property(obj, "rotation_degrees", 0, 0.25)

func bounceAnim(obj: Node, intensity: float):
	if obj:
		var tweenNode: Tween
		tweenNode = create_tween()
		# Scale up (quick ease out)
		tweenNode.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
		tweenNode.tween_property(obj, "scale", Vector2(intensity, intensity), 0.1)

		# Then scale down (with bounce)
		tweenNode.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
		tweenNode.tween_property(obj, "scale", Vector2(1, 1), 0.25)

func fadeAnim(obj: Node, time: float):
	obj.modulate.a = 1
	var tweenNode: Tween
	tweenNode = create_tween()
	# Scale up (quick ease out)
	tweenNode.set_ease(Tween.EASE_IN)
	tweenNode.tween_property(obj, "modulate:a", 0, time)
