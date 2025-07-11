extends Node

const BLOOD = preload("res://scenes/particles/blood.tscn")
var bloodArray: Array[AnimatedSprite2D]
var avaliableBlood: AnimatedSprite2D = null
 
var monsterBloodArray: Array[AnimatedSprite2D]
var monsterAvaliableBlood: AnimatedSprite2D = null

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

func Reset():
	bloodArray.resize(0)
	monsterBloodArray.resize(0)
