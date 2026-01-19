extends Node2D
class_name Hero

# 阵营枚举
enum Faction {
	ALLY,    # 我方
	ENEMY    # 敌方
}

# 英雄属性
var guid: int = 0  # 唯一标识符
var sprite_frames_path: String = ""
var hero_name: String = ""
var position_offset: Vector2 = Vector2.ZERO
var animation_name: String = "run"
var faction: Faction = Faction.ALLY

# 技能字典（key: 技能名, value: Spell 对象）
var spell_dict: Dictionary = {}

# 移动相关属性
var move_speed: float = 200.0  # 移动速度（像素/秒）
var move_target: Vector2 = Vector2.ZERO  # 移动目标位置（世界坐标）
var is_moving: bool = false  # 是否正在移动

# 动画精灵节点
var animated_sprite: AnimatedSprite2D = null

# 初始化英雄
func _init(p_sprite_frames_path: String, p_hero_name: String, p_position: Vector2 = Vector2.ZERO, p_animation: String = "run", p_faction = Faction.ALLY):
	sprite_frames_path = p_sprite_frames_path
	hero_name = p_hero_name
	position_offset = p_position
	animation_name = p_animation
	faction = p_faction
	
	# 初始化技能字典，创建默认攻击技能
	spell_dict["atk"] = Spell.new(100.0)

func _ready():
	# 自动从 guid_mgr 获取 guid
	_acquire_guid()

# 从 guid_mgr 获取 guid
func _acquire_guid():
	# 向上查找场景树，找到包含 guid_mgr 的父节点（通常是 BattleArena）
	var parent = get_parent()
	while parent:
		# 检查父节点是否有 guid_mgr 属性
		if "guid_mgr" in parent:
			var guid_manager = parent.guid_mgr
			if guid_manager and guid_manager.has_method("get_next_guid"):
				guid = guid_manager.get_next_guid()
				return
		parent = parent.get_parent()
	
	# 如果找不到 guid_mgr，使用时间戳作为临时 guid
	push_warning("Hero " + hero_name + " 无法找到 guid_mgr，使用临时 guid")
	guid = Time.get_ticks_msec()

# 创建并设置英雄
func setup():
	# 确保 guid 已设置（如果 _ready() 还未执行，则现在获取）
	if guid == 0:
		_acquire_guid()
	
	# 加载 SpriteFrames 资源
	var sprite_frames = load(sprite_frames_path) as SpriteFrames
	if not sprite_frames:
		push_error("无法加载资源: " + sprite_frames_path)
		return false
	
	# 创建 AnimatedSprite2D 节点
	animated_sprite = AnimatedSprite2D.new()
	animated_sprite.name = hero_name
	
	# 设置 SpriteFrames 资源
	animated_sprite.sprite_frames = sprite_frames
	
	# 设置角色位置
	animated_sprite.position = position_offset
	
	# 添加到场景中
	add_child(animated_sprite)
	
	# 播放指定动画
	animated_sprite.play(animation_name)
	
	return true

# 设置位置
func set_hero_position(pos: Vector2):
	position_offset = pos
	if animated_sprite:
		animated_sprite.position = pos

# 播放动画
func play_animation(anim_name: String):
	animation_name = anim_name
	if animated_sprite:
		animated_sprite.play(anim_name)

# 获取英雄当前位置（世界坐标）
func get_hero_world_position() -> Vector2:
	if animated_sprite:
		return global_position + animated_sprite.position
	return global_position

# 移动指令：设置移动目标位置（不立即移动，由 move_system 处理）
func move_pos(target_x: float, target_y: float):
	move_target = Vector2(target_x, target_y)
	is_moving = true
	print("英雄 ", hero_name, " 设置移动目标: (", target_x, ", ", target_y, ")")

# 清除移动目标（停止移动）
func clear_move_target():
	move_target = Vector2.INF  # 使用 INF 表示空值
	is_moving = false
	print("英雄 ", hero_name, " 清除移动目标，原地不动")

# AI 逻辑处理（暂时用 print 打印）
func process_ai():
	var faction_name = "我方" if faction == Faction.ALLY else "敌方"
	print("处理英雄 AI: ", hero_name, " (", faction_name, ")")
