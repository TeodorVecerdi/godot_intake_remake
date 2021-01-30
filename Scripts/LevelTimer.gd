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

var tween: Tween

func _ready():
	tween = Tween.new()
	add_child(tween)


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
		tween.interpolate_property(TimerProgress, "tint_progress", GoodColor, WarningColor, 1.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()

	# change warning -> bad
	if fillAmount > BadBracket and newFillAmount <= BadBracket:
		tween.interpolate_property(TimerProgress, "tint_progress", WarningColor, BadColor, 1.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()

	fillAmount = newFillAmount
	TimerProgress.ratio = fillAmount
	TimerText.text = "%.1fs / %.1fs" % [timeLeft, totalTime]


func _onHexGridNewLevel() -> void:
	pass
	# modulate = Color(.5, .5, .5, 1)


func _onHexGridLevelStarted() -> void:
	pass
	# modulate = Color(1, 1, 1, 1)


func start() -> void:
	fillAmount = 1.0
	tween.interpolate_property(TimerProgress, "tint_progress", null, GoodColor, 1.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(TimerProgress, "ratio", null, 1.0, 1.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	TimerText.text = "%.1fs / %.1fs" % [timeLeft, totalTime]
	enabled = true


func restart(_timeLeft: float = -1.0) -> void:
	timeLeft = _timeLeft if _timeLeft != -1.0 else totalTime
	fillAmount = timeLeft / totalTime
	tween.interpolate_property(TimerProgress, "tint_progress", null, GoodColor, 1.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(TimerProgress, "ratio", null, fillAmount, 1.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	TimerText.text = "%.1fs / %.1fs" % [timeLeft, totalTime]
	enabled = true


func stop() -> void:
	enabled = false
	emit_signal("stopped")


func reset(_totalTime: float, _timeLeft: float = -1.0) -> void:
	totalTime = _totalTime
	timeLeft = _timeLeft if _timeLeft != -1.0 else totalTime
	fillAmount = timeLeft / totalTime
	tween.interpolate_property(TimerProgress, "tint_progress", null, GoodColor, 1.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(TimerProgress, "ratio", null, fillAmount, 1.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	TimerText.text = "%.1fs / %.1fs" % [timeLeft, totalTime]
