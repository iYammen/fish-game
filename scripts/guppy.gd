extends RigidBody2D
class_name Guppy

@export var speed: float = 20
@export var health: healthComponent
@onready var move_timer: Timer = $MoveTimer
@onready var hunger_timer: Timer = $hungerTimer

var feedCount: int = 6
var game_manager: GameManager

@onready var sprite_2d: Sprite2D = $sprite2D
@onready var money_timer: Timer = $moneyTimer
const BRONZE_COIN = preload("res://scenes/bronze_coin.tscn")
const SILVER_COIN = preload("res://scenes/silver_coin.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	print(game_manager)
	health.died.connect(die)
	hunger_timer.start(randf_range(15,40))

func _process(_delta: float) -> void:
	if hunger_timer.time_left > hunger_timer.wait_time / 1.5:
		modulate = Color.WHITE
	else:
		modulate = Color.LIME
		if hunger_timer.time_left < hunger_timer.wait_time / 2:
			modulate = Color.DARK_GREEN

func _physics_process(_delta: float) -> void:
	if feedCount >= 3 and feedCount < 6:
		if money_timer.is_stopped():
			var coin: Button = BRONZE_COIN.instantiate()
			get_tree().root.add_child(coin)
			coin.global_position = global_position
			money_timer.start(randf_range(5, 10))
		scale = Vector2(1.5,1.5)
	elif feedCount >= 6:
		if money_timer.is_stopped():
			var coin: Button = SILVER_COIN.instantiate()
			get_tree().root.add_child(coin)
			coin.global_position = global_position
			money_timer.start(randf_range(5, 10))
		scale = Vector2(2, 2)

func die():
	queue_free()

func _on_hunger_timer_timeout() -> void:
	visible = false
	queue_free()
