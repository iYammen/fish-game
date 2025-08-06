extends Control
class_name powerUpScreen
@export var powerButtons: Array[Button]
@export var powerIcons: Array[Button]
var rng := RandomNumberGenerator.new()
var game_manager: GameManager
@onready var button: Button = $Panel/HBoxContainer/Button
const DEAD_FISH_COMPONENT = preload("res://scenes/power ups/dead_fish_component.tscn")
const DEAD_SHARK_COMPONENT = preload("res://scenes/power ups/dead_shark_component.tscn")
const GROWN_GUPPY_COMPONENT = preload("res://scenes/power ups/grown_guppy_component.tscn")
const LOW_FISH_COUNT_COMPONENT = preload("res://scenes/power ups/low_fish_count_component.tscn")
const UPGRADE_FISH_COMPONENT = preload("res://scenes/power ups/upgrade_fish_component.tscn")
const DEAD_ENEMY_COMPONENT = preload("res://scenes/power ups/dead_enemy_component.tscn")
@onready var website: Control = $Website

var powerWonArray: Array[powerResource]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	rng.randomize()
	setUpPowers()
	powerWonArray.resize(powerButtons.size())


func showScreen():
	AnimationManager.bounceAnim(website, 1.15)
	visible = true
	get_tree().paused = true

func setUpPowers():
	var available_powers := game_manager.powerUps.duplicate() # Copy so we don't destroy original
	powerWonArray.clear()
	powerWonArray.resize(powerButtons.size())

	for i in powerButtons.size():
		# Pick a prize from the remaining ones
		var picked := pick_weighted_prize(available_powers)
		powerWonArray[i] = picked
		powerIcons[i].icon = picked.icon
		powerButtons[i].tooltip_text = picked.description
		available_powers.erase(picked) # Remove so it can't repeat

func setUpBasicPowers():
	var available_powers := game_manager.basicPowerUps.duplicate() # Copy so we don't destroy original
	powerWonArray.clear()
	powerWonArray.resize(powerButtons.size())

	for i in powerButtons.size():
		# Pick a prize from the remaining ones
		var picked := pick_weighted_prize(available_powers)
		powerWonArray[i] = picked
		powerIcons[i].icon = picked.icon
		powerButtons[i].tooltip_text = picked.description
		available_powers.erase(picked) # Remove so it can't repeat

func pick_weighted_prize(list: Array[powerResource]) -> powerResource:
	var total := 0
	for p in list:
		total += p.rarity

	var roll := rng.randi_range(1, total)
	var cumulative := 0
	for p in list:
		cumulative += p.rarity
		if roll <= cumulative:
			return p
	return list[0]

func buttonClick(buttonNumb: int):
	match powerWonArray[buttonNumb].id:
		0:
			game_manager.animatePowerIcon(0)
			Engine.time_scale = Engine.time_scale + 0.5
		1:
			game_manager.animatePowerIcon(1)
			game_manager.foodQuality += 1
		2:
			game_manager.animatePowerIcon(2)
			game_manager.foodMax += 1
		3:
			var inst := DEAD_FISH_COMPONENT.instantiate()
			get_tree().current_scene.add_child(inst)
		4:
			game_manager.animatePowerIcon(4)
			game_manager.discount -= 0.1
		5:
			game_manager.animatePowerIcon(5)
			game_manager.damage += 5
		6:
			var inst := DEAD_SHARK_COMPONENT.instantiate()
			get_tree().current_scene.add_child(inst)
		7:
			var inst := GROWN_GUPPY_COMPONENT.instantiate()
			get_tree().current_scene.add_child(inst)
		8:
			var inst := LOW_FISH_COUNT_COMPONENT.instantiate()
			get_tree().current_scene.add_child(inst)
		9:
			var inst := UPGRADE_FISH_COMPONENT.instantiate()
			get_tree().current_scene.add_child(inst)
		10:
			var inst := DEAD_ENEMY_COMPONENT.instantiate()
			get_tree().current_scene.add_child(inst)

	game_manager.editPowerUpBar(powerWonArray[buttonNumb].id, true)
	visible = false
	get_tree().paused = false

func _on_button_pressed() -> void:
	AudioManager.playButtonClick()
	buttonClick(0)

func _on_button_2_pressed() -> void:
	AudioManager.playButtonClick()
	buttonClick(1)

func _on_button_3_pressed() -> void:
	AudioManager.playButtonClick()
	buttonClick(2)


func _on_exit_button_pressed() -> void:
	AudioManager.playButtonClick()
	visible = false
	get_tree().paused = false
