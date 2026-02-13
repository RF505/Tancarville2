extends AnimatableBody2D

@export var vitesse = 100.0
@export var temps_pause = 5.0

@onready var ray_sol = $RayCast2Dsol
@onready var timer = $WaitTimer

var pos_haut : Vector2
var vers_le_bas = true
var en_pause = false

func _ready():
	pos_haut = global_position
	timer.wait_time = temps_pause
	# On connecte le signal du timer pour savoir quand repartir
	timer.timeout.connect(_on_timer_timeout)

func _physics_process(delta):
	if en_pause:
		return

	if vers_le_bas:
		# --- MOUVEMENT VERS LE BAS ---
		if ray_sol.is_colliding():
			lancer_pause()
		else:
			global_position.y += vitesse * delta
	else:
		# --- MOUVEMENT VERS LE HAUT ---
		if global_position.y <= pos_haut.y:
			global_position.y = pos_haut.y
			lancer_pause()
		else:
			global_position.y -= vitesse * delta

func lancer_pause():
	en_pause = true
	timer.start()

func _on_timer_timeout():
	# On inverse la direction
	vers_le_bas = !vers_le_bas
	en_pause = false
