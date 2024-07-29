extends Control

func _ready() -> void:
	%ShopItemsContainer.connect("update_tooltip", update_tooltip)
	var tween = create_tween()
	tween.tween_property(Game.bgm_player, "volume_db", -30, 1)
	await tween.finished
	tween.kill()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game_items/forest.tscn")

func update_tooltip(tooltip: String) -> void:
	%Tooltip.text = tooltip
