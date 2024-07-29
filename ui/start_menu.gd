extends Control

func _on_play_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game_items/alchemist_dialogue.tscn")
