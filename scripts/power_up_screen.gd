extends Control
class_name powerUpScreen
@export var powerButtons: Array[Button]
var rng := RandomNumberGenerator.new()
var game_manager: GameManager
@onready var button: Button = $Panel/HBoxContainer/Button
const FISH_DIED_COMPONENT = preload("res://scenes/fish_died_component.tscn")
var powerWonArray: Array[powerResource]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	game_manager = get_tree().get_first_node_in_group("Game Manager")
	rng.randomize()
	setUpPowers()
	powerWonArray.resize(powerButtons.size())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func setUpPowers():
	var available_powers := game_manager.powerUps.duplicate() # Copy so we don't destroy original
	powerWonArray.clear()
	powerWonArray.resize(powerButtons.size())

	for i in powerButtons.size():
		# Pick a prize from the remaining ones
		var picked := pick_weighted_prize(available_powers)
		powerWonArray[i] = picked
		powerButtons[i].icon = picked.icon
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
		powerButtons[i].icon = picked.icon
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
			Engine.time_scale = Engine.time_scale * 1.5
		1:
			game_manager.foodQuality += 1
		2:
			game_manager.foodMax += 1
		3:
			var inst := FISH_DIED_COMPONENT.instantiate()
			get_tree().current_scene.add_child(inst)
		4:
			game_manager.discount -= 0.1
		5:
			game_manager.damage += 10
	game_manager.editPowerUpBar(powerWonArray[buttonNumb].id)
	visible = false
	get_tree().paused = false

func _on_button_pressed() -> void:
	buttonClick(0)

func _on_button_2_pressed() -> void:
	buttonClick(1)

func _on_button_3_pressed() -> void:
	buttonClick(2)
