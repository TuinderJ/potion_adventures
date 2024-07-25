extends Node

var currency: int = 0:
	set(new_value):
		currency = new_value
		if currency > 250:
			flower_mods["should_highlight"] = true

var flower_mods: = {
	"should_highlight": false
}
