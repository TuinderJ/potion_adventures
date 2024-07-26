extends Node

var number_of_runs: = 0
var currency: = 0:
	set(new_value):
		currency = new_value
		currency_updated.emit()

signal currency_updated

var upgrades: = {
	"should_highlight_flowers": false,
	"harvest_time": 10.0,
	"harvest_double_chance": 0.0,
	"exhaustion_timer": 2.0
}
var shop_items: = {
	"potion_of_enhanced_sight": {
		"cost": 150,
		"tooltip": "Highlights the flowers that appear to make them easier to see",
		"max_purchases": 1,
		"times_purchased": 0,
		"cost_scale": 1.0,
		"texture_path": "res://assets/potions/178_Potion_Mana_P.png"
	},
	"potion_of_stamina": {
		"cost": 50,
		"tooltip": "You are able to find you way out of deeper portions of the forest",
		"max_purchases": 5,
		"times_purchased": 0,
		"cost_scale": 1.5,
		"texture_path": "res://assets/potions/241_Potion_Regeneration_S.png"
	},
	"potion_of_perseverance": {
		"cost": 50,
		"tooltip": "Reduces how long you are exhausted for when you miss a flower",
		"max_purchases": 6,
		"times_purchased": 0,
		"cost_scale": 1.5,
		"texture_path": "res://assets/potions/241_Potion_Regeneration_S.png"
	},
	"potion_of_luck": {
		"cost": 100,
		"tooltip": "Increases the chance to double the value of a harvest",
		"max_purchases": 5,
		"times_purchased": 0,
		"cost_scale": 2.0,
		"texture_path": "res://assets/potions/479_Potion_Angelic_Q.png"
	}
}

func _on_harvest_time_finished() -> void:
	number_of_runs += 1

func purchase_item(upgrade: String) -> void:
	currency -= shop_items[upgrade].cost
	shop_items[upgrade].times_purchased += 1
	shop_items[upgrade].cost = roundi(shop_items[upgrade].cost * shop_items[upgrade].cost_scale)
	call(upgrade + "_purchased")

func potion_of_enhanced_sight_purchased() -> void:
	upgrades.should_highlight_flowers = true

func potion_of_stamina_purchased() -> void:
	upgrades.harvest_time += 10

func potion_of_perseverance_purchased() -> void:
	upgrades.exhaustion_timer -= .25

func potion_of_luck_purchased() -> void:
	upgrades.harvest_double_chance += .2

func _on_harvest_ending_animation_finished() -> void:
	get_tree().change_scene_to_file("res://shop.tscn")
