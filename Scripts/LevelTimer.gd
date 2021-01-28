extends Control
class_name LevelTimer

export (Color) var GoodColor: Color
export (Color) var WarningColor: Color
export (Color) var BadColor: Color
export var WarningBracket: float = 0.5
export var BadBracket: float = 0.2

onready var TimerProgress = $Timer/TimerProgress
onready var TimerText = $Timer/TimerText

signal completed
signal stopped

var timeLeft: float
var totalTime: float

var enabled = false


func _process(delta) -> void:
	if not enabled:
		return
	
	
	timeLeft -= delta
	if timeLeft <= 0:
		timeLeft = 0
		enabled = false
		emit_signal("completed")
	
	var fillAmount = timeLeft / totalTime
	var oldFillAmount = TimerProgress.ratio
	# change good -> warning
	if oldFillAmount > WarningBracket and fillAmount <= WarningBracket:
		TimerProgress.modulate = WarningColor
	elif oldFillAmount > BadBracket and fillAmount <= BadBracket:
		TimerProgress.modulate = BadColor

	TimerProgress.ratio = fillAmount
	TimerText.text = "%.1fs / %.1fs" % [timeLeft, totalTime]


func start(_totalTime: float, _timeLeft: float = -1.0):
	TimerProgress.modulate = GoodColor
	totalTime = _totalTime
	timeLeft = _timeLeft if _timeLeft != -1.0 else totalTime
	enabled = true


func stop():
	enabled = false
	emit_signal("stopped")
