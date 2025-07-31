extends Node2D

var hungerWaitTime: float = 0
@export var hungerTimerRange: Vector2
@export var moneyTimerRange: Vector2
@export var speed: float = 20
@export var health: healthComponent

var hunger_t := 0.0
var money_t := 0.0
var attackCoolDown_t: float 
var is_hungry := false

var game_manager: GameManager
var makingMoney:bool = false
@onready var sprite_2d: Sprite2D = $sprite2D
const BRONZE_COIN = preload("res://scenes/bronze_coin.tscn")
const SILVER_COIN = preload("res://scenes/silver_coin.tscn")
@onready var state_machine: stateMachine = $state_machine
signal state_transition
var hunger_state := 0
var tintCheck_t: float
@onready var hit_box: Area2D = $hitBox
var dead: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EntityManager.allPiranhas.append(self)
	state_transition.connect(state_machine.change_state)
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	health.died.connect(die)
	hungerWaitTime = randf_range(hungerTimerRange.x, hungerTimerRange.y)
	hunger_t = hungerWaitTime
	money_t = randf_range(moneyTimerRange.x, moneyTimerRange.y)
	tintCheck_t = randf_range(2, 5)
	hit_box.set_collision_mask_value(6, false)
	game_manager.addToFishCount()

func _physics_process(delta: float) -> void:
	hunger_t -= delta
	tintCheck_t -= delta
	if hunger_t <= 0.0:
		die()
	else:
		is_hungry = hunger_t < hungerWaitTime * 0.66
		if tintCheck_t <= 0:
			_update_hunger_tint()
			tintCheck_t = randf_range(0, 1)
	
	money_t -= delta
	if money_t <= 0.0:
		_on_money_timer_timeout()
		money_t = randf_range(moneyTimerRange.x, moneyTimerRange.y)
	
	if is_hungry and hit_box.get_collision_mask_value(6) == false:
		hit_box.set_collision_mask_value(6, true)
	elif !is_hungry and hit_box.get_collision_mask_value(6) == true:
		hit_box.set_collision_mask_value(6, false)
	

func _update_hunger_tint() -> void:
	var ratio := hunger_t / hungerWaitTime
	var s := 2 if ratio < 1.0 / 3.0 else 1 if ratio < 0.5 else 0
	if s == hunger_state:
		return
	hunger_state = s
	sprite_2d.modulate = [Color.WHITE, Color.LIME, Color.DARK_GREEN][s]

func die():
	game_manager.removeFromFishCount()
	hit_box.set_collision_layer_value(7, false)
	AudioManager.playBlood()
	reuseManager.createBlood(global_position)
	sprite_2d.visible = false
	if get_tree().get_nodes_in_group("Fish Dead Component").is_empty() != true:
		var fishDeadComponents :=  get_tree().get_nodes_in_group("Fish Dead Component")
		for component in fishDeadComponents:
			component.AddMult()
	queue_free()

func _on_money_timer_timeout() -> void:
	reuseManager.createDiamond(global_position)
	money_t = randf_range(moneyTimerRange.x, moneyTimerRange.y)


func _on_tree_exited() -> void:
	EntityManager.allPiranhas.erase(self)
