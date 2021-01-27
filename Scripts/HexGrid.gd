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
	var neighbourDeltas = HexConstants.NeighbourDelta[y % 2]
	var upper_right = (
		false
		if y == 0 or (x == CellsX - 1 and y % 2 == 1)
		else isPassable(x, y, x + neighbourDeltas[0][0], y + neighbourDeltas[0][1])
	)
	var right = (
		false
		if x == CellsX - 1
		else isPassable(x, y, x + neighbourDeltas[1][0], y + neighbourDeltas[1][1])
	)
	var lower_right = (
		false
		if y == CellsY - 1 or (x == CellsX - 1 and y % 2 == 1)
		else isPassable(x, y, x + neighbourDeltas[2][0], y + neighbourDeltas[2][1])
	)
	var lower_left = (
		false
		if y == CellsX - 1 or (x == 0 and y % 2 == 0)
		else isPassable(x, y, x + neighbourDeltas[3][0], y + neighbourDeltas[3][1])
	)
	var left = (
		false
		if x == 0
		else isPassable(x, y, x + neighbourDeltas[4][0], y + neighbourDeltas[4][1])
	)
	var upper_left = (
		false
		if y == 0 or (x == 0 and y % 2 == 0)
		else isPassable(x, y, x + neighbourDeltas[5][0], y + neighbourDeltas[5][1])
	)

	return [upper_right, right, lower_right, lower_left, left, upper_left]


func isPassable(fromX: int, fromY: int, toX: int, toY: int) -> bool:
	return true


func showNeighbours(x: int, y: int) -> void:
	var neighbourDeltas = HexConstants.NeighbourDelta[y % 2]
	var passableNeighbours = getPassableNeighbours(x, y)
	for i in range(6):
		if passableNeighbours[i]:
			cellGrid[y + neighbourDeltas[i][1]][x + neighbourDeltas[i][0]].setHidden(false)


func setWall(index: int, state: bool, x: int, y: int):
	var neighbourDeltas = HexConstants.NeighbourDelta[y % 2]
	var otherX = x + neighbourDeltas[index][0]
	var otherY = y + neighbourDeltas[index][1]
	cellGrid[y][x].setWall(index, state)
	cellGrid[otherY][otherX].setWall((index+3)%6, state)
