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
func _process(_delta):
	process_ai_system()

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
			hero.process_ai()
		
		current_ai_index += 1
		processed_count += 1
		
		# 如果处理完所有英雄，重置索引
		if current_ai_index >= hero_guids.size():
			current_ai_index = 0

func _on_exit_button_pressed():
	# 根据来源地图切换回对应的地图场景
	if source_map != "":
		var scene_path = "res://" + source_map + ".tscn"
		get_tree().change_scene_to_file(scene_path)
	else:
		# 如果没有来源地图信息，默认返回全局地图
		get_tree().change_scene_to_file("res://global_map.tscn")
