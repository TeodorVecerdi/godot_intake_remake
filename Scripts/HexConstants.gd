class_name HexConstants

const RADIUS: float = 100.0
const INNER_CONSTANT: float = 0.8660254037

static func WorldToArray(x: float, y: float, radius: float) -> Vector2:
	return Vector2(x / INNER_CONSTANT / radius / 2.0 - int(y) % 2 * 0.5, y / radius / 1.5)

static func ArrayToWorld(x: float, y: float, radius: float) -> Vector2:
	return Vector2((x + int(y) % 2 * 0.5) * INNER_CONSTANT * radius * 2.0, y * radius * 1.5)

const NeighbourDelta = [[[0, 1], [1, 0], [0, -1], [-1, -1], [-1, 0], [-1, 1]],[[1, 1], [1, 0], [1, -1], [0, -1], [-1, 0], [0, 1]]]
