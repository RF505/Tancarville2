extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_STEP_HEIGHT = 16

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	# 🔹 On sauvegarde la position avant mouvement
	var previous_position = position
	# A compléter 
	if Input.is_action_just_pressed("sing"):
		animation_player.play("run")
	move_and_slide()
	# 🔹 Si on est bloqué horizontalement
	if is_on_floor() and direction != 0 and is_on_wall():
		# On revient à la position précédente
		position = previous_position
		# On tente de monter progressivement
		for i in range(MAX_STEP_HEIGHT):
			position.y -= 1
			if not test_move(global_transform, Vector2(direction * 1, 0)):
				break
