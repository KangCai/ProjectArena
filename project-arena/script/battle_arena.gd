extends Node2D

# 阵营常量（对应 Hero.Faction 枚举）
const FACTION_ALLY = 0   # 我方
const FACTION_ENEMY = 1  # 敌方

# 记录当前 arena 属于哪个地图
var source_map: String = ""

# GUID 管理器
var guid_mgr: Node = null

# 英雄字典（key: guid, value: hero 对象）
var hero_dict: Dictionary = {}

# AI 系统相关
var current_ai_index: int = 0  # 当前处理的英雄索引（用于分帧处理）
var heroes_per_frame: int = 1  # 每帧处理的英雄数量

func _ready():
	# 创建并初始化 GUID 管理器
	guid_mgr = preload("res://script/guid_mgr.gd").new()
	add_child(guid_mgr)
	
	# 从场景树获取来源地图信息
	if get_tree().has_meta("source_map"):
		source_map = get_tree().get_meta("source_map")
		print("当前 arena 属于地图: ", source_map)
	
	# 获取退出按钮并连接信号
	var exit_button = $UI/ExitButton
	if exit_button:
		exit_button.pressed.connect(_on_exit_button_pressed)
	
	# 动态加载角色动画资源并创建角色
	load_hero_characters()

func load_hero_characters():
	# 白牛资源路径
	var bainiu_sprite_path = "res://image/hero/hero_niutouren_bainiu.tres"
	
	# 创建第一个白牛英雄（左侧，我方）
	var hero1 = Hero.new(bainiu_sprite_path, "HeroBainiu1", Vector2(760, 540), "run", Hero.Faction.ALLY)
	add_child(hero1)
	if hero1.setup():
		# Hero 在 _ready() 中已自动获取 guid
		hero_dict[hero1.guid] = hero1
		print("创建第一个白牛角色成功（我方），GUID: ", hero1.guid)
	else:
		push_error("创建第一个白牛角色失败")
	
	# 创建第二个白牛英雄（右侧，敌方）
	var hero2 = Hero.new(bainiu_sprite_path, "HeroBainiu2", Vector2(1160, 540), "run", Hero.Faction.ENEMY)
	add_child(hero2)
	if hero2.setup():
		# Hero 在 _ready() 中已自动获取 guid
		hero_dict[hero2.guid] = hero2
		print("创建第二个白牛角色成功（敌方），GUID: ", hero2.guid)
	else:
		push_error("创建第二个白牛角色失败")

# AI 系统 tick 逻辑（分帧处理）
func _process(delta):
	process_move_system(delta)
	process_ai_system()

# 移动系统：每帧处理所有英雄的移动
func process_move_system(delta: float):
	if hero_dict.size() == 0:
		return
	
	# 遍历所有英雄，处理移动
	for guid in hero_dict:
			var hero = hero_dict[guid]
			if hero and hero.is_moving:
				# 获取英雄当前位置
				var current_pos = hero.get_hero_world_position()
				# 计算到目标位置的距离
				var distance_to_target = current_pos.distance_to(hero.move_target)
				
				# 如果已经到达目标（距离很小），停止移动
				if distance_to_target < 0.1:
					var target_offset = hero.move_target - hero.global_position
					hero.position_offset = target_offset
					if hero.animated_sprite:
						hero.animated_sprite.position = target_offset
					hero.is_moving = false
					continue
				
				# 计算到目标位置的方向
				var direction = (hero.move_target - current_pos).normalized()
				# 计算本帧可以移动的距离
				var move_distance = delta * hero.move_speed
				
				# 如果本帧移动距离大于等于到目标的距离，直接到达目标
				if move_distance >= distance_to_target:
					# 到达目标位置
					var target_offset = hero.move_target - hero.global_position
					hero.position_offset = target_offset
					if hero.animated_sprite:
						hero.animated_sprite.position = target_offset
					hero.is_moving = false
				else:
					# 向目标方向移动
					var new_pos = current_pos + direction * move_distance
					var new_offset = new_pos - hero.global_position
					hero.position_offset = new_offset
					if hero.animated_sprite:
						hero.animated_sprite.position = new_offset

func process_ai_system():
	if hero_dict.size() == 0:
		return
	
	# 获取所有英雄的 guid 列表
	var hero_guids = hero_dict.keys()
	if hero_guids.size() == 0:
		return
	
	# 分帧处理：每帧处理 heroes_per_frame 个英雄
	var processed_count = 0
	while processed_count < heroes_per_frame and current_ai_index < hero_guids.size():
		var guid = hero_guids[current_ai_index]
		var hero = hero_dict.get(guid)
		if hero:
			# 找到距离最近的敌方单位
			var nearest_enemy = find_nearest_enemy(hero)
			if nearest_enemy:
				# 获取英雄当前位置
				var hero_pos = hero.get_hero_world_position()
				# 获取敌方单位位置
				var enemy_pos = nearest_enemy.get_hero_world_position()
				# 计算距离
				var distance = hero_pos.distance_to(enemy_pos)
				# 获取攻击距离
				var attack_distance = 100.0  # 默认值
				if hero.spell_dict.has("atk") and hero.spell_dict["atk"]:
					attack_distance = hero.spell_dict["atk"].distance
				
				# 如果距离大于攻击距离，移动到敌方单位位置
				if distance > attack_distance:
					hero.move_pos(enemy_pos.x, enemy_pos.y)
				# 否则不动（不执行任何操作）
			else:
				# 没有找到敌方单位，执行默认 AI 逻辑
				hero.process_ai()
		
		current_ai_index += 1
		processed_count += 1
		
		# 如果处理完所有英雄，重置索引
		if current_ai_index >= hero_guids.size():
			current_ai_index = 0

# 找到距离指定英雄最近的敌方单位
func find_nearest_enemy(hero: Hero) -> Hero:
	if not hero:
		return null
	
	# 确定敌方阵营
	var enemy_faction = Hero.Faction.ENEMY if hero.faction == Hero.Faction.ALLY else Hero.Faction.ALLY
	
	# 获取英雄当前位置
	var hero_pos = hero.get_hero_world_position()
	
	# 遍历所有英雄，找到最近的敌方单位
	var nearest_enemy: Hero = null
	var min_distance: float = INF
	
	for guid in hero_dict:
		var other_hero = hero_dict[guid]
		if other_hero and other_hero.faction == enemy_faction:
			var enemy_pos = other_hero.get_hero_world_position()
			var distance = hero_pos.distance_to(enemy_pos)
			if distance < min_distance:
				min_distance = distance
				nearest_enemy = other_hero
	
	return nearest_enemy

func _on_exit_button_pressed():
	# 根据来源地图切换回对应的地图场景
	if source_map != "":
		var scene_path = "res://" + source_map + ".tscn"
		get_tree().change_scene_to_file(scene_path)
	else:
		# 如果没有来源地图信息，默认返回全局地图
		get_tree().change_scene_to_file("res://global_map.tscn")
