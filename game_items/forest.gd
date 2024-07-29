extends Node2D

class_name Level

@onready var flower_spawn_timer: Timer = $FlowerSpawnTimer
@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar

func _ready() -> void:
	progress_bar.call("start_progress_bar", Game.upgrades.harvest_time)
	var tween = create_tween()
	tween.tween_property(Game.bgm_player, "volume_db", -20, 1)
	await tween.finished
	tween.kill()

func spawn_flower():
	var flower = Flower.new()
	flower.position = $Player.position + Vector2(630, -16)
	add_child(flower)

func _on_flower_spawn_timer_timeout() -> void:
	spawn_flower()
	flower_spawn_timer.wait_time = randf_range(0.5,2.5)
	flower_spawn_timer.start()

func _on_harvest_time_finished() -> void:
	var stationary_camera = Camera2D.new()
	stationary_camera.global_position = %PlayerCamera.global_position
	stationary_camera.enabled = true
	add_child(stationary_camera)
	%PlayerCamera.enabled = false

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	Game._on_harvest_ending_animation_finished()
