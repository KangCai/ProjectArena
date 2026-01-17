extends Node2D

func _ready():
	# 获取返回世界地图按钮并连接信号
	var back_button = $UI/BackButton
	if back_button:
		back_button.pressed.connect(_on_back_button_pressed)
	
	# 获取场景切换按钮并连接信号
	var to_sand_button = $UI/ToSandButton
	if to_sand_button:
		to_sand_button.pressed.connect(_on_to_sand_button_pressed)
	
	var to_stone_button = $UI/ToStoneButton
	if to_stone_button:
		to_stone_button.pressed.connect(_on_to_stone_button_pressed)
	
	var to_ice_button = $UI/ToIceButton
	if to_ice_button:
		to_ice_button.pressed.connect(_on_to_ice_button_pressed)

func _on_back_button_pressed():
	# 切换回世界地图场景
	get_tree().change_scene_to_file("res://global_map.tscn")

func _on_to_sand_button_pressed():
	# 切换到沙地场景
	get_tree().change_scene_to_file("res://global_map_sand.tscn")

func _on_to_stone_button_pressed():
	# 切换到石地场景
	get_tree().change_scene_to_file("res://global_map_stone.tscn")

func _on_to_ice_button_pressed():
	# 切换到冰地场景
	get_tree().change_scene_to_file("res://global_map_ice.tscn")
