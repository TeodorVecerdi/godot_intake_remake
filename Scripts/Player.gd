extends Sprite
class_name PlayerController

const HexConstants = preload("res://Scripts/HexConstants.gd")
onready var Grid: HexGrid = $".".get_parent() as HexGrid
var gridX: int
var gridY: int


func _ready():
	position = Grid.Offset * Grid.Scale + HexConstants.ArrayToWorld(gridX, gridY, Grid.Scale)
	scale = Vector2(Grid.Scale, Grid.Scale)


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
	position += HexConstants.DistanceToNeighbours[direction] * Grid.Scale * HexConstants.RADIUS
	gridX += HexConstants.NeighbourDelta[gridY % 2][direction][0]
	gridY += HexConstants.NeighbourDelta[gridY % 2][direction][1]

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