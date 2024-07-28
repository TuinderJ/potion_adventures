extends MarginContainer

var upgrade

signal update_tooltip

func _ready() -> void:
	Game.currency_updated.connect(update_shop_item)
	%UpgradeName.text = upgrade.capitalize()
	%TextureButton.texture_normal = load(Game.shop_items[upgrade].texture_path)
	update_shop_item()

func _on_texture_button_pressed() -> void:
	if Game.shop_items[upgrade].times_purchased >= Game.shop_items[upgrade].max_purchases:
		return
	if Game.currency < Game.shop_items[upgrade].cost:
		return
	Game.purchase_item(upgrade)
	%PurchaseSound.play()
	update_shop_item()

func update_shop_item() -> void:
	%UpgradeCost.text = str(Game.shop_items[upgrade].cost)
	if Game.shop_items[upgrade].times_purchased >= Game.shop_items[upgrade].max_purchases:
		%Max.show()
		%UpgradeCost.hide()
		%CanPurchaseCover.show()
		%TextureButton.mouse_default_cursor_shape = Control.CURSOR_ARROW
	if Game.currency < Game.shop_items[upgrade].cost:
		%CanPurchaseCover.show()
		%TextureButton.mouse_default_cursor_shape = Control.CURSOR_ARROW

func _on_texture_button_mouse_entered() -> void:
	update_tooltip.emit(Game.shop_items[upgrade].tooltip)

func _on_texture_button_mouse_exited() -> void:
	update_tooltip.emit("")
