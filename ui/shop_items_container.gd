extends HBoxContainer

signal update_tooltip(tooltip: String)

func _ready() -> void:
	for upgrade in Game.shop_items:
		var shop_item = preload("res://ui/shop_item.tscn").instantiate()
		shop_item.upgrade = upgrade
		shop_item.connect("update_tooltip", _on_update_tooltip)
		add_child(shop_item)

func _on_update_tooltip(tooltip: String) -> void:
	update_tooltip.emit(tooltip)
