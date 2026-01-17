extends Resource
class_name Spell

# 技能属性
var distance: float = 100.0  # 攻击距离，默认100

func _init(p_distance: float = 100.0):
	distance = p_distance
