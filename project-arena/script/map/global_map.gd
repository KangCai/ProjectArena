extends Node2D

func _ready():
	# 获取并连接各个地图按钮的信号
	var grass_button = $UI/GrassButton
	if grass_button:
		grass_button.pressed.connect(_on_grass_button_pressed)
	
	var sand_button = $UI/SandButton
	if sand_button:
		sand_button.pressed.connect(_on_sand_button_pressed)
	
	var stone_button = $UI/StoneButton
	if stone_button:
		stone_button.pressed.connect(_on_stone_button_pressed)
	
	var ice_button = $UI/IceButton
	if ice_button:
		ice_button.pressed.connect(_on_ice_button_pressed)
	
	var hell_button = $UI/HellButton
	if hell_button:
		hell_button.pressed.connect(_on_hell_button_pressed)

func _on_grass_button_pressed():
	# 切换到草地地图场景
	get_tree().change_scene_to_file("res://global_map_grass.tscn")

func _on_sand_button_pressed():
	# 切换到沙地地图场景
	get_tree().change_scene_to_file("res://global_map_sand.tscn")

func _on_stone_button_pressed():
	# 切换到石地地图场景
	get_tree().change_scene_to_file("res://global_map_stone.tscn")

func _on_ice_button_pressed():
	# 切换到冰地地图场景
	get_tree().change_scene_to_file("res://global_map_ice.tscn")

func _on_hell_button_pressed():
	# 切换到地狱地图场景
	get_tree().change_scene_to_file("res://global_map_hell.tscn")

