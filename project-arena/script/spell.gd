extends Resource
class_name Spell

# 技能属性
var distance: float = 100.0  # 攻击距离，默认100
var animation_name: String = "attack"  # 技能对应的动画名称
var duration: float = 1.0  # 技能持续时间（秒）

func _init(p_distance: float = 100.0, p_animation_name: String = "attack", p_duration: float = 1.0):
	distance = p_distance
	animation_name = p_animation_name
	duration = p_duration
