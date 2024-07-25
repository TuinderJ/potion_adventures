extends MarginContainer

@onready var texture_button: TextureButton = $PanelContainer/TextureButton

var upgrade

func _ready() -> void:
	Game.currency_updated.connect(update_shop_item)
	%UpgradeName.text = upgrade.capitalize()
	update_shop_item()

func _on_texture_button_pressed() -> void:
	if Game.shop_items[upgrade].times_purchased >= Game.shop_items[upgrade].max_purchases:
		return
	if Game.currency < Game.shop_items[upgrade].cost:
		return
	Game.purchase_item(upgrade)
	print(Game.shop_items[upgrade])
	update_shop_item()

func update_shop_item() -> void:
	%UpgradeCost.text = str(Game.shop_items[upgrade].cost)
	if Game.shop_items[upgrade].times_purchased >= Game.shop_items[upgrade].max_purchases:
		%Max.show()
		%CanPurchaseCover.show()
		texture_button.mouse_default_cursor_shape = Control.CURSOR_ARROW
	if Game.currency < Game.shop_items[upgrade].cost:
		%CanPurchaseCover.show()
		texture_button.mouse_default_cursor_shape = Control.CURSOR_ARROW
