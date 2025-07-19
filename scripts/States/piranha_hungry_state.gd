extends State
@export var fish: Node2D
@export var speed: float
var closestFood: Node2D

func Enter() -> void:
	pass

func Physics_Update(delta: float):
	_update_closest_food()
	if closestFood:
		
		var direction = (closestFood.global_position - fish.global_position).normalized()
		fish.global_position += direction * speed * delta
		
		var to_target = closestFood.global_position - fish.global_position
		var distance = to_target.length()
		
		if distance < fish.speed * delta:
			fish.attackCoolDown_t = randf_range(0.7,1.3)
			state_transition.emit(self, "wander")
		
		var flip_now := fish.global_position.x - closestFood.global_position.x < 0
		if flip_now != fish.sprite_2d.flip_h:
			fish.sprite_2d.flip_h = flip_now


func _update_closest_food() -> void:
	closestFood = null
	var allFood = get_tree().get_nodes_in_group("Guppy")
	if allFood.size() > 0:
		for food in allFood:
			if food.feedCount < 4:
				if closestFood == null or fish.global_position.distance_squared_to(food.global_position) < fish.global_position.distance_squared_to(closestFood.global_position):
					closestFood = food
	if closestFood == null:
		state_transition.emit(self, "wander")

func Exit():
	pass

func _on_hit_box_area_entered(area: Area2D) -> void:
	if fish.is_hungry:
		if area.owner.is_in_group("Guppy"):
			if area.owner.feedCount < 4:
				fish.is_hungry = false
				fish.hungerWaitTime = randf_range(fish.hungerTimerRange.x, fish.hungerTimerRange.y)
				fish.hunger_t = fish.hungerWaitTime
				area.owner.health.takeDamage(100)
				state_transition.emit(self, "wander")
