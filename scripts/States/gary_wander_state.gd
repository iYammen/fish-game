extends State

@export var fish: Node2D

const MAX := 50.0
var target: Vector2
var closestFood: Node2D

var food_scan_t := 0.0
var arc_time: float = 0.0
@export var arc_amplitude: float = 5.0  # height of the arc
@export var arc_frequency: float = 2.0  # speed of up/down motion

func Enter() -> void:
	arc_amplitude = randf_range(0.2,1)
	arc_frequency = randf_range(0.3,0.6)
	closestFood = null
	(func(): target = fish.game_manager.GetDirection()).call_deferred()
	fish.move_t = randf_range(0.3, 4.0)
	food_scan_t = randf_range(0.1, 0.5)

func Update(_delta: float):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta: float):
	# Move fish toward target at constant speed
	var to_target = target - fish.global_position
	var direction = to_target.normalized()
	var distance = to_target.length()

	# Step forward only if not already at the target
	if distance > fish.speed * delta:
		fish.global_position += direction * fish.speed * delta
	else:
		target = fish.game_manager.GetDirection()
		fish.move_t = randf_range(0.3, 4.0)

	# Arc motion: vertical bob (up/down)
	arc_time += delta * arc_frequency
	var arc_offset := Vector2(0, sin(arc_time * TAU) * arc_amplitude)

	# Apply arc
	fish.global_position += arc_offset
	
	var flip_now := fish.global_position.x - target.x < 0
	if flip_now != fish.sprite_2d.flip_h:
		fish.sprite_2d.flip_h = flip_now
	
	food_scan_t -= delta
	if food_scan_t <= 0.0:
		CheckHunger()
		food_scan_t = randf_range(0.1, 0.5)
	
	if fish.move_t <= 0.0:
		arc_amplitude = randf_range(0.2,1)
		arc_frequency = randf_range(0.3,0.6)
		target = fish.game_manager.GetDirection()
		fish.move_t = randf_range(0.3, 4.0)


func CheckHunger():
	if fish.attackCoolDown_t <= 0:
		if fish.is_hungry:
			if closestFood != null:
				state_transition.emit(self, "hungry")
			else:
				var allFood = get_tree().get_nodes_in_group("Piranha")
				if allFood.size() > 0:
					for food in allFood:
						if closestFood == null or fish.global_position.distance_squared_to(food.global_position) < fish.global_position.distance_squared_to(closestFood.global_position):
							closestFood = food



func Exit():
	pass
