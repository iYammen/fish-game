extends State
@export var fish: Node2D
var closestEnemy: Area2D
var target: Vector2
@export var speed: float

func Enter() -> void:
	pass

func Update(_delta:float):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta: float):
	_update_closest_enemy()
	if closestEnemy:
		var direction = (closestEnemy.global_position - fish.global_position).normalized()
		fish.global_position += direction * speed * delta
		
		var to_target = closestEnemy.global_position - fish.global_position
		var distance = to_target.length()
		
		if distance < fish.speed * delta:
			fish.attackCoolDown_t = randf_range(0.7,1.3)
			state_transition.emit(self, "wander")
		
		var flip_now := fish.global_position.x - closestEnemy.global_position.x < 0
		if flip_now != fish.sprite_2d.flip_h:
			fish.sprite_2d.flip_h = flip_now
	


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
	if fish.attackCoolDown_t <= 0:
		fish.attackCoolDown_t = randf_range(0.7,1.3)
		area.health.takeDamage(fish.damage)
		fish.game_manager.ShowDamageNumb(fish.damage, area.global_position)
		state_transition.emit(self, "wander")
