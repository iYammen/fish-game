extends State

var game_manager: GameManager
@export var fish: Node2D

@export var speed: float = 0.5
var target: Vector2
var closestEnemy: Area2D
const MAX := 50.0
var enemyCheckCoolDown: float
var move_t: float

var arc_time: float = 0.0
@export var arc_amplitude: float = 5.0  # height of the arc
@export var arc_frequency: float = 2.0  # speed of up/down motion

func Enter() -> void:
	move_t = randf_range(0.3, 4)
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	target = game_manager.GetDirection()
	enemyCheckCoolDown = randf_range(0.3,0.7)
	arc_amplitude = randf_range(0.2,1)
	arc_frequency = randf_range(0.3,0.6)

func Update(_delta: float):
	var flip_now := fish.global_position.x - target.x < 0
	if flip_now != fish.sprite_2d.flip_h:
		fish.sprite_2d.flip_h = flip_now

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta: float):
	var to_target = target - fish.global_position
	var direction = to_target.normalized()
	var distance = to_target.length()
	
		# Step forward only if not already at the target
	if distance > fish.speed * delta:
		fish.global_position += direction * fish.speed * delta
	else:
		target = game_manager.GetDirection()
		move_t = randf_range(0.3, 4.0)
	
		# Arc motion: vertical bob (up/down)
	arc_time += delta * arc_frequency
	var arc_offset := Vector2(0, sin(arc_time * TAU) * arc_amplitude)

	# Apply arc
	fish.global_position += arc_offset
	
	var flip_now := fish.global_position.x - target.x < 0
	if flip_now != fish.sprite_2d.flip_h:
		fish.sprite_2d.flip_h = flip_now
	
	enemyCheckCoolDown -= delta
	if enemyCheckCoolDown <= 0:
		CheckEnemy()
		enemyCheckCoolDown = randf_range(0.3,0.7)
	
	move_t -= delta
	if move_t <= 0:
		arc_amplitude = randf_range(0.2,1)
		arc_frequency = randf_range(0.3,0.6)
		target = game_manager.GetDirection()
		move_t = randf_range(0.3, 4)

func CheckEnemy():
	if fish.attackCoolDown_t <= 0:
		var allEnemies = EntityManager.allMonsters
		if !allEnemies.is_empty():
			state_transition.emit(self, "chase")

func Exit():
	pass
