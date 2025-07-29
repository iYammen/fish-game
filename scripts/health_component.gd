extends Node2D
class_name healthComponent

@export var maxHealth: int = 100
@export var sprite: Node
var currentHealth: int
signal died
var scaleTween: Tween

func _ready() -> void:
	currentHealth = maxHealth
	
# Called when the node enters the scene tree for the first time.
func takeDamage(damage: int):
	playHurtAnim()
	currentHealth -= damage
	if currentHealth <= 0:
		died.emit()

func animate():
	if scaleTween and scaleTween.is_running():
		return
	
	scaleTween = create_tween()
	# Scale up (quick ease out)
	scaleTween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	scaleTween.tween_property(sprite, "rotation_degrees", 6.6, 0.05)
	scaleTween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	scaleTween.tween_property(sprite, "rotation_degrees", -6.6, 0.05)
	# Then scale down (with bounce)
	scaleTween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	scaleTween.tween_property(sprite, "rotation_degrees", 0, 0.25)

func playHurtAnim():
	if sprite != null:
		animate()
		sprite.modulate =  Color(100, 100, 100)
		await get_tree().create_timer(0.05).timeout
		sprite.modulate =  Color(1, 1, 1)
