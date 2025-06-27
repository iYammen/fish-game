extends RigidBody2D
class_name Guppy

@export var nameRes: nameResource
@export var hungerTimerRange: Vector2
@export var speed: float = 20
@export var health: healthComponent
@onready var move_timer: Timer = $MoveTimer
@onready var hunger_timer: Timer = $hungerTimer
@onready var blood: AnimatedSprite2D = $blood
@onready var name_label: Label = $nameLabel

var feedCount: int = 0
var game_manager: GameManager
var makingMoney:bool = false
@onready var sprite_2d: Sprite2D = $sprite2D
@onready var money_timer: Timer = $moneyTimer
const BRONZE_COIN = preload("res://scenes/bronze_coin.tscn")
const SILVER_COIN = preload("res://scenes/silver_coin.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_pickable = true
	name_label.visible = false
	name_label.text = nameRes.firstNames[randi_range(0, nameRes.firstNames.size() - 1)] + " " + nameRes.lastNames[randi_range(0, nameRes.lastNames.size() - 1)]
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	health.died.connect(die)
	hunger_timer.start(randf_range(hungerTimerRange.x,hungerTimerRange.y))

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		die()
	if hunger_timer.time_left > hunger_timer.wait_time / 1.5:
		sprite_2d.modulate = Color.WHITE
	else:
		sprite_2d.modulate = Color.LIME
		if hunger_timer.time_left < hunger_timer.wait_time / 2:
			sprite_2d.modulate = Color.DARK_GREEN

func _physics_process(_delta: float) -> void:
	pass

func checkFoodCount():
	if !makingMoney and feedCount >= 3:
		money_timer.start(randf_range(5, 10))
		makingMoney = true
	if feedCount >= 3 and feedCount < 6:
		sprite_2d.frame = 1
	elif feedCount >= 6:
		sprite_2d.frame = 2

func die():
	blood.play("default")
	sprite_2d.visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(0.8).timeout
	queue_free()

func _on_hunger_timer_timeout() -> void:
	die()


func _on_mouse_entered() -> void:
	name_label.visible = true

func _on_mouse_exited() -> void:
	name_label.visible = false

func _on_money_timer_timeout() -> void:
	if feedCount >= 3 and feedCount < 6:
		var coin: Button = BRONZE_COIN.instantiate()
		get_tree().root.add_child(coin)
		coin.global_position = global_position
	elif feedCount >= 6:
		var coin: Button = SILVER_COIN.instantiate()
		get_tree().root.add_child(coin)
		coin.global_position = global_position
	money_timer.start(randf_range(5, 10))
