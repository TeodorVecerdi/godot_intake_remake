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
var fillAmount: float


func _process(delta) -> void:
	if not enabled:
		return

	timeLeft -= delta
	if timeLeft <= 0:
		timeLeft = 0
		enabled = false
		emit_signal("completed")

	var newFillAmount = timeLeft / totalTime

	# change good -> warning
	if fillAmount > WarningBracket and newFillAmount <= WarningBracket:
		TimerProgress.tint_progress = WarningColor

	# change warning -> bad
	if fillAmount > BadBracket and newFillAmount <= BadBracket:
		TimerProgress.tint_progress = BadColor

	fillAmount = newFillAmount
	TimerProgress.ratio = fillAmount
	TimerText.text = "%.1fs / %.1fs" % [timeLeft, totalTime]


func start(_totalTime: float, _timeLeft: float = -1.0):
	TimerProgress.tint_progress = GoodColor
	totalTime = _totalTime
	timeLeft = _timeLeft if _timeLeft != -1.0 else totalTime
	enabled = true
	fillAmount = 1.0


func stop():
	enabled = false
	emit_signal("stopped")
