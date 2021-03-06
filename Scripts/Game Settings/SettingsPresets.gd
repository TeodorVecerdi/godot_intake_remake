extends Node

var SETTINGS = {
	"mapSize": 0,
	"resetType": 0,
	"addTime": 0,
	"maxTime": 0,
	"stdPasses": 0,
	"rndPasses": 0
}

const PRESETS = [
	{
		"name": "Very Easy",
		"map_size": 0,
		"timer_reset_type": [0, 0],
		"max_time": 60,
		"wall_std": 1,
		"wall_rnd": 0
	},
	{
		"name": "Easy",
		"map_size": 1,
		"timer_reset_type": [1, 30],
		"max_time": 60,
		"wall_std": 2,
		"wall_rnd": 0
	},
	{
		"name": "Normal",
		"map_size": 2,
		"timer_reset_type": [1, 15],
		"max_time": 45,
		"wall_std": 2,
		"wall_rnd": 0
	},
	{
		"name": "Hard",
		"map_size": 3,
		"timer_reset_type": [1, 15],
		"max_time": 30,
		"wall_std": 2,
		"wall_rnd": 1
	},
	{
		"name": "Extreme",
		"map_size": 3,
		"timer_reset_type": [1, 15],
		"max_time": 30,
		"wall_std": 2,
		"wall_rnd": 2
	}
]
