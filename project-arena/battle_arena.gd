extends Node2D

func _ready():
	# 获取退出按钮并连接信号
	var exit_button = $UI/ExitButton
	if exit_button:
		exit_button.pressed.connect(_on_exit_button_pressed)

func _on_exit_button_pressed():
	get_tree().quit()


