extends Label

func _ready() -> void:
	text = str(Game.currency)
	Game.currency_updated.connect(_on_currency_update)

func _on_currency_update() -> void:
	text = str(Game.currency)
