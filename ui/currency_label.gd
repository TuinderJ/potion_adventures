extends Label

func _ready() -> void:
	text = str(Game.currency)
	Game.currency_updated.connect(_on_currency_update)
	if Game.number_of_runs == 0:
		get_parent().get_parent().hide()

func _on_currency_update() -> void:
	text = str(Game.currency)
