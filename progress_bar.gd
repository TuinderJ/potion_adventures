extends ProgressBar

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func start_progress_bar(duration: float) -> void:
	var tween: = create_tween()
	tween.finished.connect(Game._on_harvest_time_finished)
	tween.tween_property(self, "value", max_value, duration)
	tween.parallel().tween_property(animated_sprite_2d, "position", Vector2(size.x, 5), duration)
