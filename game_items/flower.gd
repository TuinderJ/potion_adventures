extends Node2D
class_name Flower

var value: int
var should_double: = false
var force_highlight: = false
var audio_stream_player: AudioStreamPlayer
var has_been_collected: = false

func _ready() -> void:
	var dir = DirAccess.open("res://assets/flowers/")
	var files: PackedStringArray = dir.get_files()
	var random_number = str(randi_range(1, 100))
	if int(random_number) < 100:
		random_number = "0" + random_number
	if int(random_number) < 10:
		random_number = "0" + random_number
	value = ceil(int(random_number) * .1)
	_should_double()
	set_up_light()
	set_up_sprite(random_number)
	set_up_area_2d()
	set_up_visible_on_screen_notifier_2d()
	set_up_loot_audio()

func set_up_sprite(random_number: String) -> void:
	var sprite_2d: = Sprite2D.new()
	
	sprite_2d.texture = load("res://assets/flowers/" + random_number + ".png")
	sprite_2d.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite_2d.scale = Vector2(2, 2)
	
	if Game.upgrades["should_highlight_flowers"] or force_highlight:
		var shader_material = ShaderMaterial.new()
		shader_material.shader = preload("res://game_items/flower.gdshader")
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

func collect() -> bool:
	if has_been_collected:
		return false
	if should_double:
		Game.currency += (value * 2)
	else:
		Game.currency += value
	for child in get_children():
		if child is Sprite2D:
			child.queue_free()
	audio_stream_player.play()
	has_been_collected = true
	return true

func _should_double() -> void:
	var random_number = randf_range(0, 1)
	should_double = random_number < Game.upgrades.harvest_double_chance

func set_up_light() -> void:
	if !Game.upgrades.should_highlight_flowers:
		return
	var sprite_2d: = Sprite2D.new()
	sprite_2d.texture = preload("res://assets/light_blur.png")
	add_child(sprite_2d)

func set_up_loot_audio() -> void:
	audio_stream_player = AudioStreamPlayer.new()
	if should_double:
		audio_stream_player.stream = preload("res://assets/audio/retro_coin_pickup_02.wav")
	else:
		audio_stream_player.stream = preload("res://assets/audio/coins_pickup_shake_08.wav")
	audio_stream_player.volume_db = -20
	audio_stream_player.finished.connect(_on_loot_audio_finish)
	add_child(audio_stream_player)

func _on_loot_audio_finish() -> void:
	queue_free()
