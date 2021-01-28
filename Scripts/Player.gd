extends Sprite
class_name PlayerController

onready var Grid = $".".get_parent()
onready var Arrows = [
	$Arrows/arrow_up_right,
	$Arrows/arrow_right,
	$Arrows/arrow_down_right,
	$Arrows/arrow_down_left,
	$Arrows/arrow_left,
	$Arrows/arrow_up_left
]

signal moved(gridX, gridY)

var gridX: int
var gridY: int
var validMoves


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
	if not justPressed:
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
	emit_signal("moved", gridX, gridY)
	updateValidMoves()
	updateArrows()
	Grid.showNeighbours(gridX, gridY)

	""" 
	//Update player sprites
	if (direction == 2 || direction == 3) // front sprite
		PlayerSprite.sprite = PlayerSprites[0];
	if (direction == 0 || direction == 5) // back sprite
		PlayerSprite.sprite = PlayerSprites[1];
	if (direction == 4) // left sprite
		PlayerSprite.sprite = PlayerSprites[2];
	if (direction == 1) // right sprite
		PlayerSprite.sprite = PlayerSprites[3];
	"""


func updateValidMoves():
	validMoves = Grid.getPassableNeighboursBool(gridX, gridY)


func updateArrows() -> void:
	for i in range(len(Arrows)):
		Arrows[i].visible = validMoves[i]
