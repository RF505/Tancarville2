extends Label

# Vitesse de défilement (ajustez selon vos besoins)
@export var vitesse_defilement: float = 80.0

# Position de départ (en dehors de l'écran en bas)
var position_depart: float
# Position finale (le bas du label atteint le bas de l'écran)
var position_finale: float

func _ready():
	# Récupérer la taille de la fenêtre
	var taille_ecran = get_viewport_rect().size
	
	# Position de départ : en bas de l'écran (invisible)
	position_depart = taille_ecran.y
	position.y = position_depart
	
	# Position finale : quand le bas du label arrive en bas de l'écran
	position_finale = -size.y

func _process(delta):
	# Faire monter le label
	position.y -= vitesse_defilement * delta
	
	# Vérifier si le défilement est terminé
	if position.y <= position_finale:
		await get_tree().create_timer(1.5).timeout
		# Ici vous pouvez relancer le jeu ou revenir au menu
		get_tree().change_scene_to_file("res://main.tscn")
