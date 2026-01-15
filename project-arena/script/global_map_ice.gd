extends Node2D

func _ready():
	# 打印进入场景时的状态
	print("进入冰地地图场景 - 当前状态: ", GameState.current_state)
	
	# 获取返回世界地图按钮并连接信号
	var back_button = $UI/BackButton
	if back_button:
		back_button.pressed.connect(_on_back_button_pressed)

func _on_back_button_pressed():
	# 打印退出场景时的状态
	print("退出冰地地图场景 - 当前状态: ", GameState.current_state)
	# 切换回世界地图场景
	get_tree().change_scene_to_file("res://global_map.tscn")
