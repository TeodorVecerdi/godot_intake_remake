extends Control
class_name LevelTimer

onready var TimerProgress = $TimerProgress
onready var TimerText = $TimerText

var timeLeft: float
var totalTime: float


func _ready() -> void:
	totalTime = 60.0
	timeLeft = totalTime


func _process(delta) -> void:
	timeLeft -= delta

	var fillAmount = timeLeft / totalTime
	TimerProgress.ratio = fillAmount
	TimerText.text = "%.1fs / %.1fs" % [timeLeft, totalTime]
