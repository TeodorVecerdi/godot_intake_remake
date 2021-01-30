extends Node

const MainMenu = preload("res://Scenes/Main Menu/Main Menu Root.tscn")
const Game = preload("res://Scenes/Game/Game.tscn")

const MAIN_MENU = 0
const GAME = 1
const TUTORIAL = 2

const _validScenes = [MAIN_MENU, GAME, TUTORIAL]
var root: Viewport

func _enter_tree() -> void:
	root = get_tree().root

func LoadScene(sceneIndex: int) -> void:
	if not sceneIndex in _validScenes:
		printerr("Invalid scene index [%d]!" % sceneIndex)
		return
	_loadSceneImpl(sceneIndex)

func _loadSceneImpl(sceneIndex: int) -> void:
	if sceneIndex == MAIN_MENU:
		print("Loading main menu scene")
		var currentScene = root.get_child(1)
		var newScene = MainMenu.instance()
		root.add_child(newScene)
		root.remove_child(currentScene)
		currentScene.queue_free()
	elif sceneIndex == GAME:
		print("Loading game scene")
		var currentScene = root.get_child(1)
		var newScene = Game.instance()
		root.add_child(newScene)
		root.remove_child(currentScene)
		currentScene.queue_free()
	elif sceneIndex == TUTORIAL:
		print("Loading tutorial scene [fail]")
		# print(get_tree().root.get_child(1).name)