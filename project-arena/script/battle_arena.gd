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

# 系统实例
var move_system: Node = null
var ai_system: Node = null

func _ready():
	# 创建并初始化 GUID 管理器
	guid_mgr = preload("res://script/guid_mgr.gd").new()
	add_child(guid_mgr)
	
	# 创建并初始化系统
	move_system = preload("res://script/system/move_system.gd").new()
	add_child(move_system)
	ai_system = preload("res://script/system/ai_system.gd").new()
	add_child(ai_system)
	
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
	var bainiu_sprite_path = "res://image/hero/hero_orc_hammer.tres"
	
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
	move_system.process_move_system(delta, hero_dict)
	current_ai_index = ai_system.process_ai_system(hero_dict, current_ai_index, heroes_per_frame)

func _on_exit_button_pressed():
	# 根据来源地图切换回对应的地图场景
	if source_map != "":
		var scene_path = "res://" + source_map + ".tscn"
		get_tree().change_scene_to_file(scene_path)
	else:
		# 如果没有来源地图信息，默认返回全局地图
		get_tree().change_scene_to_file("res://global_map.tscn")
