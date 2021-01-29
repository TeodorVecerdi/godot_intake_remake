extends Control

export (float) var AnimationDuration: float = 1.0
export (float) var ScoreAnimationDuration: float = 0.2 

signal onFadeIn
signal onFadeOut
signal onScoreRestartComplete

onready var Win = $Win
onready var WinScoreLabel = $Win/MarginContainer/TextContainer/Score
onready var Lose = $Lose
onready var LoseScoreLabel = $Lose/MarginContainer/TextContainer/Score

var tween: Tween
var isLoseActive: bool = false
var isWinActive: bool = false


func _ready():
	tween = Tween.new()
	add_child(tween)


func showWin(oldScore: int, newScore: int) -> void:
	isWinActive = true
	WinScoreLabel.text = "Score: %d" % oldScore
	var oldScoreStr: String = str(oldScore)
	var newScoreStr: String = str(newScore)
	var digitsChanged: int = _digitsChanged(oldScoreStr, newScoreStr)
	var currentDigits: int = 6 + len(oldScoreStr)
	WinScoreLabel.visible_characters = currentDigits
	tween.interpolate_property(Win, "modulate", Color(1,1,1,0), Color(1,1,1,1), AnimationDuration, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	tween.interpolate_property(WinScoreLabel, "modulate", Color(1,1,1,1), Color(0.04, 0.88, 0.22, 1), 0.1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, AnimationDuration * 0.5)
	tween.interpolate_property(WinScoreLabel, "visible_characters", currentDigits, currentDigits-digitsChanged, ScoreAnimationDuration * digitsChanged, Tween.TRANS_LINEAR, Tween.EASE_IN, AnimationDuration)
	tween.start()
	yield(tween, "tween_all_completed")
	WinScoreLabel.text = "Score: %d" % newScore
	tween.interpolate_property(WinScoreLabel, "visible_characters", currentDigits-digitsChanged, currentDigits-digitsChanged+len(newScoreStr), ScoreAnimationDuration * len(newScoreStr), Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.interpolate_property(WinScoreLabel, "modulate", Color(0.04, 0.88, 0.22, 1), Color(1,1,1,1),  0.1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, AnimationDuration * 0.5)
	tween.start()
	yield(tween, "tween_all_completed")
	emit_signal("onFadeIn")


func showLose(score: int) -> void:
	isLoseActive = true
	LoseScoreLabel.text = "Score: %d" % score
	tween.interpolate_property(Lose, "modulate", Color(1,1,1,0), Color(1,1,1,1), AnimationDuration, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	emit_signal("onFadeIn")


func animateScoreRestart(score: int) -> void:
	var currentLength = len(LoseScoreLabel.text)
	tween.interpolate_property(LoseScoreLabel, "modulate", Color(1,1,1,1), Color(0.88, 0.22, 0.04, 1), 0.1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, AnimationDuration * 0.5)
	tween.interpolate_property(LoseScoreLabel, "visible_characters", currentLength, 6, ScoreAnimationDuration * (currentLength - 6), Tween.TRANS_LINEAR, Tween.EASE_IN, AnimationDuration)
	tween.start()
	yield(tween, "tween_all_completed")
	LoseScoreLabel.text = "Score: 0"
	tween.interpolate_property(LoseScoreLabel, "visible_characters", 6, 7, ScoreAnimationDuration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.interpolate_property(LoseScoreLabel, "modulate", Color(0.88, 0.22, 0.04, 1), Color(1,1,1,1),  0.1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, AnimationDuration * 0.5)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.interpolate_callback(self, AnimationDuration, "emit_signal", "onScoreRestartComplete")
	tween.start()
	yield(tween, "tween_all_completed")


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


func _digitsChanged(old:String, new:String) -> int:
	if len(old) != len(new):
		return len(old)
	
	var changed: int = 0
	for i in range(len(old)):
		if old[i] != new[i]:
			changed+=1
	return changed
