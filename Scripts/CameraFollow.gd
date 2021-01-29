extends Camera2D
class_name CameraFollow

export (float) var followSpeed: float = 0.1
export (Vector2) var normalZoom: Vector2 = Vector2(1, 1)
export (Vector2) var limitPadding: Vector2 = Vector2(350, 200)

signal zoomChanged(state)

onready var target = $"../Player"
onready var grid: HexGrid = $".".get_parent() as HexGrid

var currentZoomState = false
var shouldFollowPlayer = true
var locked = false

var gridWidth: float
var gridHeight: float


func _ready():
	gridWidth = 2.0 * grid.CellsX * HexConstants.RADIUS * HexConstants.INNER_CONSTANT * grid.Scale
	gridHeight = 1.5 * grid.CellsY * HexConstants.RADIUS * grid.Scale

	setZoom(false)


func _process(_delta) -> void:
	if shouldFollowPlayer:
		position = target.position


func _input(event):
	if locked:
		return

	var justPressed = event.is_pressed() and not event.is_echo()
	if not justPressed:
		return

	if Input.is_key_pressed(KEY_SPACE):
		currentZoomState = ! currentZoomState
		emit_signal("zoomChanged", currentZoomState)
		setZoom(currentZoomState)
		


func setZoom(zoomState):
	if zoomState:
		shouldFollowPlayer = false

		limit_bottom = 1000000000
		limit_top = -1000000000
		limit_left = -1000000000
		limit_right = 1000000000

		var center = Vector2(gridWidth / 2.0, gridHeight / 2.0 - HexConstants.RADIUS * 0.25)
		position = center

		var viewportSize = get_viewport().size
		var zoomLevel: float = gridHeight / viewportSize.y + 0.2
		zoom = Vector2(zoomLevel, zoomLevel)
	else:
		limit_bottom = int(gridHeight + limitPadding.y)
		limit_top = int(-limitPadding.y)
		limit_left = int(-limitPadding.x)
		limit_right = int(gridWidth + limitPadding.x)

		zoom = normalZoom
		shouldFollowPlayer = true


func _onHexGridLevelCompleted():
	currentZoomState = true
	setZoom(true)
	emit_signal("zoomChanged", true)
	locked = true


func _onHexGridNewLevel():
	locked = false
	