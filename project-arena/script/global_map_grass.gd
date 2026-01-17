extends Node2D

var gm_label_sprite: Sprite2D
var gm_label_area: Area2D

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
	
	# 获取 gm_label 相关节点
	gm_label_area = $GmLabelArea
	gm_label_sprite = gm_label_area.get_node("Sprite2D")
	
	# 启用 Area2D 的输入检测（必须设置才能接收 input_event 信号）
	if gm_label_area:
		gm_label_area.input_pickable = true
	
	# 根据 Sprite2D 的纹理尺寸和位置自动设置碰撞形状
	if gm_label_sprite and gm_label_sprite.texture:
		var texture_size = gm_label_sprite.texture.get_size()
		var collision_shape = gm_label_area.get_node("CollisionShape2D")
		if collision_shape and collision_shape.shape:
			# 设置碰撞形状的大小
			collision_shape.shape.size = texture_size * gm_label_sprite.scale
			# 设置碰撞形状的位置，使其与 Sprite2D 对齐
			collision_shape.position = gm_label_sprite.position
			print("碰撞形状大小: ", collision_shape.shape.size)
			print("碰撞形状位置: ", collision_shape.position)
	
	# 连接 Area2D 的 input_event 信号
	if gm_label_area:
		gm_label_area.input_event.connect(_on_gm_label_input_event)

func _on_back_button_pressed():
	# 切换回世界地图场景
	get_tree().change_scene_to_file("res://global_map.tscn")

func _on_gm_label_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	# 检测鼠标左键点击
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# 设置来源地图信息
		get_tree().set_meta("source_map", "global_map_grass")
		# 切换到战斗场景
		get_tree().change_scene_to_file("res://battle_arena.tscn")

func _on_to_sand_button_pressed():
	# 切换到沙地场景
	get_tree().change_scene_to_file("res://global_map_sand.tscn")

func _on_to_stone_button_pressed():
	# 切换到石地场景
	get_tree().change_scene_to_file("res://global_map_stone.tscn")

func _on_to_ice_button_pressed():
	# 切换到冰地场景
	get_tree().change_scene_to_file("res://global_map_ice.tscn")
