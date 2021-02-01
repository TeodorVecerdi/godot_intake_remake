extends Control

export (float) var TimePerTutorial: float = 5.0
export (float) var FadeTime: float = 0.5

onready var Tutorials = [
	$"VBoxContainer/MarginContainer/Background/CenterContainer/Movement",
	$"VBoxContainer/MarginContainer/Background/CenterContainer/Zoom",
	$"VBoxContainer/MarginContainer/Background/CenterContainer/Win"
]
onready var Buttons = [
	$"VBoxContainer/MarginContainer2/HBox/TutorialTab1",
	$"VBoxContainer/MarginContainer2/HBox/TutorialTab2",
	$"VBoxContainer/MarginContainer2/HBox/TutorialTab3"
]

onready var Progress = $"VBoxContainer/MarginContainer/Background/ProgressBar"

signal loadComplete()

var tween: Tween
var currentTutorial: int = 0
var currentTime: float = 0.0

var lock: bool = false

func _ready():
	tween = Tween.new()
	add_child(tween)

	currentTime = 0.0
	currentTutorial = 0

	tween.interpolate_property($Fade, "modulate", Color(0,0,0,1), Color(0,0,0,0), 1.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, 0.3)
	tween.start()
	yield(tween, "tween_completed")


func _process(delta):
	if lock:
		return

	currentTime += delta
	if currentTime >= TimePerTutorial:
		currentTime = 0
		var nextIndex = (currentTutorial + 1) % len(Tutorials)
		loadTutorial(nextIndex)
		yield(self, "loadComplete")

	var fill = currentTime / TimePerTutorial
	Progress.value = fill


func loadTutorial(index: int):
	fadeOut(currentTutorial)
	currentTutorial = index
	fadeIn(currentTutorial)
	tween.start()
	yield(tween, "tween_all_completed")
	emit_signal("loadComplete")


func fadeOut(index: int):
	tween.interpolate_property(Tutorials[index], "modulate", Color(1,1,1,1), Color(1,1,1,0), FadeTime, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(Buttons[index], "self_modulate", Color(1,1,1,1), Color(1,1,1,0.35), FadeTime, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)


func fadeIn(index: int):
	tween.interpolate_property(Tutorials[index], "modulate", Color(1,1,1,0), Color(1,1,1,1), FadeTime, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(Buttons[index], "self_modulate", Color(1,1,1,0.35), Color(1,1,1,1), FadeTime, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)


func loadTutorialButton(index: int):
	lock = true
	currentTime = 0
	Progress.value = 0
	loadTutorial(index)
	yield(self, "loadComplete")
	lock = false


func tutorialComplete() -> void:
	tween.interpolate_property($Fade, "modulate", Color(0,0,0,0), Color(0,0,0,1), 1.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, 0.2)
	tween.start()
	yield(tween, "tween_completed")
	SceneManager.LoadScene(SceneManager.MAIN_MENU)
