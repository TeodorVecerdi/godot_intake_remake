extends Node2D
class_name PlayerController

export (Texture) var Front: Texture
export (Texture) var Back: Texture
export (Texture) var Left: Texture
export (Texture) var Right: Texture

signal moved(gridX, gridY)

onready var Grid = $".".get_parent()
onready var Arrows = [
	$Arrows/arrow_up_right,
	$Arrows/arrow_right,
	$Arrows/arrow_down_right,
	$Arrows/arrow_down_left,
	$Arrows/arrow_left,
	$Arrows/arrow_up_left
]

onready var PlayerSprite = $PlayerSprite

var gridX: int
var gridY: int
var validMoves
var movementLocked = false


func _ready():
	gridX = 0
	gridY = 0
	position = Grid.Offset * Grid.Scale + HexConstants.ArrayToWorld(gridX, gridY, Grid.Scale)
	scale = Vector2(Grid.Scale, Grid.Scale)


func load():
	updateValidMoves()
	updateArrows()


func _input(event):
	var justPressed = event.is_pressed() and not event.is_echo()
	if not justPressed or movementLocked:
		return

	if Input.is_key_pressed(KEY_E):
		move(0)
	if Input.is_key_pressed(KEY_D):
		move(1)
	if Input.is_key_pressed(KEY_C):
		move(2)
	if Input.is_key_pressed(KEY_Z):
		move(3)
	if Input.is_key_pressed(KEY_A):
		move(4)
	if Input.is_key_pressed(KEY_Q):
		move(5)


func move(direction: int):
	if not validMoves[direction]:
		return

	position += HexConstants.DistanceToNeighbours[direction] * Grid.Scale * HexConstants.RADIUS
	gridX += HexConstants.NeighbourDelta[gridY % 2][direction][0]
	gridY += HexConstants.NeighbourDelta[gridY % 2][direction][1]

	updateValidMoves()
	updateArrows()
	Grid.showNeighbours(gridX, gridY)

	# Update player sprites
	if direction == 2 or direction == 3:  # front sprite
		PlayerSprite.texture = Front
	elif direction == 0 or direction == 5:  # back sprite
		PlayerSprite.texture = Back
	elif direction == 4:  # left sprite
		PlayerSprite.texture = Left
	else:  # right sprite
		PlayerSprite.texture = Right

	emit_signal("moved", gridX, gridY)


func updateValidMoves():
	validMoves = Grid.getPassableNeighboursBool(gridX, gridY)


func lockMovement(state):
	movementLocked = state
	if not state:
		updateArrows()
	else:
		for i in range(6):
			Arrows[i].visible = false


func updateArrows() -> void:
	for i in range(6):
		Arrows[i].visible = validMoves[i]
