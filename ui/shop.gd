extends Control

func _ready() -> void:
	%ShopItemsContainer.connect("update_tooltip", update_tooltip)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://forest.tscn")

func update_tooltip(tooltip: String) -> void:
	%Tooltip.text = tooltip
