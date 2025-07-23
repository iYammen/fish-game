extends Node2D
class_name numberUI

@onready var label: Label = $Label
@onready var number_anim: AnimationPlayer = $numberAnim
var available: bool
 
func setNumber(number: int):
	available = false
	number_anim.play("numberAnim")
	modulate = Color.WHITE
	if label != null:
		label.text = str(number) + "$"
	await number_anim.animation_finished
	available = true

func setDamageNumber(number: int):
	number_anim.play("numberAnim")
	modulate = Color.RED
	if label != null:
		label.text = str(number)
	await number_anim.animation_finished
	queue_free()

func setText(words: String):
	if label != null:
		label.text = words
