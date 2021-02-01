extends Control

onready var extraCells = $"Control/Extra"
onready var arrows = $"Control/Player/Arrows"
onready var root = $"Control"
onready var key = $"Space"

export (float) var KeyAnimSpeed: float = 0.5
export (float) var ZoomAnimTime: float = 1.5
export (float) var WaitAnimTime: float = 2.0

var tween: Tween

func _ready():
	tween = Tween.new()
	add_child(tween)

	while true:
		animate()
		yield(tween, "tween_all_completed")


func animate():
	tween.interpolate_property(key, "rect_scale", Vector2.ONE, 0.8 * Vector2.ONE, KeyAnimSpeed/2.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, WaitAnimTime)
	tween.interpolate_property(key, "rect_scale", 0.8 * Vector2.ONE, Vector2.ONE, KeyAnimSpeed/2.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, WaitAnimTime + KeyAnimSpeed/2.0)
	tween.interpolate_property(root, "rect_scale", Vector2(1.2, 1.2), Vector2(0.65, 0.65), ZoomAnimTime, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, WaitAnimTime + KeyAnimSpeed)
	tween.interpolate_property(extraCells, "modulate", Color(1,1,1,0), Color(1,1,1,1), ZoomAnimTime, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, WaitAnimTime + KeyAnimSpeed)
	tween.interpolate_property(arrows, "modulate", Color(1,1,1,1), Color(1,1,1,0), KeyAnimSpeed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, WaitAnimTime + KeyAnimSpeed)
	
	tween.interpolate_property(key, "rect_scale", Vector2.ONE, 0.8 * Vector2.ONE, KeyAnimSpeed/2.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, 2.0 * WaitAnimTime + KeyAnimSpeed + ZoomAnimTime)
	tween.interpolate_property(key, "rect_scale", 0.8 * Vector2.ONE, Vector2.ONE, KeyAnimSpeed/2.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, 2.0 * WaitAnimTime + KeyAnimSpeed + ZoomAnimTime + KeyAnimSpeed/2.0)
	tween.interpolate_property(root, "rect_scale", Vector2(0.65, 0.65), Vector2(1.2, 1.2), ZoomAnimTime, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, 2.0 * WaitAnimTime + ZoomAnimTime + 2.0 * KeyAnimSpeed)
	tween.interpolate_property(extraCells, "modulate", Color(1,1,1,1), Color(1,1,1,0), ZoomAnimTime, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, 2.0 * WaitAnimTime + ZoomAnimTime + 2.0 * KeyAnimSpeed)
	tween.interpolate_property(arrows, "modulate", Color(1,1,1,0), Color(1,1,1,1), KeyAnimSpeed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, 2.0 * WaitAnimTime + ZoomAnimTime + 2.0 * KeyAnimSpeed + ZoomAnimTime - KeyAnimSpeed)
	tween.start()