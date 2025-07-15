extends Area2D

@export var value: int
@export var health: healthComponent
var game_manager: GameManager
var fish: Area2D
var target: Vector2
var speed: float
var entered: bool = false
var move_t := 0.0
var eat_t := 0.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var button: Button = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	target =  game_manager.GetDirection()
	health.died.connect(die)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_t -= delta
	if entered:
		eat_t -= delta
	
	if move_t <= 0.0:
		target = game_manager.GetDirection()
		move_t = randf_range(3, 6)
		
	if eat_t <= 0.0 and entered and fish:
		fish.health.takeDamage(100)
		eat_t = 1.0
	
	var flip_now := global_position.x < target.x
	if flip_now != animated_sprite_2d.flip_h:
		animated_sprite_2d.flip_h = flip_now
	
	global_position = lerp(global_position, target, 0.25 * delta)
	
	var target_anim := "Eat" if entered else "Idle"
	if animated_sprite_2d.animation != target_anim:
		animated_sprite_2d.play(target_anim)

func die():
	button.mouse_filter = Control.MOUSE_FILTER_PASS
	var finalValue: int = calculator.calculateScore(value)
	game_manager.addCoin(finalValue)
	game_manager.ShowNumb(finalValue, global_position + Vector2(0, -15))
	reuseManager.createMonsterBlood(global_position)
	animated_sprite_2d.visible = false
	queue_free()

func _on_button_pressed() -> void:
	health.takeDamage(game_manager.damage)
	game_manager.ShowDamageNumb(game_manager.damage, get_global_mouse_position())


func _on_area_entered(area: Area2D) -> void:
	fish = area
	entered = true
	eat_t = 0.5


func _on_area_exited(area: Area2D) -> void:
	if area == fish:
		entered = false
		fish = null
