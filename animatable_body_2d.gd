extends AnimatableBody2D

# --- CONFIGURATION ---
@export var vitesse = 150.0
@export var temps_pause = 5.0
# Glisse ton Line2D dans cette case dans l'inspecteur
@export var corde_node : Line2D 

# --- NODES ---
@onready var ray_sol = $RayCast2Dsol
@onready var timer = $WaitTimer

# --- VARIABLES INTERNES ---
var pos_haut : Vector2
var vers_le_bas = true
var en_pause = false

func _ready():
	# On enregistre la position de départ (le haut)
	pos_haut = global_position
	
	# Configuration du Timer
	timer.wait_time = temps_pause
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	
	# Initialisation de la corde
	if corde_node:
		# Le point 0 est l'attache fixe (en haut)
		# On suppose que le Line2D est placé au point d'attache
		corde_node.set_point_position(0, Vector2.ZERO)

func _physics_process(delta):
	# 1. MISE À JOUR DE LA CORDE
	if corde_node:
		# On force le point 1 de la ligne à suivre la plateforme
		# to_local convertit la position globale de la plateforme en coordonnée pour la ligne
		var pos_relative = corde_node.to_local(global_position)
		corde_node.set_point_position(1, pos_relative)

	# 2. GESTION DE LA PAUSE
	if en_pause:
		return

	# 3. LOGIQUE DE MOUVEMENT
	if vers_le_bas:
		# On descend jusqu'à toucher la TileMap
		if ray_sol.is_colliding():
			lancer_pause()
		else:
			global_position.y += vitesse * delta
	else:
		# On remonte jusqu'au point de départ
		if global_position.y <= pos_haut.y:
			global_position.y = pos_haut.y
			lancer_pause()
		else:
			global_position.y -= vitesse * delta

func lancer_pause():
	en_pause = true
	timer.start()

func _on_timer_timeout():
	# Inversion de la direction après les 5 secondes
	vers_le_bas = !vers_le_bas
	en_pause = false
