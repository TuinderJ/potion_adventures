extends Label

func _ready() -> void:
	if Game.number_of_runs > 0:
		hide()
