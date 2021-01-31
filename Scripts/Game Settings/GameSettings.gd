extends Control

onready var presetInput: OptionButton = $"MarginContainer/Background/VBoxContainer/Presets/MarginContainer/OptionButton"
onready var mapSizeSettings = $"MarginContainer/Background/VBoxContainer/Settings/Contents/Map Size"
onready var timerResetTypeSettings = $"MarginContainer/Background/VBoxContainer/Settings/Contents/Timer Reset Type"
onready var timerMaxValueSettings = $"MarginContainer/Background/VBoxContainer/Settings/Contents/Timer Max Value"
onready var wallStandardSettings = $"MarginContainer/Background/VBoxContainer/Settings/Contents/Wall Standard"
onready var wallRandomSettings = $"MarginContainer/Background/VBoxContainer/Settings/Contents/Wall Random"

onready var fade = $Fade

var mapSize: int
var resetType: int
var addTime: int
var maxTime: int
var stdPasses: int
var rndPasses: int

var tween: Tween


func _ready():
	tween = Tween.new()
	add_child(tween)

	tween.interpolate_property(fade, "modulate", Color(0,0,0,1), Color(0,0,0,0), 1.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, 0.3)
	tween.start()
	presetInput.selected = 0
	setPreset(SettingsPresets.PRESETS[0])
	yield(tween, "tween_completed")


func _onPresetChanged(preset: int):
	var isPresetCustom = preset >= len(SettingsPresets.PRESETS)
	if not isPresetCustom:
		var presetSettings = SettingsPresets.PRESETS[preset]
		setPreset(presetSettings)


func _on_Map_Size_onValueChanged(size: int):
	mapSize = size
	presetInput.selected = matchesPreset()


func _on_Timer_Reset_Type_onValueChanged(type: int, time: int):
	resetType = type
	addTime = time
	presetInput.selected = matchesPreset()


func _on_Timer_Max_Value_onValueChanged(time: int):
	maxTime = time
	presetInput.selected = matchesPreset()


func _on_Wall_Standard_onValueChanged(passes: int):
	stdPasses = passes
	presetInput.selected = matchesPreset()


func _on_Wall_Random_onValueChanged(passes: int):
	rndPasses = passes
	presetInput.selected = matchesPreset()


func _onPlayClicked() -> void:
	SettingsPresets.SETTINGS["mapSize"] = mapSize
	SettingsPresets.SETTINGS["resetType"] = resetType
	SettingsPresets.SETTINGS["addTime"] = addTime
	SettingsPresets.SETTINGS["maxTime"] = maxTime
	SettingsPresets.SETTINGS["stdPasses"] = stdPasses
	SettingsPresets.SETTINGS["rndPasses"] = rndPasses
	
	tween.interpolate_property(fade, "modulate", Color(0,0,0,0), Color(0,0,0,1), 1.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, 0.3)
	tween.start()
	yield(tween, "tween_completed")
	SceneManager.LoadScene(SceneManager.GAME)


func setPreset(presetSettings) -> void:
	mapSizeSettings.SetPreset(presetSettings["map_size"])
	timerResetTypeSettings.SetPreset(
		presetSettings["timer_reset_type"][0], presetSettings["timer_reset_type"][1]
	)
	timerMaxValueSettings.SetPreset(presetSettings["max_time"])
	wallStandardSettings.SetPreset(presetSettings["wall_std"])
	wallRandomSettings.SetPreset(presetSettings["wall_rnd"])


func matchesPreset() -> int:
	for i in range(len(SettingsPresets.PRESETS)):
		if mapSize != mapSizeSettings.SIZES[SettingsPresets.PRESETS[i]["map_size"]]:
			continue
		if resetType != SettingsPresets.PRESETS[i]["timer_reset_type"][0]:
			continue
		if addTime != SettingsPresets.PRESETS[i]["timer_reset_type"][1]:
			continue
		if maxTime != SettingsPresets.PRESETS[i]["max_time"]:
			continue
		if stdPasses != SettingsPresets.PRESETS[i]["wall_std"]:
			continue
		if rndPasses != SettingsPresets.PRESETS[i]["wall_rnd"]:
			continue
		return i
	return len(SettingsPresets.PRESETS)  # custom
