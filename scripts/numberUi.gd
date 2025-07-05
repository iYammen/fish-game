extends Node2D
class_name numberUI

@onready var label: Label = $Label

func setNumber(number: int):
	modulate = Color.WHITE
	if label != null:
		label.text = str(number) + "$"

func setDamageNumber(number: int):
	modulate = Color.RED
	if label != null:
		label.text = str(number)

func setText(words: String):
	if label != null:
		label.text = words
