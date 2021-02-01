extends Camera2D
class_name CameraFollow

export (float) var followSpeed: float = 0.1
export (float) var levelTransitionSpeed: float = 2
export (Vector2) var normalZoom: Vector2 = Vector2(1, 1)
export (Vector2) var limitPadding: Vector2 = Vector2(350, 200)

signal zoomChanged(state)
signal onLevelFadeOut
signal onLevelFadeIn

onready var target = $"../Player"
onready var transitionFade = $"../../UI Canvas/Fade"
onready var grid: HexGrid = $".".get_parent() as HexGrid

var currentZoomState = false
var shouldFollowPlayer = true
var locked = false

var center: Vector2
var gridWidth: float
var gridHeight: float

var tween: Tween


func _ready() -> void:
	tween = Tween.new()
	add_child(tween)

	gridWidth = 2.0 * SettingsPresets.SETTINGS["mapSize"] * HexConstants.RADIUS * HexConstants.INNER_CONSTANT * grid.Scale
	gridHeight = 1.5 * SettingsPresets.SETTINGS["mapSize"] * HexConstants.RADIUS * grid.Scale
	center = Vector2(gridWidth / 2.0, gridHeight / 2.0 - HexConstants.RADIUS * 1.2)

	setZoom(false)


func _process(_delta) -> void:
	if shouldFollowPlayer:
		position = target.position


func _input(event) -> void:
	if locked:
		return

	var justPressed = event.is_pressed() and not event.is_echo()
	if not justPressed:
		return

	if Input.is_key_pressed(KEY_SPACE):
		currentZoomState = ! currentZoomState
		emit_signal("zoomChanged", currentZoomState)
		setZoom(currentZoomState)
		


func setZoom(zoomState) -> void:
	if zoomState:
		shouldFollowPlayer = false

		limit_bottom = 1000000000
		limit_top = -1000000000
		limit_left = -1000000000
		limit_right = 1000000000

		position = center

		var viewportSize = get_viewport().size
		
		var ratioH = gridHeight / viewportSize.y
		var aspect = viewportSize.x / viewportSize.y
		var zoomLevel: float = ratioH * aspect + 0.25
		zoom = Vector2(zoomLevel, zoomLevel)
	else:
		limit_bottom = int(gridHeight + limitPadding.y)
		limit_top = int(-limitPadding.y)
		limit_left = int(-limitPadding.x)
		limit_right = int(gridWidth + limitPadding.x)

		zoom = normalZoom
		shouldFollowPlayer = true


func levelFadeOut() -> void:
	print("FADING OUT")
	smoothing_enabled = false
	tween.interpolate_property(self, "position", center, Vector2(center.x, center.y - 2000), levelTransitionSpeed, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(transitionFade, "modulate", Color(0,0,0,0), Color(0,0,0,1), 0.5,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.2)
	tween.start()
	yield(tween, "tween_all_completed")
	print("FADING OUT COMPLETE")
	emit_signal("onLevelFadeOut")
	
	
func levelFadeIn() -> void:
	print("FADING IN")
	tween.interpolate_property(self, "position", Vector2(center.x, center.y + 2000), center, levelTransitionSpeed,Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(transitionFade, "modulate", Color(0,0,0,1), Color(0,0,0,0), 0.5,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, levelTransitionSpeed-0.7)
	tween.start()
	yield(tween, "tween_all_completed")
	print("FADING IN COMPLETE")
	smoothing_enabled = true
	emit_signal("onLevelFadeIn")

func _onHexGridLevelCompleted() -> void:
	currentZoomState = true
	setZoom(true)
	emit_signal("zoomChanged", true)
	locked = true


func _onHexGridNewLevel() -> void:
	locked = false
	