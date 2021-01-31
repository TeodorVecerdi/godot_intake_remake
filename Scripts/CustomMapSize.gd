extends Control

export (NodePath) var OptionButtonPath: NodePath 
export (NodePath) var ShowPath: NodePath 
export (int) var ShowOnValue: int = 0

var optionButton: OptionButton
var targetNode: Control

func _ready():
	optionButton = get_node(OptionButtonPath)
	targetNode = get_node(ShowPath)

	optionButton.connect("item_selected", self, "onItemSelected")


func onItemSelected(index: int) -> void:
	targetNode.visible = index == ShowOnValue
