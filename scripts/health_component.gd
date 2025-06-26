extends Node2D
class_name healthComponent

@export var maxHealth: int = 100
@export var sprite: AnimatedSprite2D
var currentHealth: int
signal died

func _ready() -> void:
	currentHealth = maxHealth
	
# Called when the node enters the scene tree for the first time.
func takeDamage(damage: int):
	playHurtAnim()
	currentHealth -= damage
	if currentHealth <= 0:
		died.emit()

func playHurtAnim():
	if sprite != null:
		sprite.modulate =  Color(100, 100, 100)
		await get_tree().create_timer(0.05).timeout
		sprite.modulate =  Color(1, 1, 1)
