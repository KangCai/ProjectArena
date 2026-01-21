extends Node

# GUID 管理器单例
# 用于为每个新创建的 hero 分配唯一的 guid

var current_guid: int = 0

# 获取下一个 guid
func get_next_guid() -> int:
	current_guid += 1
	return current_guid

# 重置 guid（如果需要）
func reset():
	current_guid = 0
