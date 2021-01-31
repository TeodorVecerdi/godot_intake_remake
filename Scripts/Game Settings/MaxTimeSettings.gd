extends Control

signal onValueChanged(time)

onready var spinBox: SpinBox = $"MarginContainer/SpinBox"

var totalTime: int = 60

func _onSpinBoxValueChanged(value: float) -> void:
	totalTime = int(value)
	emit_signal("onValueChanged", totalTime)


func SetPreset(time: int, updateUI: bool = true) -> void:
	totalTime = time
	if updateUI:
		spinBox.value = time
	emit_signal("onValueChanged", totalTime)