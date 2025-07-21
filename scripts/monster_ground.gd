extends  Area2D

@export var health: healthComponent
@export var speed: float = 50.0
@export var value: int

var dir := 1

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var move_t: float
var coolDown_t: float

@onready var right_wall_check: RayCast2D = $rightWallCheck
@onready var left_wall_check: RayCast2D = $leftWallCheck
@onready var button: Button = $Button
var game_manager: GameManager

var fish: Node
var entered: bool = false
var eat_t := 0.0
var target_anim: String

func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	dir = -1 if randf() < 0.5 else 1
	move_t = randf_range(2.0, 8.0)
	coolDown_t = randf_range(0.3,0.7)
	health.died.connect(die)

func die():
	AudioManager.playBlood()
	button.mouse_filter = Control.MOUSE_FILTER_PASS
	var finalValue: int = calculator.calculateScore(value)
	game_manager.addCoin(finalValue)
	game_manager.ShowNumb(finalValue, global_position + Vector2(0, -15))
	reuseManager.createMonsterBlood(global_position)
	animated_sprite_2d.visible = false
	queue_free()

func _process(_delta: float) -> void:
	animated_sprite_2d.flip_h = dir == 1

func _physics_process(delta: float) -> void:
	if !entered:
		target_anim = "run"
		# Wall collision check
		if right_wall_check.is_colliding():
			dir = -1
		elif left_wall_check.is_colliding():
			dir = 1
		
		# Movement
		position.x += speed * dir * delta
		
		move_t -= delta
		if move_t <=0:
			dir = -dir
			move_t = randf_range(2.0, 8.0)
	else:
		eat_t -= delta
		if eat_t <= 0 and fish != null:
			AudioManager.playFishEaten()
			fish.health.takeDamage(100)
			target_anim = "chomp"
		else:
			target_anim = "idle"
	
	if animated_sprite_2d.animation != target_anim:
		if animated_sprite_2d.animation == "chomp" and !animated_sprite_2d.is_playing():
			animated_sprite_2d.play(target_anim)
		elif animated_sprite_2d.animation != "chomp":
			animated_sprite_2d.play(target_anim)


func _on_body_entered(body: Node2D) -> void:
	if not entered:
		fish = body
		entered = true
		eat_t = 0.5

func _on_body_exited(body: Node2D) -> void:
	if body == fish:
		entered = false
		fish = null


func _on_button_button_down() -> void:
	AudioManager.playAttack()
	health.takeDamage(game_manager.damage)
	game_manager.ShowDamageNumb(game_manager.damage, get_global_mouse_position())


func _on_area_entered(area: Area2D) -> void:
	if not entered:
		fish = area
		entered = true
		eat_t = 0.5



func _on_area_exited(area: Area2D) -> void:
	if area == fish:
		entered = false
		fish = null
