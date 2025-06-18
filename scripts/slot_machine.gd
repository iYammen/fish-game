extends Control
class_name SlotMachine

@export var prizes: Array[prizeResource]

@onready var slot_1: TextureRect   = $TextureRect/HBoxContainer/Slot1
@onready var slot_delay_time: Timer = $slotDelayTime
@onready var spin_time: Timer       = $spinTime
@onready var button: Button         = $Button

var prizeWon: prizeResource     # the prize we actually won
var slotNum: int = 0                 # index that drives the spinning animation
var target_index: int = 0            # index of the chosen prize – where the reel must end

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	visible = false
	rng.randomize()

func _on_slot_delay_time_timeout() -> void:
	if !spin_time.is_stopped():
		Spin()

func _on_spin_time_timeout() -> void:
	# Snap to the actual prize and handle it
	slot_1.texture = prizeWon.portrait
	SpawnPrize()

	# Reset for next spin
	slotNum = 0

func Spin():
	# Show the next portrait (purely visual)
	slot_1.texture = prizes[slotNum].portrait
	slotNum = (slotNum + 1) % prizes.size()
	slot_delay_time.start()

func pick_weighted_prize(list: Array[prizeResource]) -> prizeResource:
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

func SpawnPrize():
	match prizeWon.id:
		0:
			pass
		1:
			var spawn: Guppy = prizeWon.spawnable.instantiate()
			get_tree().root.add_child(spawn)

	# Small pause before returning control to the player
	await get_tree().create_timer(1).timeout
	visible = false
	get_tree().paused = false

func show_machine():
	visible = true
	button.disabled = false
	button.button_pressed = false
	slotNum = 0
	prizeWon = null
	spin_time.stop()
	slot_delay_time.stop()


func _on_button_pressed() -> void:
	print("pressed")
	prizeWon   = pick_weighted_prize(prizes)
	target_index   = prizes.find(prizeWon)

	spin_time.start()
	Spin()
	button.disabled = true
