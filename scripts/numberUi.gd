extends Node2D
class_name numberUI

@onready var label: Label = $Label

func setNumber(number: int):
	if label != null:
		label.text = str(number) + "$"
