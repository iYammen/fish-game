extends Node

@onready var button_enter: AudioStreamPlayer = $buttonEnter
@onready var button_click: AudioStreamPlayer = $buttonClick
@onready var collect: AudioStreamPlayer = $Collect
@onready var error: AudioStreamPlayer = $error
@onready var game_over: AudioStreamPlayer = $gameOver
@onready var enemy_spawn: AudioStreamPlayer = $enemySpawn
@onready var attack: AudioStreamPlayer = $attack
@onready var fish_eaten: AudioStreamPlayer = $fishEaten
@onready var gulp: AudioStreamPlayer = $gulp
@onready var pop: AudioStreamPlayer = $pop
@onready var splash: AudioStreamPlayer = $splash
@onready var blood: AudioStreamPlayer = $blood
@onready var next_stage: AudioStreamPlayer = $nextStage
@onready var music: AudioStreamPlayer = $Music
@onready var whale: AudioStreamPlayer = $whale


var scaleTween: Tween
const MUSIC_GLITCH = preload("res://Audio/Music/music glitch.mp3")
const YOUTUBE_JAZZ_SEABREEZE_HARMONY_375543 = preload("res://Audio/Music/youtube-jazz-seabreeze-harmony-375543.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func muteSoundEffects():
	AudioServer.set_bus_mute(1, !AudioServer.is_bus_mute(1))
	
func muteMusic():
	AudioServer.set_bus_mute(2, !AudioServer.is_bus_mute(2))

func OceanMusicToDarkMusic():
	if music.stream == YOUTUBE_JAZZ_SEABREEZE_HARMONY_375543:
		scaleTween = create_tween()
		# Scale up (quick ease out)
		scaleTween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
		scaleTween.tween_property(music, "volume_db", -80, 0.5)
		
		scaleTween.tween_callback(Callable(self, "darkMusic"))
		
		# Then scale down (with bounce)
		scaleTween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
		scaleTween.tween_property(music, "volume_db", -30, 1)

func DarkMusicToOceanMusic():
	if music.stream == MUSIC_GLITCH:
		scaleTween = create_tween()
		# Scale up (quick ease out)
		scaleTween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
		scaleTween.tween_property(music, "volume_db", -80, 0.5)

		scaleTween.tween_callback(Callable(self, "oceanMusic"))

		# Then scale down (with bounce)
		scaleTween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
		scaleTween.tween_property(music, "volume_db", -30, 1)

func darkMusic():
	music.stream = MUSIC_GLITCH
	music.play()

func oceanMusic():
	music.stream = YOUTUBE_JAZZ_SEABREEZE_HARMONY_375543
	music.play()

func playButtonClick():
	button_click.pitch_scale = randf_range(0.6,1)
	button_click.play()

func playCollect():
	collect.pitch_scale = randf_range(0.8,1.2)
	collect.play()

func playError():
	error.pitch_scale = randf_range(0.8,1.2)
	error.play()

func playGameOver():
	game_over.pitch_scale = randf_range(0.8,1.2)
	game_over.play()
	
func playEnemySpawn():
	enemy_spawn.pitch_scale = randf_range(0.8,1.2)
	enemy_spawn.play()

func playAttack():
	attack.pitch_scale = randf_range(0.8,1.2)
	attack.play()

func playFishEaten():
	fish_eaten.pitch_scale = randf_range(0.8,1.2)
	fish_eaten.play()

func playGulp():
	gulp.pitch_scale = randf_range(0.8,1.2)
	gulp.play()

func playPop():
	pop.pitch_scale = randf_range(0.8,1.2)
	pop.play()

func playSplash():
	splash.pitch_scale = randf_range(0.8,1.2)
	splash.play()

func playBlood():
	blood.pitch_scale = randf_range(0.8,1.2)
	blood.play()

func playNextStage():
	next_stage.pitch_scale = randf_range(0.8,1.2)
	next_stage.play()

func playWhaleSound():
	whale.pitch_scale = randf_range(0.8,1.2)
	whale.play()
