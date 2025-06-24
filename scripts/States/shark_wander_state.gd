extends State

var game_manager: GameManager
@export var fish: RigidBody2D

@export var speed: float = 0.5
var target: Vector2
var closestEnemy: Area2D
@onready var move_timer: Timer = $"../../MoveTimer"


func Enter() -> void:
	print("test")
	move_timer.start(1)
	print(move_timer.time_left)
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	target = game_manager.GetDirection()

func Update(_delta: float):
	if fish.global_position.x - target.x < 0:
		fish.sprite_2d.flip_h = true
	else:
		fish.sprite_2d.flip_h = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta: float):
	
	fish.linear_velocity.x = clamp(fish.linear_velocity.x, -50, 50)
	fish.linear_velocity.y = clamp(fish.linear_velocity.y, -50, 50)
	fish.linear_velocity =  lerp(fish.linear_velocity, target, speed * delta)
	CheckHunger()

func CheckHunger():
	if closestEnemy != null:
		state_transition.emit(self, "chase")
	else:
		var allEnemies = get_tree().get_nodes_in_group("Enemy")
		if allEnemies.size() > 0:
			for enemy in allEnemies:
				if closestEnemy == null or fish.global_position.distance_to(enemy.global_position) < fish.global_position.distance_to(closestEnemy.global_position):
					closestEnemy = enemy

func Exit():
	pass

func _on_hit_box_body_entered(_body: Node2D) -> void:
	target = -fish.linear_velocity
	fish.linear_velocity = Vector2.ZERO


func _on_move_timer_timeout() -> void:
	print(target)
	target = game_manager.GetDirection()
	move_timer.start(randf_range(0.3, 4))
