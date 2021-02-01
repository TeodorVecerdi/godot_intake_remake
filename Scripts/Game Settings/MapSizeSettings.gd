extends Control

signal onValueChanged(size)

onready var spinBox: SpinBox = $"MarginContainer/VBoxContainer/SpinBox"
onready var optionButton: OptionButton = $"MarginContainer/VBoxContainer/OptionButton"

const SIZES = [8, 12, 16, 24]
var currentSize: int = SIZES[0]
var currentPreset: int = 0


func _onPresetChanged(index: int) -> void:
	currentPreset = index
	if index < 4:
		currentSize = SIZES[index]
	else:
		currentSize = int(spinBox.value)
	emit_signal("onValueChanged", currentSize)


func _onSpinBoxValueChanged(value: float) -> void:
	currentSize = int(value)
	emit_signal("onValueChanged", currentSize)


func SetPreset(preset: int, updateUI: bool = true) -> void:
	currentPreset = preset
	currentSize = SIZES[preset]
	$"MarginContainer/VBoxContainer".onItemSelected(preset)
	if updateUI:
		optionButton.selected = preset
	emit_signal("onValueChanged", currentSize)
