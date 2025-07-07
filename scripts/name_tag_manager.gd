extends Node2D

const NAME_TAG_LABEL = preload("res://scenes/UI/name_tag_label.tscn")
var tag_pool: Array[Node2D] = []

func assign_follow(fish: Node2D, text: String) -> void:
	var tag := _get_tag()
	tag.name_label.text = text
	tag.target = fish
	fish.add_child(tag)
	tag.position = Vector2.ZERO
	tag.show()

func unassign_follow(tag: Node2D) -> void:
	tag.hide()
	tag.target = null
	tag_pool.append(tag)

func _get_tag() -> Node2D:
	return tag_pool.pop_back() if tag_pool.size() > 0 else NAME_TAG_LABEL.instantiate()
