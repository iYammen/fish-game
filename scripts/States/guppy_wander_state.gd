extends State

@export var fish: Guppy

@export var speed: float = 0.5
const MAX := 50.0
var target: Vector2
var closestFood: Area2D

var food_scan_t := 0.0

func Enter() -> void:
	closestFood = null
	(func(): target = fish.game_manager.GetDirection()).call_deferred()
	fish.move_t = randf_range(0.3, 4.0)
	food_scan_t = randf_range(0.1, 0.5)

func Update(_delta: float):
	var flip_now := fish.global_position.x - target.x < 0
	if flip_now != fish.sprite_2d.flip_h:
		fish.sprite_2d.flip_h = flip_now

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physics_Update(delta: float):
	var v := fish.linear_velocity.lerp(target, speed * delta)
	v.x = clampf(v.x, -MAX, MAX)         # use clampf() (float) in Godot 4
	v.y = clampf(v.y, -MAX, MAX)
	fish.linear_velocity = v             # one setter ✔
	
	food_scan_t -= delta
	if food_scan_t <= 0.0:
		CheckHunger()
		food_scan_t = randf_range(0.1, 0.5)
	
	if fish.move_t <= 0.0:
		target = fish.game_manager.GetDirection()
		fish.move_t = randf_range(0.3, 4.0)


func CheckHunger():
	if fish.is_hungry:
		if closestFood != null:
			state_transition.emit(self, "hungry")
		else:
			var allFood = get_tree().get_nodes_in_group("Food")
			if allFood.size() > 0:
				for food in allFood:
					if closestFood == null or fish.global_position.distance_squared_to(food.global_position) < fish.global_position.distance_squared_to(closestFood.global_position):
						closestFood = food



func Exit():
	pass
