extends Sprite
class_name HexCell

var Walls = []

var textureVariation
var isHidden

var hiddenTextures: HexCellTexture
var shownTextures: HexCellTexture

var walls = [true, true, true, true, true, true]


func initialize(position: Vector2, variation: int, hidden: bool = true) -> void:
	Walls.append($Walls/wall_up_right)
	Walls.append($Walls/wall_right)
	Walls.append($Walls/wall_down_right)
	Walls.append($Walls/wall_down_left)
	Walls.append($Walls/wall_left)
	Walls.append($Walls/wall_up_left)

	textureVariation = variation
	isHidden = hidden
	self.position = position

	setTexture()


func setTexture() -> void:
	if isHidden:
		texture = hiddenTextures.getTexture(textureVariation)
		for i in range(6):
			Walls[i].visible = false
	else:
		texture = shownTextures.getTexture(textureVariation)
		for i in range(6):
			Walls[i].visible = walls[i]


func loadTextures(_hiddenTextures: HexCellTexture, _shownTextures: HexCellTexture) -> void:
	hiddenTextures = _hiddenTextures
	shownTextures = _shownTextures


func setHidden(hidden: bool):
	isHidden = hidden
	setTexture()


func setWall(index: int, state: bool):
	walls[index] = state
	if isHidden:
		Walls[index].visible = false
	else:
		Walls[index].visible = walls[index]
