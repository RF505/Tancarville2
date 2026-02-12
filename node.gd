class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.RIGHT
var direction : Vector2 = Vector2.ZERO
var move_speed : float = 350.0
var gravity : float = 1000
var jump_force : float = -600
@export var bounce_height : float = 200
var state : String = "idle"

var is_jumping : bool = false
var is_falling : bool = false
@export var knockback_force : float = 600.0

var dead : bool = false

@export var max_health := 3
var current_health := 3
var can_take_damage := true
@export var invulnerability_time := 1.0  # sec
@onready var ui_hearts := get_tree().get_first_node_in_group("ui_hearts")

@export var max_jumps : int = 1
var jump_count : int = 0

@export var dash_distance : float = 150.0
@export var dash_speed : float = 1000.0
@export var dash_cooldown : float = 0.5
var can_dash : bool = true
var is_dashing : bool = false


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

@export_group("Camera sync")
@export var camera_sync: Camera2D
@export var should_camera_sync: bool = true
@export_group("")

@onready var audio_walk: AudioStreamPlayer = $walk
@onready var audio_dash: AudioStreamPlayer = $dash

func _ready():
	print("UI trouvé :", get_tree().get_first_node_in_group("ui_hearts"))

func _process(delta: float) -> void:
	if dead:
		# Autoriser juste restart
		if Input.is_action_just_pressed("restart"):
			get_tree().reload_current_scene()
		return

	
	# Directions
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = - Input.get_action_strength("up")
	
	#son de marche
	if is_on_floor() and direction.x and not audio_walk.playing:
		audio_walk.play()
	
	# Dash
	if Input.is_action_just_pressed("dash") and can_dash and not is_dashing and direction.x != 0:
		Dash()
	
	# Jump and Double
	if Input.is_action_just_pressed("up") and jump_count < max_jumps:
		is_jumping = true
		velocity.y = jump_force
		jump_count += 1
		state = "jumping"
		UpdateAnimation()
		
	# Pas d'action pendant le dash
	#if is_dashing:
		#return
		
	# Mouvement horizontal normal
	velocity.x = direction.x * move_speed
	
	if SetState() or SetDirection():
		UpdateAnimation()


func _physics_process(delta: float) -> void:
	# Gravité
	if not is_on_floor():
		velocity.y += gravity * delta

		# Déterminer état en l'air
		if velocity.y < 0:
			is_jumping = true
			is_falling = false
			state = "jumping"
		elif velocity.y > 0:
			is_jumping = false
			is_falling = true
			state = "falling"

	else:
		# Au sol → reset saut & état
		is_jumping = false
		is_falling = false
		jump_count = 0
		if abs(direction.x) > 0:
			state = "walk"
		else:
			state = "idle"

	UpdateAnimation()

	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var col := get_slide_collision(i)
		var collider := col.get_collider()

		if collider is Enemy:
			var normal := col.get_normal()
			
			# Si on saute sur le dessus de l'ennemi
			if normal.is_equal_approx(Vector2.UP):
				velocity.y = -bounce_height
				collider.die()
			else:
				# Sinon on prend des dégâts
				take_damage(collider)
		if collider is Zone_damage:
			# prend des dégâts si bush ou feu
			take_damage(collider)
			collider.traverse()



func Dash() -> void:
	audio_dash.play()
	audio_dash.seek(0.19)
	
	is_dashing = true
	can_dash = false
	
	state = "dash"
	UpdateAnimation()
	
	var dash_dir = sign(direction.x)
	var target_x = global_position.x + (dash_dir * dash_distance)
	
	#sprite.flip_h = dash_dir < 0
	
	var tween = create_tween()
	tween.tween_property(self, "global_position:x", target_x, dash_distance / dash_speed)
	tween.tween_callback(Callable(self, "_end_dash"))
	
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true
	


func _end_dash() -> void:
	is_dashing = false
	state = "idle"
	UpdateAnimation()


func SetDirection() -> bool:
	# Ne pas changer la direction pendant le dash seulement
	if is_dashing:
		return false

	var new_dir : Vector2 = cardinal_direction

	if direction.x != 0:
		new_dir = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT

	if new_dir != cardinal_direction:
		cardinal_direction = new_dir
		sprite.flip_h = (cardinal_direction == Vector2.LEFT)
		return true

	return false




func SetState() -> bool:
	# Si on saute, tombe ou dash → NE PAS changer l'état
	if is_jumping or is_falling or is_dashing:
		return false

	# On ignore direction.y ici → le walk est uniquement horizontal
	var new_state : String = "idle" if direction.x == 0 else "walk"

	if new_state == state:
		return false
	state = new_state
	return true



func UpdateAnimation() -> void:
	animation_player.play(state + "_" + AnimDirection())
	if dead: 
			animation_player.play("dead")



func AnimDirection() -> String:
	if state in ["jumping", "falling", "dash"]:
		return "slide"  # même anim pour les deux sens
	elif cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "slide"


func take_damage(source: Node2D = null):
	if not can_take_damage or dead:
		return

	can_take_damage = false
	current_health -= 1

	# Knockback
	if source != null:
		var direction_knock = sign(global_position.x - source.global_position.x)
		velocity.x = direction_knock * knockback_force
		velocity.y = -200 # petit rebond
	else:
		# Si pas de source (ex: piège), on repousse selon la direction actuelle
		velocity.x = -sign(direction.x) * knockback_force
		velocity.y = -200

	if ui_hearts:
		ui_hearts.update_hearts(current_health)

	if current_health <= 0:
		die()
	else:
		modulate = Color(1, 0.5, 0.5)
		await get_tree().create_timer(invulnerability_time).timeout
		modulate = Color(1, 1, 1)
		can_take_damage = true

func die():
	if dead:
		return
		
	dead = true
	state = "dead"
	velocity = Vector2.ZERO  # stop mouvement


	# On bloque les actions
	can_take_damage = false
	can_dash = false
	animation_player.play("dead")

	print("Player is dead. Press X to restart.")
