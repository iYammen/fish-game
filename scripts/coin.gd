extends Button

@export var value: int = 20
var game_manager: GameManager
var hitFloor: bool = false
@onready var timer: Timer = $Timer
var collected: bool = false
var available: bool = false
@onready var ray_cast_2d: RayCast2D = $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !hitFloor:
		global_position.y += 50 * delta
	else:
		modulate.a -= 1 / timer.wait_time * delta
	if ray_cast_2d.is_colliding() and !hitFloor:
		var collidedWith = ray_cast_2d.get_collider()
		if collidedWith.is_in_group("Ground Boundary"):
			hitFloor = true
			timer.start()
			global_position.y = 144.0
			ray_cast_2d.enabled = false



func _on_button_down() -> void:
	if !collected:
		AudioManager.playCollect()
		var finalValue: int = calculator.calculateScore(value)
		collected = true
		game_manager.addCoin(finalValue)
		reuseManager.createNumbLabel(global_position, finalValue)
		available = true
		global_position = Vector2(1000,1000)
		remove_from_group("Coin")

func _on_timer_timeout() -> void:
	available = true
	global_position = Vector2(1000,1000)
	remove_from_group("Coin")

func resetCoin():
	ray_cast_2d.enabled = true
	hitFloor = false
	modulate.a = 1
	available = false
	collected = false
	timer.stop()
	add_to_group("Coin")
