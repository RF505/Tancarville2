extends CharacterBody2D

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var footsteps = $Footsteps # <-- AJOUTÉ ICI

const SPEED = 100.0
const JUMP_VELOCITY = -200.0
const MAX_STEP_HEIGHT = 5

var sur_platform = false
var platform2_ref = null
var e_ref = null

func _ready():
	await get_tree().process_frame
	
	print("🔍 Recherche de platform2 et e dans Main...")
	
	# Méthode 1 : chemin relatif depuis Game vers Main
	platform2_ref = get_node_or_null("../../Main/platform/platform2")
	e_ref = get_node_or_null("../../Main/platform/e")
	
	if platform2_ref:
		print("✅ platform2 Trouvé : ../../Main/platform/platform2")
	
	if e_ref:
		print("✅ e Trouvé : ../../Main/platform/e")
	
	# Méthode 2 : depuis la racine
	if not platform2_ref:
		var root = get_tree().root
		platform2_ref = root.get_node_or_null("Main/platform/platform2")
		if platform2_ref:
			print("✅ platform2 Trouvé : Main/platform/platform2")
	
	if not e_ref:
		var root = get_tree().root
		e_ref = root.get_node_or_null("Main/platform/e")
		if e_ref:
			print("✅ e Trouvé : Main/platform/e")
	
	# Méthode 3 : recherche directe
	if not platform2_ref or not e_ref:
		var main_node = get_tree().root.get_node_or_null("Main")
		if main_node:
			var platform = main_node.get_node_or_null("platform")
			if platform:
				if not platform2_ref:
					platform2_ref = platform.get_node_or_null("platform2")
					if platform2_ref:
						print("✅ platform2 Trouvé via recherche directe")
				if not e_ref:
					e_ref = platform.get_node_or_null("e")
					if e_ref:
						print("✅ e Trouvé via recherche directe")
	
	# Initialiser l'opacité à 0
	if platform2_ref:
		platform2_ref.modulate.a = 0.0
		print("✅✅✅ platform2 TROUVÉ et invisible !")
		print("Chemin : ", platform2_ref.get_path())
	else:
		print("❌ platform2 INTROUVABLE")
	
	if e_ref:
		e_ref.modulate.a = 0.0
		print("✅✅✅ e TROUVÉ et invisible !")
		print("Chemin : ", e_ref.get_path())
	else:
		print("❌ e INTROUVABLE")

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
		if sur_platform:
			anim.play("sing")
	elif direction != 0:
		if anim.current_animation != "run":
			anim.play("run")
		sprite.flip_h = direction < 0
	else:
		if anim.current_animation != "sing" and anim.current_animation != "idle":
			anim.play("idle")
	
	# --- GESTION DU SON (Ajouté ici) ---
	if is_on_floor() and direction != 0:
		if not footsteps.playing:
			footsteps.play()
	else:
		if footsteps.playing:
			footsteps.stop()
	
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
	
	# --- Animation opacité platform2 et e ---
	if platform2_ref:
		if sur_platform:
			platform2_ref.modulate.a = move_toward(platform2_ref.modulate.a, 1.0, delta * 5.0)
			# print("🟢 Opacité platform2 : ", platform2_ref.modulate.a)
		else:
			platform2_ref.modulate.a = move_toward(platform2_ref.modulate.a, 0.0, delta * 5.0)
	
	if e_ref:
		if sur_platform:
			e_ref.modulate.a = move_toward(e_ref.modulate.a, 1.0, delta * 5.0)
		else:
			e_ref.modulate.a = move_toward(e_ref.modulate.a, 0.0, delta * 5.0)
