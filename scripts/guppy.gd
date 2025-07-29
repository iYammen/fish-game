extends Node2D
class_name Guppy

var hungerWaitTime: float = 0
@export var hungerTimerRange: Vector2
@export var hungerAdultTimerRange: Vector2
@export var moneyTimerRange: Vector2
@export var speed: float = 20
@export var health: healthComponent

var move_t := 0.0
var hunger_t := 0.0
var money_t := 0.0
var attackCoolDown_t: float 
var is_hungry := false


var feedCount: int = 0
var game_manager: GameManager
var makingMoney:bool = false
@onready var sprite_2d: Sprite2D = $sprite2D
const BRONZE_COIN = preload("res://scenes/bronze_coin.tscn")
const SILVER_COIN = preload("res://scenes/silver_coin.tscn")
@onready var state_machine: stateMachine = $state_machine
signal state_transition
var hunger_state := 0
var grown_state : int = INF
var tintCheck_t: float
var dead: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EntityManager.allGuppies.append(self)
	state_transition.connect(state_machine.change_state)
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	health.died.connect(die)
	move_t = randf_range(0.3, 4.0)
	hungerWaitTime = randf_range(hungerTimerRange.x, hungerTimerRange.y)
	hunger_t = hungerWaitTime
	money_t = randf_range(moneyTimerRange.x, moneyTimerRange.y)
	tintCheck_t = randf_range(2, 5)
	checkFoodCount()
	game_manager.addToFishCount()

func _physics_process(delta: float) -> void:
	move_t -= delta
	hunger_t -= delta
	tintCheck_t -= delta
	if hunger_t <= 0.0:
		die()
	else:
		is_hungry = hunger_t < hungerWaitTime * 0.66
		if tintCheck_t <= 0:
			_update_hunger_tint()
			tintCheck_t = randf_range(0, 1)
	
	if makingMoney:
		money_t -= delta
		if money_t <= 0.0:
			_on_money_timer_timeout()
			money_t = randf_range(moneyTimerRange.x, moneyTimerRange.y)


func _update_hunger_tint() -> void:
	var ratio := hunger_t / hungerWaitTime
	var s := 2 if ratio < 1.0 / 3.0 else 1 if ratio < 0.5 else 0
	if s == hunger_state:
		return
	hunger_state = s
	sprite_2d.modulate = [Color.WHITE, Color.LIME, Color.DARK_GREEN][s]


func checkFoodCount():
	var s := 0 if feedCount < 4 else 1 if feedCount < 10 else 2
	if s == grown_state:
		return
	grown_state = s
	sprite_2d.frame = [0,1,2][s]
	if s == 1:
		money_t = randf_range(moneyTimerRange.x, moneyTimerRange.y)
		makingMoney = true
	if s == 2:
		makingMoney = true
		hungerTimerRange = hungerAdultTimerRange
		var grownGuppyComponents :=  get_tree().get_nodes_in_group("Grown Guppy Component")
		if grownGuppyComponents.is_empty() != true:
			for component in grownGuppyComponents:
				component.AddMult()

func die():
	game_manager.removeFromFishCount()
	AudioManager.playBlood()
	reuseManager.createBlood(global_position)
	sprite_2d.visible = false
	var fishDeadComponents :=  get_tree().get_nodes_in_group("Fish Dead Component")
	if fishDeadComponents.is_empty() != true:
		for component in fishDeadComponents:
			component.AddMult()
	if grown_state == 2:
		var grownGuppyComponents :=  get_tree().get_nodes_in_group("Grown Guppy Component")
		if grownGuppyComponents.is_empty() != true:
			for component in grownGuppyComponents:
				component.RemoveMult()
	queue_free()

func _on_money_timer_timeout() -> void:
	if feedCount >= 4 and feedCount < 10:
		reuseManager.createBronzeCoin(global_position)
	elif feedCount >= 10:
		reuseManager.createSilverCoin(global_position)
	money_t = randf_range(moneyTimerRange.x, moneyTimerRange.y)


func _on_tree_exited() -> void:
	EntityManager.allGuppies.erase(self)
	game_manager.checkFishAmount()
