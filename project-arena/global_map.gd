extends Node2D

func _ready():
	# 获取战斗按钮并连接信号
	var battle_button = $UI/BattleButton
	if battle_button:
		battle_button.pressed.connect(_on_battle_button_pressed)

func _on_battle_button_pressed():
	# 切换到战斗场景
	get_tree().change_scene_to_file("res://battle_arena.tscn")

