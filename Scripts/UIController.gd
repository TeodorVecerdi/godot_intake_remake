extends Control

export (float) var AnimationDuration: float = 1.0

signal onFadeIn
signal onFadeOut

onready var Win = $Win
onready var Lose = $Lose

var tween: Tween
var isLoseActive: bool = false
var isWinActive: bool = false


func _ready():
	tween = Tween.new()
	add_child(tween)


func showWin() -> void:
	isWinActive = true
	tween.interpolate_property(Win, "modulate", Color(1,1,1,0), Color(1,1,1,1), AnimationDuration, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	emit_signal("onFadeIn")

func showLose() -> void:
	isLoseActive = true
	tween.interpolate_property(Lose, "modulate", Color(1,1,1,0), Color(1,1,1,1), AnimationDuration, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	emit_signal("onFadeIn")


func hideActive() -> void:
	if isWinActive:
		tween.interpolate_property(Win, "modulate", Color(1,1,1,1), Color(1,1,1,0), AnimationDuration, Tween.TRANS_QUAD, Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_completed")
		emit_signal("onFadeOut")
	else:
		tween.interpolate_property(Lose, "modulate", Color(1,1,1,1), Color(1,1,1,0), AnimationDuration, Tween.TRANS_QUAD, Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_completed")
		emit_signal("onFadeOut")

	isWinActive = false
	isLoseActive = false
