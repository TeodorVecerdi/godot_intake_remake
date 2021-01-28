extends Node2D
class_name CellNeighbour

var x: int
var y: int
var direction: int


func initCIdx(_cellIndex: CellIndex, _direction: int) -> void:
	x = _cellIndex.x
	y = _cellIndex.y
	direction = _direction


func initXY(_x: int, _y: int, _direction: int) -> void:
	x = _x
	y = _y
	direction = _direction