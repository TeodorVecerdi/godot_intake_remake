extends TextureRect

export (float) var ResetY: float = 0
export (float) var ResetToY: float = -1197
export (float) var ScrollSpeed: float = 1


func _ready():
	rect_position.y = ResetToY


func _process(delta):
	rect_position.y += ScrollSpeed * delta
	if abs(rect_position.y - ResetY) <= ScrollSpeed * delta * 0.5:
		rect_position.y = ResetToY