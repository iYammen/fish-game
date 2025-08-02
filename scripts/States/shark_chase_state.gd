extends State
@export var fish: Node2D
var closestEnemy: Node2D
var target: Vector2
@export var speed: float
var coolDown_t: float

func Enter() -> void:
	coolDown_t = randf_range(0.3,0.7)

func Update(_delta:float):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta: float):
	coolDown_t -= delta
	if coolDown_t <= 0:
		_update_closest_enemy()
		coolDown_t = randf_range(0.3,0.7)
	if closestEnemy:
		var direction = (closestEnemy.global_position - fish.global_position).normalized()
		
		
		var to_target = closestEnemy.global_position - fish.global_position
		var distance = to_target.length()
		
		if distance > fish.speed * delta:
			fish.global_position += direction * speed * delta
		else:
			fish.attackCoolDown_t = randf_range(0.7,1.3)
			state_transition.emit(self, "wander")
			return
		
		if distance < 50:
			fish.attackCoolDown_t = randf_range(0.7,1.3)
			closestEnemy.health.takeDamage(fish.damage)
			fish.game_manager.ShowDamageNumb(fish.damage, closestEnemy.global_position)
			state_transition.emit(self, "wander")
			return

		var flip_now := fish.global_position.x - closestEnemy.global_position.x < 0
		if flip_now != fish.sprite_2d.flip_h:
			fish.sprite_2d.flip_h = flip_now
	


func _update_closest_enemy() -> void:
	closestEnemy = null
	var allMonsters = EntityManager.allMonsters
	var foodSize: int = clampi(allMonsters.size(), 0, 45)
	var closest_dist := INF
	if allMonsters.is_empty():
		state_transition.emit(self, "wander")
		return
	for i in foodSize:
		var monster = allMonsters[i]
		var dist = fish.global_position.distance_squared_to(monster.global_position)
		if dist < closest_dist:
			closestEnemy = monster
			closest_dist = dist

func Exit():
	pass
