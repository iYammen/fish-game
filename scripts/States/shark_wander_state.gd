extends State

var game_manager: GameManager
@export var fish: RigidBody2D

@export var speed: float = 0.5
var target: Vector2
var closestEnemy: Area2D
const MAX := 50.0
var enemyCheckCoolDown: float
var move_t: float

func Enter() -> void:
	move_t = randf_range(0.3, 4)
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	target = game_manager.GetDirection()
	enemyCheckCoolDown = randf_range(0.3,0.7)

func Update(_delta: float):
	var flip_now := fish.global_position.x - target.x < 0
	if flip_now != fish.sprite_2d.flip_h:
		fish.sprite_2d.flip_h = flip_now

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta: float):
	var v := fish.linear_velocity.lerp(target, speed * delta)
	v.x = clampf(v.x, -MAX, MAX)
	v.y = clampf(v.y, -MAX, MAX)
	fish.linear_velocity = v
	
	enemyCheckCoolDown -= delta
	if enemyCheckCoolDown <= 0:
		CheckEnemy()
		enemyCheckCoolDown = randf_range(0.3,0.7)
	
	move_t -= delta
	if move_t <= 0:
		target = game_manager.GetDirection()
		move_t = randf_range(0.3, 4)

func CheckEnemy():
	if closestEnemy != null:
		state_transition.emit(self, "chase")
	else:
		var allEnemies = get_tree().get_nodes_in_group("Enemy")
		if allEnemies.size() > 0:
			for enemy in allEnemies:
				if closestEnemy == null or fish.global_position.distance_squared_to(enemy.global_position) < fish.global_position.distance_squared_to(closestEnemy.global_position):
					closestEnemy = enemy

func Exit():
	pass
