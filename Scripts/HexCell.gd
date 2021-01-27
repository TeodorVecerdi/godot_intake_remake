extends Sprite
class_name HexCell

var textureVariation
var isHidden

var hiddenTextures: HexCellTexture
var shownTextures: HexCellTexture


func initialize(position: Vector2, variation: int, hidden: bool = true) -> void:
	textureVariation = variation
	isHidden = hidden
	self.position = position

	setTexture()


func setTexture() -> void:
	texture = (
		hiddenTextures.getTexture(textureVariation)
		if isHidden
		else shownTextures.getTexture(textureVariation)
	)


func loadTextures(_hiddenTextures: HexCellTexture, _shownTextures: HexCellTexture) -> void:
	hiddenTextures = _hiddenTextures
	shownTextures = _shownTextures


func setHidden(hidden: bool):
	isHidden = hidden
	setTexture()
