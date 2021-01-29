extends Sprite
class_name HexCell

var Walls = []

var textureVariation
var isHidden

var hiddenTextures: HexCellTexture
var shownTextures: HexCellTexture

var walls = [true, true, true, true, true, true]
var hiddenWalls = [false, false, false, false, false, false]
var showWallOverride = [false, false, false, false, false, false]
var cellIndex: CellIndex

func initialize(position: Vector2, variation: int, _cellIndex: CellIndex, hidden: bool = true) -> void:
	Walls.append($Walls/wall_up_right)
	Walls.append($Walls/wall_right)
	Walls.append($Walls/wall_down_right)
	Walls.append($Walls/wall_down_left)
	Walls.append($Walls/wall_left)
	Walls.append($Walls/wall_up_left)

	textureVariation = variation
	isHidden = hidden
	self.position = position
	cellIndex = _cellIndex


func setTexture() -> void:
	if isHidden:
		texture = hiddenTextures.getTexture(textureVariation)
	else:
		texture = shownTextures.getTexture(textureVariation)
	
	showWalls()


func showWalls() -> void:
	for i in range(6):
		if isHidden:
			Walls[i].visible = true if showWallOverride[i] and walls[i] and not hiddenWalls[i] else false
		else:
			Walls[i].visible = walls[i] if not hiddenWalls[i] else false


func showWall(index: int) -> void:
	if not walls[index] or hiddenWalls[index]:
		return
	showWallOverride[index] = true
	Walls[index].visible = true

func loadTextures(_hiddenTextures: HexCellTexture, _shownTextures: HexCellTexture) -> void:
	hiddenTextures = _hiddenTextures
	shownTextures = _shownTextures


func setHidden(hidden: bool) -> void:
	isHidden = hidden
	setTexture()


func setWall(index: int, state: bool) -> void:
	walls[index] = state
	if isHidden:
		Walls[index].visible = false
	else:
		Walls[index].visible = walls[index]
