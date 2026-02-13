extends AnimatableBody2D

@export var vitesse : float = 150.0
@export var temps_pause : float = 5.0
@export var corde_node : Line2D 
@export var attache_plafond : Node2D 

@onready var ray_sol = $RayCast2Dsol
@onready var timer = $WaitTimer

var pos_haut : Vector2
var vers_le_bas = true
var en_pause = false

func _ready():
	# On s'assure que tout est bien configuré
	if not timer or not corde_node or not attache_plafond:
		print("!!! ATTENTION : Il manque des Nodes dans l'inspecteur !!!")
		return

	pos_haut = global_position
	timer.wait_time = temps_pause
	timer.one_shot = true
	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)

	# Initialisation corde
	while corde_node.get_point_count() < 2:
		corde_node.add_point(Vector2.ZERO)

func _physics_process(delta):
	# --- CORDE ---
	if corde_node and attache_plafond:
		# Le point 0 suit l'attache au plafond
		corde_node.set_point_position(0, corde_node.to_local(attache_plafond.global_position))
		# Le point 1 suit la plateforme (global_position est le centre de ton node)
		corde_node.set_point_position(1, corde_node.to_local(global_position))

	# --- MOUVEMENT ---
	if en_pause: return

	if vers_le_bas:
		if ray_sol and ray_sol.is_colliding():
			lancer_pause()
		else:
			global_position.y += vitesse * delta
	else:
		if global_position.y <= pos_haut.y:
			global_position.y = pos_haut.y
			lancer_pause()
		else:
			global_position.y -= vitesse * delta

func lancer_pause():
	en_pause = true
	timer.start()

func _on_timer_timeout():
	vers_le_bas = !vers_le_bas
	en_pause = false
