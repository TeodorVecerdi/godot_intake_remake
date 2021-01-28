extends Camera2D
class_name CameraFollow

export (float) var followSpeed: float = 0.1
export (Vector2) var limitPadding: Vector2 = Vector2(350, 200)

onready var target = $"../Player"
onready var grid: HexGrid = $".".get_parent() as HexGrid


func _ready():
	var maxWidth = 2.0 * grid.CellsX * HexConstants.RADIUS * HexConstants.INNER_CONSTANT * grid.Scale
	var maxHeight = 2.0 * grid.CellsY * HexConstants.RADIUS * grid.Scale

	limit_bottom = maxHeight + limitPadding.y
	limit_top = int(-limitPadding.y)
	limit_left = int(-limitPadding.x)
	limit_right = maxWidth + limitPadding.x


func _process(delta) -> void:
	position = target.position
