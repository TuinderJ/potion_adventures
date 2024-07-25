extends Node

var number_of_runs: = 0
var currency: int = 50:
	set(new_value):
		currency = new_value
		currency_updated.emit()

signal currency_updated

var upgrades: = {
	"should_highlight_flowers": false,
	"harvest_time": 10.0
}
var shop_items: = {
	"highlight_flowers": {
		"cost": 100,
		"tooltip": "Highlights the flowers that appear to make them easier to see.",
		"max_purchases": 1,
		"times_purchased": 0,
		"cost_scale": 1.50
	},
	"extend_harvest_time": {
		"cost": 50,
		"tooltip": "Adds 10 seconds to the timer to allow for more harvesting.",
		"max_purchases": 5,
		"times_purchased": 0,
		"cost_scale": 1.50
	}
}

func _on_harvest_time_finished() -> void:
	number_of_runs += 1
	get_tree().change_scene_to_file("res://shop.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func purchase_item(upgrade: String) -> void:
	currency -= shop_items[upgrade].cost
	shop_items[upgrade].times_purchased += 1
	shop_items[upgrade].cost = roundi(shop_items[upgrade].cost * shop_items[upgrade].cost_scale)
	call(upgrade + "_purchased")

func highlight_flowers_purchased() -> void:
	upgrades["should_highlight_flowers"] = true
	
func extend_harvest_time_purchased() -> void:
	upgrades["harvest_time"] += 10
