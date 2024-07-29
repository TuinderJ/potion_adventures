extends CharacterBody2D

const SPEED: = 250

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var collection_area: Area2D = $CollectionArea
@onready var missed_loot_timer: Timer = $MissedLootTimer

var can_loot: = false
var collected_anything: = false
var should_be_walking: = false

var collectables: Array[Flower]
var playback: AnimationNodeStateMachinePlayback = null

func _ready() -> void:
	playback = animation_tree["parameters/playback"]
	if get_parent() is Level:
		should_be_walking = true
		playback.travel("walk")
		can_loot = true

func _physics_process(_delta: float) -> void:
	if should_be_walking:
		velocity = Vector2(SPEED, 0)
		move_and_slide()

func _process(_delta: float) -> void:
	if collectables.size() and playback.get_current_node() == "loot":
		for collectable in collectables:
			if collectable.collect():
				spawn_item_collection_notifier(collectable)
				collected_anything = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("loot") and playback.get_current_node() == "walk" and can_loot:
		playback.travel("loot")
		collected_anything = false

func _on_collection_area_area_entered(area: Area2D) -> void:
	collectables.append(area.get_parent())

func _on_collection_area_area_exited(area: Area2D) -> void:
	collectables.erase(area.get_parent())

func _on_missed_loot_timer_timeout() -> void:
	playback.travel("walk")

func _on_loot_end() -> void:
	if collected_anything:
		playback.travel("walk")
	else:
		playback.travel("exhausted")
		missed_loot_timer.wait_time = Game.upgrades.exhaustion_timer
		missed_loot_timer.start()

func spawn_item_collection_notifier(item) -> void:
	if Game.number_of_runs == 0:
		return
	var h_box_container = HBoxContainer.new()
	add_child(h_box_container)
	h_box_container.size = Vector2(68, 24)
	h_box_container.position = Vector2(-20, -80)
	
	var item_collection_label = RichTextLabel.new()
	item_collection_label.bbcode_enabled = true
	item_collection_label.scroll_active = false
	item_collection_label.custom_minimum_size = Vector2(36, 16)
	item_collection_label.add_theme_constant_override("outline_size", 3)
	item_collection_label.add_theme_color_override("font_outline_color", Color(0, 1))
	if item.should_double:
		item_collection_label.text = "[right][rainbow][font_size=18][shake rate=20 level=5 connected=0]+ " + str(item.value * 2)
	else:
		item_collection_label.text = "[right]+ " + str(item.value)
	h_box_container.add_child(item_collection_label)
	
	var texture_rect = TextureRect.new()
	texture_rect.texture = preload("res://assets/22_Leperchaun_Coin.png")
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.custom_minimum_size = Vector2(24, 24)
	h_box_container.add_child(texture_rect)
	
	var tween = create_tween()
	tween.tween_property(h_box_container, "position", Vector2(-80, -125), 1)
	tween.parallel().tween_property(h_box_container, "modulate:a", 0, 1)
	await tween.finished
	h_box_container.queue_free()
	tween.kill()
