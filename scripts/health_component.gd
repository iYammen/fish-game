extends Node2D
class_name healthComponent

@export var maxHealth: int = 100
var currentHealth: int
signal died

func _ready() -> void:
	currentHealth = maxHealth
	
# Called when the node enters the scene tree for the first time.
func takeDamage(damage: int):
	currentHealth -= damage
	if currentHealth <= 0:
		died.emit()
