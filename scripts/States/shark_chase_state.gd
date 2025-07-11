extends State
@export var fish: RigidBody2D
var closestEnemy: Area2D
var target: Vector2
var attackCoolDown: float

func Enter() -> void:
	attackCoolDown = randf_range(0.3,0.7)

func Update(_delta:float):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta: float):
	attackCoolDown -= delta
	if attackCoolDown <= 0:
		_update_closest_enemy()
		if closestEnemy:
			target = (closestEnemy.global_position - fish.global_position).normalized()
			fish.sprite_2d.flip_h = target.x > 0
			fish.linear_velocity = target * 110
		else:
			attackCoolDown = randf_range(0.3,0.7)

func _update_closest_enemy() -> void:
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
	if attackCoolDown <= 0:
		attackCoolDown = randf_range(0.7,1.3)
		area.health.takeDamage(fish.damage)
		fish.game_manager.ShowDamageNumb(fish.damage, area.global_position)
		fish.linear_velocity += Vector2(randf_range(-200,200), randf_range(-200,200))
