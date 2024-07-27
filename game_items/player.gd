extends CharacterBody2D

const SPEED: = 250

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var collection_area: Area2D = $CollectionArea
@onready var missed_loot_timer: Timer = $MissedLootTimer

var can_loot: = true
var collected_anything: = false

var collectables: Array[Flower]
var playback: AnimationNodeStateMachinePlayback = null

func _ready() -> void:
	playback = animation_tree["parameters/playback"]

func _physics_process(_delta: float) -> void:
	velocity = Vector2(SPEED, 0)
	move_and_slide()

func _process(_delta: float) -> void:
	if collectables.size() and playback.get_current_node() == "loot":
		for collectable in collectables:
			collectable.collect()
			spawn_item_collection_notifier(collectable)
		collected_anything = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("loot") and playback.get_current_node() == "walk":
		playback.travel("loot")
		collected_anything = false

func _on_collection_area_area_entered(area: Area2D) -> void:
	collectables.append(area.get_parent())

func _on_collection_area_area_exited(area: Area2D) -> void:
	collectables.erase(area.get_parent())

func _on_missed_loot_timer_timeout() -> void:
	playback.travel("walk")

func _on_loot_end() -> void:
	if not collected_anything:
		playback.travel("exhausted")
		missed_loot_timer.wait_time = Game.upgrades.exhaustion_timer
		missed_loot_timer.start()

func spawn_item_collection_notifier(item) -> void:
	var item_collection_label = RichTextLabel.new()
	item_collection_label.bbcode_enabled = true
	item_collection_label.size = Vector2(620, 360)
	item_collection_label.add_theme_constant_override("outline_size", 3)
	item_collection_label.add_theme_color_override("font_outline_color", Color(0, 1))
	if item.should_double:
		item_collection_label.text = "[rainbow][font_size=25][shake rate=20 level=5 connected=0]+ " + str(item.value * 2)
	else:
		item_collection_label.text = "+ " + str(item.value)
	item_collection_label.position = Vector2(-20, -85)
	add_child(item_collection_label)
	var tween = create_tween()
	tween.tween_property(item_collection_label, "position", Vector2(-20, -125), 1)
	tween.parallel().tween_property(item_collection_label, "self_modulate:a", 0, 1)
	await tween.finished
	item_collection_label.queue_free()
