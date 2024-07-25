extends HBoxContainer

const SHOP_ITEM = preload("res://shop_item.tscn")

func _ready() -> void:
	for upgrade in Game.shop_items:
		var shop_item = SHOP_ITEM.instantiate()
		shop_item.upgrade = upgrade
		add_child(shop_item)
