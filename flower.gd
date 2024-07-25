extends Node2D
class_name Flower

var value: int

func _ready() -> void:
	var dir = DirAccess.open("res://assets/flowers/")
	var files: PackedStringArray = dir.get_files()
	var random_number = str(randi_range(1,files.size() / 2))
	if int(random_number) < 100:
		random_number = "0" + random_number
	if int(random_number) < 10:
		random_number = "0" + random_number
	value = int(random_number)
	
	set_up_sprite(random_number)
	set_up_area_2d()
	set_up_visible_on_screen_notifier_2d()

func set_up_sprite(random_number: String) -> void:
	var sprite_2d: = Sprite2D.new()
	
	sprite_2d.texture = load("res://assets/flowers/" + random_number + ".png")
	sprite_2d.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite_2d.scale = Vector2(2, 2)
	
	if Game.upgrades["should_highlight_flowers"]:
		var shader_material = ShaderMaterial.new()
		shader_material.shader = preload("res://flower.gdshader")
		sprite_2d.material = shader_material
		
	add_child(sprite_2d)

func set_up_area_2d() -> void:
	var area_2d: = Area2D.new()
	area_2d.monitoring = false
	add_child(area_2d)
	
	var collision_shape_2d = CollisionShape2D.new()
	var rectangle_shape_2d = RectangleShape2D.new()
	rectangle_shape_2d.size = Vector2(32, 32)
	collision_shape_2d.shape = rectangle_shape_2d
	area_2d.add_child(collision_shape_2d)

func set_up_visible_on_screen_notifier_2d() -> void:
	var visible_on_screen_notifier_2d: = VisibleOnScreenNotifier2D.new()
	add_child(visible_on_screen_notifier_2d)
	visible_on_screen_notifier_2d.connect("screen_exited",on_visible_on_screen_notifier_2d_screen_exited)

func on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func collect() -> void:
	Game.currency += value
	queue_free()
