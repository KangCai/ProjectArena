extends Node

# AI 系统 tick 逻辑（分帧处理）
func process_ai_system(hero_dict: Dictionary, current_ai_index: int, heroes_per_frame: int, spell_system: Node) -> int:
	if hero_dict.size() == 0:
		return current_ai_index
	
	# 获取所有英雄的 guid 列表
	var hero_guids = hero_dict.keys()
	if hero_guids.size() == 0:
		return current_ai_index
	
	# 分帧处理：每帧处理 heroes_per_frame 个英雄
	var processed_count = 0
	var new_ai_index = current_ai_index
	while processed_count < heroes_per_frame and new_ai_index < hero_guids.size():
		var guid = hero_guids[new_ai_index]
		var hero = hero_dict.get(guid)
		if hero:
			# 找到距离最近的敌方单位
			var nearest_enemy = find_nearest_enemy(hero, hero_dict)
			if nearest_enemy:
				# 获取英雄当前位置
				var hero_pos = hero.get_hero_world_position()
				# 获取敌方单位位置
				var enemy_pos = nearest_enemy.get_hero_world_position()
				# 计算距离
				var distance = hero_pos.distance_to(enemy_pos)
				# 获取攻击距离
				var attack_distance = 30.0  # 默认值
				if hero.spell_dict.has("atk") and hero.spell_dict["atk"]:
					attack_distance = hero.spell_dict["atk"].distance
				print("攻击距离: ", attack_distance, " 距离: ", distance)
				# 如果距离大于攻击距离，移动到敌方单位位置
				if distance > attack_distance:
					hero.move_pos(enemy_pos.x, enemy_pos.y)
				else:
					# 距离小于等于攻击距离，进行普攻
					if spell_system:
						spell_system.cast_spell(hero, "atk")
					# 清除移动目标，原地不动
					hero.clear_move_target()
			else:
				# 没有找到敌方单位，执行默认 AI 逻辑
				hero.process_ai()
		
		new_ai_index += 1
		processed_count += 1
		
		# 如果处理完所有英雄，重置索引
		if new_ai_index >= hero_guids.size():
			new_ai_index = 0
	
	return new_ai_index

# 找到距离指定英雄最近的敌方单位
func find_nearest_enemy(hero: Hero, hero_dict: Dictionary) -> Hero:
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
