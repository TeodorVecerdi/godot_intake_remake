extends Control

func _onPlayPressed() -> void:
	print("PLAY")

func _onTutorialPressed() -> void:
	print("TUTORIAL")

func _onExitPressed() -> void:
	get_tree().quit()