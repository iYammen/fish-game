extends State

@export var crab: Crab
@export var speed: float = 50.0

var dir := 1
var closestCoin: Button

var move_t: float
var coolDown_t: float

@onready var right_wall_check: RayCast2D = $"../../rightWallCheck"
@onready var left_wall_check: RayCast2D = $"../../leftWallCheck"

func Enter() -> void:
	dir = -1 if randf() < 0.5 else 1
	move_t = randf_range(2.0, 8.0)
	coolDown_t = randf_range(0.3,0.7)

func Update(_delta: float) -> void:
	crab.sprite_2d.flip_h = dir == -1

func Physics_Update(delta: float) -> void:
	# Wall collision check
	if right_wall_check.is_colliding():
		dir = -1
	elif left_wall_check.is_colliding():
		dir = 1
	
	# Movement
	crab.position.x += speed * dir * delta
	
	move_t -= delta
	if move_t <=0:
		dir = -dir
		move_t = randf_range(2.0, 8.0)
	
	coolDown_t -= delta
	if coolDown_t <=0:
		CheckCoin()
		coolDown_t = randf_range(0.3,0.7)

func CheckCoin() -> void:
	var coins = get_tree().get_nodes_in_group("Coin")
	var closest_dist := INF
	var found_coin: Button = null

	for coin in coins:
		if coin == null:
			continue
		var dist := crab.global_position.distance_squared_to(coin.global_position)
		if dist < closest_dist:
			closest_dist = dist
			found_coin = coin

	if found_coin != null:
		closestCoin = found_coin
		state_transition.emit(self, "chase")

func Exit() -> void:
	pass
