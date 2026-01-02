extends CharacterBody2D

# 角色动画控制器
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# 角色状态
enum State { IDLE, WALK, ATTACK }
var current_state: State = State.IDLE

func _ready():
	# 确保AnimatedSprite2D节点存在
	if not animated_sprite:
		push_error("AnimatedSprite2D节点未找到！")
		return
	
	# 设置默认动画
	animated_sprite.play("idle")

func _physics_process(delta):
	# 处理角色移动和动画切换
	handle_movement()
	update_animation()

func handle_movement():
	# 获取输入方向
	var direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)
	
	# 如果有输入，移动角色
	if direction.length() > 0:
		velocity = direction.normalized() * 200  # 移动速度
		current_state = State.WALK
	else:
		velocity = Vector2.ZERO
		current_state = State.IDLE
	
	move_and_slide()

func update_animation():
	# 根据状态切换动画
	match current_state:
		State.IDLE:
			if animated_sprite.animation != "idle":
				animated_sprite.play("idle")
		State.WALK:
			if animated_sprite.animation != "walk":
				animated_sprite.play("walk")
		State.ATTACK:
			if animated_sprite.animation != "attack":
				animated_sprite.play("attack")

