extends CharacterBody2D

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -200.0
const MAX_STEP_HEIGHT = 5

var sur_platform = false

func _physics_process(delta: float) -> void:
	# --- Gravité ---
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	# --- Saut ---
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# --- Mouvement horizontal ---
	var direction := Input.get_axis("left", "right")
	velocity.x = move_toward(velocity.x, direction * SPEED, SPEED)

	# --- Animations ---
	if Input.is_action_just_pressed("sing"):
		print("Touche E pressée. Sur platform ? ", sur_platform)
		if sur_platform:
			anim.play("sing")
	elif direction != 0:
		if anim.current_animation != "run":
			anim.play("run")
		sprite.flip_h = direction < 0
	else:
		if anim.current_animation != "sing" and anim.current_animation != "idle":
			anim.play("idle")

	# --- Déplacement ---
	var previous_position = position
	move_and_slide()

	# --- Gestion des marches ---
	if is_on_floor() and direction != 0 and is_on_wall():
		position = previous_position
		for i in range(MAX_STEP_HEIGHT):
			position.y -= 1
			if not test_move(global_transform, Vector2(direction * 1, 0)):
				break

	# --- Animation opacité platform2 ---
	var platform = get_node_or_null("../platform")
	if platform and platform.has_node("platform2"):
		var platform2 = platform.get_node("platform2")
		if sur_platform:
			platform2.modulate.a = move_toward(platform2.modulate.a, 1.0, delta * 2.0)
		else:
			platform2.modulate.a = move_toward(platform2.modulate.a, 0.0, delta * 2.0)
