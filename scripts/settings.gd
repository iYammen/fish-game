extends Control

var showing: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


func showSettings():
	visible = true
	get_tree().paused = true
	showing = true

func hideSettings():
	visible = false
	get_tree().paused = false
	showing = false

func _on_music_mute_pressed() -> void:
	AudioManager.playButtonClick()
	AudioManager.muteMusic()


func _on_sound_mute_pressed() -> void:
	AudioManager.playButtonClick()
	AudioManager.muteSoundEffects()


func _on_full_screen_pressed() -> void:
	AudioManager.playButtonClick()
	var current_mode := DisplayServer.window_get_mode()
	if current_mode == DisplayServer.WINDOW_MODE_WINDOWED or current_mode == DisplayServer.WINDOW_MODE_MAXIMIZED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN, 0)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED, 0)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_close_button_pressed() -> void:
	AudioManager.playButtonClick()
	hideSettings()
