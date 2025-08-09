extends Panel

@onready var title_label: Label = $titleLabel
@onready var texture_rect: TextureRect = $TextureRect
@onready var error_message_label: Label = $errorMessageLabel

const WARNINGICON = preload("res://assets/icons/32/warning.png")
const NOTHING = preload("res://assets/icons/32/nothing.png")
const SMILE = preload("res://assets/icons/32/smile.png")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CloseError()

func showMessage(title: String ,text: String, icon: int):
	visible = true
	error_message_label.text = text
	title_label.text = title
	match icon:
		0:
			AudioManager.playError()
			texture_rect.texture = NOTHING
		1:
			AudioManager.playError()
			texture_rect.texture = WARNINGICON
		2:
			#change this sound
			AudioManager.playError()
			texture_rect.texture = SMILE

	await get_tree().create_timer(3).timeout
	CloseError()

func CloseError():
	visible = false

func _on_button_button_down() -> void:
	AudioManager.playButtonClick()
	CloseError()
