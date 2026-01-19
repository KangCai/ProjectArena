extends Node

# 移动系统：每帧处理所有英雄的移动
func process_move_system(delta: float, hero_dict: Dictionary):
	if hero_dict.size() == 0:
		return
	
	# 遍历所有英雄，处理移动
	for guid in hero_dict:
		var hero = hero_dict[guid]
		# 如果move_target为空（Vector2.INF）或is_moving为false，则原地不动
		if not hero or not hero.is_moving or hero.move_target == Vector2.INF:
			continue
		
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
