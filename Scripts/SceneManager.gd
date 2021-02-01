extends Node

const MainMenu = preload("res://Scenes/Main Menu/Main Menu Root.tscn")
const Game = preload("res://Scenes/Game/Game.tscn")
const GameSettings = preload("res://Scenes/Main Menu/Game Settings.tscn")
const Tutorial = preload("res://Scenes/Main Menu/Tutorial.tscn")

const MAIN_MENU = 0
const GAME = 1
const TUTORIAL = 2
const GAME_SETTINGS = 3

const _validScenes = [MAIN_MENU, GAME, TUTORIAL,GAME_SETTINGS]
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
		_swapScene(MainMenu.instance())
	elif sceneIndex == GAME:
		print("Loading game scene")
		_swapScene(Game.instance())
	elif sceneIndex == TUTORIAL:
		print("Loading tutorial scene")
		_swapScene(Tutorial.instance())
	elif sceneIndex == GAME_SETTINGS:
		print("Loading game settings scene")
		_swapScene(GameSettings.instance())

func _swapScene(newScene: Node):
	var currentScene = root.get_child(root.get_child_count()-1)
	root.add_child(newScene)
	root.remove_child(currentScene)
	currentScene.queue_free()