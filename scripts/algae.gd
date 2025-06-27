extends Area2D

@onready var cool_down_timer: Timer = $coolDownTimer
@export var health: healthComponent
@onready var sprite_2d: Sprite2D = $Sprite2D
var foodQuality: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Food")
	health.died.connect(die)
	sprite_2d.frame = 0

func die():
	health.currentHealth = health.maxHealth
	remove_from_group("Food")
	cool_down_timer.start()
	sprite_2d.frame = 1

func _on_cool_down_timer_timeout() -> void:
	add_to_group("Food")
	sprite_2d.frame = 0
