extends Node2D
class_name HexGrid

const HexConstants = preload("res://Scripts/HexConstants.gd")
const HexCell = preload("res://Scenes/HexCell.tscn")

export (int) var CellsX: int = 4
export (int) var CellsY: int = 4
export var Scale: float = 1.0
export (Vector2) var Offset: Vector2 = Vector2(90, 101)

onready var normalCells: HexCellTexture = $Tiles/CellTiles
onready var hiddenCells: HexCellTexture = $Tiles/HiddenTiles
onready var finishCells: HexCellTexture = $Tiles/FinishTiles
onready var cellContainer = $Cells
onready var player = $Player

var cellGrid


func _ready() -> void:
	cellGrid = []
	for y in range(CellsY):
		cellGrid.append([])
		for x in range(CellsX):
			cellGrid[y].append(HexCell.instance())
			var texVariation = randi() % 3
			var texType = randi() % 2
			var shownTextures = normalCells if texType == 0 else finishCells

			cellGrid[y][x].loadTextures(hiddenCells, shownTextures)
			cellGrid[y][x].initialize(HexConstants.ArrayToWorld(x, y, Scale), texVariation)
			cellGrid[y][x].scale = Vector2(Scale, Scale)
			cellContainer.add_child(cellGrid[y][x])
			cellContainer.position = Offset * Scale

	for y in range(CellsY):
		for x in range(CellsX):
			for dir in range(6):
				var wall = randi() % 3 == 0
				setWall(dir, wall, x, y)
	player.load()


func _unhandled_input(event) -> void:
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()
	elif event is InputEventMouseButton and event.pressed:
		var coords = get_global_mouse_position()
		var offsetted = coords + Offset * Scale
		print(
			(
				"Mouse pressed world->array: %s"
				% [HexConstants.WorldToArray(offsetted.x, offsetted.y, Scale)]
			)
		)


func getPassableNeighbours(x: int, y: int) -> Array:
	var upper_right = (
		false
		if y == 0 or (x == CellsX - 1 and y % 2 == 1)
		else isPassable(x, y, 0)
	)
	var right = (
		false
		if x == CellsX - 1
		else isPassable(x, y, 1)
	)
	var lower_right = (
		false
		if y == CellsY - 1 or (x == CellsX - 1 and y % 2 == 1)
		else isPassable(x, y, 2)
	)
	var lower_left = (
		false
		if y == CellsX - 1 or (x == 0 and y % 2 == 0)
		else isPassable(x, y, 3)
	)
	var left = (
		false
		if x == 0
		else isPassable(x, y, 4)
	)
	var upper_left = (
		false
		if y == 0 or (x == 0 and y % 2 == 0)
		else isPassable(x, y, 5)
	)

	return [upper_right, right, lower_right, lower_left, left, upper_left]


func isPassable(x: int, y: int, direction: int) -> bool:
	return !cellGrid[y][x].walls[direction]


func showNeighbours(x: int, y: int) -> void:
	var neighbourDeltas = HexConstants.NeighbourDelta[y % 2]
	var passableNeighbours = getPassableNeighbours(x, y)
	for i in range(6):
		if passableNeighbours[i]:
			cellGrid[y + neighbourDeltas[i][1]][x + neighbourDeltas[i][0]].setHidden(false)


func setWall(index: int, state: bool, x: int, y: int):
	if index == 0 && y == 0 or (x == CellsX - 1 and y % 2 == 1):
		return
	if index == 1 && x == CellsX - 1:
		return
	if index == 2 && y == CellsY - 1 or (x == CellsX - 1 and y % 2 == 1):
		return
	if index == 3 && y == CellsX - 1 or (x == 0 and y % 2 == 0):
		return
	if index == 4 && x == 0:
		return
	if index == 5 && y == 0 or (x == 0 and y % 2 == 0):
		return
	if index > 5:
		return

	var neighbourDeltas = HexConstants.NeighbourDelta[y % 2]
	var otherX = x + neighbourDeltas[index][0]
	var otherY = y + neighbourDeltas[index][1]
	cellGrid[y][x].setWall(index, state)
	cellGrid[otherY][otherX].setWall((index+3)%6, state)
