extends Node

const BLOOD = preload("res://scenes/particles/blood.tscn")
const SILVER_COIN = preload("res://scenes/silver_coin.tscn")
const BRONZE_COIN = preload("res://scenes/bronze_coin.tscn")

var bloodArray: Array[AnimatedSprite2D] = []
var monsterBloodArray: Array[AnimatedSprite2D] = []
var silverCoinArray: Array[Button] = []
var bronzeCoinArray: Array[Button] = []

func createBlood(pos: Vector2):
	for blood in bloodArray:
		if !blood.is_playing():
			blood.global_position = pos
			blood.play()
			return
	var new_blood: AnimatedSprite2D = BLOOD.instantiate()
	new_blood.global_position = pos
	get_tree().current_scene.add_child(new_blood)
	new_blood.play()
	bloodArray.append(new_blood)

func createMonsterBlood(pos: Vector2):
	for blood in monsterBloodArray:
		if !blood.is_playing():
			blood.global_position = pos
			blood.play()
			return
	var new_blood: AnimatedSprite2D = BLOOD.instantiate()
	new_blood.scale = Vector2(2, 2)
	new_blood.global_position = pos
	get_tree().current_scene.add_child(new_blood)
	new_blood.play()
	monsterBloodArray.append(new_blood)

func createSilverCoin(pos: Vector2):
	for coin in silverCoinArray:
		if coin.available:
			coin.global_position = pos
			coin.resetCoin()
			print(silverCoinArray.size())
			return
	var new_coin: Button = SILVER_COIN.instantiate()
	new_coin.global_position = pos
	get_tree().current_scene.add_child(new_coin)
	silverCoinArray.append(new_coin)

func createBronzeCoin(pos: Vector2):
	for coin in bronzeCoinArray:
		if coin.available:
			coin.global_position = pos
			coin.resetCoin()
			return
	var new_coin: Button = BRONZE_COIN.instantiate()
	new_coin.global_position = pos
	get_tree().current_scene.add_child(new_coin)
	bronzeCoinArray.append(new_coin)

func Reset():
	bloodArray.clear()
	monsterBloodArray.clear()
	silverCoinArray.clear()
	bronzeCoinArray.clear()
