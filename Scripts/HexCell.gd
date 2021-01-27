extends Sprite
class_name HexCell

onready var Walls = [
	$Walls/wall_up_right,
	$Walls/wall_right,
	$Walls/wall_down_right,
	$Walls/wall_down_left,
	$Walls/wall_left,
	$Walls/wall_up_left
]

var textureVariation
var isHidden

var hiddenTextures: HexCellTexture
var shownTextures: HexCellTexture

var walls = [true, true, true, true, true, true]


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


func setWall(index: int, state: bool):
	walls[index] = state
	Walls[index].visible = state
