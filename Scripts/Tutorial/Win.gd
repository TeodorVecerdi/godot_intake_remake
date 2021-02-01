extends Control

onready var player = $"Control/Player"
onready var arrow = $"Control/Player/Arrows/arrow_down_right"
onready var ui = $"Control/UI"

export (float) var ArrowAnimTime: float = 0.25
export (float) var MoveAnimTime: float = 1.0
export (float) var FadeAnimTime: float = 1.0
export (float) var WaitTime1: float = 0.5
export (float) var WaitTime2: float = 0.25
export (float) var WaitTime3: float = 1.5
export (float) var WaitTime4: float = 0.8

export (float) var ScaleArrows: float = 1.5

var playerStart = Vector2(-4, -13)
var playerEnd = Vector2(57, 90)
var arrowScale = Vector2(0.06, 0.055)

var tween: Tween

func _ready():
	tween = Tween.new()
	add_child(tween)

	while true:
		animate()
		yield(tween, "tween_all_completed")


func animate():
	tween.interpolate_property(arrow, "scale", arrowScale, ScaleArrows * arrowScale, ArrowAnimTime / 2.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, WaitTime4)
	tween.interpolate_property(arrow, "scale", ScaleArrows * arrowScale, arrowScale, ArrowAnimTime / 2.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, WaitTime4 + ArrowAnimTime / 2.0)
	tween.interpolate_property(player, "rect_position", playerStart, playerEnd, MoveAnimTime, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, WaitTime4 + ArrowAnimTime + WaitTime1)
	tween.interpolate_property(ui, "modulate", Color(1,1,1,0), Color(1,1,1,1), FadeAnimTime, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, WaitTime4 + MoveAnimTime + ArrowAnimTime + WaitTime1 + WaitTime2)
	tween.interpolate_callback(self, MoveAnimTime + ArrowAnimTime + WaitTime1 + WaitTime2 + WaitTime3 + WaitTime4, "reset")
	tween.start()
	

func reset():
	player.rect_position = playerStart
	ui.modulate = Color(1,1,1,0)