extends Control

export (Texture) var KeyTexture: Texture
export (String) var Action: String

onready var Texture = $MarginContainer/Key
onready var ActionText = $Action

func _ready():
	var texSize = KeyTexture.get_size()
	var longTexture = texSize.x > texSize.y
	Texture.texture = KeyTexture
	if longTexture:
		Texture.rect_min_size = Vector2(96, 48)
	else:
		Texture.rect_min_size = Vector2(48,48)

	ActionText.text = "to %s" % Action
