extends Panel

@onready var title_label: Label = $titleLabel
@onready var texture_rect: TextureRect = $TextureRect
@onready var error_message_label: Label = $errorMessageLabel

const WARNINGICON = preload("res://assets/icons/32/warning.png")
const NOTHING = preload("res://assets/icons/32/nothing.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CloseError()

func showError(title: String ,text: String, icon: int):
	AudioManager.playError()
	visible = true
	error_message_label.text = text
	title_label.text = title
	match icon:
		0:
			texture_rect.texture = NOTHING
		1:
			texture_rect.texture = WARNINGICON
	await get_tree().create_timer(2).timeout
	CloseError()

func CloseError():
	visible = false

func _on_button_button_down() -> void:
	AudioManager.playButtonClick()
	CloseError()
