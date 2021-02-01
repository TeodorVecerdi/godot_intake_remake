extends Control

onready var Keys = [
	$"Control/Controls/E",
	$"Control/Controls/E2",
	$"Control/Controls/E3",
	$"Control/Controls/E4",
	$"Control/Controls/E5",
	$"Control/Controls/E6"
]

onready var Arrows = [
	$"Control/Player/Arrows/arrow_up_right",
	$"Control/Player/Arrows/arrow_right",
	$"Control/Player/Arrows/arrow_down_right",
	$"Control/Player/Arrows/arrow_down_left",
	$"Control/Player/Arrows/arrow_left",
	$"Control/Player/Arrows/arrow_up_left"
]

export (float) var AnimationSpeed: float = 0.25
export (float) var ScaleArrows: float = 1.5
export (float) var ScaleKeys: float = 1.5

var tween: Tween

var keyScale = Vector2(1, 1)
var arrowScale = Vector2(0.06, 0.055)

func _ready():
	tween = Tween.new()
	add_child(tween)

	while true:
		for i in range(6):
			animate(i)
			yield(tween, "tween_all_completed")



func animate(idx: int) -> void:
	tween.interpolate_property(Arrows[idx], "scale", arrowScale, ScaleArrows*arrowScale, AnimationSpeed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(Arrows[idx], "scale", ScaleArrows*arrowScale, arrowScale, AnimationSpeed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, AnimationSpeed)
	tween.interpolate_property(Keys[idx], "rect_scale", keyScale, ScaleKeys*keyScale, AnimationSpeed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(Keys[idx], "rect_scale", ScaleKeys*keyScale, keyScale, AnimationSpeed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, AnimationSpeed)
	tween.start()