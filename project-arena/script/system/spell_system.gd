extends Node

# 技能系统：每帧处理所有英雄的技能
func process_spell_system(_delta: float, hero_dict: Dictionary):
	if hero_dict.size() == 0:
		return
	
	# 遍历所有英雄，处理技能
	for guid in hero_dict:
		var hero = hero_dict[guid]
		if not hero:
			continue
		
		# 如果 cur_spell 为空，直接替换成 to_spell
		if hero.cur_spell == "":
			if hero.to_spell != "":
				# 切换到新技能
				hero.cur_spell = hero.to_spell
				hero.to_spell = ""
				hero.spell_start_time = Time.get_ticks_msec() / 1000.0
				# 播放技能对应的动画
				if hero.spell_dict.has(hero.cur_spell) and hero.spell_dict[hero.cur_spell]:
					var spell = hero.spell_dict[hero.cur_spell]
					hero.play_animation(spell.animation_name)
		else:
			# 检查当前技能是否执行完成
			if hero.spell_dict.has(hero.cur_spell) and hero.spell_dict[hero.cur_spell]:
				var spell = hero.spell_dict[hero.cur_spell]
				var current_time = Time.get_ticks_msec() / 1000.0
				var elapsed_time = current_time - hero.spell_start_time
				
				# 如果技能执行完成
				if elapsed_time >= spell.duration:
					# 如果有待执行的技能，切换到新技能
					if hero.to_spell != "":
						hero.cur_spell = hero.to_spell
						hero.to_spell = ""
						hero.spell_start_time = current_time
						# 播放新技能对应的动画
						if hero.spell_dict.has(hero.cur_spell) and hero.spell_dict[hero.cur_spell]:
							var new_spell = hero.spell_dict[hero.cur_spell]
							hero.play_animation(new_spell.animation_name)
					else:
						# 没有待执行的技能，清除当前技能
						hero.cur_spell = ""

# 决定释放什么技能，设置当前角色的 to_spell
func cast_spell(hero: Hero, spell_name: String):
	if not hero:
		return
	
	if not hero.spell_dict.has(spell_name):
		push_warning("英雄 " + hero.hero_name + " 没有技能: " + spell_name)
		return
	
	# 设置待执行的技能
	hero.to_spell = spell_name
	print("英雄 ", hero.hero_name, " 准备释放技能: ", spell_name)
