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
var tweenArrows: Tween
var tweenPlayer: Tween


func _ready() -> void:
	tweenArrows = Tween.new()
	tweenPlayer = Tween.new()
	add_child(tweenArrows)
	add_child(tweenPlayer)
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
	if tweenPlayer.is_active():
		yield(tweenPlayer, "tween_all_completed")
	position = HexConstants.ArrayToWorld(gridX, gridY, Grid.Scale) + Grid.Offset
	var currentPosition = position
	tweenPlayer.interpolate_property(self, "position", currentPosition, currentPosition + HexConstants.DistanceToNeighbours[direction] * Grid.Scale * HexConstants.RADIUS, 0.2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	# position += HexConstants.DistanceToNeighbours[direction] * Grid.Scale * HexConstants.RADIUS
	gridX += HexConstants.NeighbourDelta[gridY % 2][direction][0]
	gridY += HexConstants.NeighbourDelta[gridY % 2][direction][1]
	
	var newPlayerTexture = getPlayerTexture(direction)
	if newPlayerTexture != PlayerSprite.texture:
		tweenPlayer.interpolate_property(PlayerSprite, "scale", Vector2(1,1), Vector2(0,0), 0.1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tweenPlayer.interpolate_callback(self, 0.1, "setPlayerTexture", newPlayerTexture)
		tweenPlayer.interpolate_property(PlayerSprite, "scale", Vector2(0,0), Vector2(1,1), 0.1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, 0.1)

	tweenPlayer.start()

	updateValidMoves()
	updateArrows()
	Grid.showNeighbours(gridX, gridY)
	
	yield(self, "arrowsDone")
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
	tweenArrows.remove_all()
	for i in range(6):
		if Arrows[i].visible:
			tweenArrows.interpolate_property(Arrows[i], "scale", Vector2(0.06, 0.055), Vector2.ZERO, 0.2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	for i in range(6):
		if validMoves[i]:
			Arrows[i].visible = true
			tweenArrows.interpolate_property(Arrows[i], "scale", Vector2.ZERO, Vector2(0.06, 0.055), 0.2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tweenArrows.start()
	yield(tweenArrows, "tween_all_completed")
	for i in range(6):
		Arrows[i].visible = validMoves[i]
	emit_signal("arrowsDone")


func getPlayerTexture(direction: int) -> Texture:
	if direction == 2 or direction == 3:  # front sprite
		return Front
	elif direction == 0 or direction == 5:  # back sprite
		return Back
	elif direction == 4:  # left sprite
		return Left
	else:  # right sprite
		return Right


func setPlayerTexture(texture: Texture) -> void:
	PlayerSprite.texture = texture
