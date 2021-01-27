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

var cellArray


func _ready():
	cellArray = []
	for y in range(CellsY):
		cellArray.append([])
		for x in range(CellsX):
			cellArray[y].append(HexCell.instance())
			var texType = randi() % 2
			if texType == 0:
				cellArray[y][x].initialize(
					HexConstants.ArrayToWorld(x, y, Scale), normalCells.getTextureRandom()
				)
			else:
				cellArray[y][x].initialize(
					HexConstants.ArrayToWorld(x, y, Scale), hiddenCells.getTextureRandom()
				)
			cellArray[y][x].scale = Vector2(Scale, Scale)
			cellContainer.add_child(cellArray[y][x])
			cellContainer.position = Offset * Scale


func _unhandled_input(event):
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


func getPassableNeighbours(x: int, y: int):
	var upper_right = false if y == 0 or (x == CellsX-1 and y%2==1) else isPassable(x, y, x + y % 2, y-1)
	var right = false if x == CellsX - 1 else isPassable(x, y, x+1, y)
	var lower_right = false if y == CellsY - 1 or (x == CellsX-1 and y%2==1) else isPassable(x, y, x + y % 2, y+1)
	var lower_left = false if y == CellsX - 1 or (x == 0 and y%2==0) else isPassable(x, y, x + (y+1) % 2, y+1)
	var left = false if x == 0 else isPassable(x, y, x-1, y)
	var upper_left = false if y == 0 or (x == 0 and y%2 == 0) else isPassable(x, y, x + (y+1) % 2, y-1)

	return [upper_right, right, lower_right, lower_left, left, upper_left]
	
func isPassable(fromX: int, fromY: int, toX: int, toY: int)->bool:
	return true
