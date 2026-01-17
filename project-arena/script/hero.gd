extends Node2D
class_name Hero

# 阵营枚举
enum Faction {
	ALLY,    # 我方
	ENEMY    # 敌方
}

# 英雄属性
var sprite_frames_path: String = ""
var hero_name: String = ""
var position_offset: Vector2 = Vector2.ZERO
var animation_name: String = "run"
var faction: Faction = Faction.ALLY

# 动画精灵节点
var animated_sprite: AnimatedSprite2D = null

# 初始化英雄
func _init(p_sprite_frames_path: String, p_hero_name: String, p_position: Vector2 = Vector2.ZERO, p_animation: String = "run", p_faction = Faction.ALLY):
	sprite_frames_path = p_sprite_frames_path
	hero_name = p_hero_name
	position_offset = p_position
	animation_name = p_animation
	faction = p_faction

# 创建并设置英雄
func setup():
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

# AI 逻辑处理（暂时用 print 打印）
func process_ai():
	var faction_name = "我方" if faction == Faction.ALLY else "敌方"
	print("处理英雄 AI: ", hero_name, " (", faction_name, ")")
