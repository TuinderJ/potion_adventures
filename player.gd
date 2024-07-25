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
		collected_anything = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("loot") and playback.get_current_node() == "walk":
		playback.travel("loot")
		collected_anything = false
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _on_collection_area_area_entered(area: Area2D) -> void:
	collectables.append(area.get_parent())

func _on_collection_area_area_exited(area: Area2D) -> void:
	collectables.erase(area.get_parent())

func _on_missed_loot_timer_timeout() -> void:
	playback.travel("walk")

func _on_loot_end() -> void:
	if not collected_anything:
		playback.travel("exhausted")
		missed_loot_timer.start()
