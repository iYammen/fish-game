extends State
@export var fish: RigidBody2D
@onready var move_timer: Timer = $"../../MoveTimer"
var game_manager: GameManager
var closestEnemy: Area2D
var target: Vector2
@onready var attack_cool_down_timer: Timer = $"../../attackCoolDownTimer"

func Enter() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	move_timer.stop()

func Update(_delta:float):
	if fish.global_position.x - target.x < 0:
		fish.sprite_2d.flip_h = true
	else:
		fish.sprite_2d.flip_h = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta: float):
	if attack_cool_down_timer.is_stopped():
		_update_closest_food()
		if closestEnemy:
			target = closestEnemy.global_position
			fish.global_position = fish.global_position.move_toward(target, 150 * delta)

func _update_closest_food() -> void:
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		if closestEnemy == null:
					closestEnemy = enemy
		elif fish.global_position.distance_to(enemy.global_position) < fish.global_position.distance_to(closestEnemy.global_position):
			closestEnemy = enemy
	if closestEnemy == null:
		state_transition.emit(self, "wander")

func Exit():
	pass


func _on_hit_box_area_entered(area: Area2D) -> void:
	if attack_cool_down_timer.is_stopped():
		attack_cool_down_timer.start()
		area.health.takeDamage(20)
		fish.linear_velocity += Vector2(randf_range(-200,200), randf_range(-200,200))
