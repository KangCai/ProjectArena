extends Node2D

func _ready():
	# 获取退出按钮并连接信号
	var exit_button = $UI/ExitButton
	if exit_button:
		exit_button.pressed.connect(_on_exit_button_pressed)
	
	# 动态加载角色动画资源并创建角色
	load_hero_character()

func load_hero_character():
	# 加载 SpriteFrames 资源
	var sprite_frames = load("res://image/hero/hero_niutouren_bainiu.tres") as SpriteFrames
	if not sprite_frames:
		push_error("无法加载 hero_orc_hammer.tres 资源！")
		return
	
	# 创建 AnimatedSprite2D 节点
	var animated_sprite = AnimatedSprite2D.new()
	animated_sprite.name = "HeroOrc"
	
	# 设置 SpriteFrames 资源
	animated_sprite.sprite_frames = sprite_frames
	
	# 设置角色位置（可以根据需要调整）
	animated_sprite.position = Vector2(960, 540)  # 屏幕中心位置
	
	# 添加到场景中
	add_child(animated_sprite)
	
	# 播放 run 动画
	animated_sprite.play("run")

func _on_exit_button_pressed():
	# 切换回全局地图场景
	get_tree().change_scene_to_file("res://global_map.tscn")
