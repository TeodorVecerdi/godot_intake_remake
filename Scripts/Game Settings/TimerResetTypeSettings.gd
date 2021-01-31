extends Control

signal onValueChanged(type, time)

onready var spinBox: SpinBox = $"MarginContainer/VBoxContainer/SpinBox"
onready var optionButton: OptionButton = $"MarginContainer/VBoxContainer/OptionButton"

var timerResetType: int = 0 # 0 = Reset, 1 = Add to timer
var timerAddTime: int = 0

func _onTypeChanged(type: int):
	timerResetType = type
	if type == 0:
		timerAddTime = 0
	else:
		timerAddTime = int(spinBox.value)

	emit_signal("onValueChanged", timerResetType, timerAddTime)


func _onSpinBoxValueChanged(value: float) -> void:
	timerAddTime = int(value)
	emit_signal("onValueChanged", timerResetType, timerAddTime)

func SetPreset(preset: int, time: int, updateUI: bool = true) -> void:
	timerResetType = preset
	timerAddTime = time
	$"MarginContainer/VBoxContainer".onItemSelected(preset)
	if updateUI:
		optionButton.selected = preset
		spinBox.value = time
	emit_signal("onValueChanged", timerResetType, timerAddTime)