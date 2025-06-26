extends State

@export var fish: Guppy

@export var speed: float = 0.5
var target: Vector2
var closestFood: Area2D
@onready var move_timer: Timer = $"../../MoveTimer"
@onready var hunger_timer: Timer = $"../../hungerTimer"

func Enter() -> void:
	move_timer.start()
	(func(): target = fish.game_manager.GetDirection()).call_deferred()

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
	if hunger_timer.time_left < hunger_timer.wait_time / 1.5:
		if closestFood != null:
			state_transition.emit(self, "hungry")
		else:
			var allFood = get_tree().get_nodes_in_group("Food")
			if allFood.size() > 0:
				for food in allFood:
					if closestFood == null or fish.global_position.distance_to(food.global_position) < fish.global_position.distance_to(closestFood.global_position):
						closestFood = food



func Exit():
	pass


func _on_move_timer_timeout() -> void:
	target = fish.game_manager.GetDirection()
	move_timer.start(randf_range(0.3, 4))
