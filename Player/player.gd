extends CharacterBody2D

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var footsteps = $Footsteps # Récupère le nœud audio

const SPEED = 100.0
const JUMP_VELOCITY = -200.0
const MAX_STEP_HEIGHT = 5

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

	# --- Animations et Sons ---
	_handle_animations_and_sounds(direction)

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

var was_in_air: bool = false # À ajouter en haut du script avec tes autres variables

func _handle_animations_and_sounds(direction: float) -> void:
	# 1. GESTION DES ANIMATIONS
	if Input.is_action_just_pressed("sing"):
		anim.play("sing")
	elif direction != 0:
		if is_on_floor():
			if anim.current_animation != "run":
				anim.play("run")
		sprite.flip_h = direction < 0
	else:
		if anim.current_animation != "sing" and anim.current_animation != "idle":
			anim.play("idle")

	# 2. GESTION DU SON (La méthode infaillible)
	# On vérifie si on doit entendre des pas
	if is_on_floor() and direction != 0:
		if not footsteps.playing:
			footsteps.play() 
	else:
		# On arrête le son dès qu'on saute ou qu'on lâche les touches
		if footsteps.playing:
			footsteps.stop()
