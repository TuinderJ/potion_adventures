extends Node2D

@export_file(".dialogue") var dialogue_file

func _ready() -> void:
	if Game.number_of_runs == 0:
		var flower = Flower.new()
		flower.position = Vector2(300, 200)
		flower.force_highlight = true
		add_child(flower)
		Game.bgm_player.play()
	
	var dialogue = load(dialogue_file)
	if Game.number_of_runs == 0:
		DialogueManager.show_dialogue_balloon(dialogue, "opening_dialogue")
	else:
		DialogueManager.show_dialogue_balloon(dialogue, "dialogue_after_first_run")
	DialogueSignals.transition_to_forest.connect(_on_transition_to_forest)
	DialogueSignals.transition_to_shop.connect(_on_transition_to_shop)
	DialogueSignals.give_player_weapon.connect(_on_give_player_weapon)

func _on_transition_to_forest() -> void:
	%Player.should_be_walking = true
	%Player.playback.travel("walk")

func _on_transition_to_shop() -> void:
	get_tree().change_scene_to_file("res://ui/shop.tscn")

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	get_tree().change_scene_to_file("res://game_items/forest.tscn")

func _on_give_player_weapon() -> void:
	%Player.playback.travel("idle")
	for child in get_children():
		if child is Flower:
			child.queue_free()
