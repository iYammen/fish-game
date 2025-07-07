extends State

@export var fish: Guppy

@export var speed: float = 0.5
const MAX := 50.0
var target: Vector2
var closestFood: Area2D
@onready var move_timer: Timer = $"../../MoveTimer"
@onready var hunger_timer: Timer = $"../../hungerTimer"
@onready var food_scan_cool_down: Timer = $"../../foodScanCoolDown"
var is_hungry := false

func Enter() -> void:
	is_hungry = false
	closestFood = null
	move_timer.start()
	(func(): target = fish.game_manager.GetDirection()).call_deferred()
	food_scan_cool_down.start(randf_range(0.3, 1))

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
	

func CheckHunger():
	if is_hungry:
		return
	
	if hunger_timer.time_left < hunger_timer.wait_time / 1.5:
		if closestFood != null:
			is_hungry = true
			state_transition.emit(self, "hungry")
		else:
			if fish.game_manager.allFood.size() > 0:
				for food in fish.game_manager.allFood:
					if closestFood == null or fish.global_position.distance_squared_to(food.global_position) < fish.global_position.distance_to(closestFood.global_position):
						closestFood = food



func Exit():
	food_scan_cool_down.stop()


func _on_move_timer_timeout() -> void:
	target = fish.game_manager.GetDirection()
	move_timer.start(randf_range(0.3, 4))


func _on_food_scan_cool_down_timeout() -> void:
	CheckHunger()
	food_scan_cool_down.start(randf_range(0.3, 1))
