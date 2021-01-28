extends Node2D
class_name CellNeighbour

var cellIndex: CellIndex
var direction: int

func init(_cellIndex: CellIndex, _direction: int) -> void:
    cellIndex = _cellIndex
    direction = _direction