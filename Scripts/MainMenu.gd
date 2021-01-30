extends Control

onready var playButton = $"CenterContainer/Menu Buttons/Play"

func _ready():
	playButton.grab_focus()


func _onPlayPressed() -> void:
	SceneManager.LoadScene(SceneManager.GAME)

func _onTutorialPressed() -> void:
	SceneManager.LoadScene(SceneManager.TUTORIAL)

func _onExitPressed() -> void:
	get_tree().quit()