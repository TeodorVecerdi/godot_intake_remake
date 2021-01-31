extends Control

onready var playButton = $"CenterContainer/Menu Buttons/Play"
onready var fade = $"Background Fade"

var tween: Tween

func _ready():
	tween = Tween.new()
	add_child(tween)
	
	playButton.grab_focus()

	tween.interpolate_property(fade, "modulate", Color(0,0,0,1), Color(0,0,0,0), 1.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, 0.3)
	tween.start()
	yield(tween, "tween_completed")



func _onPlayPressed() -> void:
	tween.interpolate_property(fade, "modulate", Color(0,0,0,0), Color(0,0,0,1), 1.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, 0.3)
	tween.start()
	yield(tween, "tween_completed")
	SceneManager.LoadScene(SceneManager.GAME_SETTINGS)

func _onTutorialPressed() -> void:
	SceneManager.LoadScene(SceneManager.TUTORIAL)

func _onExitPressed() -> void:
	get_tree().quit()