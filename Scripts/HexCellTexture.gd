extends Node2D
class_name HexCellTexture

export (Array) var Textures

func getTextureRandom() -> Texture:
    var index = randi() % getTextureCount()
    return Textures[index] as Texture

func getTexture(index: int) -> Texture:
    var length = getTextureCount()
    if index < 0 or index >= length:
        return null
    return Textures[index] as Texture

func getTextureCount() -> int:
    return len(Textures)
