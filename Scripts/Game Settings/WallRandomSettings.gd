extends Control

signal onValueChanged(passes)

onready var spinBox: SpinBox = $"MarginContainer/SpinBox"

var passes: int = 60

func _onSpinBoxValueChanged(value: float) -> void:
	passes = int(value)
	emit_signal("onValueChanged", passes)


func SetPreset(value: int, updateUI: bool = true) -> void:
	passes = value
	if updateUI:
		spinBox.value = passes
	emit_signal("onValueChanged", passes)