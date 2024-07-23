extends Node2D

@onready var flower_spawn_timer: Timer = $FlowerSpawnTimer

func spawn_flower():
	var flower = Flower.new()
	flower.position = $Player.position + Vector2(630, -16)
	add_child(flower)

func _on_flower_spawn_timer_timeout() -> void:
	spawn_flower()
	flower_spawn_timer.wait_time = randf_range(1,3.5)
	flower_spawn_timer.start()
