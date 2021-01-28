extends Camera2D
class_name CameraFollow

export (float) var followSpeed: float = 0.1
export (Vector2) var limitPadding: Vector2 = Vector2(350, 200)

signal zoomChanged(state)

onready var target = $"../Player"
onready var grid: HexGrid = $".".get_parent() as HexGrid

var currentZoomState = false

func _ready():
	var maxWidth = 2.0 * grid.CellsX * HexConstants.RADIUS * HexConstants.INNER_CONSTANT * grid.Scale
	var maxHeight = 2.0 * grid.CellsY * HexConstants.RADIUS * grid.Scale

	limit_bottom = maxHeight + limitPadding.y
	limit_top = int(-limitPadding.y)
	limit_left = int(-limitPadding.x)
	limit_right = maxWidth + limitPadding.x


func _process(_delta) -> void:
	position = target.position


func _input(event):
    var justPressed = event.is_pressed() and not event.is_echo() 
    if not justPressed:
        return
    
    if Input.is_key_pressed(KEY_SPACE):
        currentZoomState = !currentZoomState
        emit_signal("zoomChanged", currentZoomState)