extends Node2D
class_name HexGrid

const HexConstants = preload("res://Scripts/HexConstants.gd")
const HexCell = preload("res://Scenes/HexCell.tscn")

export (int) var CellsX: int = 4
export (int) var CellsY: int = 4

onready var normalCells: HexCellTexture = $CellTiles
onready var hiddenCells: HexCellTexture = $HiddenTiles
onready var finishCells: HexCellTexture = $FinishTiles


func _ready():
	var hexCell = HexCell.instance()
	hexCell.initialize(Vector2(100, 100), normalCells.getTextureRandom())
	add_child(hexCell)

