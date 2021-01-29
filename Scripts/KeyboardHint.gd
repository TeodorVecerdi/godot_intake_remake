extends Control

export (Texture) var KeyTexture: Texture
export (String) var Action: String
export (bool) var IsRight: bool = false

onready var Texture = $MarginContainer/Key
onready var ActionText = $Action

const textPadding: float = 85.0
const sizePerChar: float = 16.0

var tween: Tween
var tweenDuration: float = 1
var tweenRange: float = 1

func _ready():
	tween = Tween.new()
	add_child(tween)
	var texSize = KeyTexture.get_size()
	var longTexture = texSize.x > texSize.y
	Texture.texture = KeyTexture
	if longTexture:
		Texture.rect_min_size = Vector2(96, 48)
	else:
		Texture.rect_min_size = Vector2(48,48)

	ActionText.text = "to %s" % Action
	
	animate()
	

func _process(delta):
	var center = (textPadding + (3 + len(Action)) * sizePerChar) / 2.0
	rect_pivot_offset.x = center if not IsRight else rect_size.x - center

func animate():
	tween.interpolate_property(self, "rect_rotation", -tweenRange, tweenRange, tweenDuration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	tween.interpolate_property(self, "rect_rotation", tweenRange, -tweenRange, tweenDuration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	animate()
