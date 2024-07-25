extends Node

var currency: int = 0:
	set(new_value):
		currency = new_value
		if currency > 250:
			upgrades.flower_mods["should_highlight"] = true

var upgrades: = {
	"flower_mods": {
		"should_highlight": false
	},
	"harvest_time": 10.0
}

func _on_harvest_time_finished() -> void:
	print("end of the level")
