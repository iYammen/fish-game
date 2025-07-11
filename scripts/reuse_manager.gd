extends Node

const BLOOD = preload("res://scenes/particles/blood.tscn")
const SILVER_COIN = preload("res://scenes/silver_coin.tscn")
const BRONZE_COIN = preload("res://scenes/bronze_coin.tscn")

var bloodArray: Array[AnimatedSprite2D]
var avaliableBlood: AnimatedSprite2D = null
 
var monsterBloodArray: Array[AnimatedSprite2D]
var monsterAvaliableBlood: AnimatedSprite2D = null

var silverCoinArray: Array[Button]
var silverCoinAvaliable: Button

var bronzeCoinArray: Array[Button]
var bronzeCoinAvaliable: Button

func createBlood(pos: Vector2):
	if avaliableBlood == null:
		for blood in bloodArray:
			if !blood.is_playing():
				avaliableBlood = blood
				break
	if avaliableBlood != null:
		avaliableBlood.play()
		avaliableBlood.global_position = pos
		avaliableBlood = null
	else:
		var ins = BLOOD.instantiate()
		get_tree().current_scene.add_child(ins)
		bloodArray.append(ins)
		ins.global_position = pos
		ins.play()

func createMonsterBlood(pos: Vector2):
	if monsterAvaliableBlood == null:
		for blood in monsterBloodArray:
			if !blood.is_playing():
				monsterAvaliableBlood = blood
				break
	if monsterAvaliableBlood != null:
		monsterAvaliableBlood.play()
		monsterAvaliableBlood.global_position = pos
		monsterAvaliableBlood = null
	else:
		var ins = BLOOD.instantiate()
		get_tree().current_scene.add_child(ins)
		ins.scale = Vector2(2,2)
		monsterBloodArray.append(ins)
		ins.global_position = pos
		ins.play()

func createSilverCoin(pos: Vector2):
	if silverCoinAvaliable == null:
		for silverCoin in silverCoinArray:
			if silverCoin.avaliable:
				silverCoinAvaliable = silverCoin
				break
	if silverCoinAvaliable != null:
		silverCoinAvaliable.resetCoin()
		silverCoinAvaliable.global_position = pos
		silverCoinAvaliable = null
	else:
		var ins = SILVER_COIN.instantiate()
		get_tree().current_scene.add_child(ins)
		silverCoinArray.append(ins)
		ins.global_position = pos

func createBronzeCoin(pos: Vector2):
	if bronzeCoinAvaliable == null:
		for bronzeCoin in bronzeCoinArray:
			if bronzeCoin.avaliable:
				bronzeCoinAvaliable = bronzeCoin
				break
	if bronzeCoinAvaliable != null:
		bronzeCoinAvaliable.resetCoin()
		bronzeCoinAvaliable.global_position = pos
		bronzeCoinAvaliable = null
	else:
		var ins = BRONZE_COIN.instantiate()
		get_tree().current_scene.add_child(ins)
		bronzeCoinArray.append(ins)
		ins.global_position = pos
	print(bronzeCoinArray.size())

func Reset():
	bloodArray.resize(0)
	monsterBloodArray.resize(0)
	silverCoinArray.resize(0)
	bronzeCoinArray.resize(0)
