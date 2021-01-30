extends Node2D
class_name HexGrid

const HexConstants = preload("res://Scripts/HexConstants.gd")
const HexCell = preload("res://Scenes/Game/HexCell.tscn")
const CellIndex = preload("res://Scripts/CellIndex.gd")
const CellNeighbour = preload("res://Scripts/CellNeighbour.gd")

export (int) var CellsX: int = 4
export (int) var CellsY: int = 4
export var Scale: float = 1.0
export (Vector2) var Offset: Vector2 = Vector2(90, 101)

signal levelCompleted
signal newLevel
signal levelStarted

onready var normalCells: HexCellTexture = $Tiles/CellTiles
onready var hiddenCells: HexCellTexture = $Tiles/HiddenTiles
onready var finishCells: HexCellTexture = $Tiles/FinishTiles
onready var cellContainer = $Cells
onready var player: PlayerController = $Player
onready var timer = $"../UI Canvas/HUD"
onready var winLose = $"../UI Canvas/UI"
onready var cameraController = $Camera

var cellGrid
var goalX: int
var goalY: int
var score: int = 0
var waitingForInput: bool = false
var waitingForPlayerStart: bool = false
var waitingForAnimation: bool = false
var isGameOver: bool = false


func _ready() -> void:
	emit_signal("levelCompleted")


func _input(event) -> void:
	var isPressed = event.is_pressed() and not event.is_echo()
	if not isPressed:
		return

	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE and not isGameOver and not waitingForInput and not waitingForAnimation:
			get_tree().quit()
		elif not isGameOver:
			if event.scancode == KEY_F and waitingForInput:
				winLose.hideActive()
				yield(winLose, "onFadeOut")
				startLevel()
			elif event.scancode == KEY_ESCAPE and waitingForInput:
				returnToMainMenu()
		elif isGameOver:
			if event.scancode == KEY_R and waitingForInput:
				winLose.animateScoreRestart(score)
				yield(winLose, "onScoreRestartComplete")
				winLose.hideActive()
				yield(winLose, "onFadeOut")
				restart()
			elif event.scancode == KEY_ESCAPE and waitingForInput:
				returnToMainMenu()


func _onPlayerMoved(gridX: int, gridY: int) -> void:
	if gridX == goalX and gridY == goalY:
		win()


func _onCameraZoomChanged(state) -> void:
	if waitingForPlayerStart:
		waitingForPlayerStart = false

		player.load()
		emit_signal("levelStarted")

		timer.start()

	player.lockMovement(state)
	print("Camera zoom state changed to [%s]" % ("Zoomed Out" if state else "Zoomed In"))


func _onTimerCompleted() -> void:
	print("Time ran out")
	gameOver()


func _onTimerStopped() -> void:
	pass


func _onTimerReady() -> void:
	startLevel(true)


func gameOver() -> void:
	showAll()
	timer.stop()
	emit_signal("levelCompleted")
	isGameOver = true
	winLose.showLose(score)
	yield(winLose, "onFadeIn")
	waitingForInput = true

func restart() -> void:
	score = 0
	isGameOver = false
	startLevel()


func returnToMainMenu() -> void:
	score = 0
	isGameOver = false
	SceneManager.call_deferred("LoadScene", SceneManager.MAIN_MENU)



func win() -> void:
	var scoreIncrease: int = 1
	if timer.fillAmount > timer.WarningBracket:
		scoreIncrease = 4
	elif timer.fillAmount > timer.BadBracket:
		scoreIncrease = 2
	var oldScore: int = score
	score += scoreIncrease
	print("Score: [%d] (increased by [%d])" % [score, scoreIncrease])
	showAll()
	timer.stop()
	emit_signal("levelCompleted")
	waitingForAnimation = true
	winLose.showWin(oldScore, score)
	yield(winLose, "onFadeIn")
	waitingForAnimation = false
	waitingForInput = true



func startLevel(skipTransition: bool = false) -> void:
	waitingForInput = false
	if not skipTransition:
		cameraController.levelFadeOut()
		yield(cameraController, "onLevelFadeOut")
	generateMaze()
	player.reset()
	if not skipTransition:
		cameraController.levelFadeIn()
		yield(cameraController, "onLevelFadeIn")
	waitingForPlayerStart = true
	emit_signal("newLevel")
	timer.reset(60.0)


func generateMaze() -> void:
	resetMaze()
	generateMazeWalls()
	hideAdjacentWalls()

	for y in range(CellsY):
		for x in range(CellsX):
			cellGrid[y][x].setTexture()

	showNeighbours(0, 0)
	showCell(goalX, goalY)


func resetMaze() -> void:
	for child in cellContainer.get_children():
		cellContainer.remove_child(child)
		child.queue_free()

	cellGrid = []

	goalX = randi() % CellsX
	if goalX < int(float(CellsX) / 2):
		goalY = randi() % int(float(CellsY) / 2) + int(float(CellsY) / 2)
	else:
		goalY = randi() % CellsY

	# First pass - generate cells
	for y in range(CellsY):
		cellGrid.append([])
		for x in range(CellsX):
			cellGrid[y].append(HexCell.instance())

			var texVariation = randi() % 3
			var index = CellIndex.new()
			index.init(x, y)
			if x == goalX and y == goalY:
				cellGrid[y][x].loadTextures(hiddenCells, finishCells)
			else:
				cellGrid[y][x].loadTextures(hiddenCells, normalCells)
			cellGrid[y][x].initialize(HexConstants.ArrayToWorld(x, y, Scale), texVariation, index)
			cellGrid[y][x].scale = Vector2(Scale, Scale)
			cellContainer.add_child(cellGrid[y][x])
			cellContainer.position = Offset * Scale


func generateMazeWalls() -> void:
	var visited = []
	for y in range(CellsY):
		visited.append([])
		for _x in range(CellsX):
			visited[y].append(false)

	var cellStack = []
	var cellsLeft = CellsX * CellsY - 1
	var current = CellNeighbour.new()
	current.initXY(0, 0, 0)
	visited[0][0] = true
	while cellsLeft > 0:
		var neighbours = getUnvisitedNeighbours(current, visited)
		var neighbourLength = len(neighbours)
		if neighbourLength != 0:
			var chosen = neighbours[randi() % neighbourLength]
			cellStack.push_back(current)
			setWall(chosen.direction, false, current.x, current.y)
			current = chosen
			visited[current.y][current.x] = true
			cellsLeft -= 1
		elif len(cellStack) != 0:
			current = cellStack.pop_back()
		else:
			print("EXITED MAZE GENERATION EARLY")
			break


func hideAdjacentWalls() -> void:
	# Third pass - hide adjacent walls
	for y in range(CellsY):
		for x in range(CellsX):
			var neighbours := getNeighboursIndices(x, y)
			var current = cellGrid[y][x]
			for neighbourIndex in neighbours:
				var neighbour = cellGrid[neighbourIndex.y][neighbourIndex.x]
				if (
					current.walls[neighbourIndex.direction]
					and not (
						neighbour.hiddenWalls[(neighbourIndex.direction + 3) % 6]
						or current.hiddenWalls[neighbourIndex.direction]
					)
				):
					neighbour.hiddenWalls[(neighbourIndex.direction + 3) % 6] = true


func getPassableNeighboursBool(x: int, y: int) -> Array:
	var upper_right = false if y == 0 or (x == CellsX - 1 and y % 2 == 1) else isPassable(x, y, 0)
	var right = false if x == CellsX - 1 else isPassable(x, y, 1)
	var lower_right = (
		false
		if y == CellsY - 1 or (x == CellsX - 1 and y % 2 == 1)
		else isPassable(x, y, 2)
	)
	var lower_left = false if y == CellsX - 1 or (x == 0 and y % 2 == 0) else isPassable(x, y, 3)
	var left = false if x == 0 else isPassable(x, y, 4)
	var upper_left = false if y == 0 or (x == 0 and y % 2 == 0) else isPassable(x, y, 5)

	return [upper_right, right, lower_right, lower_left, left, upper_left]


func getNeighboursIndices(x: int, y: int) -> Array:
	var indices = []
	var deltas = HexConstants.NeighbourDelta[y % 2]
	for index in range(6):
		if not rangeCheck(index, x, y):
			continue
		var neighbour = CellNeighbour.new()
		neighbour.initCIdx(cellGrid[y + deltas[index][1]][x + deltas[index][0]].cellIndex, index)
		indices.append(neighbour)
	return indices


func isPassable(x: int, y: int, direction: int) -> bool:
	return not cellGrid[y][x].walls[direction]


func getUnvisitedNeighbours(current: CellNeighbour, visited: Array) -> Array:
	var unvisited = []
	var allNeighbours = getNeighboursIndices(current.x, current.y)
	for neighbour in allNeighbours:
		if visited[neighbour.y][neighbour.x] == false:
			unvisited.append(neighbour)
	return unvisited


func showCell(x: int, y: int) -> void:
	cellGrid[y][x].setHidden(false)
	var neighbourDeltas = HexConstants.NeighbourDelta[y % 2]
	for i in range(6):
		if rangeCheck(i, x, y):
			var neighbour = cellGrid[y + neighbourDeltas[i][1]][x + neighbourDeltas[i][0]]
			if neighbour.isHidden:
				neighbour.showWall((i + 3) % 6)


func showNeighbours(x: int, y: int) -> void:
	showCell(x, y)
	var neighbourDeltas = HexConstants.NeighbourDelta[y % 2]
	var passableNeighbours = getPassableNeighboursBool(x, y)
	for i in range(6):
		if passableNeighbours[i]:
			showCell(x + neighbourDeltas[i][0], y + neighbourDeltas[i][1])


func showAll() -> void:
	for x in range(CellsX):
		for y in range(CellsY):
			showCell(x, y)


func setWall(index: int, state: bool, x: int, y: int) -> void:
	if not rangeCheck(index, x, y):
		return

	var neighbourDeltas = HexConstants.NeighbourDelta[y % 2]
	var otherX = x + neighbourDeltas[index][0]
	var otherY = y + neighbourDeltas[index][1]
	cellGrid[y][x].setWall(index, state)
	cellGrid[otherY][otherX].setWall((index + 3) % 6, state)


func rangeCheck(index: int, x: int, y: int) -> bool:
	return not (
		(index == 0 && (y == 0 or (x == CellsX - 1 and y % 2 == 1)))
		or (index == 1 && x == CellsX - 1)
		or (index == 2 && (y == CellsY - 1 or (x == CellsX - 1 and y % 2 == 1)))
		or (index == 3 && (y == CellsX - 1 or (x == 0 and y % 2 == 0)))
		or (index == 4 && x == 0)
		or (index == 5 && (y == 0 or (x == 0 and y % 2 == 0)))
		or (index > 5)
	)
