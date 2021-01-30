extends Node2D
class_name PlayerController

export (Texture) var Front: Texture
export (Texture) var Back: Texture
export (Texture) var Left: Texture
export (Texture) var Right: Texture

signal moved(gridX, gridY)
signal arrowsDone

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
var tween: Tween


func _ready() -> void:
	tween = Tween.new()
	add_child(tween)
	scale = Vector2(Grid.Scale, Grid.Scale)


func reset() -> void:
	gridX = 0
	gridY = 0
	position = Grid.Offset * Grid.Scale + HexConstants.ArrayToWorld(gridX, gridY, Grid.Scale)


func load() -> void:
	updateValidMoves()
	updateArrows()


func _input(event) -> void:
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


func move(direction: int) -> void:
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


func updateValidMoves() -> void:
	validMoves = Grid.getPassableNeighboursBool(gridX, gridY)


func lockMovement(state) -> void:
	movementLocked = state
	if not state:
		updateArrows()
	else:
		for i in range(6):
			Arrows[i].visible = false


func updateArrows() -> void:
	tween.remove_all()
	for i in range(6):
		if Arrows[i].visible:
			tween.interpolate_property(Arrows[i], "scale", Vector2(0.06, 0.055), Vector2.ZERO, 0.25, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	for i in range(6):
		if validMoves[i]:
			Arrows[i].visible = true
			tween.interpolate_property(Arrows[i], "scale", Vector2.ZERO, Vector2(0.06, 0.055), 0.25, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	for i in range(6):
		Arrows[i].visible = validMoves[i]
	emit_signal("arrowsDone")